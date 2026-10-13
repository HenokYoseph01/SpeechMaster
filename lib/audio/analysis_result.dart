enum PauseKind { short, medium, long }

class PauseInterval {
  const PauseInterval(this.startMs, this.endMs, this.kind);
  final int startMs;
  final int endMs;
  final PauseKind kind;
  int get durationMs => endMs - startMs;
  List<int> toJson() => [startMs, endMs];
}

class PaceWindow {
  const PaceWindow({
    required this.startMs,
    required this.endMs,
    required this.speechMs,
    required this.syllables,
    required this.syllablesPerSecond,
  });
  final int startMs;
  final int endMs;
  final int speechMs;
  final int syllables;
  // Null when the window has too little speech for a pace comparison.
  final double? syllablesPerSecond;
}

enum QualityWarning {
  insufficientSpeech('insufficient_speech'),
  noisyRecording('noisy_recording'),
  clippedAudio('clipped_audio'),
  quietAudio('quiet_audio');

  const QualityWarning(this.code);
  final String code;
}

// Measurements only. Scoring and tip selection belong to Phase 2.
class AnalysisResult {
  const AnalysisResult({
    required this.pitchMedianHz,
    required this.pitchRangeSt,
    required this.pitchStdSt,
    required this.pitchMovementStPerS,
    required this.syllableCount,
    required this.articulationRate,
    required this.speakingRate,
    required this.approximateEnglishWpm,
    required this.paceCV,
    required this.loudnessRangeDb,
    required this.energyTrendDb,
    required this.pausesPerMin,
    required this.pauseRatio,
    required this.longPauseCount,
    required this.meanPauseMs,
    required this.speechMs,
    required this.snrDb,
    required this.clippingPct,
    required this.pauses,
    required this.paceWindows,
    required this.qualityWarnings,
  });
  // These remain null below the full speech-frame voicing requirement,
  // even when the separate, more permissive preview still draws a chart.
  final double? pitchMedianHz;
  final double? pitchRangeSt;
  final double? pitchStdSt;
  final double? pitchMovementStPerS;
  final int? syllableCount;
  final double? articulationRate;
  final double? speakingRate;
  final double? approximateEnglishWpm;
  final double? paceCV;
  final double? loudnessRangeDb;
  final double? energyTrendDb;
  final double pausesPerMin;
  final double pauseRatio;
  final int longPauseCount;
  final int? meanPauseMs;
  final int speechMs;
  final double? snrDb;
  final double clippingPct;
  final List<PauseInterval> pauses;
  final List<PaceWindow> paceWindows;
  final List<QualityWarning> qualityWarnings;
  bool get passesQualityGates => qualityWarnings.isEmpty;
  int get totalPauseMs =>
      pauses.fold(0, (sum, pause) => sum + pause.durationMs);
  int get shortPauseCount =>
      pauses.where((p) => p.kind == PauseKind.short).length;
  int get mediumPauseCount =>
      pauses.where((p) => p.kind == PauseKind.medium).length;
}
