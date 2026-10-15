import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_result.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/core/l10n/generated/app_localizations.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/record/playback_controller.dart';
import 'package:speech_coach/features/record/transcript_panel.dart';
import 'package:speech_coach/features/record/transcription_controller.dart';

import '../support/audio_fixtures.dart';
import 'transcription_controller_test.dart'
    show exampleTranscript, MemoryTranscriptRepository;

class RecordingReplaySpy extends PlaybackController {
  RecordingReplaySpy()
    : super(
        '/local.wav',
        () => throw StateError('No native audio in a widget test'),
      );
  int? wordPosition;
  (int, int)? gap;
  @override
  Future<void> playFrom(int absoluteMs, int durationMs) async {
    wordPosition = absoluteMs;
  }

  @override
  Future<void> previewPause(
    int startMs,
    int endMs,
    int durationMs,
    int contextMs,
  ) async {
    gap = (startMs, endMs);
  }
}

void main() {
  testWidgets(
    'optional English transcription shows words and independent pause markers with replay',
    (tester) async {
      final replay = RecordingReplaySpy();
      var calls = 0;
      final container = ProviderContainer(
        overrides: [
          transcriberProvider.overrideWithValue((_) {
            calls++;
            return Stream.value(TranscriptComplete(exampleTranscript));
          }),
          transcriptRepositoryProvider.overrideWithValue(
            MemoryTranscriptRepository(),
          ),
          playbackControllerProvider.overrideWith((ref, path) => replay),
          transcriptionConfigProvider.overrideWith(
            (ref) async => TranscriptionConfig.fromJson({
              'version': 1,
              'chunkMs': 20000,
              'overlapMs': 1000,
              'threads': 2,
              'replayLeadMs': 350,
              'minimumSignalRms': 0.00001,
              'paceWindowMs': 10000,
              'captionWordsPerCue': 6,
              'captionGapMs': 1200,
              'captionMaxHoldMs': 2000,
            }),
          ),
        ],
      );
      addTearDown(
        () => tester.runAsync(() async {
          container.dispose();
          await replay.dispose();
        }),
      );
      // The known two-burst sample supplies a real acoustic pause for the UI.
      final samples = speechTone(durationSeconds: 4, silenceSeconds: 0.5);
      for (var i = 16000; i < 24000; i++) {
        samples[i] = 0;
      }
      final recording = analyzePitch(
        WavAudio(samples, 16000),
        loadAudioConfig(),
      );
      expect(recording.analysis!.pauses, hasLength(1));
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: buildTheme(AppTheme.honey, Brightness.light),
            home: Scaffold(
              body: SingleChildScrollView(
                child: TranscriptPanel(
                  path: '/local.wav',
                  recording: recording,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(calls, 0);
      await tester.tap(find.text('Transcribe recording'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.text('HELLO WORLD'), findsOneWidget);
      expect(
        find.text('2 recognized words · about 40 words/min'),
        findsOneWidget,
      );
      expect(find.text('0.0–3.0 s: about 40 words/min'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'HELLO'), findsOneWidget);
      expect(find.textContaining('…'), findsWidgets);
      await tester.tap(find.widgetWithText(ActionChip, 'HELLO'));
      await tester.pump();
      expect(replay.wordPosition, 150);
      await tester.tap(find.byType(ActionChip).last);
      await tester.pump();
      // Timeline order places WORLD last; select the actual acoustic-gap chip.
      final gapChip = find.byWidgetPredicate(
        (w) => w is ActionChip && w.avatar is Icon,
      );
      await tester.tap(gapChip);
      await tester.pump();
      final pause = recording.analysis!.pauses.single;
      expect(replay.gap, (pause.startMs, pause.endMs));
      expect(pause.kind, PauseKind.short);
      expect(tester.takeException(), isNull);
    },
  );
}
