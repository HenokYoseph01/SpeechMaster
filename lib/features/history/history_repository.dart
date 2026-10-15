import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/analysis_result.dart' as audio;
import '../../audio/audio_config.dart';
import '../../audio/pitch_result.dart';
import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../record/recording_controller.dart';

final historyRepositoryProvider = Provider(
  (ref) => HistoryRepository(ref.watch(databaseProvider)),
);
final recordingHistoryProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(historyRepositoryProvider).watch(),
);
final savedRecordingProvider = FutureProvider.autoDispose
    .family<SavedRecording?, String>((ref, id) async {
      final repository = ref.watch(historyRepositoryProvider);
      final config = await ref.watch(audioConfigProvider.future);
      return repository.load(id, config);
    });

class SavedRecording {
  const SavedRecording(this.recording, this.result, this.audioAvailable);
  final Recording recording;
  final PitchResult result;
  final bool audioAvailable;
}

class HistoryRepository {
  HistoryRepository(this.database);
  final AppDatabase database;
  Stream<List<Recording>> watch() =>
      (database.select(database.recordings)
            ..where((r) => r.deletedAt.isNull())
            ..orderBy([
              (r) => OrderingTerm.desc(r.createdAt),
              (r) => OrderingTerm.asc(r.id),
            ]))
          .watch();

  Future<SavedRecording?> load(String id, AudioConfig config) async {
    final r = await (database.select(
      database.recordings,
    )..where((r) => r.id.equals(id) & r.deletedAt.isNull())).getSingleOrNull();
    if (r == null) return null;
    final row = await (database.select(
      database.analysisResults,
    )..where((a) => a.recordingId.equals(id))).getSingleOrNull();
    final points = <PitchPoint>[];
    final pauses = <audio.PauseInterval>[];
    // Older or malformed analysis must not prevent replay of a valid WAV.
    try {
      for (final value in jsonDecode(row?.contourJson ?? '[]') as List) {
        final p = value as List;
        if (p.length != 3 ||
            p[0] is! int ||
            (p[0] as int) < 0 ||
            (p[0] as int) >= r.durationMs ||
            p[2] is! num ||
            (p[1] != null && p[1] is! num)) {
          throw const FormatException();
        }
        points.add(
          PitchPoint(
            p[0] as int,
            (p[1] as num?)?.toDouble(),
            (p[2] as num).toDouble(),
          ),
        );
      }
    } catch (_) {
      points.clear();
    }
    try {
      for (final value in jsonDecode(row?.pausesJson ?? '[]') as List) {
        final p = value as List;
        final start = p[0] as int, end = p[1] as int;
        if (start < 0 || end <= start || end > r.durationMs) {
          throw const FormatException();
        }
        final duration = end - start;
        pauses.add(
          audio.PauseInterval(
            start,
            end,
            duration < config.pauseShortUpperMs
                ? audio.PauseKind.short
                : duration <= config.pauseMediumUpperMs
                ? audio.PauseKind.medium
                : audio.PauseKind.long,
          ),
        );
      }
    } catch (_) {
      pauses.clear();
    }
    final analysis = row == null
        ? null
        : audio.AnalysisResult(
            pitchMedianHz: row.pitchMedianHz,
            pitchRangeSt: row.pitchRangeSt,
            pitchStdSt: row.pitchStdSt,
            pitchMovementStPerS: row.pitchMovementStS,
            syllableCount: null,
            articulationRate: row.articulationRate,
            speakingRate: row.speakingRate,
            approximateEnglishWpm: null,
            paceCV: row.paceCv,
            loudnessRangeDb: row.loudnessRangeDb,
            energyTrendDb: row.energyTrendDb,
            pausesPerMin: row.pausesPerMin ?? 0,
            pauseRatio: row.pauseRatio ?? 0,
            longPauseCount: row.longPauseCount ?? 0,
            meanPauseMs: row.meanPauseMs,
            speechMs: row.speechMs ?? 0,
            snrDb: row.snrDb,
            clippingPct: row.clippingPct ?? 0,
            pauses: List.unmodifiable(pauses),
            paceWindows: const [],
            qualityWarnings: const [],
          );
    return SavedRecording(
      r,
      PitchResult(
        durationMs: r.durationMs,
        points: List.unmodifiable(points),
        medianHz: row?.pitchMedianHz,
        // Preview voicing ratio and processing time were not persisted.
        voicedRatio: 0,
        speechMs: row?.speechMs ?? 0,
        analysisMs: 0,
        noiseFloorDb: null,
        analysis: analysis,
      ),
      await File(r.audioPath).exists(),
    );
  }
}
