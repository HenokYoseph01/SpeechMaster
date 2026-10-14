import 'dart:math' as math;
import 'dart:typed_data';

import '../audio_config.dart';
import 'statistics.dart';

class SpeechFrames {
  const SpeechFrames(this.db, this.speech, this.noiseFloorDb);
  final List<double> db;
  final List<bool> speech;
  final double? noiseFloorDb;
  SpeechFrames withSegments(List<(int, int)> segments, AudioConfig config) {
    final mask = List<bool>.filled(db.length, false);
    for (final (start, end) in segments) {
      for (
        var i = math.max(0, start ~/ config.energyHopMs);
        i < mask.length && i * config.energyHopMs < end;
        i++
      ) {
        mask[i] = true;
      }
    }
    final quiet = <double>[
      for (var i = 0; i < db.length; i++)
        if (!mask[i]) db[i],
    ];
    final floor =
        quiet.length * config.energyHopMs >= config.neuralNoiseMinimumMs
        ? percentile(quiet, config.noiseFloorPercentile)
        : null;
    return SpeechFrames(db, List.unmodifiable(mask), floor);
  }
}

SpeechFrames detectSpeech(Float32List samples, AudioConfig config) {
  final frame = config.captureSampleRate * config.energyFrameMs ~/ 1000;
  final hop = config.captureSampleRate * config.energyHopMs ~/ 1000;
  final energy = <double>[];
  for (var offset = 0; offset + frame <= samples.length; offset += hop) {
    var sum = 0.0;
    for (var i = offset; i < offset + frame; i++) {
      sum += samples[i] * samples[i];
    }
    energy.add(
      20 * math.log(math.sqrt(sum / frame) + config.rmsEpsilon) / math.ln10,
    );
  }
  if (energy.isEmpty) return const SpeechFrames([], [], null);
  final db = medianSmooth(energy, config.energyMedianFrames);
  final floor = percentile(db, config.noiseFloorPercentile);
  final speech = [
    for (final value in db) value > floor + config.speechMarginDb,
  ];
  for (var start = 0; start < speech.length;) {
    var end = start + 1;
    while (end < speech.length && speech[end] == speech[start]) {
      end++;
    }
    if (!speech[start] &&
        start > 0 &&
        end < speech.length &&
        (end - start) * config.energyHopMs < config.fillSpeechGapMs) {
      for (var i = start; i < end; i++) {
        speech[i] = true;
      }
    }
    start = end;
  }
  for (var start = 0; start < speech.length;) {
    var end = start + 1;
    while (end < speech.length && speech[end] == speech[start]) {
      end++;
    }
    if (speech[start] &&
        (end - start) * config.energyHopMs < config.minimumSpeechRunMs) {
      for (var i = start; i < end; i++) {
        speech[i] = false;
      }
    }
    start = end;
  }
  return SpeechFrames(db, speech, floor);
}
