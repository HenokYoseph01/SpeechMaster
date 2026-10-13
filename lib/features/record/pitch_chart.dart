import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../audio/pitch_result.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class PitchChart extends StatelessWidget {
  const PitchChart({
    super.key,
    required this.result,
    required this.minimumSpan,
  });
  final PitchResult result;
  final double minimumSpan;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final voiced = result.points
        .map((point) => point.semitones)
        .whereType<double>()
        .toList();
    if (voiced.isEmpty) return Text(strings.noPitchFound);
    final low = voiced.reduce(math.min);
    final high = voiced.reduce(math.max);
    final formatter = NumberFormat('0.0', strings.localeName);
    final summary = strings.pitchSummary(
      formatter.format(low),
      formatter.format(high),
      (result.durationMs / 1000).round(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.pitchChartTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Semantics(
          label: summary,
          image: true,
          child: ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ColoredBox(
                color: colors.surfaceAlt,
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: CustomPaint(
                    painter: PitchContourPainter(
                      result: result,
                      minimumSpan: minimumSpan,
                      line: colors.text,
                      baseline: colors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.durationSeconds(0)),
            Text(strings.durationSeconds((result.durationMs / 1000).round())),
          ],
        ),
        const SizedBox(height: 16),
        Text(strings.pitchChartExplanation),
      ],
    );
  }
}

class PitchContourPainter extends CustomPainter {
  const PitchContourPainter({
    required this.result,
    required this.minimumSpan,
    required this.line,
    required this.baseline,
  });
  final PitchResult result;
  final double minimumSpan;
  final Color line;
  final Color baseline;

  @override
  void paint(Canvas canvas, Size size) {
    final values = result.points
        .map((point) => point.semitones)
        .whereType<double>()
        .toList();
    if (values.isEmpty || result.durationMs == 0) return;
    final span = math.max(
      minimumSpan / 2,
      values.map((value) => value.abs()).reduce(math.max),
    );
    final bounds = Rect.fromLTWH(
      16,
      16,
      math.max(0, size.width - 32),
      math.max(0, size.height - 32),
    );
    canvas.drawLine(
      Offset(bounds.left, bounds.center.dy),
      Offset(bounds.right, bounds.center.dy),
      Paint()
        ..color = baseline
        ..strokeWidth = 1,
    );
    final path = Path();
    var connected = false;
    for (final point in result.points) {
      if (point.semitones == null) {
        connected = false;
        continue;
      }
      final x = bounds.left + bounds.width * point.timeMs / result.durationMs;
      final y =
          bounds.center.dy - bounds.height * point.semitones! / (2 * span);
      if (connected) {
        path.lineTo(x, y);
      } else {
        path.moveTo(x, y);
      }
      connected = true;
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant PitchContourPainter oldDelegate) =>
      result != oldDelegate.result ||
      line != oldDelegate.line ||
      baseline != oldDelegate.baseline ||
      minimumSpan != oldDelegate.minimumSpan;
}
