import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/analysis_result.dart';
import 'package:speech_coach/audio/audio_config.dart';
import 'package:speech_coach/audio/dsp/metrics.dart';
import 'package:speech_coach/audio/dsp/pauses.dart';
import 'package:speech_coach/audio/dsp/pitch_analysis.dart';
import 'package:speech_coach/audio/dsp/syllables.dart';
import 'package:speech_coach/audio/dsp/vad.dart';
import 'package:speech_coach/audio/dsp/wav.dart';

import '../support/audio_fixtures.dart';

void main() {
  final config = loadAudioConfig();

  test('internal pauses are accurate within 50 ms, excluding opening and closing silence', () {
    const rate = 16000;
    final samples = Float32List(rate * 18);
    const spans = [(1.0, 4.0), (4.4, 7.4), (8.3, 11.3), (13.3, 16.3)];
    for (final (start, end) in spans) {
      for (var i = (start * rate).round(); i < (end * rate).round(); i++) {
        samples[i] = 0.3 * math.sin(2 * math.pi * 160 * i / rate);
      }
    }
    final metrics = analyzePitch(WavAudio(samples, rate), config).analysis!;
    expect(metrics.pauses.length, 3);
    const expected = [(4000, 4400), (7400, 8300), (11300, 13300)];
    for (var i = 0; i < expected.length; i++) {
      expect(metrics.pauses[i].startMs, closeTo(expected[i].$1, 50));
      expect(metrics.pauses[i].endMs, closeTo(expected[i].$2, 50));
    }
    expect(metrics.shortPauseCount, 1);
    expect(metrics.mediumPauseCount, 1);
    expect(metrics.longPauseCount, 1);
    expect(metrics.meanPauseMs, closeTo(1100, 50));
    expect(metrics.pauseRatio, closeTo(3300 / 18000, 0.01));
    expect(metrics.pausesPerMin, 10);
    expect(metrics.passesQualityGates, isTrue);
  });

  test(
    'pause classification includes 250 ms, 600 ms and 1500 ms boundaries',
    () {
      final speech = <bool>[...List.filled(100, false)];
      for (final gap in [24, 25, 59, 60, 150, 151]) {
        speech.addAll([...List.filled(100, true), ...List.filled(gap, false)]);
      }
      speech.addAll([...List.filled(100, true), ...List.filled(200, false)]);
      final pauses = detectPauses(speech, config);
      expect(pauses.map((p) => p.durationMs), [250, 590, 600, 1500, 1510]);
      expect(pauses.map((p) => p.kind), [
        PauseKind.short,
        PauseKind.short,
        PauseKind.medium,
        PauseKind.medium,
        PauseKind.long,
      ]);
      expect(detectPauses(List.filled(100, false), config), isEmpty);
      expect(detectPauses(List.filled(100, true), config), isEmpty);
    },
  );

  test('amplitude ramps measure volume range and the signed ending trend', () {
    for (final direction in [1, -1]) {
      const rate = 16000;
      final samples = Float32List(rate * 14);
      for (var i = rate; i < rate * 13; i++) {
        final progress = (i - rate) / (rate * 12);
        final db = direction == 1 ? -24 + 18 * progress : -6 - 18 * progress;
        samples[i] =
            math.pow(10, db / 20) * math.sin(2 * math.pi * 160 * i / rate);
      }
      final result = analyzePitch(WavAudio(samples, rate), config).analysis!;
      expect(result.energyTrendDb, closeTo(direction * 12, 0.5));
      expect(result.loudnessRangeDb, closeTo(13.5, 0.5));
      expect(result.pitchRangeSt, lessThan(0.1));
      expect(result.pitchStdSt, lessThan(0.1));
      expect(result.pitchMovementStPerS, lessThan(0.2));
    }
  });

  test('voiced energy pulses produce syllable estimates with the correct denominators', () {
    final audio = WavAudio(syllablePulses(), 16000);
    final metrics = analyzePitch(audio, config).analysis!;
    expect(metrics.syllableCount, 48);
    expect(metrics.articulationRate, closeTo(4, 0.1));
    expect(metrics.speakingRate, closeTo(48 / 14, 0.01));
    expect(metrics.approximateEnglishWpm, closeTo(48 / 14 * 60 / 1.5, 0.1));
    expect(metrics.paceWindows.length, 3);
    expect(metrics.paceCV, closeTo(0.127075, 0.001));
  });

  test(
    'band pass preserves speech-band energy while reducing rumble and hiss',
    () {
      double rms(Float32List samples) => math.sqrt(
        samples.skip(1000).fold<double>(0, (s, v) => s + v * v) /
            (samples.length - 1000),
      );
      final middle = bandPassForSyllables(
        sine(1000, sampleRate: 16000, samples: 16000),
        config,
      );
      for (final hz in [80.0, 6000.0]) {
        final outside = bandPassForSyllables(
          sine(hz, sampleRate: 16000, samples: 16000),
          config,
        );
        expect(rms(outside), lessThan(rms(middle) * 0.15));
      }
      expect(rms(middle), greaterThan(0.3));
    },
  );

  test('syllable peaks require voicing and stay at least 100 ms apart', () {
    final samples = syllablePulses(ratePerSecond: 12);
    final frameCount = (samples.length - 400) ~/ 160 + 1;
    final energy = SpeechFrames(
      List.filled(frameCount, -20),
      List.filled(frameCount, true),
      -60,
    );
    final contour = List<double?>.filled(samples.length ~/ 320, 0);
    final peaks = detectSyllablePeaks(samples, energy, contour, config);
    expect(peaks, isNotEmpty);
    expect(peaks.length, lessThan(144));
    for (var i = 1; i < peaks.length; i++) {
      expect(peaks[i] - peaks[i - 1], greaterThanOrEqualTo(100));
    }
    expect(
      detectSyllablePeaks(
        samples,
        energy,
        List.filled(contour.length, null),
        config,
      ),
      isEmpty,
    );
  });

  test('pitch movement does not treat a pause as a large pitch jump', () {
    final samples = Float32List(16000);
    final energy = SpeechFrames(
      List.filled(100, -20),
      List.filled(100, true),
      -60,
    );
    final contour = <double?>[
      ...List.filled(20, 0.0),
      ...List.filled(10, null),
      ...List.filled(20, 10.0),
    ];
    final metrics = measureDelivery(
      WavAudio(samples, 16000),
      energy,
      contour,
      150,
      0.8,
      config,
    );
    expect(metrics.pitchRangeSt, 10);
    expect(metrics.pitchStdSt, 5);
    expect(metrics.pitchMovementStPerS, 0);
  });

  test('pace windows use total window time and exclude windows with too little speech', () {
    final speech = List<bool>.filled(1200, false);
    for (var i = 0; i < 1100; i++) {
      speech[i] = true;
    }
    final peaks = [
      for (var t = 0; t < 5000; t += 500) t,
      for (var t = 5000; t < 10000; t += 250) t,
      10000,
      10500,
    ];
    final windows = buildPaceWindows(
      12000,
      speech,
      peaks,
      config,
      hasVoicedSpeech: true,
    );
    expect(windows.map((w) => w.syllablesPerSecond), [2, 4, null]);
    expect(windows.map((w) => w.speechMs), [5000, 5000, 1000]);
    expect(windows.last.syllables, 2);
  });

  test(
    'quality thresholds accept exact boundaries and report every failing gate',
    () {
      expect(
        qualityWarnings(
          speechMs: 10000,
          snrDb: 15,
          clippingPct: 1,
          loudestSpeechDb: -35,
          config: config,
        ),
        isEmpty,
      );
      expect(
        qualityWarnings(
          speechMs: 9999,
          snrDb: 14.9,
          clippingPct: 1.001,
          loudestSpeechDb: -35.01,
          config: config,
        ),
        QualityWarning.values,
      );
    },
  );

  test(
    'white noise and silence fail quality checks without fabricated pace',
    () {
      final rng = math.Random(91);
      for (final samples in [
        Float32List(16000 * 12),
        Float32List.fromList(
          List.generate(16000 * 12, (_) => rng.nextDouble() - 0.5),
        ),
      ]) {
        final result = analyzePitch(WavAudio(samples, 16000), config);
        final metrics = result.analysis!;
        expect(result.hasPitch, isFalse);
        expect(metrics.passesQualityGates, isFalse);
        expect(
          metrics.qualityWarnings,
          contains(QualityWarning.insufficientSpeech),
        );
        expect(
          metrics.qualityWarnings,
          contains(QualityWarning.noisyRecording),
        );
        expect(metrics.syllableCount, isNull);
        expect(metrics.speakingRate, isNull);
        expect(metrics.articulationRate, isNull);
        expect(metrics.pitchRangeSt, isNull);
        expect(metrics.paceCV, isNull);
        expect(metrics.pauses, isEmpty);
      }
    },
  );

  test(
    'quiet voiced audio and actual PCM clipping raise their own warnings',
    () {
      final quiet = speechTone(durationSeconds: 14, silenceSeconds: 1);
      for (var i = 0; i < quiet.length; i++) {
        quiet[i] *= 0.001;
      }
      expect(
        analyzePitch(WavAudio(quiet, 16000), config).analysis!.qualityWarnings,
        contains(QualityWarning.quietAudio),
      );
      final clipped = speechTone(durationSeconds: 14);
      for (var i = 0; i < clipped.length; i++) {
        clipped[i] = (clipped[i] * 3).clamp(-1, 1);
      }
      final metrics = analyzePitch(WavAudio(clipped, 16000), config).analysis!;
      expect(metrics.clippingPct, greaterThan(1));
      expect(metrics.qualityWarnings, contains(QualityWarning.clippedAudio));
    },
  );

  test(
    'new configuration rejects missing and inconsistent analysis thresholds',
    () {
      final missing = {...config.values}..remove('syllableBandLowHz');
      expect(() => AudioConfig.fromJson(missing), throwsFormatException);
      for (final edit in [
        {'syllableBandHighHz': 8000},
        {'pauseShortUpperMs': 200},
        {'paceMinimumSpeechMs': 6000},
        {'clippingSampleThreshold': 1.1},
        {'qualityQuietFrameDb': 35},
        {'loudnessHighPercentile': 101},
      ]) {
        expect(
          () => AudioConfig.fromJson({...config.values, ...edit}),
          throwsFormatException,
        );
      }
    },
  );
}
