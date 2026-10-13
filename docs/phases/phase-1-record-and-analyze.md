# Phase 1: record and analyze

Read `docs/SPEC.md`: Decisions, Stack and project layout, Audio pipeline,
Data model, Design system, Build phases (Phase 1), and the final prototype note.
Follow `AGENTS.md`. Phase 0 was accepted by the user on a real Android phone.

## Current task: recording and pitch-contour prototype

- [x] WAV PCM16 capture at 16 kHz mono, processing effects off, microphone permission handling.
- [x] Default 30-second recording, with only 30/60-second modes, countdown,
  automatic stop, and early stop allowed after 10 seconds.
- [x] Background isolate: WAV parsing, low-pass/downsample to 8 kHz, energy and
  VAD for speech-only YIN, contour cleaning, and chart data at 10 points/second.
- [x] Show a localized, accessible pitch chart and keep audio on the phone.
- [x] Synthetic tone, glide, silence, WAV, isolate, and recorder control tests.
- [ ] Real-phone microphone/contour acceptance, reported by the user.

Save recording metadata and pitch-only analysis in the existing tables. Do not
change the schema or scoring formula. No overall score is shown or saved.
Keep tunable DSP/recorder parameters in `assets/audio_config.json`.

## Remaining Phase 1 tasks

- [ ] Pauses, syllable rate, windowed pace, remaining metrics and full quality gates.
- [ ] Full pipeline synthetic audio acceptance tests from the spec.
- [ ] A 60-second clip analyzed in under 3 seconds on a low-end phone,
  with UI responsiveness checked in profile mode.

Complete this prototype before starting the remaining tasks. Do not begin
Phase 2 or later assignments.
