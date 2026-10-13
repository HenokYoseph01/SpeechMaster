import 'dart:typed_data';

class WavAudio {
  const WavAudio(this.samples, this.sampleRate);
  final Float32List samples;
  final int sampleRate;
  int get durationMs => (samples.length * 1000 / sampleRate).round();
}

WavAudio decodeWav(Uint8List bytes, {required int expectedSampleRate}) {
  final data = ByteData.sublistView(bytes);
  String tag(int offset) =>
      String.fromCharCodes(bytes.sublist(offset, offset + 4));
  if (bytes.length < 12 || tag(0) != 'RIFF' || tag(8) != 'WAVE') {
    throw const FormatException('Not a RIFF WAV file');
  }
  final end = data.getUint32(4, Endian.little) + 8;
  if (end > bytes.length || end < 12) {
    throw const FormatException('Truncated WAV');
  }
  int? sampleRate;
  int? dataOffset;
  int? dataLength;
  for (var offset = 12; offset + 8 <= end;) {
    final size = data.getUint32(offset + 4, Endian.little);
    final start = offset + 8;
    if (start + size > end) throw const FormatException('Truncated WAV chunk');
    if (tag(offset) == 'fmt ') {
      if (size < 16 ||
          data.getUint16(start, Endian.little) != 1 ||
          data.getUint16(start + 2, Endian.little) != 1 ||
          data.getUint16(start + 12, Endian.little) != 2 ||
          data.getUint16(start + 14, Endian.little) != 16) {
        throw const FormatException('Expected mono PCM16 WAV');
      }
      sampleRate = data.getUint32(start + 4, Endian.little);
      if (sampleRate != expectedSampleRate ||
          data.getUint32(start + 8, Endian.little) != sampleRate * 2) {
        throw const FormatException('Unexpected WAV sample rate');
      }
    } else if (tag(offset) == 'data') {
      dataOffset = start;
      dataLength = size;
    }
    offset = start + size + size % 2;
  }
  if (sampleRate == null ||
      dataOffset == null ||
      dataLength == null ||
      dataLength.isOdd) {
    throw const FormatException('Missing or invalid WAV audio');
  }
  final samples = Float32List(dataLength ~/ 2);
  for (var i = 0; i < samples.length; i++) {
    samples[i] = data.getInt16(dataOffset + i * 2, Endian.little) / 32768;
  }
  return WavAudio(samples, sampleRate);
}
