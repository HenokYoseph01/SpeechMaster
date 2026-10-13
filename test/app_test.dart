import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:speech_coach/core/bootstrap.dart';
import 'package:speech_coach/core/db/app_database.dart';
import 'package:speech_coach/core/db/database_provider.dart';
import 'package:speech_coach/features/settings/settings_provider.dart';
import 'package:speech_coach/features/settings/settings_repository.dart';

void main() {
  testWidgets('app starts without framework errors', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AppBootstrap(),
      ),
    );
    await tester.runAsync(() => container.read(bootstrapProvider.future));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('database startup failure offers a retry and recovers', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = FailingLoadRepository(database);
    final container = ProviderContainer(
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AppBootstrap(),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text("Your practice space couldn't open. Please try again."),
      findsOneWidget,
    );
    repository.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.runAsync(() => container.read(bootstrapProvider.future));
    await tester.pumpAndSettle();
    expect(find.text('Make room for your voice'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class FailingLoadRepository extends SettingsRepository {
  FailingLoadRepository(super.database);
  bool fail = true;

  @override
  Future<AppSettings> load() async {
    if (fail) throw StateError('test storage unavailable');
    return super.load();
  }
}
