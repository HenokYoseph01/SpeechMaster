import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final themeLabels = [
      strings.honey,
      strings.ember,
      strings.meadow,
      strings.dusk,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              strings.appearance,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            if (settings.saveFailed) ...[
              Text(strings.settingsSaveFailed),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.retrySave,
                child: Text(strings.retry),
              ),
              const SizedBox(height: 24),
            ],
            DropdownButtonFormField<AppTheme>(
              key: ValueKey(settings.theme),
              initialValue: settings.theme,
              decoration: InputDecoration(labelText: strings.theme),
              isExpanded: true,
              items: [
                for (final theme in AppTheme.values)
                  DropdownMenuItem(
                    value: theme,
                    child: Text(themeLabels[theme.index]),
                  ),
              ],
              onChanged: (value) {
                if (value != null) controller.setTheme(value);
              },
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<ThemeMode>(
              key: ValueKey(settings.mode),
              initialValue: settings.mode,
              decoration: InputDecoration(labelText: strings.displayMode),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(strings.system),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(strings.light),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(strings.dark),
                ),
              ],
              onChanged: (value) {
                if (value != null) controller.setMode(value);
              },
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              key: ValueKey(settings.locale?.languageCode ?? 'system'),
              initialValue: settings.locale?.languageCode ?? 'system',
              decoration: InputDecoration(labelText: strings.language),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 'system', child: Text(strings.system)),
                DropdownMenuItem(value: 'en', child: Text(strings.english)),
                DropdownMenuItem(value: 'am', child: Text(strings.amharic)),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.setLocale(
                    value == 'system' ? null : Locale(value),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
