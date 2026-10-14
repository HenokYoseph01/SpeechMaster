import 'dart:convert';
import 'dart:io';

import '../../audio/transcript.dart';

class TranscriptRepository {
  File _file(String audioPath) => File('$audioPath.transcript.json');

  Future<TranscriptResult?> load(String audioPath) async {
    final file = _file(audioPath);
    if (!await file.exists()) return null;
    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final source = await File(audioPath).stat();
      if (source.type != FileSystemEntityType.file) return null;
      if (json['audioBytes'] != source.size ||
          json['audioModifiedMs'] != source.modified.millisecondsSinceEpoch) {
        return null;
      }
      return TranscriptResult.fromJson(
        json['transcript'] as Map<String, dynamic>,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  Future<void> save(String audioPath, TranscriptResult transcript) async {
    final source = await File(audioPath).stat();
    if (source.type != FileSystemEntityType.file) {
      throw StateError('Recorded audio is unavailable');
    }
    final file = _file(audioPath);
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(
      jsonEncode({
        'audioBytes': source.size,
        'audioModifiedMs': source.modified.millisecondsSinceEpoch,
        'transcript': transcript.toJson(),
      }),
      flush: true,
    );
    await temporary.rename(file.path);
  }
}
