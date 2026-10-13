# Local database

Schema version 1 is defined in `lib/core/db/schema.drift`. It mirrors the eight
tables and index in the spec. `key` is quoted for Drift's SQL parser; the SQLite
column name is unchanged. Timestamps remain integer epoch milliseconds.

The app stores `speech_coach.sqlite` in its private application support folder.
Drift runs the native connection in a background isolate. Foreign keys are
enabled on every open. Initial creation uses `createAll`; unsupported schema
versions fail without recreating or deleting tables.

Appearance preferences use the existing settings keys: `theme` stores the theme
enum name, `dark_mode` stores `system`/`light`/`dark`, and `language` stores
`system`/`en`/`am`. Saves update all three in a transaction and preserve other
settings. Startup loads these before showing the home screen.

The user approved `sqlite3` 3.x in place of the spec's obsolete
`sqlite3_flutter_libs`. No spec file was edited. Supporting packages
`path_provider`, `drift_dev`, and `build_runner` were also approved.

## Future migrations

Keep `drift_schema_v1.json` as the original snapshot. After approval for a schema
change, increment the database version, implement an explicit migration, and
test upgrading an old database without losing data. Generate and format with:

```sh
dart run build_runner build --delete-conflicting-outputs
dart run drift_dev schema dump lib/core/db/app_database.dart docs/database/drift_schema_v2.json
dart format .
flutter analyze
flutter test
```

Current build_runner reports that `--delete-conflicting-outputs` is removed and
ignored; the command is retained here to match the project's instructions.

## Phone acceptance check

Connect a real Android phone with USB debugging enabled and run `flutter run`.
Check each theme in light and dark mode and switch between English and Amharic.
Choose a theme, display mode, and language, then close and relaunch the app.
Verify that all three choices remain. Report any startup or save error.

The user confirmed these Phase 0 phone checks passed on 2026-10-13. Version 1 is the first
database schema; there is no earlier app database requiring a version upgrade.
