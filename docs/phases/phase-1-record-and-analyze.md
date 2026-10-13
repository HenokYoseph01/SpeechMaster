# Phase 1: record and analyze

Read `docs/SPEC.md`: Decisions, Stack and project layout, Audio pipeline,
Data model, Design system, Build phases (Phase 1), and the final prototype note.
Follow `AGENTS.md`. Phase 0 was accepted by the user on a real Android phone.

## Current task: recording and pitch-contour prototype

- [x] WAV PCM16 capture at 16 kHz mono, processing effects off, microphone permission handling.
- [x] Default 30-second recording, with only 30/60-second modes, countdown,
  automatic stop, and early stop allowed after 10 seconds.
- [x] Background isolate: WAV parsing, low-pass/downsample to 8 kHz, energy and
  VAD for primary YIN, the approved chart fallback below, contour cleaning,
  and chart data at 10 points/second.
- [x] Show a localized, accessible pitch chart and keep audio on the phone.
- [x] Synthetic tone, glide, silence, WAV, isolate, and recorder control tests.
- [ ] Real-phone microphone/contour acceptance, reported by the user.

Save recording metadata and pitch-only analysis in the existing tables. Do not
change the schema or scoring formula. No overall score is shown or saved.
Keep tunable DSP/recorder parameters in `assets/audio_config.json`.

## Approved correction for missing pitch (2026-10-13)

The user approved a chart-only deviation from speech-frame-only YIN: when the
normal energy-gated contour is unusable, run YIN on the remaining frames and
require the existing minimum voiced ratio across the whole clip. Keep the VAD
speech-time estimate unchanged; this fallback does not enable scoring or
replace the full quality gates. Record `pitch_periodicity_fallback` in the
existing `flags_json` field when used. The human-owned spec is unchanged.

Compare octave jumps against the previous detected voiced frame, including a
rejected frame, so one pitch-register change cannot suppress the rest of a take.
Aggregate valid contour frames within each chart bucket to preserve pitch when
the first frame of that bucket is unvoiced. Entirely unvoiced buckets stay gaps.
Analysis version 2 identifies this DSP correction; existing audio remains local.

## Real-recording correction (2026-10-13)

The user explicitly authorized going outside AGENTS.md for this persistent
failure. On-device diagnosis reproduced no contour in all seven saved WAVs
despite valid capture. Version 3 uses a 0.25 YIN threshold and a separate 10%
speech-gated preview threshold; whole-clip fallback retains its 30% requirement.
Unvoiced gaps remain gaps, and isolated chart points are drawn visibly. These
preview settings do not implement or relax scoring quality gates. A dedicated
diagnostic entry point analyzes saved audio entirely on the phone.

## Remaining Phase 1 tasks

- [ ] Pauses, syllable rate, windowed pace, remaining metrics and full quality gates.
- [ ] Full pipeline synthetic audio acceptance tests from the spec.
- [ ] A 60-second clip analyzed in under 3 seconds on a low-end phone,
  with UI responsiveness checked in profile mode.

Complete this prototype before starting the remaining tasks. Do not begin
Phase 2 or later assignments.
