import 'dart:typed_data';

import '../audio_config.dart';

class YinEstimate {
  const YinEstimate(this.hz, this.periodicity, this.octaveCorrected);
  final double hz;
  // Difference-function fit in [0, 1], not a calibrated accuracy probability.
  final double periodicity;
  final bool octaveCorrected;
}

class YinDetector {
  YinDetector(this.config)
    : _minLag = (config.pitchSampleRate / config.pitchMaximumHz).ceil(),
      _maxLag = (config.pitchSampleRate / config.pitchMinimumHz).floor();

  final AudioConfig config;
  final int _minLag;
  final int _maxLag;

  double? detect(Float32List samples, {int offset = 0}) {
    return detectEstimate(samples, offset: offset)?.hz;
  }

  YinEstimate? detectEstimate(Float32List samples, {int offset = 0}) {
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
      // A strong second harmonic can satisfy the threshold at half the
      // fundamental period. Prefer twice the period only when its local
      // difference minimum is substantially deeper, not merely also periodic.
      // This avoids halving a clean high voice with equally good multiples.
      var octaveCorrected = false;
      var doubled = lag * 2;
      if (doubled <= _maxLag) {
        for (final candidate in [lag * 2 - 1, lag * 2 + 1]) {
          if (candidate <= _maxLag && cmnd[candidate] < cmnd[doubled]) {
            doubled = candidate;
          }
        }
        if (cmnd[doubled] < cmnd[lag] * config.yinOctaveImprovementRatio &&
            cmnd[lag] - cmnd[doubled] > config.yinOctaveMinimumImprovement) {
          lag = doubled;
          octaveCorrected = true;
        }
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
          ? YinEstimate(pitch, (1 - center).clamp(0.0, 1.0), octaveCorrected)
          : null;
    }
    return null;
  }
}
