# Speech Coach

Android-first Flutter app for local speech and presentation practice.

The app shell has a welcome screen and appearance settings with four themes,
light/dark/system modes, and English/Amharic localization. Fonts are bundled
for offline use. Settings currently reset when the app restarts.

Foundation work is assigned in `docs/phases/phase-0-foundation.md`;
`docs/SPEC.md` owns the product requirements and `AGENTS.md` defines contribution
rules. Database and feature-flag implementation awaits approval.

```sh
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

Use a real Android phone for microphone testing. Complete Phase 0 before
starting the 30-second recording and pitch-contour prototype.
