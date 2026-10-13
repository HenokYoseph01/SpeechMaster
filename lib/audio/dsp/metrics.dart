import 'dart:math' as math;

import '../analysis_result.dart';
import '../audio_config.dart';
import 'pauses.dart';
import 'statistics.dart';
import 'syllables.dart';
import 'vad.dart';
import 'wav.dart';

AnalysisResult measureDelivery(
  WavAudio audio,
  SpeechFrames energy,
  List<double?> speechContour,
  double? speechMedianHz,
  double speechVoicedRatio,
  AudioConfig config,
) {
  final speechDb = <double>[
    for (var i = 0; i < energy.speech.length; i++)
      if (energy.speech[i]) energy.db[i],
  ];
  final speechMs = speechDb.length * config.energyHopMs;
  final pauses = detectPauses(energy.speech, config);
  final pauseMs = pauses.fold<int>(0, (sum, p) => sum + p.durationMs);
  final voiced = speechContour.whereType<double>().toList();
  final pitchUsable =
      speechMedianHz != null &&
      speechVoicedRatio >= config.minimumVoicedRatio &&
      voiced.isNotEmpty;
  final movements = <double>[
    for (var i = 1; i < speechContour.length; i++)
      if (speechContour[i] != null && speechContour[i - 1] != null)
        (speechContour[i]! - speechContour[i - 1]!).abs(),
  ];
  final hasVoicedSpeech = voiced.isNotEmpty && speechMs > 0;
  final peaks = detectSyllablePeaks(
    audio.samples,
    energy,
    speechContour,
    config,
  );
  final speakingRate = hasVoicedSpeech && audio.durationMs > 0
      ? peaks.length * 1000 / audio.durationMs
      : null;
  final windows = buildPaceWindows(
    audio.durationMs,
    energy.speech,
    peaks,
    config,
    hasVoicedSpeech: hasVoicedSpeech,
  );
  final rates = windows
      .map((w) => w.syllablesPerSecond)
      .whereType<double>()
      .toList();
  final meanRate = rates.isEmpty ? 0.0 : _mean(rates);
  final snr = energy.db.isEmpty || energy.noiseFloorDb == null
      ? null
      : percentile(energy.db, config.qualitySnrPercentile) -
            energy.noiseFloorDb!;
  final clipped = audio.samples
      .where((s) => s.abs() >= config.clippingSampleThreshold)
      .length;
  final clippingPct = audio.samples.isEmpty
      ? 0.0
      : clipped * 100 / audio.samples.length;
  final loudest = speechDb.isEmpty ? null : speechDb.reduce(math.max);
  final warnings = qualityWarnings(
    speechMs: speechMs,
    snrDb: snr,
    clippingPct: clippingPct,
    loudestSpeechDb: loudest,
    config: config,
  );
  final third = speechDb.length ~/ 3;
  return AnalysisResult(
    pitchMedianHz: pitchUsable ? speechMedianHz : null,
    pitchRangeSt: pitchUsable
        ? percentile(voiced, config.pitchRangeHighPercentile) -
              percentile(voiced, config.pitchRangeLowPercentile)
        : null,
    pitchStdSt: pitchUsable ? _std(voiced) : null,
    pitchMovementStPerS: pitchUsable && movements.isNotEmpty
        ? _mean(movements) * 1000 / config.pitchHopMs
        : null,
    syllableCount: hasVoicedSpeech ? peaks.length : null,
    articulationRate: hasVoicedSpeech ? peaks.length * 1000 / speechMs : null,
    speakingRate: speakingRate,
    approximateEnglishWpm: speakingRate == null
        ? null
        : speakingRate * 60 / config.englishSyllablesPerWord,
    paceCV: rates.length >= 2 && meanRate > 0 ? _std(rates) / meanRate : null,
    loudnessRangeDb: speechDb.isEmpty
        ? null
        : percentile(speechDb, config.loudnessHighPercentile) -
              percentile(speechDb, config.loudnessLowPercentile),
    energyTrendDb: third == 0
        ? null
        : _mean(speechDb.sublist(speechDb.length - third)) -
              _mean(speechDb.sublist(0, third)),
    pausesPerMin: audio.durationMs == 0
        ? 0
        : pauses.length * 60000 / audio.durationMs,
    pauseRatio: audio.durationMs == 0 ? 0 : pauseMs / audio.durationMs,
    longPauseCount: pauses.where((p) => p.kind == PauseKind.long).length,
    meanPauseMs: pauses.isEmpty ? null : (pauseMs / pauses.length).round(),
    speechMs: speechMs,
    snrDb: snr,
    clippingPct: clippingPct,
    pauses: pauses,
    paceWindows: windows,
    qualityWarnings: warnings,
  );
}

List<PaceWindow> buildPaceWindows(
  int durationMs,
  List<bool> speech,
  List<int> syllableTimes,
  AudioConfig config, {
  required bool hasVoicedSpeech,
}) {
  final windows = <PaceWindow>[];
  for (var start = 0; start < durationMs; start += config.paceWindowMs) {
    final end = math.min(durationMs, start + config.paceWindowMs);
    var speechMs = 0;
    // Include exact overlap when a configuration uses non-aligned boundaries.
    for (
      var i = start ~/ config.energyHopMs;
      i < speech.length && i * config.energyHopMs < end;
      i++
    ) {
      if (speech[i]) {
        speechMs += math.max(
          0,
          math.min(end, (i + 1) * config.energyHopMs) -
              math.max(start, i * config.energyHopMs),
        );
      }
    }
    final count = syllableTimes.where((t) => t >= start && t < end).length;
    windows.add(
      PaceWindow(
        startMs: start,
        endMs: end,
        speechMs: speechMs,
        syllables: count,
        syllablesPerSecond:
            hasVoicedSpeech && speechMs >= config.paceMinimumSpeechMs
            ? count * 1000 / (end - start)
            : null,
      ),
    );
  }
  return List.unmodifiable(windows);
}

List<QualityWarning> qualityWarnings({
  required int speechMs,
  required double? snrDb,
  required double clippingPct,
  required double? loudestSpeechDb,
  required AudioConfig config,
}) => List.unmodifiable([
  if (speechMs < config.qualityMinimumSpeechMs)
    QualityWarning.insufficientSpeech,
  if (snrDb != null && snrDb < config.qualityMinimumSnrDb)
    QualityWarning.noisyRecording,
  if (clippingPct > config.qualityMaximumClippingPct)
    QualityWarning.clippedAudio,
  if (loudestSpeechDb != null && loudestSpeechDb < config.qualityQuietFrameDb)
    QualityWarning.quietAudio,
]);

double _mean(List<double> values) =>
    values.reduce((a, b) => a + b) / values.length;
double _std(List<double> values) {
  final mean = _mean(values);
  return math.sqrt(
    values.fold<double>(0, (sum, v) => sum + (v - mean) * (v - mean)) /
        values.length,
  );
}
