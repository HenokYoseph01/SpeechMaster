import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import 'settings_model.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

class SettingsRepository {
  SettingsRepository(this.database);

  final AppDatabase database;

  Future<AppSettings> load() async {
    final rows = await database.allSettings().get();
    final values = {for (final row in rows) row.key: row.value};
    return AppSettings(
      theme: AppTheme.values.firstWhere(
        (theme) => theme.name == values['theme'],
        orElse: () => AppTheme.honey,
      ),
      mode: ThemeMode.values.firstWhere(
        (mode) => mode.name == values['dark_mode'],
        orElse: () => ThemeMode.system,
      ),
      locale: switch (values['language']) {
        'en' => const Locale('en'),
        'am' => const Locale('am'),
        _ => null,
      },
    );
  }

  Future<void> save(AppSettings settings) => database.transaction(() async {
    await database.writeSetting('theme', settings.theme.name);
    await database.writeSetting('dark_mode', settings.mode.name);
    await database.writeSetting(
      'language',
      settings.locale?.languageCode ?? 'system',
    );
  });
}
