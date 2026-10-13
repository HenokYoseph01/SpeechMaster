import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:speech_coach/core/db/app_database.dart';

void main() {
  group('in-memory schema', () {
    late AppDatabase database;
    setUp(() => database = AppDatabase(NativeDatabase.memory()));
    tearDown(() => database.close());

    test(
      'creates version 1 tables and tip index with foreign keys enabled',
      () async {
        final version = await database
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), 1);
        final foreignKeys = await database
            .customSelect('PRAGMA foreign_keys')
            .getSingle();
        expect(foreignKeys.read<int>('foreign_keys'), 1);
        final tables = await database
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
            )
            .get();
        expect(
          tables.map((row) => row.read<String>('name')),
          unorderedEquals([
            'recordings',
            'analysis_results',
            'tip_log',
            'drill_sessions',
            'daily_activity',
            'settings',
            'entitlements',
            'ai_feedback',
          ]),
        );
        final index = await database
            .customSelect("PRAGMA index_xinfo('idx_tip_log_rule')")
            .get();
        final columns = index
            .where((row) => row.read<int>('key') == 1)
            .toList();
        expect(columns.map((row) => row.read<String>('name')), [
          'rule_id',
          'shown_at',
        ]);
        expect(columns.map((row) => row.read<int>('desc')), [0, 1]);
      },
    );

    test('created schema matches the SQL in the human-owned spec', () async {
      final spec = File('docs/SPEC.md').readAsStringSync();
      final sql = spec
          .split('## Data model')[1]
          .split('```sql')[1]
          .split('```')[0];
      final reference = sqlite3.openInMemory();
      addTearDown(reference.close);
      reference.execute(sql);
      // Compare SQLite's interpretation rather than maintaining a second schema.
      for (final table in database.allTables) {
        final name = table.actualTableName;
        for (final pragma in ['table_info', 'foreign_key_list']) {
          final actual = await database
              .customSelect('PRAGMA $pragma($name)')
              .get();
          final expected = reference.select('PRAGMA $pragma($name)');
          expect(
            actual.map((row) => row.data).toList(),
            expected.toList(),
            reason: '$name $pragma',
          );
        }
      }
    });

    test('recording deletion cascades results, tips and feedback but preserves drill', () async {
      await database.customStatement('''
      INSERT INTO recordings (id, created_at, duration_ms, target_ms, audio_path,
        kind, language, analysis_version)
      VALUES ('clip', 1, 30000, 30000, 'clip.wav', 'free', 'en', 1)
    ''');
      await database.customStatement(
        "INSERT INTO analysis_results (recording_id) VALUES ('clip')",
      );
      await database.customStatement(
        "INSERT INTO tip_log (recording_id, rule_id, variant_id, kind, shown_at) VALUES ('clip', 'praise_first', 'one', 'praise', 1)",
      );
      await database.customStatement(
        "INSERT INTO ai_feedback (recording_id, created_at, body_json) VALUES ('clip', 1, '{}')",
      );
      await database.customStatement(
        "INSERT INTO drill_sessions (id, drill_id, started_at, recording_id) VALUES ('drill', 'pause_power', 1, 'clip')",
      );
      await (database.delete(
        database.recordings,
      )..where((row) => row.id.equals('clip'))).go();
      expect(await database.select(database.analysisResults).get(), isEmpty);
      expect(await database.select(database.tipLog).get(), isEmpty);
      expect(await database.select(database.aiFeedback).get(), isEmpty);
      final drill = await database.select(database.drillSessions).getSingle();
      expect(drill.recordingId, isNull);
      expect(drill.drillId, 'pause_power');
    });

    test('rejects orphan rows and non-singleton entitlement ids', () async {
      await expectLater(
        database.customStatement(
          "INSERT INTO analysis_results (recording_id) VALUES ('missing')",
        ),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        database.customStatement(
          "INSERT INTO entitlements (id, updated_at) VALUES (2, 1)",
        ),
        throwsA(isA<SqliteException>()),
      );
      await database.customStatement(
        "INSERT INTO entitlements (id, updated_at) VALUES (1, 1)",
      );
      final entitlement = await database
          .select(database.entitlements)
          .getSingle();
      expect(entitlement.tier, 'free');
      expect(await database.select(database.aiFeedback).get(), isEmpty);
    });
  });

  test('on-disk database reopens with data and foreign keys intact', () async {
    final directory = await Directory.systemTemp.createTemp('speech_coach_db_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/practice.sqlite');
    final first = AppDatabase(NativeDatabase.createInBackground(file));
    await first.writeSetting('theme', 'dusk');
    await first.close();
    final reopened = AppDatabase(NativeDatabase.createInBackground(file));
    try {
      expect((await reopened.allSettings().getSingle()).value, 'dusk');
      final foreignKeys = await reopened
          .customSelect('PRAGMA foreign_keys')
          .getSingle();
      expect(foreignKeys.read<int>('foreign_keys'), 1);
    } finally {
      await reopened.close();
    }
  });

  test('refuses future schema versions without erasing data', () async {
    final directory = await Directory.systemTemp.createTemp(
      'speech_coach_future_db_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/practice.sqlite');
    final future = sqlite3.open(file.path);
    future.execute('CREATE TABLE keep_me (value TEXT)');
    future.execute("INSERT INTO keep_me VALUES ('saved')");
    future.execute('PRAGMA user_version = 2');
    future.close();
    final oldApp = AppDatabase(NativeDatabase(file));
    try {
      await expectLater(oldApp.allSettings().get(), throwsUnsupportedError);
    } finally {
      await oldApp.close();
    }
    final unchanged = sqlite3.open(file.path);
    try {
      expect(
        unchanged.select('SELECT value FROM keep_me').single['value'],
        'saved',
      );
      expect(unchanged.select('PRAGMA user_version').single['user_version'], 2);
    } finally {
      unchanged.close();
    }
  });
}
