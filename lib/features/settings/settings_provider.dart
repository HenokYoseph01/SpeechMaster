import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';

class AppSettings {
  const AppSettings({
    this.theme = AppTheme.honey,
    this.mode = ThemeMode.system,
    this.locale,
  });

  final AppTheme theme;
  final ThemeMode mode;
  final Locale? locale;
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

// Phase 0 preview state. Persistence is added with the database task.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setTheme(AppTheme theme) =>
      state = AppSettings(theme: theme, mode: state.mode, locale: state.locale);

  void setMode(ThemeMode mode) =>
      state = AppSettings(theme: state.theme, mode: mode, locale: state.locale);

  void setLocale(Locale? locale) =>
      state = AppSettings(theme: state.theme, mode: state.mode, locale: locale);
}
