import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import 'audio_config.dart';
import 'dsp/vad.dart';

// Invoked only inside the analysis isolate. Never infer speech from volume
// when the model cannot load: propagate the error so the saved clip can retry.
SpeechFrames detectNeuralSpeech(
  Float32List samples,
  AudioConfig config,
  String modelPath, {
  String? nativeLibraryDirectory,
}) {
  sherpa.initBindings(nativeLibraryDirectory);
  final detector = sherpa.VoiceActivityDetector(
    config: sherpa.VadModelConfig(
      sileroVad: sherpa.SileroVadModelConfig(
        model: modelPath,
        threshold: config.neuralVadThreshold,
        minSilenceDuration: config.neuralVadMinimumSilenceMs / 1000,
        minSpeechDuration: config.neuralVadMinimumSpeechMs / 1000,
        windowSize: config.neuralVadWindowSamples,
        maxSpeechDuration: config.neuralVadMaxSpeechMs / 1000,
      ),
      sampleRate: config.captureSampleRate,
      numThreads: 1,
      debug: false,
    ),
    bufferSizeInSeconds: config.neuralVadMaxSpeechMs / 1000,
  );
  final segments = <(int, int)>[];
  void drain() {
    while (!detector.isEmpty()) {
      final segment = detector.front();
      segments.add((
        segment.start * 1000 ~/ config.captureSampleRate,
        math.min(samples.length, segment.start + segment.samples.length) *
            1000 ~/
            config.captureSampleRate,
      ));
      detector.pop();
    }
  }

  try {
    for (
      var offset = 0;
      offset < samples.length;
      offset += config.neuralVadWindowSamples
    ) {
      final window = Float32List(config.neuralVadWindowSamples);
      final end = math.min(samples.length, offset + window.length);
      window.setRange(0, end - offset, samples, offset);
      detector.acceptWaveform(window);
      drain();
    }
    detector.flush();
    drain();
    return detectSpeech(samples, config).withSegments(segments, config);
  } finally {
    detector.free();
  }
}
