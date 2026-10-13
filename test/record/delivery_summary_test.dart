import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/core/l10n/generated/app_localizations.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/record/delivery_summary.dart';

import '../support/audio_fixtures.dart';

void main() {
  final analysis = analyzePitch(
    WavAudio(syllablePulses(), 16000),
    loadAudioConfig(),
  ).analysis!;
  for (final language in ['en', 'am']) {
    testWidgets(
      'delivery summary supports large $language text and English-only approximate words',
      (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: buildTheme(AppTheme.honey, Brightness.light),
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: DeliverySummary(analysis: analysis),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final strings = await AppLocalizations.delegate.load(Locale(language));
        expect(find.text(strings.deliverySummaryTitle), findsOneWidget);
        expect(find.text(strings.deliveryPreviewNote), findsOneWidget);
        expect(
          find.textContaining(language == 'en' ? 'Approximately' : 'በግምት'),
          language == 'en' ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('all applicable quality warnings remain visible with no score', (
    tester,
  ) async {
    final quiet = speechTone(durationSeconds: 14, silenceSeconds: 1);
    for (var i = 0; i < quiet.length; i++) {
      quiet[i] *= 0.001;
    }
    final metrics = analyzePitch(
      WavAudio(quiet, 16000),
      loadAudioConfig(),
    ).analysis!;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(AppTheme.honey, Brightness.light),
        home: Scaffold(
          body: SingleChildScrollView(
            child: DeliverySummary(analysis: metrics),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final strings = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(strings.deliveryQualityTitle), findsOneWidget);
    expect(find.text(strings.qualityMoveCloser), findsOneWidget);
    expect(find.text(strings.deliveryPreviewNote), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
