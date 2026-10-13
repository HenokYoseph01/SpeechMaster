import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/core/router.dart';
import 'package:speech_coach/features/record/pitch_chart.dart';
import 'package:speech_coach/features/record/delivery_summary.dart';
import 'package:speech_coach/features/settings/settings_provider.dart';
import 'package:speech_coach/main.dart';

import '../support/recording_fakes.dart';
import '../support/audio_fixtures.dart';

void main() {
  testWidgets(
    'completed full analysis displays its summary below the working pitch chart',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.analysisOverride = Stream.value(
        PitchComplete(
          analyzePitch(WavAudio(syllablePulses(), 16000), loadAudioConfig()),
        ),
      );
      fixture.container.read(routerProvider).go('/record');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: fixture.container,
          child: const MainApp(),
        ),
      );
      await tester.pumpAndSettle();
      await fixture.controller.start('en');
      fixture.clock.elapsedMs = 10000;
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(fixture.controller.stop);
      await tester.pumpAndSettle();
      expect(find.byType(PitchChart), findsOneWidget);
      expect(find.byType(DeliverySummary), findsOneWidget);
      expect(find.textContaining('Estimated pace:'), findsOneWidget);
      expect(fixture.repository.pitchesSaved, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'recording UI supports large Amharic text and shows a pitch chart after stop',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      await tester.runAsync(
        () => fixture.container
            .read(settingsProvider.notifier)
            .setLocale(const Locale('am')),
      );
      fixture.container.read(routerProvider).go('/record');
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: fixture.container,
          child: const MainApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ChoiceChip), findsNWidgets(2));
      await fixture.controller.start('am');
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'ቀረጻውን ያጠናቅቁ'),
            )
            .onPressed,
        isNull,
      );
      fixture.clock.elapsedMs = 10000;
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'ቀረጻውን ያጠናቅቁ'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.runAsync(() => fixture.controller.stop());
      await tester.pumpAndSettle();
      expect(find.byType(PitchChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
