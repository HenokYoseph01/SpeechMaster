import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/analysis_isolate.dart';
import '../../audio/audio_config.dart';
import '../../audio/pitch_result.dart';
import '../../audio/recorder.dart';
import 'recording_model.dart';
import 'recording_repository.dart';

final audioConfigProvider = FutureProvider<AudioConfig>(
  (ref) async => AudioConfig.fromJson(
    jsonDecode(await rootBundle.loadString('assets/audio_config.json'))
        as Map<String, dynamic>,
  ),
);
final recordingDeviceFactoryProvider = Provider<RecordingDevice Function()>(
  (ref) => PhoneRecordingDevice.new,
);
final pitchAnalyzerProvider =
    Provider<Stream<PitchEvent> Function(String, AudioConfig)>(
      (ref) => analyzeWavInIsolate,
    );
final recordingClockFactoryProvider = Provider<RecordingClock Function()>(
  (ref) => StopwatchRecordingClock.new,
);
final recordingControllerProvider =
    NotifierProvider.autoDispose<RecordingController, RecordingState>(
      RecordingController.new,
    );

abstract interface class RecordingClock {
  void start();
  int get elapsedMs;
}

class StopwatchRecordingClock implements RecordingClock {
  final _watch = Stopwatch();
  @override
  void start() => _watch
    ..reset()
    ..start();
  @override
  int get elapsedMs => _watch.elapsedMilliseconds;
}

class RecordingController extends Notifier<RecordingState> {
  late RecordingDevice _device;
  late RecordingClock _clock;
  Timer? _ticker;
  Timer? _deadline;
  StreamSubscription<double>? _amplitude;
  StreamSubscription<RecorderSignal>? _signals;
  StreamSubscription<PitchEvent>? _analysis;
  Completer<PitchResult>? _analysisCompletion;
  AudioConfig? _config;
  ClipDraft? _draft;
  int _capturedMs = 0;
  bool _captureSaved = false;
  bool _captureFinished = false;
  bool _backgrounded = false;
  bool _disposed = false;

  @override
  RecordingState build() {
    _device = ref.read(recordingDeviceFactoryProvider)();
    _clock = ref.read(recordingClockFactoryProvider)();
    ref.onDispose(() {
      _disposed = true;
      unawaited(_dispose());
    });
    return const RecordingState();
  }

  void selectMode(RecordingMode mode) {
    if (!state.isBusy) state = RecordingState(mode: mode);
  }

  Future<void> start(String language) async {
    if (state.isBusy) return;
    final mode = state.mode;
    _draft = null;
    _captureSaved = false;
    _captureFinished = false;
    state = RecordingState(mode: mode, phase: RecordingPhase.starting);
    try {
      _ensureForeground();
      _config = await ref.read(audioConfigProvider.future);
      if (_disposed) return;
      _ensureForeground();
      final permitted = await _device.requestPermission();
      if (_disposed) return;
      _ensureForeground();
      if (!permitted) {
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.permissionDenied,
        );
        return;
      }
      _draft = await ref
          .read(recordingRepositoryProvider)
          .allocate(mode, language);
      if (_disposed) return;
      _ensureForeground();
      await _device.start(_draft!.path, _config!);
      if (_disposed) return;
      _ensureForeground();
      _clock.start();
      state = RecordingState(
        mode: mode,
        phase: RecordingPhase.recording,
        minimumMs: _config!.minimumRecordingMs,
      );
      _signals = _device.signals.listen(
        (signal) {
          if (!_disposed &&
              state.phase == RecordingPhase.recording &&
              signal != RecorderSignal.recording) {
            unawaited(interrupt());
          }
        },
        onError: (Object error) {
          if (!_disposed) unawaited(interrupt());
        },
      );
      _amplitude = _device
          .amplitudes(Duration(milliseconds: _config!.amplitudeIntervalMs))
          .listen(
            (db) {
              if (_disposed ||
                  state.phase != RecordingPhase.recording ||
                  !db.isFinite) {
                return;
              }
              final levels = [
                ...state.levels,
                db.clamp(_config!.waveformFloorDb, 0.0),
              ];
              state = state.recordingUpdate(
                levels: List.unmodifiable(
                  levels.length > _config!.waveformHistoryPoints
                      ? levels.sublist(
                          levels.length - _config!.waveformHistoryPoints,
                        )
                      : levels,
                ),
              );
            },
            onError: (Object error) {
              if (!_disposed) unawaited(interrupt());
            },
          );
      _ticker = Timer.periodic(
        Duration(milliseconds: _config!.countdownIntervalMs),
        (_) {
          if (!_disposed && state.phase == RecordingPhase.recording) {
            state = state.recordingUpdate(
              elapsedMs: _clock.elapsedMs.clamp(0, mode.durationMs),
            );
          }
        },
      );
      _deadline = Timer(
        Duration(milliseconds: mode.durationMs),
        () => unawaited(_stop(automatic: true)),
      );
    } catch (error) {
      if (!_disposed) {
        await _safeCancel();
        if (!_disposed) {
          state = RecordingState(
            mode: mode,
            phase: error is _CaptureInterrupted
                ? RecordingPhase.interrupted
                : RecordingPhase.failure,
            failure: RecordingFailure.capture,
          );
        }
      }
    }
  }

  Future<void> stop() => _stop();

  Future<void> openAppSettings() async {
    try {
      await _device.openAppSettings();
    } catch (_) {
      // The permission screen also explains how to open settings manually.
      debugPrint('Android app settings could not open');
    }
  }

  void setForeground(bool foreground) {
    _backgrounded = !foreground;
    if (!foreground) unawaited(interrupt());
  }

  void _ensureForeground() {
    if (_backgrounded) throw const _CaptureInterrupted();
  }

  Future<void> _stop({bool automatic = false}) async {
    if (_disposed ||
        state.phase != RecordingPhase.recording ||
        (!automatic && _clock.elapsedMs < _config!.minimumRecordingMs)) {
      return;
    }
    final mode = state.mode;
    _capturedMs = _clock.elapsedMs;
    state = RecordingState(mode: mode, phase: RecordingPhase.stopping);
    await _stopMonitoring();
    try {
      final path = await _device.stop();
      if (_disposed) return;
      if (path == null || path != _draft!.path) {
        throw StateError('Capture returned no WAV path');
      }
      _captureFinished = true;
    } catch (_) {
      await _safeCancel();
      if (!_disposed) {
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.failure,
          failure: RecordingFailure.capture,
        );
      }
      return;
    }
    await _saveAndAnalyze();
  }

  Future<void> retryAnalysis() async {
    if (!state.isBusy && state.canRetryAnalysis) await _saveAndAnalyze();
  }

  Future<void> _saveAndAnalyze() async {
    if (_disposed) return;
    final mode = _draft!.mode;
    state = RecordingState(mode: mode, phase: RecordingPhase.analyzing);
    try {
      if (!_captureSaved) {
        await ref
            .read(recordingRepositoryProvider)
            .saveCapture(_draft!, _capturedMs, _config!);
        _captureSaved = true;
      }
    } catch (_) {
      if (!_disposed) {
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.failure,
          failure: RecordingFailure.storage,
          canRetryAnalysis: true,
        );
      }
      return;
    }
    if (_disposed) return;
    final completion = Completer<PitchResult>();
    _analysisCompletion = completion;
    _analysis = ref
        .read(pitchAnalyzerProvider)(_draft!.path, _config!)
        .listen(
          (event) {
            if (_disposed) return;
            if (event is PitchProgress) {
              state = RecordingState(
                mode: mode,
                phase: RecordingPhase.analyzing,
                progress: event.value,
              );
            } else if (event is PitchComplete && !completion.isCompleted) {
              completion.complete(event.result);
            }
          },
          onError: (Object error, StackTrace stack) {
            if (!completion.isCompleted) completion.completeError(error, stack);
          },
          onDone: () {
            if (!completion.isCompleted) {
              completion.completeError(StateError('No analysis result'));
            }
          },
        );
    PitchResult result;
    try {
      result = await completion.future;
    } catch (error, stack) {
      debugPrint('Pitch analysis failed: $error\n$stack');
      if (!_disposed) {
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.failure,
          failure: RecordingFailure.analysis,
          canRetryAnalysis: true,
        );
      }
      return;
    } finally {
      await _analysis?.cancel();
      _analysis = null;
      _analysisCompletion = null;
    }
    if (_disposed) return;
    try {
      await ref.read(recordingRepositoryProvider).savePitch(_draft!, result);
      if (!_disposed) {
        debugPrint(
          'Pitch prototype analysis: ${result.analysisMs} ms; '
          'speech=${result.speechMs} ms; voicedRatio=${result.voicedRatio.toStringAsFixed(3)}; '
          'fallback=${result.usedPitchFallback}; hasPitch=${result.hasPitch}',
        );
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.done,
          result: result,
          progress: 1,
        );
      }
    } catch (_) {
      if (!_disposed) {
        state = RecordingState(
          mode: mode,
          phase: RecordingPhase.failure,
          failure: RecordingFailure.storage,
          canRetryAnalysis: true,
        );
      }
    }
  }

  Future<void> discard() async {
    if (_disposed || state.phase != RecordingPhase.recording) return;
    final mode = state.mode;
    state = RecordingState(mode: mode, phase: RecordingPhase.cancelling);
    await _stopMonitoring();
    await _safeCancel();
    if (!_disposed) state = RecordingState(mode: mode);
  }

  Future<void> interrupt() async {
    if (_disposed || state.phase != RecordingPhase.recording) return;
    final mode = state.mode;
    state = RecordingState(mode: mode, phase: RecordingPhase.cancelling);
    await _stopMonitoring();
    await _safeCancel();
    if (!_disposed) {
      state = RecordingState(mode: mode, phase: RecordingPhase.interrupted);
    }
  }

  Future<void> _stopMonitoring() async {
    _ticker?.cancel();
    _deadline?.cancel();
    await _amplitude?.cancel();
    await _signals?.cancel();
    _amplitude = null;
    _signals = null;
  }

  Future<void> _safeCancel() async {
    try {
      await _device.cancel();
    } catch (_) {
      await _device.dispose();
      if (!_disposed) _device = ref.read(recordingDeviceFactoryProvider)();
    }
  }

  Future<void> _dispose() async {
    await _stopMonitoring();
    await _analysis?.cancel();
    final completion = _analysisCompletion;
    if (completion != null && !completion.isCompleted) {
      completion.completeError(StateError('Analysis cancelled on disposal'));
    }
    // Only unsaved active captures are discarded. Completed WAVs stay local.
    if (!_captureFinished) await _safeCancel();
    await _device.dispose();
  }
}

class _CaptureInterrupted implements Exception {
  const _CaptureInterrupted();
}
