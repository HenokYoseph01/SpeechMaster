import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import 'dsp/wav.dart';
import 'transcript.dart';

Stream<TranscriptEvent> transcribeWavInIsolate(
  String path,
  String modelDirectory,
  TranscriptionConfig config, {
  String? nativeLibraryDirectory,
}) async* {
  final port = ReceivePort();
  SendPort? control;
  try {
    await Isolate.spawn(
      _worker,
      (
        path,
        modelDirectory,
        config.toJson(),
        nativeLibraryDirectory,
        port.sendPort,
      ),
      onError: port.sendPort,
      onExit: port.sendPort,
      errorsAreFatal: true,
    );
    await for (final message in port) {
      if (message is SendPort) {
        control = message;
        continue;
      }
      if (message is TranscriptResult) {
        yield TranscriptComplete(message);
        return;
      }
      if (message is double) {
        yield TranscriptProgress(message);
      } else if (message is List) {
        throw StateError('Transcription failed: ${message.first}');
      } else if (message == null) {
        throw StateError('Transcription stopped before returning a result');
      }
    }
  } finally {
    // Let an in-flight native decode finish before freeing its model. Killing
    // an isolate inside FFI can bypass native cleanup and leak large buffers.
    control?.send('cancel');
    port.close();
  }
}

Future<void> _worker(
  (String, String, Map<String, num>, String?, SendPort) request,
) async {
  final (path, directory, settings, nativeDirectory, port) = request;
  final watch = Stopwatch()..start();
  final control = ReceivePort();
  var cancelled = false;
  final commands = control.listen((_) {
    cancelled = true;
  });
  port.send(control.sendPort);
  try {
    port.send(0.0);
    final config = TranscriptionConfig.fromJson(settings);
    final audio = decodeWav(
      await File(path).readAsBytes(),
      expectedSampleRate: 16000,
    );
    if (cancelled) return;
    final power = audio.samples.fold<double>(0, (sum, s) => sum + s * s);
    if (audio.samples.isEmpty ||
        math.sqrt(power / audio.samples.length) < config.minimumSignalRms) {
      port.send(1.0);
      port.send(
        TranscriptResult(
          durationMs: audio.durationMs,
          words: const [],
          elapsedMs: watch.elapsedMilliseconds,
        ),
      );
      return;
    }
    sherpa.initBindings(nativeDirectory);
    final recognizer = sherpa.OfflineRecognizer(
      sherpa.OfflineRecognizerConfig(
        model: sherpa.OfflineModelConfig(
          transducer: sherpa.OfflineTransducerModelConfig(
            encoder: '$directory/encoder.int8.onnx',
            decoder: '$directory/decoder.onnx',
            joiner: '$directory/joiner.int8.onnx',
          ),
          tokens: '$directory/tokens.txt',
          numThreads: config.threads,
          debug: false,
        ),
      ),
    );
    try {
      port.send(0.1);
      final chunks = transcriptChunks(audio.durationMs, config);
      final words = <TranscriptWord>[];
      for (var i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        final stream = recognizer.createStream();
        try {
          final samples = Float32List.sublistView(
            audio.samples,
            math.min(
              audio.samples.length,
              chunk.startMs * audio.sampleRate ~/ 1000,
            ),
            math.min(
              audio.samples.length,
              chunk.endMs * audio.sampleRate ~/ 1000,
            ),
          );
          stream.acceptWaveform(samples: samples, sampleRate: audio.sampleRate);
          recognizer.decode(stream);
          final result = recognizer.getResult(stream);
          final candidates = wordsFromTokens(
            result.tokens,
            result.timestamps,
            durationMs: audio.durationMs,
            offsetMs: chunk.startMs,
          );
          words.addAll(
            candidates.where(
              (w) =>
                  w.startMs >= chunk.keepStartMs && w.startMs < chunk.keepEndMs,
            ),
          );
        } finally {
          stream.free();
        }
        port.send(0.1 + 0.9 * (i + 1) / chunks.length);
        await Future<void>.delayed(Duration.zero);
        if (cancelled) return;
      }
      port.send(
        TranscriptResult(
          durationMs: audio.durationMs,
          words: List.unmodifiable(words),
          elapsedMs: watch.elapsedMilliseconds,
        ),
      );
    } finally {
      recognizer.free();
    }
  } finally {
    await commands.cancel();
    control.close();
  }
}
