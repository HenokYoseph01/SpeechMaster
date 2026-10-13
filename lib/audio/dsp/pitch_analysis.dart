import 'dart:math' as math;

import '../audio_config.dart';
import '../pitch_result.dart';
import 'downsample.dart';
import 'statistics.dart';
import 'vad.dart';
import 'wav.dart';
import 'yin.dart';

PitchResult analyzePitch(
  WavAudio audio,
  AudioConfig config, {
  void Function(double)? onProgress,
}) {
  final watch = Stopwatch()..start();
  final energy = detectSpeech(audio.samples, config);
  onProgress?.call(0.2);
  final samples = downsampleForPitch(audio.samples, config);
  onProgress?.call(0.4);
  final detector = YinDetector(config);
  final hz = <double?>[];
  var speechPitchFrames = 0;
  for (
    var offset = 0;
    offset + config.pitchFrameSamples <= samples.length;
    offset += config.pitchHopSamples
  ) {
    final timeMs = offset * 1000 ~/ config.pitchSampleRate;
    final energyIndex =
        (timeMs + config.pitchFrameMs ~/ 2) ~/ config.energyHopMs;
    final isSpeech =
        energyIndex < energy.speech.length && energy.speech[energyIndex];
    if (isSpeech) speechPitchFrames++;
    hz.add(isSpeech ? detector.detect(samples, offset: offset) : null);
    if (hz.length % config.contourPointsPerSecond == 0) {
      onProgress?.call(0.4 + 0.5 * offset / math.max(1, samples.length));
    }
  }
  final voiced = hz.whereType<double>().toList();
  final median = voiced.isEmpty ? null : percentile(voiced, 50);
  final contour = <double?>[];
  double? previous;
  for (final value in hz) {
    final st = value == null || median == null
        ? null
        : semitones(value, median);
    if (st == null) {
      contour.add(null);
    } else if (previous != null &&
        (st - previous).abs() > config.octaveJumpSemitones) {
      contour.add(null);
      // Keep the last accepted frame so an octave-error run does not become a new baseline.
    } else {
      contour.add(st);
      previous = st;
    }
  }
  final cleanVoiced = contour.whereType<double>().length;
  final ratio = speechPitchFrames == 0 ? 0.0 : cleanVoiced / speechPitchFrames;
  final usable = median != null && ratio >= config.minimumVoicedRatio;
  final cleaned = usable
      ? _smoothContour(contour, config)
      : List<double?>.filled(contour.length, null);
  final points = <PitchPoint>[];
  final intervalMs = 1000 ~/ config.contourPointsPerSecond;
  for (var timeMs = 0; timeMs < audio.durationMs; timeMs += intervalMs) {
    final pitchIndex = timeMs ~/ config.pitchHopMs;
    final energyIndex = timeMs ~/ config.energyHopMs;
    points.add(
      PitchPoint(
        timeMs,
        pitchIndex < cleaned.length ? cleaned[pitchIndex] : null,
        energyIndex < energy.db.length
            ? energy.db[energyIndex]
            : energy.noiseFloorDb ?? 0,
      ),
    );
  }
  onProgress?.call(1);
  return PitchResult(
    durationMs: audio.durationMs,
    points: List.unmodifiable(points),
    medianHz: usable ? median : null,
    voicedRatio: ratio,
    speechMs: energy.speech.where((frame) => frame).length * config.energyHopMs,
    analysisMs: watch.elapsedMilliseconds,
    noiseFloorDb: energy.noiseFloorDb,
  );
}

List<double?> _smoothContour(List<double?> values, AudioConfig config) {
  final result = List<double?>.filled(values.length, null);
  for (var start = 0; start < values.length;) {
    if (values[start] == null) {
      start++;
      continue;
    }
    var end = start;
    while (end < values.length && values[end] != null) {
      end++;
    }
    final run = values.sublist(start, end).cast<double>();
    final median = medianSmooth(run, config.pitchMedianFrames);
    for (var i = 0; i < run.length; i++) {
      final window = median.sublist(
        math.max(0, i - config.pitchAverageFrames ~/ 2),
        math.min(median.length, i + config.pitchAverageFrames ~/ 2 + 1),
      );
      result[start + i] = window.reduce((a, b) => a + b) / window.length;
    }
    start = end;
  }
  return result;
}
