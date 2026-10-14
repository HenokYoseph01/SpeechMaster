import '../../audio/analysis_result.dart';
import '../../audio/transcript.dart';

sealed class TranscriptMoment {
  int get timeMs;
}

class SpokenWordMoment extends TranscriptMoment {
  SpokenWordMoment(this.word);
  final TranscriptWord word;
  @override
  int get timeMs => word.startMs;
}

class PauseMoment extends TranscriptMoment {
  PauseMoment(this.pause);
  final PauseInterval pause;
  @override
  int get timeMs => pause.startMs;
}

List<TranscriptMoment> transcriptTimeline(
  TranscriptResult result,
  List<PauseInterval> pauses,
) {
  final moments = <TranscriptMoment>[
    for (final word in result.words) SpokenWordMoment(word),
    for (final pause in pauses) PauseMoment(pause),
  ];
  // Markers are acoustic measurements, never punctuation inferred by ASR.
  moments.sort((a, b) {
    final time = a.timeMs.compareTo(b.timeMs);
    if (time != 0) return time;
    return a is PauseMoment
        ? (b is PauseMoment ? 0 : -1)
        : (b is PauseMoment ? 1 : 0);
  });
  return List.unmodifiable(moments);
}

TranscriptMoment? transcriptMomentAt(
  TranscriptResult result,
  List<PauseInterval> pauses,
  int positionMs,
) {
  if (positionMs < 0 || positionMs >= result.durationMs) return null;
  for (final pause in pauses) {
    if (positionMs >= pause.startMs && positionMs < pause.endMs) {
      return PauseMoment(pause);
    }
  }
  TranscriptWord? active;
  for (final word in result.words) {
    if (word.startMs > positionMs) break;
    active = word;
  }
  return active == null ? null : SpokenWordMoment(active);
}
