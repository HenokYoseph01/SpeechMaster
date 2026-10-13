import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/settings/settings_provider.dart';
import 'package:speech_coach/features/settings/settings_repository.dart';

void main() {
  test(
    'appearance and language survive database and controller recreation',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'speech_coach_settings_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/practice.sqlite');
      var database = AppDatabase(NativeDatabase(file));
      var repository = SettingsRepository(database);
      var container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
      );
      final controller = container.read(settingsProvider.notifier);
      await controller.load();
      // Rapid changes are saved in order, with every earlier choice retained.
      final saves = [
        controller.setTheme(AppTheme.ember),
        controller.setMode(ThemeMode.dark),
        controller.setLocale(const Locale('am')),
        controller.setTheme(AppTheme.dusk),
      ];
      await Future.wait(saves);
      container.dispose();
      await database.close();
      database = AppDatabase(NativeDatabase(file));
      repository = SettingsRepository(database);
      container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
      );
      try {
        await container.read(settingsProvider.notifier).load();
        final restored = container.read(settingsProvider);
        expect(restored.theme, AppTheme.dusk);
        expect(restored.mode, ThemeMode.dark);
        expect(restored.locale, const Locale('am'));
        expect(restored.saveFailed, isFalse);
        await container.read(settingsProvider.notifier).setLocale(null);
        expect((await repository.load()).locale, isNull);
      } finally {
        container.dispose();
        await database.close();
      }
    },
  );

  test(
    'invalid preferences safely fall back without deleting other settings',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.writeSetting('theme', 'unknown');
      await database.writeSetting('dark_mode', 'unknown');
      await database.writeSetting('language', 'unknown');
      await database.writeSetting('goal', 'prepare_a_talk');
      final settings = await SettingsRepository(database).load();
      expect(settings.theme, AppTheme.honey);
      expect(settings.mode, ThemeMode.system);
      expect(settings.locale, isNull);
      await SettingsRepository(database).save(settings);
      final rows = await database.allSettings().get();
      expect(
        rows.singleWhere((row) => row.key == 'goal').value,
        'prepare_a_talk',
      );
    },
  );

  test(
    'failed save is reported and retry persists the latest choices',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = FailingSaveRepository(database);
      final container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final controller = container.read(settingsProvider.notifier);
      await controller.setTheme(AppTheme.meadow);
      expect(container.read(settingsProvider).saveFailed, isTrue);
      repository.fail = false;
      await controller.retrySave();
      expect(container.read(settingsProvider).saveFailed, isFalse);
      expect((await repository.load()).theme, AppTheme.meadow);
    },
  );
}

class FailingSaveRepository extends SettingsRepository {
  FailingSaveRepository(super.database);
  bool fail = true;

  @override
  Future<void> save(AppSettings settings) async {
    if (fail) throw StateError('test storage unavailable');
    await super.save(settings);
  }
}
