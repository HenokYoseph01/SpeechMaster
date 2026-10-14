import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/audio/transcript.dart';
import 'package:speech_coach/features/record/transcript_repository.dart';
import 'package:speech_coach/features/record/transcription_controller.dart';

const exampleTranscript = TranscriptResult(
  durationMs: 3000,
  elapsedMs: 20,
  words: [TranscriptWord('HELLO', 500), TranscriptWord('WORLD', 1600)],
);

class MemoryTranscriptRepository extends TranscriptRepository {
  TranscriptResult? saved;
  bool failSave = false;
  int writes = 0;
  Future<TranscriptResult?>? pendingLoad;
  @override
  Future<TranscriptResult?> load(String audioPath) async =>
      pendingLoad == null ? saved : pendingLoad!;
  @override
  Future<void> save(String audioPath, TranscriptResult transcript) async {
    writes++;
    if (failSave) throw StateError('disk full');
    saved = transcript;
  }
}

void main() {
  test(
    'transcript survives reopening and never changes the original WAV',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_transcript_cache_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final audio = File('${directory.path}/clip.wav');
      await audio.writeAsBytes([1, 2, 3, 4]);
      await TranscriptRepository().save(audio.path, exampleTranscript);
      final loaded = await TranscriptRepository().load(audio.path);
      expect(loaded!.text, 'HELLO WORLD');
      expect(loaded.words.map((w) => w.startMs), [500, 1600]);
      expect(await audio.readAsBytes(), [1, 2, 3, 4]);
      await audio.writeAsBytes([1, 2, 3, 4, 5]);
      expect(await TranscriptRepository().load(audio.path), isNull);
    },
  );
  test('corrupted or outdated transcript caches are ignored', () async {
    final directory = await Directory.systemTemp.createTemp(
      'speech_coach_transcript_invalid_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final audio = File('${directory.path}/clip.wav');
    await audio.writeAsBytes([1]);
    final cache = File('${audio.path}.transcript.json');
    await cache.writeAsString('{');
    expect(await TranscriptRepository().load(audio.path), isNull);
    await TranscriptRepository().save(audio.path, exampleTranscript);
    final json = jsonDecode(await cache.readAsString()) as Map<String, dynamic>;
    (json['transcript'] as Map)['model'] = 'old-model';
    await cache.writeAsString(jsonEncode(json));
    expect(await TranscriptRepository().load(audio.path), isNull);
  });
  test(
    'saving failures retain the transcript and retry without decoding again',
    () async {
      final repository = MemoryTranscriptRepository()..failSave = true;
      var decodes = 0;
      final controller = TranscriptionController('/local.wav', (_) {
        decodes++;
        return Stream.value(TranscriptComplete(exampleTranscript));
      }, repository);
      addTearDown(controller.dispose);
      expect(decodes, 0);
      await controller.start();
      expect(controller.state.result!.text, 'HELLO WORLD');
      expect(controller.state.saveFailed, isTrue);
      repository.failSave = false;
      await controller.retrySave();
      expect(controller.state.saveFailed, isFalse);
      expect(repository.saved, same(exampleTranscript));
      expect(decodes, 1);
    },
  );
  test(
    'cached transcript load cannot overwrite a newer recognition request',
    () async {
      final pending = Completer<TranscriptResult?>();
      final repository = MemoryTranscriptRepository()
        ..pendingLoad = pending.future;
      final controller = TranscriptionController(
        '/local.wav',
        (_) => Stream.value(TranscriptComplete(exampleTranscript)),
        repository,
      );
      addTearDown(controller.dispose);
      final load = controller.loadCached();
      await controller.start();
      pending.complete(
        const TranscriptResult(
          durationMs: 3000,
          elapsedMs: 1,
          words: [TranscriptWord('OLD', 0)],
        ),
      );
      await load;
      expect(controller.state.result!.text, 'HELLO WORLD');
    },
  );
  test('duplicate requests do not start another worker and disposal finishes pending work', () async {
    final events = StreamController<TranscriptEvent>();
    addTearDown(events.close);
    var decodes = 0;
    final controller = TranscriptionController('/local.wav', (_) {
      decodes++;
      return events.stream;
    }, MemoryTranscriptRepository());
    final running = controller.start();
    await controller.start();
    expect(decodes, 1);
    expect(controller.state.busy, isTrue);
    await controller.dispose();
    await running;
    expect(controller.state.result, isNull);
  });
  test('recognizer errors are retryable while the original recording remains untouched', () async {
    var fails = true;
    final controller = TranscriptionController(
      '/local.wav',
      (_) => fails
          ? Stream.error(StateError('model failed'))
          : Stream.value(TranscriptComplete(exampleTranscript)),
      MemoryTranscriptRepository(),
    );
    addTearDown(controller.dispose);
    await controller.start();
    expect(controller.state.phase, TranscriptionPhase.failed);
    fails = false;
    await controller.start();
    expect(controller.state.phase, TranscriptionPhase.done);
  });
}
