import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_isolate.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/vad.dart';
import 'package:speech_coach/audio/dsp/wav.dart';
import 'package:speech_coach/audio/pitch_result.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = loadAudioConfig();

  test(
    'preview retains sparse reliable speech segments without filling gaps',
    () {
      const rate = 16000;
      final rng = math.Random(902);
      final samples = Float32List(rate * 12);
      for (var i = rate; i < rate * 11; i++) {
        samples[i] = i % rate < 2240
            ? 0.205 * math.sin(2 * math.pi * 150 * i / rate)
            : 0.5 * (rng.nextDouble() - 0.5);
      }
      final audio = WavAudio(samples, rate);
      final result = analyzePitch(audio, config);
      expect(result.hasPitch, isTrue);
      expect(result.usedPitchFallback, isFalse);
      expect(
        result.voicedRatio,
        greaterThanOrEqualTo(config.chartMinimumVoicedRatio),
      );
      expect(result.voicedRatio, lessThan(config.minimumVoicedRatio));
      expect(result.analysis!.pitchRangeSt, isNull);
      expect(result.analysis!.pitchMedianHz, isNull);
      expect(result.medianHz, closeTo(150, 3));
      expect(
        result.points.where((p) => p.semitones == null).length,
        greaterThan(50),
      );
      final strict = AudioConfig.fromJson({
        ...config.values,
        'chartMinimumVoicedRatio': config.minimumVoicedRatio,
      });
      expect(analyzePitch(audio, strict).hasPitch, isFalse);
    },
  );

  test(
    'moderately noisy periodic frames pass the calibrated YIN threshold',
    () {
      const rate = 16000;
      final rng = math.Random(503);
      final samples = Float32List(rate * 4);
      for (var i = 0; i < samples.length; i++) {
        samples[i] =
            0.2 * math.sin(2 * math.pi * 150 * i / rate) +
            0.4 * (rng.nextDouble() - 0.5);
      }
      final audio = WavAudio(samples, rate);
      final strict = AudioConfig.fromJson({
        ...config.values,
        'yinThreshold': 0.15,
      });
      expect(analyzePitch(audio, strict).hasPitch, isFalse);
      final result = analyzePitch(audio, config);
      expect(result.hasPitch, isTrue);
      expect(result.medianHz, closeTo(150, 3));
    },
  );

  test('continuous voiced delivery retains pitch at different microphone levels', () {
    for (final amplitude in [0.1, 0.3, 0.7]) {
      final samples = sine(
        150,
        sampleRate: 16000,
        samples: 16000 * 12,
        amplitude: amplitude,
      );
      final speech = detectSpeech(samples, config);
      final result = analyzePitch(WavAudio(samples, 16000), config);
      // ignore: avoid_print
      print(
        'Continuous voice amplitude=$amplitude: speechFrames=${speech.speech.where((value) => value).length}, pitch=${result.medianHz}, voicedRatio=${result.voicedRatio}',
      );
      expect(
        result.hasPitch,
        isTrue,
        reason: 'A stable voiced delivery should not require leading silence',
      );
      expect(result.medianHz, closeTo(150, 2));
      expect(result.usedPitchFallback, isTrue);
      expect(
        result.speechMs,
        0,
        reason: 'A chart fallback must not replace VAD speech time',
      );
    }
  });

  test('a short initial pitch register cannot reject the rest of the recording', () {
    const rate = 16000;
    final samples = Float32List(rate * 12);
    var phase = 0.0;
    for (var i = 0; i < samples.length; i++) {
      final seconds = i / rate;
      if (seconds < 1 || seconds >= 11) continue;
      final hz = seconds < 1.3 ? 90 : 180;
      phase += 2 * math.pi * hz / rate;
      samples[i] = 0.5 * math.sin(phase);
    }
    final result = analyzePitch(WavAudio(samples, rate), config);
    // ignore: avoid_print
    print(
      'Initial register change: speechMs=${result.speechMs}, pitch=${result.medianHz}, voicedRatio=${result.voicedRatio}',
    );
    expect(result.hasPitch, isTrue);
    expect(result.usedPitchFallback, isFalse);
    expect(result.voicedRatio, greaterThan(0.9));
    expect(
      result.points
          .where((point) => point.timeMs > 2000)
          .map((point) => point.semitones)
          .whereType<double>()
          .length,
      greaterThan(50),
    );
  });

  test('voice-like harmonics with breath noise retain pitch without leading silence', () {
    const rate = 16000;
    final rng = math.Random(24);
    final samples = Float32List(rate * 12);
    for (var i = 0; i < samples.length; i++) {
      final phase = 2 * math.pi * 150 * i / rate;
      final envelope = 0.9 + 0.1 * math.sin(2 * math.pi * i / rate);
      samples[i] =
          envelope *
              (0.22 * math.sin(phase) +
                  0.14 * math.sin(2 * phase) +
                  0.09 * math.sin(3 * phase)) +
          (rng.nextDouble() - 0.5) * 0.008;
    }
    final result = analyzePitch(WavAudio(samples, rate), config);
    expect(result.hasPitch, isTrue);
    expect(result.usedPitchFallback, isTrue);
    expect(result.medianHz, closeTo(150, 2));
    expect(result.voicedRatio, greaterThan(0.9));
  });

  test(
    'dominant second harmonic stays at the fundamental after WAV filtering',
    () {
      const rate = 16000;
      final samples = Float32List(rate * 12);
      for (var i = rate; i < rate * 11; i++) {
        final phase = 2 * math.pi * 150 * i / rate;
        samples[i] =
            0.025 * math.sin(phase) +
            0.25 * math.sin(2 * phase) +
            0.0375 * math.sin(3 * phase);
      }
      final result = analyzePitch(
        decodeWav(makeWav(samples), expectedSampleRate: rate),
        config,
      );
      expect(result.hasPitch, isTrue);
      expect(result.medianHz, closeTo(150, 2));
      expect(result.voicedRatio, greaterThan(0.9));
    },
  );
  test('changing white-noise levels never become a periodic pitch chart', () {
    const rate = 16000;
    final rng = math.Random(78);
    final samples = Float32List(rate * 12);
    for (var i = 0; i < samples.length; i++) {
      final amplitude =
          0.1 + 0.8 * (0.5 + 0.5 * math.sin(2 * math.pi * i / rate));
      samples[i] = (rng.nextDouble() - 0.5) * amplitude;
    }
    final result = analyzePitch(WavAudio(samples, rate), config);
    expect(result.hasPitch, isFalse);
    expect(result.medianHz, isNull);
    expect(result.usedPitchFallback, isFalse);
  });

  test(
    'a brief periodic burst in steady noise cannot qualify the whole clip',
    () {
      const rate = 16000;
      final rng = math.Random(63);
      final samples = Float32List(rate * 12);
      for (var i = 0; i < samples.length; i++) {
        final seconds = i / rate;
        samples[i] = seconds >= 5 && seconds < 6
            ? 0.245 * math.sin(2 * math.pi * 150 * seconds)
            : 0.6 * (rng.nextDouble() - 0.5);
      }
      final result = analyzePitch(WavAudio(samples, rate), config);
      expect(result.hasPitch, isFalse);
      expect(result.usedPitchFallback, isFalse);
    },
  );

  test('fallback and monotonic progress survive WAV decoding and the isolate boundary', () async {
    final directory = await Directory.systemTemp.createTemp(
      'speech_coach_pitch_regression_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/clip.wav');
    await file.writeAsBytes(
      makeWav(sine(150, sampleRate: 16000, samples: 16000 * 12)),
    );
    final events = await analyzeWavInIsolate(file.path, config).toList();
    final result = events.whereType<PitchComplete>().single.result;
    expect(result.hasPitch, isTrue);
    expect(result.usedPitchFallback, isTrue);
    expect(result.medianHz, closeTo(150, 2));
    final progress = events
        .whereType<PitchProgress>()
        .map((event) => event.value)
        .toList();
    expect(progress.first, 0);
    expect(progress.last, 1);
    for (var i = 1; i < progress.length; i++) {
      expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
    }
  });

  test('brief unvoiced bucket starts do not erase a mostly voiced chart', () {
    const rate = 16000;
    final rng = math.Random(41);
    final samples = Float32List(rate * 12);
    for (var i = 0; i < samples.length; i++) {
      // Each chart bucket begins with a short unvoiced sound, followed by
      // enough periodic frames. Sampling only the first frame loses them all.
      samples[i] = i % 1600 < 320
          ? 0.6 * (rng.nextDouble() - 0.5)
          : 0.245 * math.sin(2 * math.pi * 150 * i / rate);
    }
    final result = analyzePitch(WavAudio(samples, rate), config);
    expect(result.hasPitch, isTrue);
    expect(result.usedPitchFallback, isTrue);
    expect(result.points.first.semitones, isNotNull);
    expect(
      result.points.where((point) => point.semitones != null).length,
      greaterThan(100),
    );
  });
}
