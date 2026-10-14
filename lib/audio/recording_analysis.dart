import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'analysis_isolate.dart';
import 'audio_config.dart';
import 'pitch_result.dart';

Future<String>? _modelPreparation;

Future<String> _prepareModel() async {
  final root = await getApplicationSupportDirectory();
  final directory = Directory('${root.path}/models');
  await directory.create(recursive: true);
  // Versioned filename prevents retaining a stale bundled model after updates.
  final file = File('${directory.path}/silero-vad-9e2449e1.onnx');
  final asset = await rootBundle.load('assets/models/silero_vad.onnx');
  // Install the bundled model once. This makes no network call.
  if (!await file.exists() || await file.length() != asset.lengthInBytes) {
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsBytes(
      asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes),
      flush: true,
    );
    await temporary.rename(file.path);
  }
  return file.path;
}

Stream<PitchEvent> analyzeRecording(String path, AudioConfig config) async* {
  String model;
  try {
    model = await (_modelPreparation ??= _prepareModel());
  } catch (_) {
    _modelPreparation = null;
    rethrow;
  }
  yield* analyzeWavInIsolate(path, config, vadModelPath: model);
}
