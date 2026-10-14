import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

abstract interface class PlaybackDevice {
  Stream<int> get positionMs;
  Stream<bool> get playing;
  Future<void> load(String path, int startMs, int? endMs);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(int relativeMs);
  Future<void> dispose();
}

class LocalPlaybackDevice implements PlaybackDevice {
  final _player = AudioPlayer();
  @override
  Stream<int> get positionMs =>
      _player.positionStream.map((p) => p.inMilliseconds);
  @override
  Stream<bool> get playing => _player.playerStateStream.map(
    (s) => s.playing && s.processingState != ProcessingState.completed,
  );
  @override
  Future<void> load(String path, int startMs, int? endMs) async {
    await _player.setAudioSource(
      ClippingAudioSource(
        child: AudioSource.file(path),
        start: Duration(milliseconds: startMs),
        end: endMs == null ? null : Duration(milliseconds: endMs),
      ),
    );
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(int relativeMs) =>
      _player.seek(Duration(milliseconds: relativeMs));
  @override
  Future<void> dispose() => _player.dispose();
}

class PlaybackState {
  const PlaybackState({
    this.positionMs = 0,
    this.playing = false,
    this.loading = false,
    this.failed = false,
  });
  final int positionMs;
  final bool playing, loading, failed;
}

final playbackDeviceFactoryProvider = Provider<PlaybackDevice Function()>(
  (ref) => LocalPlaybackDevice.new,
);
final playbackControllerProvider = Provider.autoDispose
    .family<PlaybackController, String>((ref, path) {
      final controller = PlaybackController(
        path,
        ref.watch(playbackDeviceFactoryProvider),
      );
      ref.onDispose(() => unawaited(controller.dispose()));
      return controller;
    });
final playbackStateProvider = StreamProvider.autoDispose
    .family<PlaybackState, String>((ref, path) {
      return ref.watch(playbackControllerProvider(path)).states;
    });

class PlaybackController {
  PlaybackController(this.path, this._factory);
  final String path;
  final PlaybackDevice Function() _factory;
  final _changes = StreamController<PlaybackState>.broadcast();
  PlaybackState state = const PlaybackState();
  PlaybackDevice? _device;
  StreamSubscription<int>? _positions;
  StreamSubscription<bool>? _playing;
  bool _disposed = false;
  int _startMs = 0;
  bool _loaded = false;
  bool _playAllowed = true;
  Stream<PlaybackState> get states async* {
    yield state;
    yield* _changes.stream;
  }

  void _update({int? positionMs, bool? playing, bool? loading, bool? failed}) {
    if (_disposed) return;
    state = PlaybackState(
      positionMs: positionMs ?? state.positionMs,
      playing: playing ?? state.playing,
      loading: loading ?? state.loading,
      failed: failed ?? state.failed,
    );
    _changes.add(state);
  }

  void _initialize() {
    if (_device != null) return;
    final device = _device = _factory();
    _positions = device.positionMs.listen(
      (ms) => _update(positionMs: _startMs + ms),
      onError: (Object error) => _update(failed: true, playing: false),
    );
    _playing = device.playing.listen(
      (playing) => _update(playing: playing),
      onError: (Object error) => _update(failed: true, playing: false),
    );
  }

  Future<void> _operate(Future<void> Function() operation) async {
    if (_disposed || state.loading) return;
    _update(loading: true, failed: false);
    try {
      _initialize();
      await operation();
    } catch (_) {
      _loaded = false;
      _update(failed: true, playing: false);
    } finally {
      _update(loading: false);
    }
  }

  void _play() {
    if (_disposed || !_playAllowed) return;
    _update(playing: true);
    unawaited(
      _device!.play().catchError((Object error) {
        _loaded = false;
        _update(failed: true, playing: false);
      }),
    );
  }

  Future<void> toggle(int durationMs) => _operate(() async {
    _playAllowed = true;
    if (state.playing) {
      await _device!.pause();
      _update(playing: false);
      return;
    }
    // Resume the whole clip at the displayed absolute position, including
    // after a bounded pause preview reaches its end.
    final position = state.positionMs >= durationMs ? 0 : state.positionMs;
    _startMs = 0;
    await _device!.load(path, 0, null);
    _loaded = true;
    if (_disposed) return;
    await _device!.seek(position);
    _play();
  });

  Future<void> seek(int absoluteMs) => _operate(() async {
    final resume = state.playing;
    await _device!.pause();
    _startMs = 0;
    await _device!.load(path, 0, null);
    _loaded = true;
    if (_disposed) return;
    await _device!.seek(math.max(0, absoluteMs));
    _update(positionMs: math.max(0, absoluteMs), playing: false);
    if (resume) _play();
  });

  Future<void> playFrom(int absoluteMs, int durationMs) => _operate(() async {
    _playAllowed = true;
    await _device!.pause();
    _startMs = 0;
    await _device!.load(path, 0, null);
    _loaded = true;
    if (_disposed) return;
    final start = absoluteMs.clamp(0, math.max(0, durationMs - 1)).toInt();
    await _device!.seek(start);
    _update(positionMs: start);
    _play();
  });

  Future<void> previewPause(
    int startMs,
    int endMs,
    int durationMs,
    int contextMs,
  ) => _operate(() async {
    _playAllowed = true;
    await _device!.pause();
    _startMs = math.max(0, startMs - contextMs);
    final end = math.min(durationMs, endMs + contextMs);
    await _device!.load(path, _startMs, end);
    _loaded = true;
    if (_disposed) return;
    _update(positionMs: _startMs);
    _play();
  });

  Future<void> pause() async {
    _playAllowed = false;
    if (_disposed || !_loaded) return;
    try {
      await _device?.pause();
      _update(playing: false);
    } catch (_) {
      _update(failed: true, playing: false);
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _positions?.cancel();
    await _playing?.cancel();
    await _device?.dispose();
    await _changes.close();
  }
}
