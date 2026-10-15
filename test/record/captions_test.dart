import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_result.dart';
import 'package:speech_coach/audio/captions.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/core/l10n/generated/app_localizations.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/record/caption_preferences.dart';
import 'package:speech_coach/features/record/playback_controller.dart';
import 'package:speech_coach/features/record/recording_captions.dart';
import 'package:speech_coach/features/record/transcript_panel.dart';
import 'package:speech_coach/features/record/transcription_controller.dart';

import '../support/audio_fixtures.dart';

import 'transcription_controller_test.dart' show MemoryTranscriptRepository;

const transcript = TranscriptResult(
  durationMs: 6000,
  elapsedMs: 0,
  words: [
    TranscriptWord('HELLO', 500),
    TranscriptWord('WORLD', 900),
    TranscriptWord('AGAIN', 4000),
  ],
);

class MemoryPreferences extends CaptionPreferences {
  bool enabled = true;
  @override
  Future<bool> load(String path) async => enabled;
  @override
  Future<void> save(String path, bool enabled) async {
    this.enabled = enabled;
  }
}

class FailingPreferences extends CaptionPreferences {
  @override
  Future<bool> load(String path) async => true;
  @override
  Future<void> save(String path, bool enabled) async =>
      throw StateError('disk full');
}

void main() {
  final config = TranscriptionConfig.fromJson(
    jsonDecode(File('assets/transcription_config.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  test(
    'cues follow seek positions, split gaps and expire after final word',
    () {
      final cues = captionCues(transcript, const [], config);
      expect(cues, hasLength(2));
      expect(captionAt(cues, [], 0), isNull);
      expect(captionAt(cues, [], 1000)!.wordAt(1000)!.text, 'WORLD');
      expect(captionAt(cues, [], 3500), isNull);
      expect(captionAt(cues, [], 4500)!.words.single.text, 'AGAIN');
      expect(captionAt(cues, [], 6000), isNull);
      expect(captionAt(cues, [], 600)!.wordAt(600)!.text, 'HELLO');
    },
  );
  test(
    'acoustic pauses hide captions without deriving silence from missing words',
    () {
      const pauses = [PauseInterval(1000, 1600, PauseKind.medium)];
      final cues = captionCues(transcript, pauses, config);
      expect(captionAt(cues, pauses, 1200), isNull);
      expect(captionAt(cues, pauses, 999), isNotNull);
      expect(
        captionCues(
          const TranscriptResult(durationMs: 1000, elapsedMs: 0, words: []),
          [],
          config,
        ),
        isEmpty,
      );
    },
  );
  test('caption preference survives reopening, defaults on and stays per recording', () async {
    final directory = await Directory.systemTemp.createTemp(
      'caption_preferences_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final path = '${directory.path}/clip.wav';
    final repository = CaptionPreferences();
    expect(await repository.load(path), isTrue);
    await repository.save(path, false);
    expect(await CaptionPreferences().load(path), isFalse);
    expect(await repository.load('${directory.path}/other.wav'), isTrue);
    await File('$path.captions.json').writeAsString('broken');
    expect(await repository.load(path), isTrue);
  });
  test(
    'failed preference save retains session choice and permits retry',
    () async {
      final controller = CaptionPreferenceController(
        '/local.wav',
        FailingPreferences(),
      );
      addTearDown(controller.dispose);
      await controller.load();
      await controller.setEnabled(false);
      expect(controller.state.enabled, isFalse);
      expect(controller.state.failed, isTrue);
      expect(controller.state.saving, isFalse);
    },
  );
  testWidgets(
    'cached transcript enables captions without transcribing and follows playback',
    (tester) async {
      final samples = speechTone(durationSeconds: 6);
      for (var i = 16000; i < 24000; i++) {
        samples[i] = 0;
      }
      final recording = analyzePitch(
        WavAudio(samples, 16000),
        loadAudioConfig(),
      );
      final preferences = MemoryPreferences();
      final repository = MemoryTranscriptRepository()..saved = transcript;
      var calls = 0;
      final positions = StreamController<PlaybackState>();
      final container = ProviderContainer(
        overrides: [
          captionPreferencesProvider.overrideWithValue(preferences),
          transcriptRepositoryProvider.overrideWithValue(repository),
          transcriberProvider.overrideWithValue((_) {
            calls++;
            return const Stream.empty();
          }),
          transcriptionConfigProvider.overrideWith((ref) async => config),
          playbackStateProvider.overrideWith((ref, path) => positions.stream),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await positions.close();
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: buildTheme(AppTheme.honey, Brightness.light),
            home: Scaffold(
              body: RecordingCaptions(path: '/local.wav', recording: recording),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      positions.add(const PlaybackState(positionMs: 800, playing: true));
      await tester.pumpAndSettle();
      expect(find.text('HELLO WORLD '), findsOneWidget);
      expect(calls, 0);
      positions.add(const PlaybackState(positionMs: 1200, playing: true));
      await tester.pumpAndSettle();
      expect(find.text('(Pause)'), findsOneWidget);
      expect(find.text('No caption at this moment.'), findsNothing);
      positions.add(const PlaybackState(positionMs: 3500));
      await tester.pumpAndSettle();
      expect(find.text('(Pause)'), findsNothing);
      expect(find.text('No caption at this moment.'), findsOneWidget);
      positions.add(const PlaybackState(positionMs: 4500));
      await tester.pumpAndSettle();
      expect(find.text('AGAIN '), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(preferences.enabled, isFalse);
      expect(find.text('AGAIN '), findsNothing);
    },
  );
}
