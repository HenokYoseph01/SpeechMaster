import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/dsp/wav.dart';

import '../support/audio_fixtures.dart';

void main() {
  test('decodes PCM16 with odd-sized padded metadata chunks', () {
    final samples = Float32List.fromList([-1, -0.5, 0, 0.5, 0.9999]);
    final audio = decodeWav(
      makeWav(samples, junkChunk: true),
      expectedSampleRate: 16000,
    );
    expect(audio.sampleRate, 16000);
    expect(audio.samples.length, samples.length);
    for (var i = 0; i < samples.length; i++) {
      expect(audio.samples[i], closeTo(samples[i], 1 / 32768));
    }
  });
  test('rejects truncated files and unsupported format or sample rate', () {
    final bytes = makeWav(speechTone());
    expect(
      () => decodeWav(
        bytes.sublist(0, bytes.length - 1),
        expectedSampleRate: 16000,
      ),
      throwsFormatException,
    );
    expect(
      () => decodeWav(bytes, expectedSampleRate: 8000),
      throwsFormatException,
    );
    ByteData.sublistView(bytes).setUint16(22, 2, Endian.little);
    expect(
      () => decodeWav(bytes, expectedSampleRate: 16000),
      throwsFormatException,
    );
    expect(
      () => decodeWav(Uint8List(4), expectedSampleRate: 16000),
      throwsFormatException,
    );
  });
}
