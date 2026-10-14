import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/offline_transcription.dart';
import '../../audio/transcript.dart';
import 'transcript_repository.dart';

enum TranscriptionPhase { ready, transcribing, saving, done, failed }

class TranscriptionState {
  const TranscriptionState({
    this.phase = TranscriptionPhase.ready,
    this.progress = 0,
    this.result,
    this.saveFailed = false,
  });
  final TranscriptionPhase phase;
  final double progress;
  final TranscriptResult? result;
  final bool saveFailed;
  bool get busy =>
      phase == TranscriptionPhase.transcribing ||
      phase == TranscriptionPhase.saving;
}

final transcriptRepositoryProvider = Provider<TranscriptRepository>(
  (ref) => TranscriptRepository(),
);
final transcriberProvider = Provider<Stream<TranscriptEvent> Function(String)>(
  (ref) => transcribeRecording,
);
final transcriptionControllerProvider = Provider.autoDispose
    .family<TranscriptionController, String>((ref, path) {
      final controller = TranscriptionController(
        path,
        ref.watch(transcriberProvider),
        ref.watch(transcriptRepositoryProvider),
      );
      ref.onDispose(() => unawaited(controller.dispose()));
      unawaited(controller.loadCached());
      return controller;
    });
final transcriptionStateProvider = StreamProvider.autoDispose
    .family<TranscriptionState, String>(
      (ref, path) => ref.watch(transcriptionControllerProvider(path)).states,
    );

class TranscriptionController {
  TranscriptionController(this.path, this._transcribe, this._repository);
  final String path;
  final Stream<TranscriptEvent> Function(String) _transcribe;
  final TranscriptRepository _repository;
  final _changes = StreamController<TranscriptionState>.broadcast();
  TranscriptionState state = const TranscriptionState();
  StreamSubscription<TranscriptEvent>? _subscription;
  Completer<TranscriptResult>? _completion;
  bool _disposed = false;
  int _revision = 0;
  Stream<TranscriptionState> get states async* {
    yield state;
    yield* _changes.stream;
  }

  void _set(TranscriptionState next) {
    if (_disposed) return;
    state = next;
    _changes.add(next);
  }

  Future<void> loadCached() async {
    final revision = _revision;
    final TranscriptResult? result;
    try {
      result = await _repository.load(path);
    } catch (_) {
      return;
    }
    if (!_disposed && revision == _revision && result != null) {
      _set(TranscriptionState(phase: TranscriptionPhase.done, result: result));
    }
  }

  Future<void> start() async {
    if (_disposed || state.busy) return;
    _revision++;
    final previous = state.result;
    _set(
      TranscriptionState(
        phase: TranscriptionPhase.transcribing,
        result: previous,
      ),
    );
    final completion = _completion = Completer<TranscriptResult>();
    try {
      _subscription = _transcribe(path).listen(
        (event) {
          if (_disposed) return;
          if (event is TranscriptProgress) {
            _set(
              TranscriptionState(
                phase: TranscriptionPhase.transcribing,
                progress: event.value.clamp(state.progress, 1),
                result: previous,
              ),
            );
          } else if (event is TranscriptComplete && !completion.isCompleted) {
            completion.complete(event.result);
          }
        },
        onError: (Object error, StackTrace stack) {
          if (!completion.isCompleted) completion.completeError(error, stack);
        },
        onDone: () {
          if (!completion.isCompleted) {
            completion.completeError(StateError('No transcript returned'));
          }
        },
      );
      final result = await completion.future;
      if (_disposed) return;
      _set(
        TranscriptionState(
          phase: TranscriptionPhase.saving,
          result: result,
          progress: 1,
        ),
      );
      try {
        await _repository.save(path, result);
      } catch (_) {
        _set(
          TranscriptionState(
            phase: TranscriptionPhase.done,
            result: result,
            progress: 1,
            saveFailed: true,
          ),
        );
        return;
      }
      _set(
        TranscriptionState(
          phase: TranscriptionPhase.done,
          result: result,
          progress: 1,
        ),
      );
    } catch (_) {
      _set(
        TranscriptionState(phase: TranscriptionPhase.failed, result: previous),
      );
    } finally {
      await _subscription?.cancel();
      _subscription = null;
      _completion = null;
    }
  }

  Future<void> retrySave() async {
    if (_disposed || state.busy || state.result == null) return;
    final result = state.result!;
    _set(
      TranscriptionState(
        phase: TranscriptionPhase.saving,
        result: result,
        progress: 1,
      ),
    );
    try {
      await _repository.save(path, result);
      _set(
        TranscriptionState(
          phase: TranscriptionPhase.done,
          result: result,
          progress: 1,
        ),
      );
    } catch (_) {
      _set(
        TranscriptionState(
          phase: TranscriptionPhase.done,
          result: result,
          progress: 1,
          saveFailed: true,
        ),
      );
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _revision++;
    if (_completion != null && !_completion!.isCompleted) {
      _completion!.completeError(StateError('Transcription disposed'));
    }
    await _subscription?.cancel();
    await _changes.close();
  }
}
