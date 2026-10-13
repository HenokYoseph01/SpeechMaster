import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:speech_coach/audio/audio_config.dart';

AudioConfig loadAudioConfig() => AudioConfig.fromJson(
  jsonDecode(File('assets/audio_config.json').readAsStringSync())
      as Map<String, dynamic>,
);

Float32List sine(
  double hz, {
  int sampleRate = 8000,
  int samples = 320,
  double amplitude = 0.5,
  double phase = 0,
}) => Float32List.fromList([
  for (var i = 0; i < samples; i++)
    amplitude * math.sin(2 * math.pi * hz * i / sampleRate + phase),
]);

Float32List speechTone({
  double durationSeconds = 4,
  double silenceSeconds = 0.5,
  double startHz = 120,
  double endHz = 120,
}) {
  const rate = 16000;
  final output = Float32List((durationSeconds * rate).round());
  final voicedSeconds = durationSeconds - 2 * silenceSeconds;
  var phase = 0.0;
  for (var i = 0; i < output.length; i++) {
    final time = i / rate;
    if (time < silenceSeconds || time >= durationSeconds - silenceSeconds) {
      continue;
    }
    final hz =
        startHz + (endHz - startHz) * (time - silenceSeconds) / voicedSeconds;
    phase += 2 * math.pi * hz / rate;
    output[i] = 0.5 * math.sin(phase);
  }
  return output;
}

Float32List syllablePulses({
  double durationSeconds = 14,
  double ratePerSecond = 4,
}) {
  const rate = 16000;
  final output = Float32List((durationSeconds * rate).round());
  final period = 1 / ratePerSecond;
  final width = math.min(0.15, period * 0.7);
  for (var i = rate; i < output.length - rate; i++) {
    final time = (i - rate) / rate;
    final local = time % period;
    if (local >= width) continue;
    final envelope = (1 - math.cos(2 * math.pi * local / width)) / 2;
    final phase = 2 * math.pi * 160 * i / rate;
    output[i] =
        envelope *
        (0.3 * math.sin(phase) +
            0.2 * math.sin(2 * phase) +
            0.1 * math.sin(4 * phase));
  }
  return output;
}

Uint8List makeWav(
  Float32List samples, {
  int sampleRate = 16000,
  bool junkChunk = false,
}) {
  final headerSize = junkChunk ? 54 : 44;
  final bytes = Uint8List(headerSize + samples.length * 2);
  final data = ByteData.sublistView(bytes);
  void tag(int offset, String value) =>
      bytes.setRange(offset, offset + 4, value.codeUnits);
  tag(0, 'RIFF');
  data.setUint32(4, bytes.length - 8, Endian.little);
  tag(8, 'WAVE');
  tag(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  if (junkChunk) {
    tag(36, 'JUNK');
    data.setUint32(40, 1, Endian.little);
    bytes[44] = 42;
  }
  tag(headerSize - 8, 'data');
  data.setUint32(headerSize - 4, samples.length * 2, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    data.setInt16(
      headerSize + i * 2,
      (samples[i] * 32768).round().clamp(-32768, 32767),
      Endian.little,
    );
  }
  return bytes;
}
