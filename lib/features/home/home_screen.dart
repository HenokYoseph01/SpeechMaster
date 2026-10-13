import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wb_sunny_rounded, size: 72, color: colors.primary),
                  const SizedBox(height: 24),
                  Text(
                    strings.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.welcomeBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colors.textMuted),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => context.push('/record'),
                    icon: const Icon(Icons.mic_rounded),
                    label: Text(strings.record),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.tune_rounded),
                    label: Text(strings.settings),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
