import 'dart:math' as math;

import 'analysis_result.dart';
import 'transcript.dart';

class CaptionCue {
  const CaptionCue(this.words, this.startMs, this.endMs);
  final List<TranscriptWord> words;
  final int startMs, endMs;
  TranscriptWord? wordAt(int positionMs) {
    TranscriptWord? current;
    for (final word in words) {
      if (word.startMs > positionMs) break;
      current = word;
    }
    return current;
  }
}

List<CaptionCue> captionCues(
  TranscriptResult transcript,
  List<PauseInterval> pauses,
  TranscriptionConfig config,
) {
  final cues = <CaptionCue>[];
  final words = transcript.words;
  var start = 0;
  while (start < words.length) {
    var end = start + 1;
    while (end < words.length &&
        end - start < config.captionWordsPerCue &&
        words[end].startMs - words[end - 1].startMs < config.captionGapMs &&
        !pauses.any(
          (p) =>
              p.startMs >= words[end - 1].startMs &&
              p.startMs < words[end].startMs,
        )) {
      end++;
    }
    final last = words[end - 1].startMs;
    var until = math.min(transcript.durationMs, last + config.captionMaxHoldMs);
    if (end < words.length) until = math.min(until, words[end].startMs);
    for (final pause in pauses) {
      if (pause.startMs >= last) until = math.min(until, pause.startMs);
    }
    cues.add(
      CaptionCue(
        List.unmodifiable(words.sublist(start, end)),
        words[start].startMs,
        until,
      ),
    );
    start = end;
  }
  return List.unmodifiable(cues);
}

bool isCaptionPause(List<PauseInterval> pauses, int positionMs) =>
    pauses.any((p) => positionMs >= p.startMs && positionMs < p.endMs);

CaptionCue? captionAt(
  List<CaptionCue> cues,
  List<PauseInterval> pauses,
  int positionMs,
) {
  if (isCaptionPause(pauses, positionMs)) {
    return null;
  }
  for (final cue in cues) {
    if (positionMs >= cue.startMs && positionMs < cue.endMs) return cue;
  }
  return null;
}
