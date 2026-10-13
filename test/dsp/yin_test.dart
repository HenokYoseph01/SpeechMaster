import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/dsp/statistics.dart';
import 'package:speech_coach/audio/dsp/yin.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = loadAudioConfig();
  final detector = YinDetector(config);
  for (final hz in [70.0, 80.0, 100.0, 120.0, 220.0, 240.0, 350.0, 400.0]) {
    test('detects $hz Hz within one semitone at multiple phases', () {
      for (final phase in [0.0, 0.7, 2.1]) {
        final pitch = detector.detect(
          sine(hz, samples: config.pitchFrameSamples, phase: phase),
        );
        expect(pitch, isNotNull);
        expect(semitones(pitch!, hz).abs(), lessThan(1));
      }
    });
  }
  test('silence and seeded white noise are unvoiced', () {
    expect(detector.detect(Float32List(config.pitchFrameSamples)), isNull);
    final rng = math.Random(23);
    final noise = Float32List.fromList(
      List.generate(config.pitchFrameSamples, (_) => rng.nextDouble() - 0.5),
    );
    expect(detector.detect(noise), isNull);
  });
  test('short frames and invalid offsets cannot produce pitch', () {
    expect(detector.detect(Float32List(20)), isNull);
    expect(detector.detect(sine(120), offset: -1), isNull);
    expect(detector.detect(sine(120), offset: 1), isNull);
  });
}
