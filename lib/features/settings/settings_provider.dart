import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import 'settings_model.dart';
import 'settings_repository.dart';

export 'settings_model.dart';

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<AppSettings> {
  Future<void> _pending = Future.value();
  int _revision = 0;

  Future<void> get pendingSave => _pending;

  @override
  AppSettings build() => const AppSettings();

  Future<void> load() async {
    state = await ref.read(settingsRepositoryProvider).load();
  }

  Future<void> setTheme(AppTheme theme) =>
      _save(AppSettings(theme: theme, mode: state.mode, locale: state.locale));

  Future<void> setMode(ThemeMode mode) =>
      _save(AppSettings(theme: state.theme, mode: mode, locale: state.locale));

  Future<void> setLocale(Locale? locale) =>
      _save(AppSettings(theme: state.theme, mode: state.mode, locale: locale));

  Future<void> retrySave() => _save(state.withSaveFailure(false));

  Future<void> _save(AppSettings next) {
    state = next;
    final revision = ++_revision;
    final repository = ref.read(settingsRepositoryProvider);
    // Serialize snapshots so rapid taps cannot leave an older choice on disk.
    _pending = _pending.then((_) async {
      try {
        await repository.save(next);
      } catch (_) {
        if (ref.mounted && revision == _revision) {
          state = state.withSaveFailure(true);
        }
      }
    });
    return _pending;
  }
}
