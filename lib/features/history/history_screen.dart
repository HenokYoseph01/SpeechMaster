import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../record/recording_controller.dart';
import '../record/recording_replay.dart';
import '../record/transcript_panel.dart';
import 'history_repository.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final history = ref.watch(recordingHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(strings.recordingHistory)),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.historyFailed),
              TextButton(
                onPressed: () => ref.invalidate(recordingHistoryProvider),
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
        data: (rows) => rows.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(strings.historyEmpty),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  final date = DateFormat.yMMMd(strings.localeName)
                      .add_jm()
                      .format(
                        DateTime.fromMillisecondsSinceEpoch(row.createdAt),
                      );
                  return ListTile(
                    leading: const Icon(Icons.audiotrack_rounded),
                    title: Text(row.title ?? date),
                    subtitle: Text(
                      strings.savedClipDuration(
                        (row.durationMs / 1000).round(),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: row.id == null
                        ? null
                        : () => context.push(
                            '/history/${Uri.encodeComponent(row.id!)}',
                          ),
                  );
                },
              ),
      ),
    );
  }
}

class SavedRecordingScreen extends ConsumerWidget {
  const SavedRecordingScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final saved = ref.watch(savedRecordingProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(strings.savedRecordingTitle)),
      body: saved.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.historyFailed),
              TextButton(
                onPressed: () => ref.invalidate(savedRecordingProvider(id)),
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
        data: (clip) {
          if (clip == null) {
            return Center(child: Text(strings.savedRecordingMissing));
          }
          if (!clip.audioAvailable || clip.result.durationMs <= 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(strings.savedAudioMissing),
              ),
            );
          }
          final configuration = ref.watch(audioConfigProvider);
          final config = configuration.value;
          if (config == null) {
            if (configuration.hasError) {
              return Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(audioConfigProvider),
                  child: Text(strings.retry),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                DateFormat.yMMMd(strings.localeName).add_jm().format(
                  DateTime.fromMillisecondsSinceEpoch(clip.recording.createdAt),
                ),
              ),
              const SizedBox(height: 16),
              RecordingReplay(
                path: clip.recording.audioPath,
                result: clip.result,
                contextMs: config.playbackContextMs,
              ),
              const SizedBox(height: 24),
              TranscriptPanel(
                path: clip.recording.audioPath,
                recording: clip.result,
              ),
            ],
          );
        },
      ),
    );
  }
}
