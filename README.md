# Speech Coach

Android-first Flutter app for local speech and presentation practice.

The app has a recording and pitch-contour prototype: choose 30 or 60 seconds,
record a local WAV, and see how your pitch moved. The default is 30 seconds;
early finish becomes available after 10 seconds. Pitch analysis runs in a
background isolate. Recordings and partial pitch analysis are saved locally.

Appearance settings include four themes, light/dark/system modes, and
English/Amharic localization. Fonts are bundled for offline use. Appearance
and language settings persist in SQLite.

Current work is assigned in `docs/phases/phase-1-record-and-analyze.md`;
`docs/SPEC.md` owns the product requirements and `AGENTS.md` defines contribution
rules. The version 1 Drift schema and disabled coach flag contract are implemented.
See `docs/database/README.md` for database details and the real-phone acceptance
check, which the user accepted for Phase 0. See `docs/PROTOTYPE.md` for the
microphone and pitch-contour check. Full metrics, quality gates, playback,
scores, and tips remain future tasks.

```sh
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

Use a real Android phone for microphone testing. Confirm the prototype check
before continuing with the remaining Phase 1 analysis tasks.
