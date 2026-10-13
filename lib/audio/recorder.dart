import 'package:flutter/services.dart';
import 'package:record/record.dart';

import 'audio_config.dart';

enum RecorderSignal { recording, paused, stopped }

abstract interface class RecordingDevice {
  Future<bool> requestPermission();
  Future<void> openAppSettings();
  Future<void> start(String path, AudioConfig config);
  Future<String?> stop();
  Future<void> cancel();
  Future<void> dispose();
  Stream<double> amplitudes(Duration interval);
  Stream<RecorderSignal> get signals;
}

class PhoneRecordingDevice implements RecordingDevice {
  final AudioRecorder _recorder = AudioRecorder();

  @override
  Future<bool> requestPermission() => _recorder.hasPermission();

  @override
  Future<void> openAppSettings() =>
      const MethodChannel('speech_coach/permissions')
          .invokeMethod<void>('openAppSettings');

  @override
  Future<void> start(String path, AudioConfig config) async {
    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: config.captureSampleRate,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
      ),
      path: path,
    );
    await HapticFeedback.lightImpact();
  }

  @override
  Future<String?> stop() async {
    final path = await _recorder.stop();
    await HapticFeedback.lightImpact();
    return path;
  }

  @override
  Future<void> cancel() => _recorder.cancel();
  @override
  Future<void> dispose() => _recorder.dispose();
  @override
  Stream<double> amplitudes(Duration interval) => _recorder
      .onAmplitudeChanged(interval)
      .map((amplitude) => amplitude.current);
  @override
  Stream<RecorderSignal> get signals => _recorder.onStateChanged().map(
    (signal) => switch (signal) {
      RecordState.record => RecorderSignal.recording,
      RecordState.pause => RecorderSignal.paused,
      RecordState.stop => RecorderSignal.stopped,
    },
  );
}
