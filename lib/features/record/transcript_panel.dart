import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../audio/offline_transcription.dart';
import '../../audio/pitch_result.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'playback_controller.dart';
import 'transcription_controller.dart';
import 'transcript_timeline.dart';

final transcriptionConfigProvider = FutureProvider(
  (ref) => loadTranscriptionConfig(),
);

class TranscriptPanel extends ConsumerWidget {
  const TranscriptPanel({
    super.key,
    required this.path,
    required this.recording,
  });
  final String path;
  final PitchResult recording;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final state =
        ref.watch(transcriptionStateProvider(path)).value ??
        const TranscriptionState();
    final controller = ref.watch(transcriptionControllerProvider(path));
    final playback =
        ref.watch(playbackStateProvider(path)).value ?? const PlaybackState();
    final replay = ref.watch(playbackControllerProvider(path));
    final config = ref.watch(transcriptionConfigProvider);
    final number = NumberFormat('0.0', 'en');
    final colors = Theme.of(context).extension<AppColors>()!;
    final active = !playback.playing || state.result == null
        ? null
        : transcriptMomentAt(
            state.result!,
            recording.analysis?.pauses ?? const [],
            playback.positionMs,
          );
    final moments = state.result == null
        ? const <TranscriptMoment>[]
        : transcriptTimeline(
            state.result!,
            recording.analysis?.pauses ?? const [],
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.transcriptTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(strings.transcriptExplanation),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          onPressed: state.busy || !config.hasValue ? null : controller.start,
          icon: const Icon(Icons.text_snippet_outlined),
          label: Text(
            state.result == null
                ? strings.transcribeRecording
                : strings.transcribeAgain,
          ),
        ),
        if (state.busy) ...[
          const SizedBox(height: 12),
          Text(strings.transcribingRecording),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: state.progress),
        ],
        if (state.phase == TranscriptionPhase.failed || config.hasError) ...[
          const SizedBox(height: 12),
          Text(strings.transcriptionFailed),
          if (config.hasError)
            TextButton(
              onPressed: () => ref.invalidate(transcriptionConfigProvider),
              child: Text(strings.retry),
            ),
        ],
        if (state.saveFailed) ...[
          const SizedBox(height: 12),
          Text(strings.transcriptSaveFailed),
          TextButton(
            onPressed: state.busy ? null : controller.retrySave,
            child: Text(strings.retry),
          ),
        ],
        if (state.result != null) ...[
          const SizedBox(height: 16),
          if (state.result!.words.isEmpty)
            Text(strings.transcriptEmpty)
          else
            SelectableText(state.result!.text),
          const SizedBox(height: 12),
          Text(strings.transcriptTimingNote),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final moment in moments)
                if (moment is SpokenWordMoment)
                  ActionChip(
                    backgroundColor:
                        active is SpokenWordMoment &&
                            identical(active.word, moment.word)
                        ? colors.primary
                        : null,
                    label: Text(moment.word.text),
                    labelStyle: TextStyle(
                      color:
                          active is SpokenWordMoment &&
                              identical(active.word, moment.word)
                          ? colors.onPrimary
                          : colors.text,
                    ),
                    tooltip: strings.transcriptWordTime(
                      number.format(moment.timeMs / 1000),
                    ),
                    onPressed: playback.loading || !config.hasValue
                        ? null
                        : () => replay.playFrom(
                            moment.timeMs - config.value!.replayLeadMs,
                            recording.durationMs,
                          ),
                  )
                else if (moment is PauseMoment)
                  ActionChip(
                    backgroundColor:
                        active is PauseMoment &&
                            identical(active.pause, moment.pause)
                        ? colors.primary
                        : null,
                    labelStyle: TextStyle(
                      color:
                          active is PauseMoment &&
                              identical(active.pause, moment.pause)
                          ? colors.onPrimary
                          : colors.text,
                    ),
                    avatar: const Icon(Icons.pause_rounded),
                    label: Text(
                      strings.transcriptPause(
                        number.format(moment.pause.durationMs / 1000),
                      ),
                    ),
                    tooltip: strings.pauseMarker(
                      number.format(moment.pause.startMs / 1000),
                      number.format(moment.pause.endMs / 1000),
                    ),
                    onPressed: playback.loading || !config.hasValue
                        ? null
                        : () => replay.previewPause(
                            moment.pause.startMs,
                            moment.pause.endMs,
                            recording.durationMs,
                            config.value!.replayLeadMs,
                          ),
                  ),
            ],
          ),
        ],
      ],
    );
  }
}
