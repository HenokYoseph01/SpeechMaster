import 'dart:io';
import 'dart:isolate';

import 'audio_config.dart';
import 'dsp/pitch_analysis.dart';
import 'dsp/wav.dart';
import 'pitch_result.dart';

Stream<PitchEvent> analyzeWavInIsolate(String path, AudioConfig config) async* {
  final port = ReceivePort();
  Isolate? isolate;
  try {
    isolate = await Isolate.spawn(
      _analyzeWorker,
      (path, config.values, port.sendPort),
      onError: port.sendPort,
      onExit: port.sendPort,
      errorsAreFatal: true,
    );
    await for (final message in port) {
      if (message is PitchResult) {
        yield PitchComplete(message);
        return;
      } else if (message is double) {
        yield PitchProgress(message);
      } else if (message is List) {
        throw StateError('Pitch analysis failed: ${message.first}');
      } else if (message == null) {
        throw StateError('Pitch analysis stopped before returning a result');
      }
    }
  } finally {
    isolate?.kill(priority: Isolate.immediate);
    port.close();
  }
}

Future<void> _analyzeWorker(
  (String, Map<String, dynamic>, SendPort) request,
) async {
  final (path, values, port) = request;
  port.send(0.0);
  final config = AudioConfig.fromJson(values);
  final bytes = await File(path).readAsBytes();
  final audio = decodeWav(bytes, expectedSampleRate: config.captureSampleRate);
  port.send(analyzePitch(audio, config, onProgress: port.send));
}
