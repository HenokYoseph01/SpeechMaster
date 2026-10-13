import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/audio/recorder.dart';
import 'package:speech_coach/features/record/recording_model.dart';

import '../support/recording_fakes.dart';

void main() {
  testWidgets(
    'default 30-second mode refuses early stop then saves and analyzes once',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      expect(fixture.state.mode, RecordingMode.thirtySeconds);
      await fixture.controller.start('am');
      fixture.controller.selectMode(RecordingMode.sixtySeconds);
      expect(fixture.state.mode, RecordingMode.thirtySeconds);
      fixture.clock.elapsedMs = 9999;
      await tester.runAsync(() => fixture.controller.stop());
      expect(fixture.device.stops, 0);
      fixture.clock.elapsedMs = 10000;
      await tester.pump(const Duration(milliseconds: 100));
      expect(fixture.state.canStop, isTrue);
      expect(fixture.state.remainingSeconds, 20);
      fixture.device.levels.add(-12);
      expect(fixture.state.levels, [-12]);
      await tester.runAsync(() => fixture.controller.stop());
      await tester.runAsync(() => fixture.controller.stop());
      expect(fixture.state.phase, RecordingPhase.done);
      expect(fixture.device.stops, 1);
      expect(fixture.repository.capturesSaved, 1);
      expect(fixture.repository.pitchesSaved, 1);
      expect(fixture.repository.captured!.language, 'am');
      expect(fixture.repository.captured!.mode.durationMs, 30000);
      expect(fixture.repository.capturedMs, 10000);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  for (final mode in RecordingMode.values) {
    testWidgets('${mode.durationMs} mode auto-stops at its deadline', (
      tester,
    ) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.controller.selectMode(mode);
      await fixture.controller.start('en');
      fixture.clock.elapsedMs = mode.durationMs - 1;
      await tester.pump(Duration(milliseconds: mode.durationMs - 1));
      expect(fixture.device.stops, 0);
      fixture.clock.elapsedMs = mode.durationMs;
      await tester.pump(const Duration(milliseconds: 1));
      await pumpRecordingUntil(
        tester,
        () => fixture.state.phase == RecordingPhase.done,
      );
      expect(fixture.device.stops, 1);
      expect(fixture.state.phase, RecordingPhase.done);
      expect(fixture.repository.captured!.mode, mode);
    });
  }

  testWidgets(
    'permission denial creates no audio path and duplicate starts are ignored',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.device.permissionPending = Completer<bool>();
      final first = fixture.controller.start('en');
      await tester.pump();
      await fixture.controller.start('en');
      fixture.device.permissionPending!.complete(false);
      await first;
      expect(fixture.state.phase, RecordingPhase.permissionDenied);
      expect(fixture.repository.allocated, 0);
      expect(fixture.device.starts, 0);
      await fixture.controller.openAppSettings();
      expect(fixture.device.settingsOpened, 1);
    },
  );

  testWidgets(
    'discard and native interruptions cancel captures without saving',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      await fixture.controller.start('en');
      await tester.runAsync(() => fixture.controller.discard());
      expect(fixture.state.phase, RecordingPhase.ready);
      expect(fixture.repository.capturesSaved, 0);
      await fixture.controller.start('en');
      fixture.device.states.add(RecorderSignal.paused);
      await pumpRecordingUntil(
        tester,
        () => fixture.state.phase == RecordingPhase.interrupted,
      );
      expect(fixture.state.phase, RecordingPhase.interrupted);
      expect(fixture.device.cancels, 2);
      expect(fixture.repository.capturesSaved, 0);
    },
  );

  testWidgets(
    'backgrounding during permission cannot start a hidden recording',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.device.permissionPending = Completer<bool>();
      final starting = fixture.controller.start('en');
      await tester.pump();
      fixture.controller.setForeground(false);
      fixture.device.permissionPending!.complete(true);
      await starting;
      expect(fixture.device.starts, 0);
      expect(fixture.state.phase, RecordingPhase.interrupted);
    },
  );

  testWidgets(
    'analysis retry preserves audio and does not create a second recording',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.failAnalysis = true;
      await fixture.controller.start('en');
      fixture.clock.elapsedMs = 10000;
      await tester.runAsync(() => fixture.controller.stop());
      expect(fixture.state.failure, RecordingFailure.analysis);
      expect(fixture.state.canRetryAnalysis, isTrue);
      expect(fixture.device.cancels, 0);
      fixture.failAnalysis = false;
      await tester.runAsync(() => fixture.controller.retryAnalysis());
      expect(fixture.state.phase, RecordingPhase.done);
      expect(fixture.repository.capturesSaved, 1);
      expect(fixture.device.starts, 1);
    },
  );

  testWidgets(
    'storage failure retains completed audio even when leaving the screen',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      fixture.repository.failCaptureSave = true;
      await fixture.controller.start('en');
      fixture.clock.elapsedMs = 10000;
      await tester.runAsync(() => fixture.controller.stop());
      expect(fixture.state.failure, RecordingFailure.storage);
      expect(fixture.state.canRetryAnalysis, isTrue);
      await tester.runAsync(fixture.dispose);
      expect(fixture.device.cancels, 0);
    },
  );

  testWidgets(
    'disposing during analysis closes the subscription and completes pending work',
    (tester) async {
      final fixture = RecordingFixture();
      addTearDown(() => tester.runAsync(fixture.dispose));
      final events = StreamController<PitchEvent>();
      fixture.analysisOverride = events.stream;
      await fixture.controller.start('en');
      fixture.clock.elapsedMs = 10000;
      final stopping = fixture.controller.stop();
      await pumpRecordingUntil(
        tester,
        () => fixture.state.phase == RecordingPhase.analyzing,
      );
      expect(fixture.state.phase, RecordingPhase.analyzing);
      final disposal = fixture.dispose();
      await pumpRecordingUntil(tester, () => fixture.device.closed.isCompleted);
      await disposal;
      await stopping;
      unawaited(events.close());
      await tester.pump();
      expect(fixture.device.cancels, 0);
      expect(tester.takeException(), isNull);
    },
  );
}

// Stream cancellation can schedule zero-delay work without scheduling a frame.
// Drive both fake-clock and real async work until the observable state settles.
Future<void> pumpRecordingUntil(
  WidgetTester tester,
  bool Function() complete,
) async {
  for (var i = 0; i < 30 && !complete(); i++) {
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
  expect(complete(), isTrue, reason: 'Recorder async work did not settle');
}
