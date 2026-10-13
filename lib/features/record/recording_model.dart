import '../../audio/pitch_result.dart';

enum RecordingMode {
  thirtySeconds(30000),
  sixtySeconds(60000);

  const RecordingMode(this.durationMs);
  final int durationMs;
}

enum RecordingPhase {
  ready,
  starting,
  recording,
  stopping,
  analyzing,
  done,
  permissionDenied,
  interrupted,
  failure,
  cancelling,
}

enum RecordingFailure { capture, analysis, storage }

class ClipDraft {
  const ClipDraft({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.mode,
    required this.language,
  });
  final String id;
  final String path;
  final int createdAt;
  final RecordingMode mode;
  final String language;
}

class RecordingState {
  const RecordingState({
    this.mode = RecordingMode.thirtySeconds,
    this.phase = RecordingPhase.ready,
    this.elapsedMs = 0,
    this.minimumMs = 0,
    this.progress = 0,
    this.levels = const [],
    this.result,
    this.failure,
    this.canRetryAnalysis = false,
  });
  final RecordingMode mode;
  final RecordingPhase phase;
  final int elapsedMs;
  final int minimumMs;
  final double progress;
  final List<double> levels;
  final PitchResult? result;
  final RecordingFailure? failure;
  final bool canRetryAnalysis;
  bool get isBusy => switch (phase) {
    RecordingPhase.starting ||
    RecordingPhase.recording ||
    RecordingPhase.stopping ||
    RecordingPhase.analyzing ||
    RecordingPhase.cancelling => true,
    _ => false,
  };
  bool get canStop =>
      phase == RecordingPhase.recording && elapsedMs >= minimumMs;
  int get remainingSeconds =>
      ((mode.durationMs - elapsedMs).clamp(0, mode.durationMs) / 1000).ceil();
  RecordingState recordingUpdate({int? elapsedMs, List<double>? levels}) =>
      RecordingState(
        mode: mode,
        phase: phase,
        elapsedMs: elapsedMs ?? this.elapsedMs,
        minimumMs: minimumMs,
        levels: levels ?? this.levels,
      );
}
