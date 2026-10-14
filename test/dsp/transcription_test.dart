import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/audio/transcription_isolate.dart';
import 'package:speech_coach/audio/analysis_result.dart';
import 'package:speech_coach/features/record/transcript_timeline.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = TranscriptionConfig.fromJson(
    jsonDecode(File('assets/transcription_config.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  String? nativeDirectory;
  if (Platform.isLinux) {
    final packages = jsonDecode(
      File('.dart_tool/package_config.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final package = (packages['packages'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['name'] == 'sherpa_onnx_linux');
    nativeDirectory = Directory.fromUri(Uri.parse(package['rootUri'] as String))
        .uri
        .resolve('linux/x64/')
        .toFilePath();
  }
  final model = Directory('assets/models/english_zipformer').absolute.path;

  test(
    'groups SentencePiece and leading-space subwords without inventing timing',
    () {
      final words = wordsFromTokens(
        ['▁HEL', 'LO', '▁WORLD', "'S", ' AGAIN'],
        [0.2, 0.3, 1.0, 1.1, 2.0],
        durationMs: 3000,
        offsetMs: 100,
      );
      expect(words.map((w) => w.text), ['HELLO', "WORLD'S", 'AGAIN']);
      expect(words.map((w) => w.startMs), [300, 1100, 2100]);
    },
  );
  test('invalid or unavailable token timing fails instead of distributing words evenly', () {
    expect(
      () => wordsFromTokens(['▁HELLO'], [], durationMs: 1000),
      throwsFormatException,
    );
    expect(
      () => wordsFromTokens(['▁A'], [double.nan], durationMs: 1000),
      throwsFormatException,
    );
    expect(
      () => wordsFromTokens(['▁A', '▁B'], [0.3, 0.2], durationMs: 1000),
      throwsFormatException,
    );
  });
  test('overlapping chunks partition the full recording without duplicate ownership', () {
    final chunks = transcriptChunks(60000, config);
    expect(chunks.first.startMs, 0);
    expect(chunks.first.keepStartMs, 0);
    expect(chunks.last.endMs, 60000);
    expect(chunks.last.keepEndMs, 60000);
    for (var i = 1; i < chunks.length; i++) {
      expect(chunks[i].startMs, chunks[i - 1].endMs - config.overlapMs);
      expect(chunks[i].keepStartMs, chunks[i - 1].keepEndMs);
    }
    expect(transcriptChunks(0, config), isEmpty);
  });
  test('pause markers come from acoustic intervals and active gaps override word highlights', () {
    const result = TranscriptResult(
      durationMs: 3000,
      elapsedMs: 1,
      words: [TranscriptWord('HELLO', 200), TranscriptWord('WORLD', 1500)],
    );
    const pauses = [PauseInterval(500, 1200, PauseKind.medium)];
    final timeline = transcriptTimeline(result, pauses);
    expect(timeline.map((m) => m.timeMs), [200, 500, 1500]);
    expect(timeline.whereType<PauseMoment>().single.pause.durationMs, 700);
    expect(
      transcriptTimeline(result, const []).whereType<PauseMoment>(),
      isEmpty,
    );
    expect(transcriptMomentAt(result, pauses, 100), isNull);
    expect(transcriptMomentAt(result, pauses, 700), isA<PauseMoment>());
    expect(
      (transcriptMomentAt(result, pauses, 1600) as SpokenWordMoment).word.text,
      'WORLD',
    );
  });
  test('local reference English speech is recognized with ordered real timestamps in the isolate', () async {
    final events = await transcribeWavInIsolate(
      File('test/fixtures/english-reference.wav').absolute.path,
      model,
      config,
      nativeLibraryDirectory: nativeDirectory,
    ).toList();
    final result = events.whereType<TranscriptComplete>().single.result;
    expect(result.text, contains('AFTER EARLY NIGHTFALL'));
    expect(result.text, contains('YELLOW LAMPS'));
    expect(result.words.length, greaterThan(10));
    expect(result.words.first.startMs, greaterThanOrEqualTo(0));
    for (var i = 1; i < result.words.length; i++) {
      expect(
        result.words[i].startMs,
        greaterThanOrEqualTo(result.words[i - 1].startMs),
      );
    }
    expect(result.words.last.startMs, lessThan(result.durationMs));
    final progress = events
        .whereType<TranscriptProgress>()
        .map((p) => p.value)
        .toList();
    expect(progress.first, 0);
    expect(progress.last, 1);
    for (var i = 1; i < progress.length; i++) {
      expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
    }
    // ignore: avoid_print
    print(
      'English reference ASR: ${result.words.length} words, ${result.elapsedMs} ms',
    );
  });
  test(
    'silence produces an empty transcript and missing audio produces an error',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_asr_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/silence.wav');
      await file.writeAsBytes(makeWav(Float32List(16000)));
      final events = await transcribeWavInIsolate(
        file.path,
        model,
        config,
        nativeLibraryDirectory: nativeDirectory,
      ).toList();
      expect(
        events.whereType<TranscriptComplete>().single.result.words,
        isEmpty,
      );
      await expectLater(
        transcribeWavInIsolate(
          '${directory.path}/missing.wav',
          model,
          config,
          nativeLibraryDirectory: nativeDirectory,
        ).toList(),
        throwsStateError,
      );
    },
  );
}
