import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/audio/recorder.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/core/db/database_provider.dart';
import 'package:speech_coach/features/record/recording_controller.dart';
import 'package:speech_coach/features/record/recording_model.dart';
import 'package:speech_coach/features/record/recording_repository.dart';

import 'audio_fixtures.dart';

class FakeDevice implements RecordingDevice {
  final levels = StreamController<double>.broadcast(sync: true);
  final states = StreamController<RecorderSignal>.broadcast(sync: true);
  final closed = Completer<void>.sync();
  Completer<bool>? permissionPending;
  bool allowed = true;
  bool failStart = false;
  int starts = 0;
  int stops = 0;
  int cancels = 0;
  int settingsOpened = 0;
  String? path;
  AudioConfig? config;
  @override
  Future<bool> requestPermission() async =>
      permissionPending == null ? allowed : permissionPending!.future;
  @override
  Future<void> openAppSettings() async {
    settingsOpened++;
  }

  @override
  Future<void> start(String path, AudioConfig config) async {
    starts++;
    if (failStart) throw StateError('test start failed');
    this.path = path;
    this.config = config;
  }

  @override
  Future<String?> stop() async {
    stops++;
    return path;
  }

  @override
  Future<void> cancel() async {
    cancels++;
  }

  @override
  Future<void> dispose() async {
    if (closed.isCompleted) return;
    // These broadcast streams are created in the fake-clock zone. Closing
    // initiates cleanup; awaiting their done futures would need another pump.
    unawaited(levels.close());
    unawaited(states.close());
    closed.complete();
  }

  @override
  Stream<double> amplitudes(Duration interval) => levels.stream;
  @override
  Stream<RecorderSignal> get signals => states.stream;
}

class FakeClock implements RecordingClock {
  @override
  int elapsedMs = 0;
  @override
  void start() {
    elapsedMs = 0;
  }
}

class FakeRecordingRepository extends RecordingRepository {
  FakeRecordingRepository(super.database);
  int allocated = 0;
  int capturesSaved = 0;
  int pitchesSaved = 0;
  bool failCaptureSave = false;
  int? capturedMs;
  ClipDraft? captured;
  @override
  Future<ClipDraft> allocate(RecordingMode mode, String language) async {
    allocated++;
    return ClipDraft(
      id: 'test-$allocated',
      path: '/test-$allocated.wav',
      createdAt: 1,
      mode: mode,
      language: language,
    );
  }

  @override
  Future<void> saveCapture(
    ClipDraft draft,
    int durationMs,
    AudioConfig config,
  ) async {
    capturesSaved++;
    if (failCaptureSave) throw StateError('test storage failed');
    captured = draft;
    capturedMs = durationMs;
  }

  @override
  Future<void> savePitch(ClipDraft draft, PitchResult result) async {
    pitchesSaved++;
  }
}

class RecordingFixture {
  RecordingFixture() {
    repository = FakeRecordingRepository(database);
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        audioConfigProvider.overrideWith((ref) async => loadAudioConfig()),
        recordingDeviceFactoryProvider.overrideWithValue(() => device),
        recordingClockFactoryProvider.overrideWithValue(() => clock),
        recordingRepositoryProvider.overrideWithValue(repository),
        pitchAnalyzerProvider.overrideWithValue(
          (path, config) => analyze(path, config),
        ),
      ],
    );
    subscription = container.listen(recordingControllerProvider, (_, _) {});
    controller = container.read(recordingControllerProvider.notifier);
  }
  final database = AppDatabase(NativeDatabase.memory());
  final device = FakeDevice();
  final clock = FakeClock();
  late final FakeRecordingRepository repository;
  late final ProviderContainer container;
  late final ProviderSubscription<RecordingState> subscription;
  late final RecordingController controller;
  bool failAnalysis = false;
  Stream<PitchEvent>? analysisOverride;
  bool disposed = false;
  RecordingState get state => container.read(recordingControllerProvider);

  Stream<PitchEvent> analyze(String path, AudioConfig config) async* {
    if (analysisOverride != null) {
      yield* analysisOverride!;
      return;
    }
    if (failAnalysis) throw StateError('test analysis failed');
    yield PitchProgress(0.5);
    yield PitchComplete(
      PitchResult(
        durationMs: 30000,
        points: const [
          PitchPoint(0, -1, -20),
          PitchPoint(1000, 1, -20),
          PitchPoint(2000, null, -60),
        ],
        medianHz: 120,
        voicedRatio: 0.9,
        speechMs: 25000,
        analysisMs: 1,
        noiseFloorDb: -60,
      ),
    );
  }

  Future<void> dispose() async {
    if (disposed) return;
    disposed = true;
    subscription.close();
    container.dispose();
    await device.closed.future;
    await database.close();
  }
}
