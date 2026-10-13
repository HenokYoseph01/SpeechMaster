import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_isolate.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/downsample.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/pitch_result.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = loadAudioConfig();
  test('anti-alias filter preserves pitch tones and attenuates frequencies above 4 kHz', () {
    final low = sine(240, sampleRate: 16000, samples: 16000);
    final high = sine(6000, sampleRate: 16000, samples: 16000);
    double rms(Float32List audio) => math.sqrt(
      audio
              .skip(100)
              .take(audio.length - 200)
              .fold<double>(0, (sum, value) => sum + value * value) /
          (audio.length - 200),
    );
    expect(downsampleForPitch(low, config).length, 8000);
    expect(rms(downsampleForPitch(low, config)), closeTo(rms(low), 0.01));
    expect(rms(downsampleForPitch(high, config)), lessThan(rms(high) * 0.1));
  });
  test(
    '120 to 240 Hz glide has a rising contour and silence stays unvoiced',
    () {
      final result = analyzePitch(
        WavAudio(speechTone(startHz: 120, endHz: 240), 16000),
        config,
      );
      expect(result.hasPitch, isTrue);
      final start = result.points
          .where((point) => point.timeMs >= 600 && point.timeMs <= 1000)
          .map((point) => point.semitones)
          .whereType<double>();
      final end = result.points
          .where((point) => point.timeMs >= 3000 && point.timeMs <= 3300)
          .map((point) => point.semitones)
          .whereType<double>();
      expect(start.every((st) => st < 0), isTrue);
      expect(end.every((st) => st > 0), isTrue);
      expect(end.first - start.first, greaterThan(8));
      expect(
        result.points.take(4).every((point) => point.semitones == null),
        isTrue,
      );
      expect(
        result.points.skip(37).every((point) => point.semitones == null),
        isTrue,
      );
      expect(result.points.length, 40);
      expect(result.voicedRatio, greaterThan(0.9));
    },
  );
  test('silence and white noise return no usable pitch contour', () {
    final rng = math.Random(91);
    for (final samples in [
      Float32List(16000 * 4),
      Float32List.fromList(
        List.generate(16000 * 4, (_) => rng.nextDouble() - 0.5),
      ),
    ]) {
      final result = analyzePitch(WavAudio(samples, 16000), config);
      expect(result.hasPitch, isFalse);
      expect(result.medianHz, isNull);
      expect(result.points.every((point) => point.semitones == null), isTrue);
    }
  });
  test(
    '30-second WAV is read and analyzed in an isolate with monotonic progress',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_pitch_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/clip.wav');
      await file.writeAsBytes(
        makeWav(
          speechTone(
            durationSeconds: 30,
            silenceSeconds: 3,
            startHz: 120,
            endHz: 240,
          ),
          junkChunk: true,
        ),
      );
      final events = await analyzeWavInIsolate(file.path, config).toList();
      final progress = events
          .whereType<PitchProgress>()
          .map((event) => event.value)
          .toList();
      expect(progress.first, 0);
      expect(progress.last, 1);
      for (var i = 1; i < progress.length; i++) {
        expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
      }
      final result = events.whereType<PitchComplete>().single.result;
      expect(result.durationMs, 30000);
      expect(result.points.length, 300);
      expect(result.medianHz, closeTo(180, 5));
      expect(result.hasPitch, isTrue);
      expect(await file.exists(), isTrue);
      // A host measurement is diagnostic only, not a low-end-phone acceptance claim.
      // ignore: avoid_print
      print('30-second pitch prototype on test host: ${result.analysisMs} ms');
    },
  );
  test('isolate failures reach the caller rather than hanging', () async {
    await expectLater(
      analyzeWavInIsolate('/missing/speech-coach.wav', config).toList(),
      throwsStateError,
    );
  });
  test('audio config rejects fractional hops and changed capture format', () {
    expect(
      () => AudioConfig.fromJson({...config.values, 'pitchHopMs': 0.5}),
      throwsFormatException,
    );
    expect(
      () =>
          AudioConfig.fromJson({...config.values, 'captureSampleRate': 44100}),
      throwsFormatException,
    );
    expect(
      () => AudioConfig.fromJson({...config.values, 'lowPassTaps': 30}),
      throwsFormatException,
    );
  });
}
