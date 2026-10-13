import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/features/record/recording_model.dart';
import 'package:speech_coach/features/record/recording_repository.dart';

import '../support/audio_fixtures.dart';

void main() {
  test('capture and pitch-only analysis survive reopening without fabricating scores', () async {
    final directory = await Directory.systemTemp.createTemp(
      'speech_coach_recording_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/practice.sqlite');
    var database = AppDatabase(NativeDatabase(file));
    final repository = RecordingRepository(
      database,
      directory: () async => directory,
    );
    final draft = await repository.allocate(RecordingMode.thirtySeconds, 'am');
    expect(
      draft.id,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    await File(draft.path).writeAsBytes(makeWav(speechTone()));
    await repository.saveCapture(draft, 30050, loadAudioConfig());
    await repository.savePitch(
      draft,
      const PitchResult(
        durationMs: 30040,
        points: [PitchPoint(0, null, -60), PitchPoint(100, 2, -20)],
        medianHz: 120,
        voicedRatio: 0.9,
        speechMs: 25000,
        analysisMs: 10,
        noiseFloorDb: -60,
      ),
    );
    await database.close();
    database = AppDatabase(NativeDatabase(file));
    try {
      final recording = await database.select(database.recordings).getSingle();
      expect(recording.targetMs, 30000);
      expect(recording.durationMs, 30040);
      expect(recording.language, 'am');
      expect(recording.overallScore, isNull);
      expect(recording.audioPath, draft.path);
      expect(await File(recording.audioPath).exists(), isTrue);
      final analysis = await database
          .select(database.analysisResults)
          .getSingle();
      expect(analysis.pitchMedianHz, 120);
      expect(analysis.scorePitch, isNull);
      expect(analysis.fillerCount, isNull);
      expect(jsonDecode(analysis.contourJson!), [
        [0, null, -60.0],
        [100, 2.0, -20.0],
      ]);
      expect(jsonDecode(analysis.flagsJson!), ['prototype_pitch_only']);
    } finally {
      await database.close();
    }
  });
}
