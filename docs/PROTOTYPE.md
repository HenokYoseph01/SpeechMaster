# Recording and delivery measurements

Phase 0 and the recording/pitch prototype were accepted on a real Android phone.
The current build extends it with delivery measurements, neural speech detection,
and local replay. The user authorized an English-first voice-analysis direction
on 2026-10-14; see `docs/VOICE_ROADMAP.md` for the current scope.

## Try it on an Android phone

```sh
flutter run
```

1. Open Record. Leave the mode at 30 seconds and tap Start recording.
2. Grant microphone permission. Talk naturally, using both steady and varied
   pitch. Let the countdown finish automatically.
3. Verify that the microphone level responds and the countdown continues.
4. Verify that a pitch chart appears after recording, with rises/falls and gaps
   for unvoiced moments. Below it, check detected speech time, pause counts,
   estimated pace, volume variation and ending energy. No score is shown yet.
   Tap a detected pause below the summary to replay it with surrounding words.
   Tap Transcribe recording for an optional offline English transcript. Tap a
   word to replay from its approximate time; acoustic gaps appear as
   `… duration …` chips, independent of transcript punctuation.
5. Try finishing early: the finish button is unavailable before 10 seconds.
6. Try the 60-second mode and verify its countdown stops automatically.
7. Deny microphone permission and verify the explanation and Android app
   settings link. Returning from settings should allow another attempt.
8. Background the app during a recording. The unfinished take is discarded
   and the app explains the interruption; the microphone should stop.
9. Include a few deliberate pauses between sentences. Opening and closing
   silence should not be counted as pauses.
10. Try a quiet take or finish with less than 10 seconds of detected speech.
    Check the encouraging quality warning. The chart remains a preview; a
    warning does not delete the recording.

The chart has a screen-reader summary. English/Amharic and system text scaling
are supported. The user accepted the microphone/contour prototype. The new
summary still needs a real-phone check.

## What runs locally

- `record` captures WAV PCM16, 16 kHz, mono with gain/echo/noise processing off.
- `analysis_isolate.dart` reads and parses RIFF chunks off the UI thread.
- A low-pass FIR filter precedes downsampling to 8 kHz for pitch.
- Frame energy and VAD gate YIN; the detector searches 70–400 Hz and refines the
  first CMND valley below the configured threshold with parabolic interpolation.
- The user approved a pitch-chart fallback when energy gating produces no usable
  contour: YIN checks the remaining frames, with the existing minimum voiced
  ratio applied to the whole clip. This recovers steady voiced delivery when the
  noise-floor estimate contains speech. Silence and white noise remain unvoiced.
- Semitones use the clip's median pitch. Octave jumps are rejected, with median
  and moving-average smoothing that preserve unvoiced gaps.
- The chart stores 10 points per second using the median of voiced frames in each
  time bucket, preserving fully unvoiced gaps. Too little voiced speech produces a
  localized suggestion to try again, rather than an invented contour.
- Version 3 separates preview acceptance from whole-clip fallback acceptance:
  speech-gated previews require 10% valid frames, while the fallback still
  requires 30% across the clip. The YIN threshold is 0.25, calibrated against
  failed recordings on the connected phone. Sparse measured points are visible
  as dots; no line bridges an unvoiced gap. These are pitch-only previews, not
  passing quality scores.
- The WAV and metadata are saved in the existing local tables and files folder.
  Analysis errors preserve the captured WAV for a retry.
- Version 4 adds internal pauses (at least 250 ms), a 300–2500 Hz syllable
  band-pass and 40 ms energy smoothing, voiced peaks at least 100 ms apart,
  speaking/articulation rates and 5-second pace windows with at least 2 seconds
  of speech. These are language-independent estimates, not transcription.
- Loudness range is p95 minus p20 of speech dB; ending energy compares the
  last and first third of speech. Full pitch statistics still require 30%
  voiced speech frames, independently of the working preview chart.
- Quality checks flag insufficient speech, low SNR, clipping and quiet audio.
  Clipping means a PCM16 endpoint (absolute amplitude at least 32767/32768);
  `clippingPct` is a percentage, while `pauseRatio` is a fraction.
- Pause durations below 600 ms are short; 600–1500 ms are medium; over 1500 ms
  are long. Pace CV uses population standard deviation over eligible windows
  and stays null with fewer than two windows or a zero mean. Pitch movement
  uses adjacent voiced frames and never bridges an unvoiced gap.

Tunable parameters are in `assets/audio_config.json`. Only the two recording
modes in the spec are exposed. No schema, scoring formula, coach flag, or network
behavior changed in this task.

## Scope and verification

Older pitch-only rows carry `prototype_pitch_only` in `flags_json`. New version 4
rows carry `phase1_metrics_only` plus applicable quality-warning codes, with all
scores and filler counts null. Fallback rows also carry
`pitch_periodicity_fallback` and retain the original VAD speech-time estimate.
`insufficient_pitch` indicates unavailable full pitch metrics even if the
preview still draws some segments. Audio remains available for later re-analysis;
old results are not automatically rewritten. Playback, scoring and coaching tips
are later work.

Production analysis now uses a bundled Silero speech detector instead of the
volume-only VAD. All recordings stay on the phone, including replay. Version 5
rows include `silero_vad` in flags. The legacy energy detector remains a
reference for synthetic tone tests, and the chart-only fallback remains separate.
When there is too little independently detected background-only audio, SNR is
unavailable rather than estimated from speech. Treat pace and pause boundaries
as estimates; replay the actual flagged audio before interpreting them.

The automated suite checks tones across 70–400 Hz with less than one semitone
error, a 120–240 Hz glide, silence/noise, low-pass attenuation, padded/truncated
WAV chunks, progress/errors from an isolate, recording limits and interruptions,
analysis retry/cleanup, persisted metrics/quality flags, pause timing within
50 ms, signed volume ramps, known syllable pulses, quality gate boundaries,
60-second full-isolate analysis and large English/Amharic summary text.

For phone timing, Flutter's console prints `Pitch prototype analysis: N ms`.
Host test timings are diagnostics only. The complete 60-second pipeline's
under-3-second low-end-phone and 60 fps acceptance checks remain Phase 1 tasks;
use `flutter run --profile` for those later checks.

To diagnose existing recordings without copying audio off the phone, run
`flutter run -t tool/phone_pitch_diagnostics.dart`. It opens the normal app and
analyzes saved WAVs without changing the database, logging aggregate signal
levels, pitch coverage, and errors. Run `flutter run` afterward to restore the
normal entry point. The diagnostic tool is not part of normal app startup.
