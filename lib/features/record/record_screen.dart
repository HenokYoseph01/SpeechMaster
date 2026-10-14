import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'delivery_summary.dart';
import 'pitch_chart.dart';
import 'recording_controller.dart';
import 'recording_model.dart';
import 'recording_replay.dart';
import 'playback_controller.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});
  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen>
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
    if (state == AppLifecycleState.resumed) {
      ref.read(recordingControllerProvider.notifier).setForeground(true);
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      ref.read(recordingControllerProvider.notifier).setForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final state = ref.watch(recordingControllerProvider);
    final controller = ref.read(recordingControllerProvider.notifier);
    final config = ref.watch(audioConfigProvider);
    return PopScope(
      canPop: !state.isBusy,
      child: Scaffold(
        appBar: AppBar(title: Text(strings.record)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        strings.recordTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(strings.recordPrivacy),
                      const SizedBox(height: 24),
                      Text(strings.recordingDuration),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          for (final mode in RecordingMode.values)
                            ChoiceChip(
                              label: Text(
                                strings.durationSeconds(
                                  mode.durationMs ~/ 1000,
                                ),
                              ),
                              selected: state.mode == mode,
                              onSelected: state.isBusy
                                  ? null
                                  : (_) => controller.selectMode(mode),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              selectedColor: colors.primary,
                              labelStyle: TextStyle(
                                color: state.mode == mode
                                    ? colors.onPrimary
                                    : colors.text,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (state.phase == RecordingPhase.recording) ...[
                        Text(strings.recordingNow),
                        const SizedBox(height: 16),
                        Semantics(
                          label: strings.secondsRemaining(
                            state.remainingSeconds,
                          ),
                          liveRegion: true,
                          child: ExcludeSemantics(
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value:
                                            state.remainingSeconds *
                                            1000 /
                                            state.mode.durationMs,
                                        color: colors.text,
                                        backgroundColor: colors.surfaceAlt,
                                        strokeWidth: 8,
                                      ),
                                    ),
                                    Container(
                                      width: 168,
                                      height: 168,
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat.decimalPattern(
                                            strings.localeName,
                                          ).format(state.remainingSeconds),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                color: colors.onPrimary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          label: strings.microphoneLevel,
                          child: ExcludeSemantics(
                            child: SizedBox(
                              height: 64,
                              child: CustomPaint(
                                painter: _LevelPainter(
                                  levels: state.levels,
                                  color: colors.text,
                                  floorDb: config.value!.waveformFloorDb,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: state.canStop ? controller.stop : null,
                          icon: const Icon(Icons.stop_rounded),
                          label: Text(strings.stopRecording),
                        ),
                        if (!state.canStop) ...[
                          const SizedBox(height: 8),
                          Text(
                            strings.stopAfterSeconds(state.minimumMs ~/ 1000),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: controller.discard,
                          child: Text(strings.discardRecording),
                        ),
                      ] else if (state.isBusy) ...[
                        Text(switch (state.phase) {
                          RecordingPhase.starting =>
                            strings.preparingMicrophone,
                          RecordingPhase.stopping => strings.finishingRecording,
                          RecordingPhase.cancelling =>
                            strings.discardingRecording,
                          _ => strings.analyzingPitch,
                        }),
                        const SizedBox(height: 24),
                        const Icon(Icons.graphic_eq_rounded, size: 64),
                        const SizedBox(height: 24),
                        LinearProgressIndicator(
                          value: state.phase == RecordingPhase.analyzing
                              ? state.progress
                              : null,
                        ),
                      ] else ...[
                        if (state.phase == RecordingPhase.permissionDenied) ...[
                          Text(strings.microphoneDenied),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: controller.openAppSettings,
                            child: Text(strings.openAppSettings),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (state.phase == RecordingPhase.interrupted) ...[
                          Text(strings.recordingInterrupted),
                          const SizedBox(height: 16),
                        ],
                        if (state.phase == RecordingPhase.failure) ...[
                          Text(switch (state.failure) {
                            RecordingFailure.analysis =>
                              strings.pitchAnalysisFailed,
                            RecordingFailure.storage =>
                              strings.recordingSaveFailed,
                            _ => strings.recordingFailed,
                          }),
                          const SizedBox(height: 16),
                          if (state.canRetryAnalysis) ...[
                            FilledButton(
                              onPressed: controller.retryAnalysis,
                              child: Text(strings.retryPitchAnalysis),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                        if (state.result != null && config.hasValue) ...[
                          PitchChart(
                            result: state.result!,
                            minimumSpan:
                                config.value!.chartMinimumSpanSemitones,
                          ),
                          const SizedBox(height: 24),
                          if (state.result!.analysis != null) ...[
                            DeliverySummary(analysis: state.result!.analysis!),
                            const SizedBox(height: 24),
                          ],
                          if (state.audioPath != null) ...[
                            RecordingReplay(
                              key: ValueKey(state.audioPath),
                              path: state.audioPath!,
                              result: state.result!,
                              contextMs: config.value!.playbackContextMs,
                            ),
                            const SizedBox(height: 24),
                          ],
                          Text(strings.recordingSaved),
                          const SizedBox(height: 24),
                        ],
                        FilledButton.icon(
                          onPressed: config.hasValue
                              ? () async {
                                  if (state.audioPath != null) {
                                    await ref
                                        .read(
                                          playbackControllerProvider(
                                            state.audioPath!,
                                          ),
                                        )
                                        .pause();
                                  }
                                  if (mounted) await controller.start('en');
                                }
                              : null,
                          icon: const Icon(Icons.mic_rounded),
                          label: Text(
                            state.phase == RecordingPhase.done
                                ? strings.recordAgain
                                : strings.startRecording,
                          ),
                        ),
                        if (config.hasError) ...[
                          const SizedBox(height: 16),
                          Text(strings.recordingFailed),
                          TextButton(
                            onPressed: () =>
                                ref.invalidate(audioConfigProvider),
                            child: Text(strings.retry),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelPainter extends CustomPainter {
  const _LevelPainter({
    required this.levels,
    required this.color,
    required this.floorDb,
  });
  final List<double> levels;
  final Color color;
  final double floorDb;
  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final step = size.width / levels.length;
    for (var i = 0; i < levels.length; i++) {
      final height =
          ((levels[i] - floorDb) / -floorDb).clamp(0.0, 1.0) * size.height;
      final x = (i + 0.5) * step;
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LevelPainter oldDelegate) =>
      levels != oldDelegate.levels ||
      color != oldDelegate.color ||
      floorDb != oldDelegate.floorDb;
}
