# Phase 0: foundation

Read `docs/SPEC.md`: Decisions, Stack and project layout, Data model,
Design system, and Build phases (Phase 0). Follow `AGENTS.md`.

## Tasks

- [x] Create an Android Flutter scaffold and initialize Git.
- [x] Add Riverpod and go_router, with feature folders from the spec.
- [ ] Implement the specified drift schema and migrations after approval.
- [x] Add four themes in light and dark, using theme tokens.
- [x] Add English and Amharic ARB localization.
- [ ] Implement FeatureFlags after approval, with AI coach off by default.

## Acceptance

- Run `dart format .`, `flutter analyze`, and `flutter test` for each task.
- Verify launch on a real Android phone, live theme switching, and database
  opening and migration before completing this phase.

## Scope

Complete Phase 0 before starting the 30-second recording and pitch-contour
prototype. Do not start Phase 1 or later assignments in this phase.

## Next task proposal (approval required)

Implement schema version 1 with the eight tables in the spec's Data model:
`recordings`, `analysis_results`, `tip_log`, `drill_sessions`, `daily_activity`,
`settings`, `entitlements`, and `ai_feedback`. Preserve the specified columns,
foreign keys, cascading behavior, and tip-log index. Enable SQLite foreign keys,
create the initial schema on first open, and test reopening, relationships, and
the schema version. Persist appearance and language in `settings`.

Use `drift` and `sqlite3_flutter_libs` from the spec. Supporting dependencies
requiring approval: `path_provider` for the private app data directory,
`drift_dev` and `build_runner` for schema generation and migration tooling.
Check current package documentation and add them with `flutter pub add`.

Implement the Phase 0 flag contract only: compile-time `AI_COACH` defaults to
false; effective availability also requires the remote kill switch to allow it.
Unknown remote configuration stays disabled. Test the combinations, with no
coach UI, entitlement implementation, purchases, or network calls in this task.
Worker configuration integration remains assigned to Phase 4.

Current appearance and language settings are in memory. No real Android phone
was detected during the app-shell task; hardware acceptance remains pending.
