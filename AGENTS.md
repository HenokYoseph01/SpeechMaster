# AGENTS.md

## Current user direction (2026-10-14)

The user explicitly superseded the conflicting rules below: focus new work on
English only, research and improve voice analysis freely, and do not treat the
old phase/dependency restrictions as approval gates. `docs/VOICE_ROADMAP.md`
records the active direction. Keep audio on-device. Preserve useful checks,
tests and existing user data. The original spec remains historical reference;
do not silently rewrite the human-owned document.

Project: speech and presentation coaching app (working title). Flutter, Android first, local-first.
It records a 30 s or 60 s clip, scores how expressive the delivery sounds on the phone, and gives varied tips.

## Source of truth
- `docs/SPEC.md` is the spec. Read the sections your phase file names before writing code.
- `docs/phases/phase-N-*.md` is your current assignment. Do one phase at a time and never start the next one.
- If the code and the spec disagree, or the spec is unclear, stop and ask. Do not silently deviate.
- `docs/PROGRESS.md` is the shared log. After each finished task, add one line: date, task, what changed, anything left over.

## How to work
- For any task that touches more than 3 files, write a short plan in your reply first, then implement.
- One task, one commit. Message format: `phase1: add YIN pitch detector`.
- Before you say a task is done, run `dart format .`, `flutter analyze` and `flutter test`. Fix every failure and report the real output. Never claim tests pass without running them.
- Add dependencies with `flutter pub add <name>` so you get the current version. Never guess a package name, version or API; check pub.dev or the package's docs.
- Prefer small, reviewable diffs. Do not refactor unrelated code.

## Commands
- `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`
- `flutter run` (use a real Android phone for anything involving the microphone)
- `dart run build_runner build --delete-conflicting-outputs` (after changing drift tables)

## Architecture rules
- State with Riverpod. Navigation with go_router. Database with drift. Feature folders as in the spec's layout.
- No business logic in widgets.
- DSP code in `lib/audio/dsp/` is pure Dart with no Flutter imports. It runs inside an `Isolate`, never on the UI thread.
- Every tunable number (score bands, weights, thresholds, tip text, drill text) lives in `assets/*.json`, not in code.
- Every user-visible string comes from the ARB files (`en`, `am`). No hard-coded UI text.
- Colors come only from theme tokens. No hard-coded colors in widgets.
- Recording is limited to two modes: 30 s and 60 s. Nothing else.
- Audio never leaves the device. The app's only network calls are the anonymous event pings and the flagged coach call, both defined in the spec.

## Ask first, then act
- Changing a database table or the scoring formula
- Adding a dependency that is not in the spec
- Anything that touches `FeatureFlags` or the paid tier

## Never
- Edit `docs/SPEC.md` (the human owns it).
- Commit secrets, API keys, tokens or `.env` files.
- Turn on the `AI_COACH` flag by default.
- Delete or weaken a test to make it pass.
- Use red for scores or negative words about the user in copy ("Room to grow", never "weak").

## Voice of the app
Warm, short, encouraging. Describe the delivery, never judge the person.
