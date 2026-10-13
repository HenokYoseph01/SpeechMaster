import 'dart:math' as math;
import 'dart:typed_data';

import '../audio_config.dart';

Float32List downsampleForPitch(Float32List input, AudioConfig config) {
  final half = config.lowPassTaps ~/ 2;
  final cutoff = config.lowPassCutoffHz / config.captureSampleRate;
  final taps = List<double>.generate(config.lowPassTaps, (i) {
    final k = i - half;
    final sinc = k == 0
        ? 2 * cutoff
        : math.sin(2 * math.pi * cutoff * k) / (math.pi * k);
    final hamming =
        0.54 - 0.46 * math.cos(2 * math.pi * i / (config.lowPassTaps - 1));
    return sinc * hamming;
  });
  final sum = taps.fold<double>(0, (a, b) => a + b);
  final output = Float32List((input.length + 1) ~/ 2);
  for (var i = 0; i < output.length; i++) {
    var sample = 0.0;
    for (var j = 0; j < taps.length; j++) {
      final index = i * 2 + j - half;
      if (index >= 0 && index < input.length) {
        sample += input[index] * taps[j] / sum;
      }
    }
    output[i] = sample;
  }
  return output;
}
