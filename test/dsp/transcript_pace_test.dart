import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/audio/transcript_pace.dart';

void main() {
  test(
    'whole-clip rate includes silence and partial windows use real length',
    () {
      final result = measureTranscriptPace(
        const TranscriptResult(
          durationMs: 25000,
          elapsedMs: 0,
          words: [
            TranscriptWord("DON'T", 0),
            TranscriptWord('STOP', 9999),
            TranscriptWord('NOW', 10000),
            TranscriptWord('YES', 20000),
            TranscriptWord('…', 22000),
          ],
        ),
        10000,
      );
      expect(result.wordCount, 4);
      expect(result.wordsPerMinute, 9.6);
      expect(result.windows.map((w) => w.wordCount), [2, 1, 1]);
      expect(result.windows.map((w) => w.wordsPerMinute), [12, 6, 12]);
    },
  );
  test(
    'no recognized words means unavailable average, never confident zero',
    () {
      for (final duration in [0, 30000]) {
        final result = measureTranscriptPace(
          TranscriptResult(durationMs: duration, words: const [], elapsedMs: 0),
          10000,
        );
        expect(result.wordsPerMinute, isNull);
        expect(result.wordCount, 0);
      }
    },
  );
  test('word timing gaps retain empty windows without inferring pauses', () {
    final result = measureTranscriptPace(
      const TranscriptResult(
        durationMs: 30000,
        elapsedMs: 0,
        words: [TranscriptWord('FIRST', 100), TranscriptWord('LAST', 29999)],
      ),
      10000,
    );
    expect(result.windows.map((w) => w.wordCount), [1, 0, 1]);
    expect(result.wordsPerMinute, 4);
    expect(
      () => measureTranscriptPace(
        const TranscriptResult(durationMs: 0, words: [], elapsedMs: 0),
        0,
      ),
      throwsArgumentError,
    );
  });
}
