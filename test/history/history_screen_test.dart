import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/core/l10n/generated/app_localizations.dart';
import 'package:speech_coach/core/router.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/history/history_repository.dart';
import 'package:speech_coach/features/record/caption_preferences.dart';
import 'package:speech_coach/features/record/playback_controller.dart';
import 'package:speech_coach/features/record/recording_controller.dart';
import 'package:speech_coach/features/record/transcript_panel.dart';
import 'package:speech_coach/features/record/transcription_controller.dart';

import '../support/audio_fixtures.dart';
import '../record/playback_controller_test.dart' show FakePlaybackDevice;
import '../record/transcription_controller_test.dart'
    show MemoryTranscriptRepository, exampleTranscript;
import '../record/captions_test.dart' show MemoryPreferences;

void main() {
  testWidgets(
    'home opens saved clip, reuses transcript and stops playback on leaving',
    (tester) async {
      const row = Recording(
        id: 'saved',
        createdAt: 1000,
        durationMs: 3000,
        targetMs: 30000,
        audioPath: '/saved.wav',
        kind: 'free',
        language: 'en',
        analysisVersion: 6,
        title: 'Practice clip',
      );
      const result = PitchResult(
        durationMs: 3000,
        points: [],
        medianHz: null,
        voicedRatio: 0,
        speechMs: 0,
        analysisMs: 0,
        noiseFloorDb: null,
      );
      final device = FakePlaybackDevice();
      var transcriptions = 0;
      final repository = MemoryTranscriptRepository()
        ..saved = exampleTranscript;
      final config = TranscriptionConfig.fromJson(
        jsonDecode(File('assets/transcription_config.json').readAsStringSync())
            as Map<String, dynamic>,
      );
      final container = ProviderContainer(
        overrides: [
          recordingHistoryProvider.overrideWith((ref) => Stream.value([row])),
          savedRecordingProvider.overrideWith(
            (ref, id) async => const SavedRecording(row, result, true),
          ),
          audioConfigProvider.overrideWith((ref) async => loadAudioConfig()),
          transcriptionConfigProvider.overrideWith((ref) async => config),
          transcriptRepositoryProvider.overrideWithValue(repository),
          captionPreferencesProvider.overrideWithValue(MemoryPreferences()),
          playbackDeviceFactoryProvider.overrideWithValue(() => device),
          transcriberProvider.overrideWithValue((_) {
            transcriptions++;
            return const Stream.empty();
          }),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(routerProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: buildTheme(AppTheme.honey, Brightness.light),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Your recordings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Practice clip'));
      await tester.pumpAndSettle();
      expect(find.text('Closed captions'), findsOneWidget);
      expect(
        container
            .read(transcriptionControllerProvider('/saved.wav'))
            .state
            .result!
            .text,
        'HELLO WORLD',
      );
      expect(transcriptions, 0);
      await tester.tap(find.text('Play recording'));
      await tester.pumpAndSettle();
      expect(device.plays, 1);
      device.positions.add(1700);
      await tester.pumpAndSettle();
      expect(find.text('HELLO WORLD '), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Practice clip'), findsOneWidget);
      // Provider auto-disposal cascades through state streams on the next frame.
      await tester.pump();
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(Duration.zero);
      });
      expect(device.disposed, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
