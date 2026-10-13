import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/settings_provider.dart';
import '../main.dart';
import 'l10n/generated/app_localizations.dart';
import 'db/database_provider.dart';
import 'theme/app_theme.dart';

final bootstrapProvider = FutureProvider<void>(
  (ref) => ref.read(settingsProvider.notifier).load(),
);

final retryBootstrapProvider = Provider<VoidCallback>(
  (ref) => () {
    // A failed executor may cache its opening error. Retry with a fresh connection.
    ref.invalidate(databaseProvider);
    ref.invalidate(bootstrapProvider);
  },
);

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);
    if (bootstrap.hasValue) return const MainApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildTheme(AppTheme.honey, Brightness.light),
      darkTheme: buildTheme(AppTheme.honey, Brightness.dark),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final strings = AppLocalizations.of(context);
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        bootstrap.hasError
                            ? strings.storageOpenFailed
                            : strings.startingApp,
                        textAlign: TextAlign.center,
                      ),
                      if (bootstrap.hasError) ...[
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: ref.read(retryBootstrapProvider),
                          child: Text(strings.retry),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
