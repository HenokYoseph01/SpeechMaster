import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_coach/audio/analysis_isolate.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/main.dart' as app;

// Run on the phone with flutter run -t tool/phone_pitch_diagnostics.dart.
// Audio stays on the device. Only aggregate diagnostics go to the debug log.
Future<void> main() async {
  app.main();
  final config = AudioConfig.fromJson(
    jsonDecode(await rootBundle.loadString('assets/audio_config.json'))
        as Map<String, dynamic>,
  );
  final support = await getApplicationSupportDirectory();
  final directory = Directory('${support.path}/recordings');
  if (!await directory.exists()) return;
  var index = 0;
  await for (final file in directory.list()) {
    if (file is! File || !file.path.endsWith('.wav')) continue;
    index++;
    try {
      final audio = decodeWav(
        await file.readAsBytes(),
        expectedSampleRate: config.captureSampleRate,
      );
      var squareSum = 0.0;
      var peak = 0.0;
      for (final sample in audio.samples) {
        squareSum += sample * sample;
        peak = math.max(peak, sample.abs());
      }
      debugPrint(
        'PHONE_PITCH clip=$index duration=${audio.durationMs} '
        'peak=$peak rms=${math.sqrt(squareSum / audio.samples.length)}',
      );
      final events = await analyzeWavInIsolate(file.path, config).toList();
      final result = events.whereType<PitchComplete>().single.result;
      debugPrint(
        'PHONE_PITCH clip=$index version=${config.analysisVersion} '
        'hasPitch=${result.hasPitch} median=${result.medianHz} '
        'ratio=${result.voicedRatio} speech=${result.speechMs} '
        'points=${result.points.where((p) => p.semitones != null).length} '
        'fallback=${result.usedPitchFallback}',
      );
    } catch (error, stack) {
      debugPrint('PHONE_PITCH clip=$index error=$error\n$stack');
    }
  }
  debugPrint('PHONE_PITCH complete clips=$index');
}
