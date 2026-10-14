import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../audio/pitch_result.dart';
import '../../core/l10n/generated/app_localizations.dart';
import 'playback_controller.dart';

class RecordingReplay extends ConsumerStatefulWidget {
  const RecordingReplay({
    super.key,
    required this.path,
    required this.result,
    required this.contextMs,
  });
  final String path;
  final PitchResult result;
  final int contextMs;
  @override
  ConsumerState<RecordingReplay> createState() => _RecordingReplayState();
}

class _RecordingReplayState extends ConsumerState<RecordingReplay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(ref.read(playbackControllerProvider(widget.path)).pause());
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state =
        ref.watch(playbackStateProvider(widget.path)).value ??
        const PlaybackState();
    final controller = ref.watch(playbackControllerProvider(widget.path));
    final number = NumberFormat('0.0', 'en');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.replayTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(strings.replayExplanation),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: state.loading
              ? null
              : () => controller.toggle(widget.result.durationMs),
          icon: Icon(
            state.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
          label: Text(
            state.playing ? strings.pausePlayback : strings.playRecording,
          ),
        ),
        Slider(
          value: state.positionMs.clamp(0, widget.result.durationMs).toDouble(),
          max: widget.result.durationMs.toDouble(),
          label: strings.durationSeconds(state.positionMs ~/ 1000),
          onChanged: state.loading
              ? null
              : (value) => controller.seek(value.round()),
        ),
        Text(
          strings.replayPosition(
            number.format(state.positionMs / 1000),
            number.format(widget.result.durationMs / 1000),
          ),
        ),
        if (state.failed) ...[
          const SizedBox(height: 8),
          Text(strings.playbackFailed),
        ],
        if (widget.result.analysis != null) ...[
          const SizedBox(height: 16),
          Text(
            strings.pauseMarkersTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (widget.result.analysis!.pauses.isEmpty)
            Text(strings.noDetectedPauses),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pause in widget.result.analysis!.pauses)
                ActionChip(
                  avatar: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    strings.pauseMarker(
                      number.format(pause.startMs / 1000),
                      number.format(pause.endMs / 1000),
                    ),
                  ),
                  onPressed: state.loading
                      ? null
                      : () => controller.previewPause(
                          pause.startMs,
                          pause.endMs,
                          widget.result.durationMs,
                          widget.contextMs,
                        ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
