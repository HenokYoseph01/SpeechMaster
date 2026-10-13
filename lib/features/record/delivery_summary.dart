import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../audio/analysis_result.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class DeliverySummary extends StatelessWidget {
  const DeliverySummary({super.key, required this.analysis});
  final AnalysisResult analysis;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final decimal = NumberFormat('0.0', strings.localeName);
    final integer = NumberFormat('0', strings.localeName);
    final signed = NumberFormat('+0.0;-0.0', strings.localeName);
    final percent = NumberFormat.percentPattern(strings.localeName);
    final measurements = <String>[
      strings.detectedSpeech(decimal.format(analysis.speechMs / 1000)),
      strings.deliveryPauses(
        analysis.pauses.length,
        decimal.format(analysis.totalPauseMs / 1000),
      ),
      strings.deliveryPauseKinds(
        analysis.shortPauseCount,
        analysis.mediumPauseCount,
        analysis.longPauseCount,
      ),
      strings.deliveryPauseShare(percent.format(analysis.pauseRatio)),
      if (analysis.speakingRate != null)
        strings.deliverySpeakingRate(decimal.format(analysis.speakingRate)),
      if (analysis.articulationRate != null)
        strings.deliveryArticulationRate(
          decimal.format(analysis.articulationRate),
        ),
      if (strings.localeName == 'en' && analysis.approximateEnglishWpm != null)
        strings.deliveryApproximateWpm(
          integer.format(analysis.approximateEnglishWpm),
        ),
      if (analysis.speakingRate == null) strings.deliveryPaceUnavailable,
      if (analysis.paceCV != null)
        strings.deliveryPaceVariation(percent.format(analysis.paceCV)),
      if (analysis.loudnessRangeDb != null)
        strings.deliveryVolumeRange(decimal.format(analysis.loudnessRangeDb)),
      if (analysis.energyTrendDb != null)
        strings.deliveryEnergyTrend(signed.format(analysis.energyTrendDb)),
      if (analysis.pitchRangeSt != null)
        strings.deliveryPitchRange(decimal.format(analysis.pitchRangeSt)),
      if (analysis.pitchRangeSt == null) strings.deliveryPitchLimited,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.deliverySummaryTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(strings.deliveryPreviewNote),
        const SizedBox(height: 16),
        if (!analysis.passesQualityGates) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.deliveryQualityTitle,
                  style: theme.textTheme.titleMedium,
                ),
                for (final warning in analysis.qualityWarnings) ...[
                  const SizedBox(height: 8),
                  Text(switch (warning) {
                    QualityWarning.insufficientSpeech =>
                      strings.qualityMoreSpeech,
                    QualityWarning.noisyRecording => strings.qualityQuieterRoom,
                    QualityWarning.clippedAudio => strings.qualityStepBack,
                    QualityWarning.quietAudio => strings.qualityMoveCloser,
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        for (final measurement in measurements) ...[
          Text(measurement),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        Text(strings.deliveryPaceExplanation, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
