# Recording and pitch-contour prototype

Phase 0 was accepted on a real Android phone. This task implements the first
recording/pitch test requested at the end of the spec, within Phase 1.

## Try it on an Android phone

```sh
flutter run
```

1. Open Record. Leave the mode at 30 seconds and tap Start recording.
2. Grant microphone permission. Talk naturally, using both steady and varied
   pitch. Let the countdown finish automatically.
3. Verify that the microphone level responds and the countdown continues.
4. Verify that a pitch chart appears after recording, with rises/falls and gaps
   for unvoiced moments. No score is shown in this prototype.
5. Try finishing early: the finish button is unavailable before 10 seconds.
6. Try the 60-second mode and verify its countdown stops automatically.
7. Deny microphone permission and verify the explanation and Android app
   settings link. Returning from settings should allow another attempt.
8. Background the app during a recording. The unfinished take is discarded
   and the app explains the interruption; the microphone should stop.

The chart has a screen-reader summary. English/Amharic and system text scaling
are supported. User confirmation of the microphone/contour check is required
before accepting the prototype.

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
- The WAV and metadata are saved in the existing local tables and files folder.
  Analysis errors preserve the captured WAV for a retry.

Tunable parameters are in `assets/audio_config.json`. Only the two recording
modes in the spec are exposed. No schema, scoring formula, coach flag, or network
behavior changed in this task.

## Scope and verification

Pitch-only rows carry `prototype_pitch_only` in `flags_json`, and all scores
remain null. Chart fallback rows also carry `pitch_periodicity_fallback` and
retain the original VAD speech-time estimate. This is analysis version 2; the
approved exception is documented in the phase assignment. Audio remains available
for re-analysis as Phase 1 is completed;
increment `analysisVersion` when the pipeline changes. No pause/pace/volume
metrics, full quality gates, playback, results scoring, or coaching tips are
implemented by this task.

The automated suite checks tones across 70–400 Hz with less than one semitone
error, a 120–240 Hz glide, silence/noise, low-pass attenuation, padded/truncated
WAV chunks, progress/errors from an isolate, recording limits and interruptions,
analysis retry/cleanup, persisted metadata, and large Amharic text.

For phone timing, Flutter's console prints `Pitch prototype analysis: N ms`.
Host test timings are diagnostics only. The complete 60-second pipeline's
under-3-second low-end-phone and 60 fps acceptance checks remain Phase 1 tasks;
use `flutter run --profile` for those later checks.
