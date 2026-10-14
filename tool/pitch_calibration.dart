import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/statistics.dart';
import 'package:speech_coach/audio/dsp/yin.dart';

// Known synthetic fundamentals; no microphone recordings leave the device.
void main() {
  final config = AudioConfig.fromJson(
    jsonDecode(File('assets/audio_config.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  final detector = YinDetector(config);
  var total = 0, missing = 0, octaveErrors = 0;
  var worstError = 0.0;
  for (final hz in [70.0, 80.0, 100.0, 150.0, 190.0]) {
    for (final fundamental in [1.0, 0.3, 0.1]) {
      for (final amplitude in [0.01, 0.3]) {
        for (final phase in [0.0, 0.7, 2.1]) {
          final frame = Float32List.fromList([
            for (var i = 0; i < config.pitchFrameSamples; i++)
              amplitude *
                  (fundamental *
                          math.sin(
                            2 * math.pi * hz * i / config.pitchSampleRate +
                                phase,
                          ) +
                      math.sin(
                        4 * math.pi * hz * i / config.pitchSampleRate + phase,
                      ) +
                      0.15 *
                          math.sin(
                            6 * math.pi * hz * i / config.pitchSampleRate +
                                phase,
                          )),
          ]);
          final pitch = detector.detect(frame);
          total++;
          if (pitch == null) {
            missing++;
            continue;
          }
          final error = semitones(pitch, hz).abs();
          worstError = math.max(worstError, error);
          if (error > 6) {
            octaveErrors++;
            stdout.writeln(
              jsonEncode({
                'hz': hz,
                'fundamental': fundamental,
                'amplitude': amplitude,
                'phase': phase,
                'detectedHz': pitch,
              }),
            );
          }
        }
      }
    }
  }
  stdout.writeln(
    jsonEncode({
      'frames': total,
      'missing': missing,
      'octaveErrors': octaveErrors,
      'worstErrorSemitones': worstError,
    }),
  );
}
