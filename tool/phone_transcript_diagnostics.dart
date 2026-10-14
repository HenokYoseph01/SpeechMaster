import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_coach/audio/offline_transcription.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/features/record/transcript_repository.dart';
import 'package:speech_coach/main.dart' as app;

// Run with flutter run -t tool/phone_transcript_diagnostics.dart.
// One saved WAV is transcribed locally. No text or audio is logged/exported.
Future<void> main() async {
  app.main();
  final root = await getApplicationSupportDirectory();
  final directory = Directory('${root.path}/recordings');
  if (!await directory.exists()) {
    debugPrint('PHONE_TRANSCRIPT no saved recordings');
    return;
  }
  final files = await directory
      .list()
      .where((f) => f is File && f.path.endsWith('.wav'))
      .cast<File>()
      .toList();
  if (files.isEmpty) {
    debugPrint('PHONE_TRANSCRIPT no saved recordings');
    return;
  }
  files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  try {
    final events = await transcribeRecording(files.first.path).toList();
    final result = events.whereType<TranscriptComplete>().single.result;
    final repository = TranscriptRepository();
    await repository.save(files.first.path, result);
    final reopened = await repository.load(files.first.path);
    debugPrint(
      'PHONE_TRANSCRIPT durationMs=${result.durationMs} words=${result.words.length} '
      'elapsedMs=${result.elapsedMs} timestamps=${result.words.isNotEmpty} '
      'cacheMatches=${reopened?.text == result.text}',
    );
  } catch (error) {
    debugPrint('PHONE_TRANSCRIPT failed: ${error.runtimeType}');
  }
}
