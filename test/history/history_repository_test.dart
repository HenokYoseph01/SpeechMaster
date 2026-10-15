import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/features/history/history_repository.dart';
import 'package:speech_coach/features/record/recording_model.dart';
import 'package:speech_coach/features/record/recording_repository.dart';

import '../support/audio_fixtures.dart';

void main() {
  test('history reopens stored audio/pauses, orders newest first and handles missing files', () async {
    final directory = await Directory.systemTemp.createTemp(
      'recording_history_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/app.sqlite');
    var db = AppDatabase(NativeDatabase(file));
    final repository = RecordingRepository(
      db,
      directory: () async => directory,
    );
    final config = loadAudioConfig();
    final samples = speechTone(durationSeconds: 4, silenceSeconds: 0.5);
    for (var i = 16000; i < 24000; i++) {
      samples[i] = 0;
    }
    final result = analyzePitch(WavAudio(samples, 16000), config);
    final first = await repository.allocate(RecordingMode.thirtySeconds, 'en');
    await File(first.path).writeAsBytes(makeWav(samples));
    await repository.saveCapture(first, 4000, config);
    await repository.savePitch(first, result);
    final second = ClipDraft(
      id: 'newer',
      path: '${directory.path}/missing.wav',
      createdAt: first.createdAt + 1000,
      mode: RecordingMode.thirtySeconds,
      language: 'en',
    );
    await repository.saveCapture(second, 10000, config);
    await db.close();
    db = AppDatabase(NativeDatabase(file));
    addTearDown(() => db.close());
    final history = HistoryRepository(db);
    expect((await history.watch().first).map((r) => r.id), ['newer', first.id]);
    final opened = (await history.load(first.id, config))!;
    expect(opened.audioAvailable, isTrue);
    expect(
      opened.result.analysis!.pauses.map((p) => p.toJson()),
      result.analysis!.pauses.map((p) => p.toJson()),
    );
    expect(
      opened.result.points.map((p) => p.toJson()),
      result.points.map((p) => p.toJson()),
    );
    expect((await history.load('newer', config))!.audioAvailable, isFalse);
    expect(await history.load('unknown', config), isNull);
    await (db.update(db.recordings)..where((r) => r.id.equals('newer'))).write(
      const RecordingsCompanion(deletedAt: Value(1)),
    );
    expect((await history.watch().first).map((r) => r.id), [first.id]);
    expect(await history.load('newer', config), isNull);
    await (db.update(
      db.analysisResults,
    )..where((a) => a.recordingId.equals(first.id))).write(
      const AnalysisResultsCompanion(
        pausesJson: Value('bad'),
        contourJson: Value('bad'),
      ),
    );
    final malformed = (await history.load(first.id, config))!;
    expect(malformed.audioAvailable, isTrue);
    expect(malformed.result.points, isEmpty);
    expect(malformed.result.analysis!.pauses, isEmpty);
  });
}
