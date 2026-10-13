import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/pitch_result.dart';
import 'package:speech_coach/features/record/pitch_chart.dart';

void main() {
  test(
    'an isolated voiced bucket remains visible without bridging gaps',
    () async {
      final recorder = PictureRecorder();
      final result = PitchResult(
        durationMs: 1000,
        points: const [
          PitchPoint(0, null, -20),
          PitchPoint(400, null, -20),
          PitchPoint(500, 1, -20),
          PitchPoint(600, null, -20),
        ],
        medianHz: 150,
        voicedRatio: 0.15,
        speechMs: 1000,
        analysisMs: 1,
        noiseFloorDb: -60,
      );
      const green = Color(0xff00ff00);
      PitchContourPainter(
        result: result,
        minimumSpan: 4,
        line: green,
        baseline: const Color(0xff0000ff),
      ).paint(Canvas(recorder), const Size(200, 150));
      final picture = recorder.endRecording();
      final image = await picture.toImage(200, 150);
      final bytes = (await image.toByteData(format: ImageByteFormat.rawRgba))!;
      expect(bytes.getUint8((45 * 200 + 100) * 4 + 1), 255);
      expect(bytes.getUint8((45 * 200 + 50) * 4 + 3), 0);
      image.dispose();
      picture.dispose();
    },
  );
}
