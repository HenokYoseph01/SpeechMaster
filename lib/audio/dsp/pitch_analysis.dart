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
  final speechMask = <bool>[];
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
    speechMask.add(isSpeech);
    hz.add(isSpeech ? detector.detect(samples, offset: offset) : null);
    if (hz.length % config.contourPointsPerSecond == 0) {
      onProgress?.call(0.4 + 0.3 * offset / math.max(1, samples.length));
    }
  }
  var selected = _prepareContour(hz, speechPitchFrames, config);
  var usedPitchFallback = false;
  onProgress?.call(0.75);
  if (!selected.usable && hz.isNotEmpty) {
    // Approved chart-only fallback: steady voiced audio can lift the adaptive
    // noise floor and be excluded by VAD. YIN still has to find a periodic
    // signal in enough of the whole clip; silence/noise do not get a contour.
    final candidates = [...hz];
    for (var i = 0; i < candidates.length; i++) {
      if (!speechMask[i]) {
        candidates[i] = detector.detect(
          samples,
          offset: i * config.pitchHopSamples,
        );
      }
      if (i % config.contourPointsPerSecond == 0) {
        onProgress?.call(0.75 + 0.2 * i / candidates.length);
      }
    }
    final fallback = _prepareContour(candidates, candidates.length, config);
    if (fallback.usable) {
      selected = fallback;
      usedPitchFallback = true;
    }
  }
  final cleaned = selected.usable
      ? _smoothContour(selected.contour, config)
      : List<double?>.filled(hz.length, null);
  final points = <PitchPoint>[];
  final intervalMs = 1000 ~/ config.contourPointsPerSecond;
  for (var timeMs = 0; timeMs < audio.durationMs; timeMs += intervalMs) {
    final from = math.min(cleaned.length, timeMs ~/ config.pitchHopMs);
    final to = math.min(
      cleaned.length,
      (timeMs + intervalMs + config.pitchHopMs - 1) ~/ config.pitchHopMs,
    );
    final voicedInBucket = cleaned
        .sublist(from, to)
        .whereType<double>()
        .toList();
    final energyIndex = timeMs ~/ config.energyHopMs;
    points.add(
      PitchPoint(
        timeMs,
        // A single unvoiced sample must not hide the other voiced frames in
        // this 100 ms bucket. Fully unvoiced buckets still remain gaps.
        voicedInBucket.isEmpty ? null : percentile(voicedInBucket, 50),
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
    medianHz: selected.usable ? selected.medianHz : null,
    voicedRatio: selected.ratio,
    // The fallback is for the chart, not a replacement speech-time estimate.
    speechMs: energy.speech.where((frame) => frame).length * config.energyHopMs,
    analysisMs: watch.elapsedMilliseconds,
    noiseFloorDb: energy.noiseFloorDb,
    usedPitchFallback: usedPitchFallback,
  );
}

({double? medianHz, List<double?> contour, double ratio, bool usable})
_prepareContour(List<double?> hz, int candidateFrames, AudioConfig config) {
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
    } else {
      contour.add(st);
    }
    // Compare adjacent detected voiced frames, including a rejected frame.
    // Holding the last accepted pitch can reject an entire new register.
    if (st != null) previous = st;
  }
  final cleanVoiced = contour.whereType<double>().length;
  final ratio = candidateFrames == 0 ? 0.0 : cleanVoiced / candidateFrames;
  final usable = median != null && ratio >= config.minimumVoicedRatio;
  return (medianHz: median, contour: contour, ratio: ratio, usable: usable);
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
