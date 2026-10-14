import 'dart:convert';
import 'dart:io';

import 'package:speech_coach/audio/analysis_isolate.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/pitch_result.dart';

// Developer-only CLI; no recordings or transcripts are uploaded.
Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    throw ArgumentError('Pass a mono PCM16 16 kHz WAV path');
  }
  final config = AudioConfig.fromJson(
    jsonDecode(await File('assets/audio_config.json').readAsString())
        as Map<String, dynamic>,
  );
  String? nativeDirectory;
  if (Platform.isLinux) {
    final packages = jsonDecode(
      await File('.dart_tool/package_config.json').readAsString(),
    ) as Map<String, dynamic>;
    final package = (packages['packages'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['name'] == 'sherpa_onnx_linux');
    nativeDirectory = Directory.fromUri(Uri.parse(package['rootUri'] as String))
        .uri
        .resolve('linux/x64/')
        .toFilePath();
  }
  for (final neural in [false, true]) {
    final events = await analyzeWavInIsolate(
      arguments.single,
      config,
      vadModelPath: neural
          ? File('assets/models/silero_vad.onnx').absolute.path
          : null,
      nativeLibraryDirectory: nativeDirectory,
    ).toList();
    final result = events.whereType<PitchComplete>().single.result;
    final metrics = result.analysis!;
    stdout.writeln(
      jsonEncode({
        'detector': neural ? 'silero' : 'legacy_energy',
        'durationMs': result.durationMs,
        'speechMs': result.speechMs,
        'analysisMs': result.analysisMs,
        'hasPitch': result.hasPitch,
        'voicedRatio': result.voicedRatio,
        'pauses': [for (final p in metrics.pauses) p.toJson()],
        'speakingRate': metrics.speakingRate,
        'snrDb': metrics.snrDb,
        'warnings': [for (final w in metrics.qualityWarnings) w.code],
      }),
    );
  }
}
