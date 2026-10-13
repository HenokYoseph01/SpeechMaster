import 'analysis_result.dart';

class PitchPoint {
  const PitchPoint(this.timeMs, this.semitones, this.db);
  final int timeMs;
  final double? semitones;
  final double db;
  List<num?> toJson() => [timeMs, semitones, db];
}

class PitchResult {
  const PitchResult({
    required this.durationMs,
    required this.points,
    required this.medianHz,
    required this.voicedRatio,
    required this.speechMs,
    required this.analysisMs,
    required this.noiseFloorDb,
    this.usedPitchFallback = false,
    this.analysis,
  });
  final int durationMs;
  final List<PitchPoint> points;
  final double? medianHz;
  final double voicedRatio;
  final int speechMs;
  final int analysisMs;
  final double? noiseFloorDb;
  final bool usedPitchFallback;
  final AnalysisResult? analysis;
  bool get hasPitch =>
      medianHz != null && points.any((point) => point.semitones != null);
}

sealed class PitchEvent {}

class PitchProgress extends PitchEvent {
  PitchProgress(this.value);
  final double value;
}

class PitchComplete extends PitchEvent {
  PitchComplete(this.result);
  final PitchResult result;
}
