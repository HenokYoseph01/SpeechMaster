# Phase 0: foundation

Read `docs/SPEC.md`: Decisions, Stack and project layout, Data model,
Design system, and Build phases (Phase 0). Follow `AGENTS.md`.

## Tasks

- [x] Create an Android Flutter scaffold and initialize Git.
- [x] Add Riverpod and go_router, with feature folders from the spec.
- [x] Implement the specified drift schema and initial creation after approval; keep a schema snapshot for future migrations.
- [x] Add four themes in light and dark, using theme tokens.
- [x] Add English and Amharic ARB localization.
- [x] Implement FeatureFlags after approval, with AI coach off by default.

## Acceptance

- Run `dart format .`, `flutter analyze`, and `flutter test` for each task.
- Verify launch on a real Android phone, live theme switching, and database
  opening and migration before completing this phase.

## Scope

Complete Phase 0 before starting the 30-second recording and pitch-contour
prototype. Do not start Phase 1 or later assignments in this phase.

## Approved database and flag task

Implement schema version 1 with the eight tables in the spec's Data model:
`recordings`, `analysis_results`, `tip_log`, `drill_sessions`, `daily_activity`,
`settings`, `entitlements`, and `ai_feedback`. Preserve the specified columns,
foreign keys, cascading behavior, and tip-log index. Enable SQLite foreign keys,
create the initial schema on first open, and test reopening, relationships, and
the schema version. Persist appearance and language in `settings`.

Use `drift` and `sqlite3` 3.x. The user approved replacing the obsolete
`sqlite3_flutter_libs` package without editing the human-owned spec.
Approved supporting dependencies: `path_provider` for the private app data directory,
`drift_dev` and `build_runner` for schema generation and migration tooling.
Check current package documentation and add them with `flutter pub add`.

Implement the Phase 0 flag contract only: compile-time `AI_COACH` defaults to
false; effective availability also requires the remote kill switch to allow it.
Unknown remote configuration stays disabled. Test the combinations, with no
coach UI, entitlement implementation, purchases, or network calls in this task.
Worker configuration integration remains assigned to Phase 4.

Appearance and language now persist in SQLite. Database schema, reopening,
foreign keys, settings persistence and failure recovery have automated tests.
The user confirmed the real-phone acceptance check passed on 2026-10-13:
the app launches, themes and languages switch, and settings persist after
restart. Phase 0 is complete. Version 1 creates the first schema; no older
schema exists to upgrade.
