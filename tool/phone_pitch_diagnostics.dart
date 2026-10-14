import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_coach/audio/recording_analysis.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/main.dart' as app;
import 'package:speech_coach/features/record/playback_controller.dart';

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
      final events = await analyzeRecording(file.path, config).toList();
      if (index == 1 && const bool.fromEnvironment('CHECK_REPLAY')) {
        final playback = LocalPlaybackDevice();
        try {
          await playback.load(file.path, 0, null);
          await playback.seek(1000);
          await playback.load(file.path, 0, 2000);
          debugPrint(
            'PHONE_REPLAY local WAV load, seek and bounded source passed',
          );
        } finally {
          await playback.dispose();
        }
      }
      final result = events.whereType<PitchComplete>().single.result;
      debugPrint(
        'PHONE_PITCH clip=$index version=${config.analysisVersion} '
        'hasPitch=${result.hasPitch} median=${result.medianHz} '
        'ratio=${result.voicedRatio} speech=${result.speechMs} '
        'points=${result.points.where((p) => p.semitones != null).length} '
        'fallback=${result.usedPitchFallback} analysisMs=${result.analysisMs}',
      );
      final metrics = result.analysis;
      if (metrics != null) {
        debugPrint(
          'PHONE_METRICS clip=$index '
          'pauses=${metrics.pauses.length} syllables=${metrics.syllableCount} '
          'speakingRate=${metrics.speakingRate} articulationRate=${metrics.articulationRate} '
          'loudnessRange=${metrics.loudnessRangeDb} energyTrend=${metrics.energyTrendDb} '
          'snr=${metrics.snrDb} clippingPct=${metrics.clippingPct} '
          'warnings=${metrics.qualityWarnings.map((w) => w.code).join(",")}',
        );
      }
    } catch (error, stack) {
      debugPrint('PHONE_PITCH clip=$index error=$error\n$stack');
    }
  }
  debugPrint('PHONE_PITCH complete clips=$index');
}
