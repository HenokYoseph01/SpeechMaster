import 'dart:math' as math;
import 'dart:typed_data';

import '../audio_config.dart';
import 'vad.dart';

// Two second-order Butterworth sections suppress rumble and high-frequency
// consonants. Recursive filtering is linear in clip length, unlike a long FIR.
Float32List bandPassForSyllables(Float32List samples, AudioConfig config) {
  final highPass = _Biquad(
    config.syllableBandLowHz,
    config.captureSampleRate,
    true,
  );
  final lowPass = _Biquad(
    config.syllableBandHighHz,
    config.captureSampleRate,
    false,
  );
  final output = Float32List(samples.length);
  for (var i = 0; i < samples.length; i++) {
    output[i] = lowPass.filter(highPass.filter(samples[i]));
  }
  return output;
}

class _Biquad {
  _Biquad(double cutoff, int rate, bool highPass) {
    final omega = 2 * math.pi * cutoff / rate;
    final cosine = math.cos(omega);
    final alpha = math.sin(omega) / math.sqrt2;
    final a0 = 1 + alpha;
    b0 = (highPass ? (1 + cosine) : (1 - cosine)) / (2 * a0);
    b1 = (highPass ? -(1 + cosine) : (1 - cosine)) / a0;
    b2 = b0;
    a1 = -2 * cosine / a0;
    a2 = (1 - alpha) / a0;
  }
  late final double b0, b1, b2, a1, a2;
  double x1 = 0, x2 = 0, y1 = 0, y2 = 0;
  double filter(double x) {
    final y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
    x2 = x1;
    x1 = x;
    y2 = y1;
    y1 = y;
    return y;
  }
}

List<int> detectSyllablePeaks(
  Float32List samples,
  SpeechFrames energy,
  List<double?> speechContour,
  AudioConfig config,
) {
  if (energy.noiseFloorDb == null || !speechContour.any((v) => v != null)) {
    return const [];
  }
  final filtered = bandPassForSyllables(samples, config);
  final frame = config.captureSampleRate * config.energyFrameMs ~/ 1000;
  final hop = config.captureSampleRate * config.energyHopMs ~/ 1000;
  final powers = <double>[];
  var sum = 0.0;
  for (var i = 0; i < filtered.length; i++) {
    sum += filtered[i] * filtered[i];
    if (i >= frame) sum -= filtered[i - frame] * filtered[i - frame];
    if (i + 1 >= frame && (i + 1 - frame) % hop == 0) {
      powers.add(math.max(0, sum / frame));
    }
  }
  // Centered 40 ms moving average of energy, followed by RMS-to-dB.
  final smoothFrames = (config.syllableSmoothMs / config.energyHopMs).round();
  final prefix = <double>[0];
  for (final power in powers) {
    prefix.add(prefix.last + power);
  }
  final envelope = <double>[];
  for (var i = 0; i < powers.length; i++) {
    final from = math.max(0, i - (smoothFrames - 1) ~/ 2);
    final to = math.min(powers.length, i + smoothFrames ~/ 2 + 1);
    final rms = math.sqrt(
      math.max(0, (prefix[to] - prefix[from]) / (to - from)),
    );
    envelope.add(20 * math.log(rms + config.rmsEpsilon) / math.ln10);
  }
  final threshold = energy.noiseFloorDb! + config.speechMarginDb;
  final candidates = <({int timeMs, double db})>[];
  for (var i = 1; i + 1 < envelope.length; i++) {
    if (envelope[i] <= threshold ||
        envelope[i] <= envelope[i - 1] ||
        envelope[i] < envelope[i + 1] ||
        !energy.speech[i]) {
      continue;
    }
    final timeMs = i * config.energyHopMs + config.energyFrameMs ~/ 2;
    final pitchIndex = ((timeMs - config.pitchFrameMs / 2) / config.pitchHopMs)
        .round();
    if (pitchIndex >= 0 &&
        pitchIndex < speechContour.length &&
        speechContour[pitchIndex] != null) {
      candidates.add((timeMs: timeMs, db: envelope[i]));
    }
  }
  // Keep the stronger peak when two candidates are closer than 100 ms.
  candidates.sort((a, b) {
    final strength = b.db.compareTo(a.db);
    return strength != 0 ? strength : a.timeMs.compareTo(b.timeMs);
  });
  final peaks = <int>[];
  for (final candidate in candidates) {
    if (peaks.every(
      (t) => (t - candidate.timeMs).abs() >= config.syllableMinimumGapMs,
    )) {
      peaks.add(candidate.timeMs);
    }
  }
  peaks.sort();
  return List.unmodifiable(peaks);
}
