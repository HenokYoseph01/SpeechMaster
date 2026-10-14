import 'dart:math' as math;

class TranscriptWord {
  const TranscriptWord(this.text, this.startMs);
  final String text;
  // Token-emission timing grouped into words, not forced-alignment truth.
  final int startMs;
  Map<String, Object> toJson() => {'text': text, 'startMs': startMs};
  factory TranscriptWord.fromJson(Map<String, dynamic> json) {
    final text = json['text'];
    final start = json['startMs'];
    if (text is! String || text.trim().isEmpty || start is! int || start < 0) {
      throw const FormatException('Invalid transcript word');
    }
    return TranscriptWord(text, start);
  }
}

class TranscriptResult {
  const TranscriptResult({
    required this.durationMs,
    required this.words,
    required this.elapsedMs,
  });
  static const modelId = 'zipformer-small-en-int8-e8add537';
  final int durationMs;
  final List<TranscriptWord> words;
  final int elapsedMs;
  String get text => words.map((w) => w.text).join(' ');
  Map<String, Object> toJson() => {
    'version': 1,
    'model': modelId,
    'durationMs': durationMs,
    'elapsedMs': elapsedMs,
    'words': [for (final word in words) word.toJson()],
  };
  factory TranscriptResult.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1 ||
        json['model'] != modelId ||
        json['durationMs'] is! int ||
        (json['durationMs'] as int) < 0 ||
        json['elapsedMs'] is! int ||
        (json['elapsedMs'] as int) < 0 ||
        json['words'] is! List) {
      throw const FormatException('Invalid transcript');
    }
    final duration = json['durationMs'] as int;
    final words = (json['words'] as List)
        .map((w) => TranscriptWord.fromJson(w as Map<String, dynamic>))
        .toList();
    var previous = -1;
    for (final word in words) {
      if (word.startMs < previous || word.startMs >= duration) {
        throw const FormatException('Invalid transcript timing');
      }
      previous = word.startMs;
    }
    return TranscriptResult(
      durationMs: duration,
      words: List.unmodifiable(words),
      elapsedMs: json['elapsedMs'] as int,
    );
  }
}

class TranscriptionConfig {
  TranscriptionConfig.fromJson(Map<String, dynamic> json) {
    for (final key in [
      'version',
      'chunkMs',
      'overlapMs',
      'threads',
      'replayLeadMs',
    ]) {
      if (json[key] is! int || (json[key] as int) <= 0) {
        throw FormatException('Invalid transcription setting: $key');
      }
    }
    version = json['version'] as int;
    chunkMs = json['chunkMs'] as int;
    overlapMs = json['overlapMs'] as int;
    threads = json['threads'] as int;
    replayLeadMs = json['replayLeadMs'] as int;
    final minimum = json['minimumSignalRms'];
    if (minimum is! num ||
        !minimum.isFinite ||
        minimum <= 0 ||
        minimum > 0.01) {
      throw const FormatException('Invalid silent-audio floor');
    }
    minimumSignalRms = minimum.toDouble();
    if (version != 1 ||
        overlapMs * 2 >= chunkMs ||
        chunkMs > 30000 ||
        threads > 4) {
      throw const FormatException('Unsupported transcription settings');
    }
  }
  late final int version, chunkMs, overlapMs, threads, replayLeadMs;
  late final double minimumSignalRms;
  Map<String, num> toJson() => {
    'version': version,
    'chunkMs': chunkMs,
    'overlapMs': overlapMs,
    'threads': threads,
    'replayLeadMs': replayLeadMs,
    'minimumSignalRms': minimumSignalRms,
  };
}

class TranscriptChunk {
  const TranscriptChunk(
    this.startMs,
    this.endMs,
    this.keepStartMs,
    this.keepEndMs,
  );
  final int startMs, endMs, keepStartMs, keepEndMs;
}

List<TranscriptChunk> transcriptChunks(
  int durationMs,
  TranscriptionConfig config,
) {
  final chunks = <TranscriptChunk>[];
  for (
    var start = 0;
    start < durationMs;
    start += config.chunkMs - config.overlapMs
  ) {
    final end = math.min(durationMs, start + config.chunkMs);
    chunks.add(
      TranscriptChunk(
        start,
        end,
        start == 0 ? 0 : start + config.overlapMs ~/ 2,
        end == durationMs ? durationMs : end - config.overlapMs ~/ 2,
      ),
    );
    if (end == durationMs) break;
  }
  return chunks;
}

List<TranscriptWord> wordsFromTokens(
  List<String> tokens,
  List<double> timestamps, {
  required int durationMs,
  int offsetMs = 0,
}) {
  if (tokens.length != timestamps.length) {
    throw const FormatException('Recognizer did not provide token timestamps');
  }
  final words = <TranscriptWord>[];
  var text = '';
  var start = 0;
  var previous = -1;
  void flush() {
    if (text.trim().isNotEmpty) words.add(TranscriptWord(text.trim(), start));
    text = '';
  }

  for (var i = 0; i < tokens.length; i++) {
    final time = timestamps[i];
    if (!time.isFinite || time < 0) {
      throw const FormatException('Invalid token timing');
    }
    final absolute = offsetMs + (time * 1000).round();
    if (absolute < previous) {
      throw const FormatException('Unordered token timing');
    }
    previous = absolute;
    if (absolute >= durationMs) continue;
    final token = tokens[i].replaceAll('▁', ' ');
    if (token.startsWith('<') && token.endsWith('>')) continue;
    // SentencePiece English tokens use ▁ to indicate the next word; the
    // runtime may expose it as a leading space. Subword pieces retain timing.
    final pieces = token.split(RegExp(r'\s+'));
    if (token.startsWith(' ') || pieces.length > 1) flush();
    for (var j = 0; j < pieces.length; j++) {
      if (pieces[j].isEmpty) continue;
      if (j > 0 && text.isNotEmpty) flush();
      if (text.isEmpty) start = absolute;
      text += pieces[j];
    }
  }
  flush();
  return List.unmodifiable(words);
}

sealed class TranscriptEvent {}

class TranscriptProgress extends TranscriptEvent {
  TranscriptProgress(this.value);
  final double value;
}

class TranscriptComplete extends TranscriptEvent {
  TranscriptComplete(this.result);
  final TranscriptResult result;
}
