import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'transcript.dart';
import 'transcription_isolate.dart';

Future<String>? _installation;
Future<String> prepareEnglishRecognizer() async {
  Future<String> install() async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(
      '${root.path}/models/${TranscriptResult.modelId}',
    );
    await directory.create(recursive: true);
    for (final name in [
      'encoder.int8.onnx',
      'decoder.onnx',
      'joiner.int8.onnx',
      'tokens.txt',
    ]) {
      final data = await rootBundle.load(
        'assets/models/english_zipformer/$name',
      );
      final file = File('${directory.path}/$name');
      if (!await file.exists() || await file.length() != data.lengthInBytes) {
        final temporary = File('${file.path}.tmp');
        await temporary.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          flush: true,
        );
        await temporary.rename(file.path);
      }
    }
    return directory.path;
  }

  try {
    return await (_installation ??= install());
  } catch (_) {
    _installation = null;
    rethrow;
  }
}

Future<TranscriptionConfig> loadTranscriptionConfig() async =>
    TranscriptionConfig.fromJson(
      jsonDecode(
        await rootBundle.loadString('assets/transcription_config.json'),
      ) as Map<String, dynamic>,
    );

Stream<TranscriptEvent> transcribeRecording(String path) async* {
  final directory = await prepareEnglishRecognizer();
  final config = await loadTranscriptionConfig();
  yield* transcribeWavInIsolate(path, directory, config);
}
