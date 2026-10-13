import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/record/record_screen.dart';
import 'l10n/generated/app_localizations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/record',
        builder: (context, state) => const RecordScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      final strings = AppLocalizations.of(context);
      return Scaffold(
        appBar: AppBar(title: Text(strings.pageNotFound)),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: Text(strings.home),
          ),
        ),
      );
    },
  );
  ref.onDispose(router.dispose);
  return router;
});
