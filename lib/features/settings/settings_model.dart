import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppSettings {
  const AppSettings({
    this.theme = AppTheme.honey,
    this.mode = ThemeMode.system,
    this.locale,
    this.saveFailed = false,
  });

  final AppTheme theme;
  final ThemeMode mode;
  final Locale? locale;
  final bool saveFailed;

  AppSettings withSaveFailure(bool failed) =>
      AppSettings(theme: theme, mode: mode, locale: locale, saveFailed: failed);
}
