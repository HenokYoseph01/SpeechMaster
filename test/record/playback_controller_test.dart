import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/features/record/playback_controller.dart';

class FakePlaybackDevice implements PlaybackDevice {
  final positions = StreamController<int>.broadcast(sync: true);
  final active = StreamController<bool>.broadcast(sync: true);
  final loads = <(String, int, int?)>[];
  final seeks = <int>[];
  int plays = 0;
  int pauses = 0;
  bool disposed = false;
  bool failLoad = false;
  Completer<void>? pendingLoad;
  @override
  Stream<int> get positionMs => positions.stream;
  @override
  Stream<bool> get playing => active.stream;
  @override
  Future<void> load(String path, int startMs, int? endMs) async {
    loads.add((path, startMs, endMs));
    if (failLoad) throw StateError('unavailable file');
    await pendingLoad?.future;
  }

  @override
  Future<void> play() async {
    plays++;
    active.add(true);
  }

  @override
  Future<void> pause() async {
    pauses++;
    active.add(false);
  }

  @override
  Future<void> seek(int relativeMs) async {
    seeks.add(relativeMs);
    positions.add(relativeMs);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await positions.close();
    await active.close();
  }
}

void main() {
  late FakePlaybackDevice device;
  late PlaybackController controller;
  setUp(() {
    device = FakePlaybackDevice();
    controller = PlaybackController('/private/clip.wav', () => device);
  });
  tearDown(() => controller.dispose());

  test('loads only on command and plays/pauses the local recording', () async {
    expect(device.loads, isEmpty);
    await controller.toggle(30000);
    expect(device.loads.single, ('/private/clip.wav', 0, null));
    expect(controller.state.playing, isTrue);
    await controller.toggle(30000);
    expect(controller.state.playing, isFalse);
    expect(device.plays, 1);
  });
  test('pause preview is bounded and positions stay on the full recording timeline', () async {
    await controller.previewPause(500, 1500, 30000, 750);
    expect(device.loads.last, ('/private/clip.wav', 0, 2250));
    await controller.previewPause(29000, 29500, 30000, 750);
    expect(device.loads.last, ('/private/clip.wav', 28250, 30000));
    device.positions.add(1000);
    expect(controller.state.positionMs, 29250);
    device.active.add(false);
    await controller.toggle(30000);
    expect(device.loads.last, ('/private/clip.wav', 0, null));
    expect(device.seeks.last, 29250);
  });
  test('seeking from a preview restores the whole clip and retains playback intent', () async {
    await controller.previewPause(5000, 6000, 30000, 750);
    await controller.seek(12000);
    expect(device.loads.last, ('/private/clip.wav', 0, null));
    expect(device.seeks.last, 12000);
    expect(controller.state.positionMs, 12000);
    expect(controller.state.playing, isTrue);
  });
  test('a playback failure is visible and the next command retries', () async {
    device.failLoad = true;
    await controller.toggle(30000);
    expect(controller.state.failed, isTrue);
    expect(controller.state.loading, isFalse);
    device.failLoad = false;
    await controller.toggle(30000);
    expect(controller.state.failed, isFalse);
    expect(controller.state.playing, isTrue);
  });
  test('backgrounding during loading prevents delayed autoplay', () async {
    device.pendingLoad = Completer<void>();
    final loading = controller.toggle(30000);
    await Future<void>.delayed(Duration.zero);
    await controller.pause();
    device.pendingLoad!.complete();
    await loading;
    expect(device.plays, 0);
    expect(controller.state.playing, isFalse);
  });
  test(
    'disposal while loading prevents playback and releases the device',
    () async {
      device.pendingLoad = Completer<void>();
      final loading = controller.toggle(30000);
      await Future<void>.delayed(Duration.zero);
      await controller.dispose();
      device.pendingLoad!.complete();
      await loading;
      expect(device.plays, 0);
      expect(device.disposed, isTrue);
    },
  );
}
