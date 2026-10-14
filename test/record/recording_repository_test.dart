import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/features/record/recording_model.dart';
import 'package:speech_coach/features/record/recording_repository.dart';

import '../support/audio_fixtures.dart';

void main() {
  test(
    'full metrics and pause intervals survive reopening without any scores',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_metrics_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/practice.sqlite');
      var database = AppDatabase(NativeDatabase(file));
      final repository = RecordingRepository(
        database,
        directory: () async => directory,
      );
      final draft = await repository.allocate(
        RecordingMode.thirtySeconds,
        'en',
      );
      final config = loadAudioConfig();
      final audio = WavAudio(syllablePulses(), 16000);
      final result = analyzePitch(audio, config);
      final metrics = result.analysis!;
      await File(draft.path).writeAsBytes(makeWav(audio.samples));
      await repository.saveCapture(draft, audio.durationMs, config);
      await repository.savePitch(draft, result);
      await database.close();
      database = AppDatabase(NativeDatabase(file));
      try {
        final row = await database.select(database.analysisResults).getSingle();
        expect(row.pitchMedianHz, metrics.pitchMedianHz);
        expect(row.pitchRangeSt, metrics.pitchRangeSt);
        expect(row.pitchStdSt, metrics.pitchStdSt);
        expect(row.pitchMovementStS, metrics.pitchMovementStPerS);
        expect(row.articulationRate, metrics.articulationRate);
        expect(row.speakingRate, metrics.speakingRate);
        expect(row.paceCv, metrics.paceCV);
        expect(row.loudnessRangeDb, metrics.loudnessRangeDb);
        expect(row.energyTrendDb, metrics.energyTrendDb);
        expect(row.pausesPerMin, metrics.pausesPerMin);
        expect(row.pauseRatio, metrics.pauseRatio);
        expect(row.longPauseCount, metrics.longPauseCount);
        expect(row.meanPauseMs, metrics.meanPauseMs);
        expect(row.speechMs, metrics.speechMs);
        expect(row.snrDb, metrics.snrDb);
        expect(row.clippingPct, metrics.clippingPct);
        expect(jsonDecode(row.pausesJson!), [
          for (final pause in metrics.pauses) pause.toJson(),
        ]);
        expect(jsonDecode(row.contourJson!), [
          for (final point in result.points) point.toJson(),
        ]);
        expect(jsonDecode(row.flagsJson!), ['phase1_metrics_only']);
        expect([
          row.scorePitch,
          row.scorePace,
          row.scorePaceVar,
          row.scorePause,
          row.scoreVolume,
          row.scoreEnergy,
          row.fillerCount,
        ], everyElement(isNull));
        final recording = await database
            .select(database.recordings)
            .getSingle();
        expect(recording.overallScore, isNull);
        expect(recording.analysisVersion, loadAudioConfig().analysisVersion);
        expect(await File(recording.audioPath).exists(), isTrue);
      } finally {
        await database.close();
      }
    },
  );

  test('failed quality checks persist warnings and clear unavailable metrics on retry', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = RecordingRepository(database);
    const draft = ClipDraft(
      id: 'quality',
      path: '/local/quality.wav',
      createdAt: 1,
      mode: RecordingMode.thirtySeconds,
      language: 'en',
    );
    final config = loadAudioConfig();
    await repository.saveCapture(draft, 14000, config);
    await repository.savePitch(
      draft,
      analyzePitch(WavAudio(syllablePulses(), 16000), config),
    );
    final silence = WavAudio(
      speechTone(durationSeconds: 14, silenceSeconds: 7),
      16000,
    );
    await repository.savePitch(draft, analyzePitch(silence, config));
    expect(await database.select(database.analysisResults).get(), hasLength(1));
    final row = await database.select(database.analysisResults).getSingle();
    expect(row.pitchMedianHz, isNull);
    expect(row.pitchRangeSt, isNull);
    expect(row.articulationRate, isNull);
    expect(row.speakingRate, isNull);
    expect(row.loudnessRangeDb, isNull);
    expect(row.scorePitch, isNull);
    expect(jsonDecode(row.pausesJson!), isEmpty);
    expect(jsonDecode(row.flagsJson!), [
      'phase1_metrics_only',
      'insufficient_pitch',
      'insufficient_speech',
      'noisy_recording',
    ]);
  });

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
      expect(recording.analysisVersion, loadAudioConfig().analysisVersion);
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

  test(
    'fallback provenance is saved without inventing speech time or scores',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = RecordingRepository(database);
      const draft = ClipDraft(
        id: 'fallback',
        path: '/local/fallback.wav',
        createdAt: 1,
        mode: RecordingMode.thirtySeconds,
        language: 'en',
      );
      await repository.saveCapture(draft, 30000, loadAudioConfig());
      await repository.savePitch(
        draft,
        const PitchResult(
          durationMs: 30000,
          points: [PitchPoint(0, 0, -20), PitchPoint(100, 0, -20)],
          medianHz: 150,
          voicedRatio: 1,
          speechMs: 0,
          analysisMs: 1,
          noiseFloorDb: -20,
          usedPitchFallback: true,
        ),
      );
      final recording = await database.select(database.recordings).getSingle();
      final result = await database
          .select(database.analysisResults)
          .getSingle();
      expect(recording.overallScore, isNull);
      expect(result.speechMs, 0);
      expect(result.scorePitch, isNull);
      expect(result.scorePace, isNull);
      expect(result.scorePause, isNull);
      expect(result.scoreVolume, isNull);
      expect(jsonDecode(result.flagsJson!), [
        'prototype_pitch_only',
        'pitch_periodicity_fallback',
      ]);
    },
  );
}
