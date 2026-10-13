import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/core/db/database_provider.dart';
import 'package:speech_coach/core/l10n/generated/app_localizations.dart';
import 'package:speech_coach/core/router.dart';
import 'package:speech_coach/core/theme/app_theme.dart';
import 'package:speech_coach/features/settings/settings_provider.dart';
import 'package:speech_coach/features/settings/settings_repository.dart';
import 'package:speech_coach/main.dart';

void main() {
  testWidgets('settings change theme and language without losing navigation', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MainApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<AppTheme>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dusk').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<ThemeMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(
      Theme.of(context).extension<AppColors>()!.primary,
      AppColors.palette(AppTheme.dusk, Brightness.dark).primary,
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('አማርኛ').last);
    await tester.pumpAndSettle();
    expect(find.text('ቅንብሮች'), findsOneWidget);
    expect(find.text('ገጽታ'), findsOneWidget);
    // pageBack searches for the English tooltip; this screen is now Amharic.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('ለድምፅዎ ቦታ ይስጡ'), findsOneWidget);
    await tester.runAsync(() async {
      await container.read(settingsProvider.notifier).pendingSave;
      final saved = await container.read(settingsRepositoryProvider).load();
      expect(saved.theme, AppTheme.dusk);
      expect(saved.mode, ThemeMode.dark);
      expect(saved.locale, const Locale('am'));
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings deep link works with large Amharic text', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);
    await tester.runAsync(
      () => container
          .read(settingsProvider.notifier)
          .setLocale(const Locale('am')),
    );
    container.read(routerProvider).go('/settings');
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MainApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('ቅንብሮች'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('both localizations load all app shell messages', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final strings = await AppLocalizations.delegate.load(locale);
      expect(strings.appTitle, isNotEmpty);
      expect(strings.welcomeTitle, isNotEmpty);
      expect(strings.settings, isNotEmpty);
    }
  });

  test('all theme text and button color pairs meet minimum contrast', () {
    double contrast(Color a, Color b) {
      final x = a.computeLuminance();
      final y = b.computeLuminance();
      return ((x > y ? x : y) + 0.05) / ((x > y ? y : x) + 0.05);
    }

    for (final theme in AppTheme.values) {
      for (final brightness in Brightness.values) {
        final colors = AppColors.palette(theme, brightness);
        for (final background in [
          colors.background,
          colors.surface,
          colors.surfaceAlt,
        ]) {
          expect(contrast(colors.text, background), greaterThanOrEqualTo(4.5));
          expect(
            contrast(colors.textMuted, background),
            greaterThanOrEqualTo(4.5),
          );
        }
        expect(
          contrast(colors.onPrimary, colors.primary),
          greaterThanOrEqualTo(4.5),
        );
      }
    }
  });
}
