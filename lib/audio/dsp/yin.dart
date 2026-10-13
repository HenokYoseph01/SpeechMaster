import 'dart:typed_data';

import '../audio_config.dart';

class YinDetector {
  YinDetector(this.config)
    : _minLag = (config.pitchSampleRate / config.pitchMaximumHz).ceil(),
      _maxLag = (config.pitchSampleRate / config.pitchMinimumHz).floor();

  final AudioConfig config;
  final int _minLag;
  final int _maxLag;

  double? detect(Float32List samples, {int offset = 0}) {
    if (offset < 0 || offset + config.pitchFrameSamples > samples.length) {
      return null;
    }
    final cmnd = Float64List(_maxLag + 2);
    cmnd[0] = 1;
    var cumulative = 0.0;
    final comparisons = config.pitchFrameSamples - _maxLag - 1;
    for (var lag = 1; lag <= _maxLag + 1; lag++) {
      var difference = 0.0;
      for (var i = 0; i < comparisons; i++) {
        final delta = samples[offset + i] - samples[offset + i + lag];
        difference += delta * delta;
      }
      cumulative += difference;
      cmnd[lag] = cumulative == 0 ? 1 : difference * lag / cumulative;
    }
    for (var lag = _minLag; lag <= _maxLag; lag++) {
      if (cmnd[lag] >= config.yinThreshold) continue;
      while (lag < _maxLag && cmnd[lag + 1] < cmnd[lag]) {
        lag++;
      }
      final left = cmnd[lag - 1];
      final center = cmnd[lag];
      final right = cmnd[lag + 1];
      final denominator = left - 2 * center + right;
      final adjustment = denominator == 0
          ? 0.0
          : ((left - right) / (2 * denominator)).clamp(-1.0, 1.0);
      final refinedLag = (lag + adjustment).clamp(
        config.pitchSampleRate / config.pitchMaximumHz,
        config.pitchSampleRate / config.pitchMinimumHz,
      );
      final pitch = config.pitchSampleRate / refinedLag;
      return pitch >= config.pitchMinimumHz && pitch <= config.pitchMaximumHz
          ? pitch
          : null;
    }
    return null;
  }
}
