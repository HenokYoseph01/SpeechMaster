import '../analysis_result.dart';
import '../audio_config.dart';

List<PauseInterval> detectPauses(List<bool> speech, AudioConfig config) {
  final pauses = <PauseInterval>[];
  int? lastSpeechEnd;
  for (var i = 0; i < speech.length;) {
    if (!speech[i]) {
      i++;
      continue;
    }
    final startMs = i * config.energyHopMs;
    if (lastSpeechEnd != null) {
      final duration = startMs - lastSpeechEnd;
      if (duration >= config.pauseMinimumMs) {
        pauses.add(
          PauseInterval(
            lastSpeechEnd,
            startMs,
            duration < config.pauseShortUpperMs
                ? PauseKind.short
                : duration <= config.pauseMediumUpperMs
                ? PauseKind.medium
                : PauseKind.long,
          ),
        );
      }
    }
    while (i < speech.length && speech[i]) {
      i++;
    }
    lastSpeechEnd = i * config.energyHopMs;
  }
  return List.unmodifiable(pauses);
}
