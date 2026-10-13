import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../audio/audio_config.dart';
import '../../audio/pitch_result.dart';
import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'recording_model.dart';

final recordingRepositoryProvider = Provider<RecordingRepository>(
  (ref) => RecordingRepository(ref.watch(databaseProvider)),
);

class RecordingRepository {
  RecordingRepository(this.database, {Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationSupportDirectory;
  final AppDatabase database;
  final Future<Directory> Function() _directory;

  Future<ClipDraft> allocate(RecordingMode mode, String language) async {
    final root = await _directory();
    final recordings = Directory('${root.path}/recordings');
    await recordings.create(recursive: true);
    final id = _uuidV4();
    return ClipDraft(
      id: id,
      path: '${recordings.path}/$id.wav',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      mode: mode,
      language: language,
    );
  }

  Future<void> saveCapture(
    ClipDraft draft,
    int durationMs,
    AudioConfig config,
  ) async {
    await database
        .into(database.recordings)
        .insertOnConflictUpdate(
          RecordingsCompanion.insert(
            id: Value(draft.id),
            createdAt: draft.createdAt,
            durationMs: durationMs,
            targetMs: draft.mode.durationMs,
            audioPath: draft.path,
            kind: 'free',
            language: draft.language,
            analysisVersion: config.analysisVersion,
          ),
        );
  }

  Future<void> savePitch(ClipDraft draft, PitchResult result) =>
      database.transaction(() async {
        await (database.update(database.recordings)
              ..where((row) => row.id.equals(draft.id)))
            .write(RecordingsCompanion(durationMs: Value(result.durationMs)));
        await database
            .into(database.analysisResults)
            .insertOnConflictUpdate(
              AnalysisResultsCompanion.insert(
                recordingId: Value(draft.id),
                pitchMedianHz: Value(result.medianHz),
                speechMs: Value(result.speechMs),
                contourJson: Value(
                  jsonEncode([
                    for (final point in result.points) point.toJson(),
                  ]),
                ),
                flagsJson: Value(
                  jsonEncode([
                    'prototype_pitch_only',
                    if (result.usedPitchFallback) 'pitch_periodicity_fallback',
                    if (!result.hasPitch) 'insufficient_pitch',
                  ]),
                ),
              ),
            );
      });
}

String _uuidV4() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
