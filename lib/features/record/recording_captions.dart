import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/captions.dart';
import '../../audio/pitch_result.dart';
import '../../core/l10n/generated/app_localizations.dart';
import 'caption_preferences.dart';
import 'playback_controller.dart';
import 'transcript_panel.dart';
import 'transcription_controller.dart';

class RecordingCaptions extends ConsumerWidget {
  const RecordingCaptions({
    super.key,
    required this.path,
    required this.recording,
  });
  final String path;
  final PitchResult recording;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final transcript = ref
        .watch(transcriptionStateProvider(path))
        .value
        ?.result;
    final preference = ref.watch(captionPreferenceStateProvider(path)).value;
    final preferences = ref.watch(captionPreferenceControllerProvider(path));
    final playback =
        ref.watch(playbackStateProvider(path)).value ?? const PlaybackState();
    final config = ref.watch(transcriptionConfigProvider).value;
    final pauses = recording.analysis?.pauses ?? const [];
    final cue = transcript == null || config == null
        ? null
        : captionAt(
            captionCues(transcript, pauses, config),
            pauses,
            playback.positionMs,
          );
    final active = cue?.wordAt(playback.positionMs);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.captionsTitle),
          subtitle: Text(
            transcript == null
                ? strings.captionsNeedTranscript
                : strings.captionsTimingNote,
          ),
          value: transcript != null && (preference?.enabled ?? false),
          onChanged:
              transcript == null ||
                  preference?.ready != true ||
                  preference!.saving
              ? null
              : preferences.setEnabled,
        ),
        if (preference?.failed == true) Text(strings.captionsPreferenceFailed),
        if (transcript != null && preference?.enabled == true)
          Semantics(
            label: strings.captionsTitle,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: cue == null
                    ? Text(
                        isCaptionPause(pauses, playback.positionMs)
                            ? strings.captionsPause
                            : strings.captionsNoWords,
                        textAlign: TextAlign.center,
                      )
                    : Text.rich(
                        TextSpan(
                          children: [
                            for (final word in cue.words)
                              TextSpan(
                                text: '${word.text} ',
                                style: TextStyle(
                                  fontWeight: identical(active, word)
                                      ? FontWeight.w800
                                      : FontWeight.normal,
                                  decoration: identical(active, word)
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
