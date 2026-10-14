import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_isolate.dart';
import 'package:speech_coach/audio/neural_vad.dart';
import 'package:speech_coach/audio/dsp/vad.dart';
import 'package:speech_coach/audio/pitch_result.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = loadAudioConfig();
  String? nativeDirectory;
  if (Platform.isLinux) {
    final packages = jsonDecode(
      File('.dart_tool/package_config.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final package = (packages['packages'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['name'] == 'sherpa_onnx_linux');
    nativeDirectory = Directory.fromUri(Uri.parse(package['rootUri'] as String))
        .uri
        .resolve('linux/x64/')
        .toFilePath();
  }
  final model = File('assets/models/silero_vad.onnx').absolute.path;
  test('bundled neural model rejects silence and noise without manufacturing pauses', () {
    final rng = math.Random(718);
    for (final samples in [
      Float32List(16000 * 3),
      Float32List.fromList(
        List.generate(16000 * 3, (_) => (rng.nextDouble() - 0.5) * 0.2),
      ),
    ]) {
      final speech = detectNeuralSpeech(
        samples,
        config,
        model,
        nativeLibraryDirectory: nativeDirectory,
      );
      expect(speech.speech.where((s) => s), isEmpty);
      expect(speech.noiseFloorDb, isNotNull);
    }
  });
  test('speech segmentation retains quiet speech and does not require silence for speech time', () {
    final db = List<double>.filled(3000, -40);
    final old = SpeechFrames(db, List.filled(3000, false), -40);
    final continuous = old.withSegments([(0, 30000)], config);
    expect(continuous.speech.where((s) => s).length, 3000);
    expect(
      continuous.noiseFloorDb,
      isNull,
      reason: 'Do not pretend speech provides an independent background-noise estimate',
    );
    final withGap = old.withSegments([(0, 14000), (15000, 30000)], config);
    expect(withGap.speech.where((s) => s).length, 2900);
    expect(withGap.noiseFloorDb, -40);
  });
  test(
    'native model executes in the analysis isolate and preserves quality flags',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_neural_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/silence.wav');
      await file.writeAsBytes(makeWav(Float32List(16000 * 3)));
      final events = await analyzeWavInIsolate(
        file.path,
        config,
        vadModelPath: model,
        nativeLibraryDirectory: nativeDirectory,
      ).toList();
      final result = events.whereType<PitchComplete>().single.result;
      expect(result.usedNeuralVad, isTrue);
      expect(result.speechMs, 0);
      expect(result.analysis!.passesQualityGates, isFalse);
      expect(result.analysis!.pauses, isEmpty);
    },
  );
  test('an unavailable neural model returns a retryable error instead of quietly using energy VAD', () async {
    final directory = await Directory.systemTemp.createTemp(
      'speech_coach_neural_failure_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/clip.wav');
    await file.writeAsBytes(makeWav(Float32List(16000)));
    await expectLater(
      analyzeWavInIsolate(
        file.path,
        config,
        vadModelPath: '${directory.path}/missing.onnx',
        nativeLibraryDirectory: nativeDirectory,
      ).toList(),
      throwsStateError,
    );
  });
}
