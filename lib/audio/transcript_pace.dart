import 'dart:math' as math;

import 'transcript.dart';

class TranscriptPaceWindow {
  const TranscriptPaceWindow(this.startMs, this.endMs, this.wordCount);
  final int startMs, endMs, wordCount;
  double get wordsPerMinute => wordCount * 60000 / (endMs - startMs);
}

class TranscriptPace {
  const TranscriptPace(this.wordCount, this.wordsPerMinute, this.windows);
  final int wordCount;
  final double? wordsPerMinute;
  final List<TranscriptPaceWindow> windows;
}

// Token emission times allocate words to windows only. They never classify
// silence or supply word durations. Rates include all recorded silence.
TranscriptPace measureTranscriptPace(TranscriptResult result, int windowMs) {
  if (windowMs <= 0) throw ArgumentError.value(windowMs, 'windowMs');
  final counts = List<int>.filled(
    result.durationMs <= 0 ? 0 : (result.durationMs / windowMs).ceil(),
    0,
  );
  var total = 0;
  for (final word in result.words) {
    if (word.startMs < 0 || word.startMs >= result.durationMs) continue;
    // Ignore punctuation-only entries, without splitting contractions or
    // hyphenated words into inflated word counts.
    if (!RegExp(r'[A-Za-z0-9]').hasMatch(word.text)) continue;
    counts[word.startMs ~/ windowMs]++;
    total++;
  }
  return TranscriptPace(
    total,
    total == 0 || result.durationMs <= 0
        ? null
        : total * 60000 / result.durationMs,
    List.unmodifiable([
      for (var i = 0; i < counts.length; i++)
        TranscriptPaceWindow(
          i * windowMs,
          math.min(result.durationMs, (i + 1) * windowMs),
          counts[i],
        ),
    ]),
  );
}
