# Phase 1: record and analyze

Read `docs/SPEC.md`: Decisions, Stack and project layout, Audio pipeline,
Data model, Design system, Build phases (Phase 1), and the final prototype note.
Follow `AGENTS.md`. Phase 0 was accepted by the user on a real Android phone.

## Completed task: recording and pitch-contour prototype

- [x] WAV PCM16 capture at 16 kHz mono, processing effects off, microphone permission handling.
- [x] Default 30-second recording, with only 30/60-second modes, countdown,
  automatic stop, and early stop allowed after 10 seconds.
- [x] Background isolate: WAV parsing, low-pass/downsample to 8 kHz, energy and
  VAD for primary YIN, the approved chart fallback below, contour cleaning,
  and chart data at 10 points/second.
- [x] Show a localized, accessible pitch chart and keep audio on the phone.
- [x] Synthetic tone, glide, silence, WAV, isolate, and recorder control tests.
- [x] Real-phone microphone/contour acceptance, reported by the user on 2026-10-13.

The initial prototype saved recording metadata and pitch-only analysis. The
current assignment below extends it using the existing analysis columns. Do not
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

## Current task: delivery measurements and quality checks

The user approved proceeding after confirming the pitch preview works.

- [x] Pauses between speech segments, excluding opening/closing silence, with
  short/medium/long classification and replay-ready local intervals.
- [x] Voiced energy-peak syllable estimates, speaking/articulation rates, 5-second
  pace windows and pace CV; English-only approximate words per minute.
- [x] Speech-frame loudness range, first/last-third energy trend and full pitch
  metrics only when at least 30% of speech pitch frames are voiced.
- [x] Quality warnings for speech under 10 seconds, SNR under 15 dB, clipping
  over 1% and loudest speech below -35 dBFS. Keep scores null.
- [x] One-isolate analysis, progress, existing-table persistence and a localized
  measurement summary below the chart; analysis version 4.
- [x] Synthetic acceptance coverage for pauses, amplitude trends, syllable pulses,
  quality boundaries, silence/noise and 60-second isolate responsiveness.

The preview-only exceptions from versions 2/3 still apply. Do not use the relaxed
chart threshold or periodicity fallback to qualify full pitch metrics. Keep all
analysis thresholds in `assets/audio_config.json`; no dependencies are needed.

## Remaining Phase 1 acceptance

- [ ] User checks the new measurement summary and quality warnings on a real phone.
- [ ] A 60-second clip analyzed in under 3 seconds on a low-end phone,
  with UI responsiveness checked in profile mode.

Host timings and an event-loop responsiveness test do not satisfy the low-end
phone / 60 fps acceptance check. Do not begin Phase 2 or later assignments.
