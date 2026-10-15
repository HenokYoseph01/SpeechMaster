import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaptionPreferences {
  Future<bool> load(String path) async {
    try {
      final json = jsonDecode(await File('$path.captions.json').readAsString());
      return json is Map && json['enabled'] is bool
          ? json['enabled'] as bool
          : true;
    } on FileSystemException {
      return true;
    } on FormatException {
      return true;
    }
  }

  Future<void> save(String path, bool enabled) async {
    final target = File('$path.captions.json');
    final temporary = File('${target.path}.tmp');
    await temporary.writeAsString(
      jsonEncode({'enabled': enabled}),
      flush: true,
    );
    await temporary.rename(target.path);
  }
}

class CaptionPreferenceState {
  const CaptionPreferenceState({
    this.enabled = true,
    this.ready = false,
    this.saving = false,
    this.failed = false,
  });
  final bool enabled, ready, saving, failed;
}

final captionPreferencesProvider = Provider((ref) => CaptionPreferences());
final captionPreferenceControllerProvider = Provider.autoDispose
    .family<CaptionPreferenceController, String>((ref, path) {
      final controller = CaptionPreferenceController(
        path,
        ref.watch(captionPreferencesProvider),
      );
      ref.onDispose(controller.dispose);
      unawaited(controller.load());
      return controller;
    });
final captionPreferenceStateProvider = StreamProvider.autoDispose
    .family<CaptionPreferenceState, String>(
      (ref, path) =>
          ref.watch(captionPreferenceControllerProvider(path)).states,
    );

class CaptionPreferenceController {
  CaptionPreferenceController(this.path, this.repository);
  final String path;
  final CaptionPreferences repository;
  final _changes = StreamController<CaptionPreferenceState>.broadcast();
  var state = const CaptionPreferenceState();
  bool _disposed = false;
  Stream<CaptionPreferenceState> get states async* {
    yield state;
    yield* _changes.stream;
  }

  void _set(CaptionPreferenceState value) {
    if (_disposed) return;
    state = value;
    _changes.add(value);
  }

  Future<void> load() async {
    try {
      final enabled = await repository.load(path);
      _set(CaptionPreferenceState(enabled: enabled, ready: true));
    } catch (_) {
      _set(const CaptionPreferenceState(ready: true, failed: true));
    }
  }

  Future<void> setEnabled(bool enabled) async {
    if (_disposed || !state.ready || state.saving) return;
    _set(CaptionPreferenceState(enabled: enabled, ready: true, saving: true));
    try {
      await repository.save(path, enabled);
      _set(CaptionPreferenceState(enabled: enabled, ready: true));
    } catch (_) {
      _set(CaptionPreferenceState(enabled: enabled, ready: true, failed: true));
    }
  }

  void dispose() {
    _disposed = true;
    unawaited(_changes.close());
  }
}
