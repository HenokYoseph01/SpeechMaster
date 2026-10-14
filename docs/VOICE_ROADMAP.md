# English voice analysis direction

On 2026-10-14 the user authorized an English-only focus and overriding the
original AGENTS.md/spec phase restrictions to improve voice measurements.
The original human-owned SPEC.md is retained as historical reference. New voice
features prioritize English; existing localization assets remain compatible,
and new untranslated messages fall back to English. Audio remains on-device.

## Current delivery: speech-aware pauses and verification

- Bundle Silero VAD and its native sherpa-onnx runtime. Classify speech using
  learned acoustic features instead of deciding that quiet speech is silence.
- Feed the same speech mask into pitch, syllable estimates, volume and quality
  checks. The pitch-only preview fallback remains separate from full metrics.
- Avoid forced detector splits inside a 60-second take by allowing 65 seconds
  of continuous speech. Preserve the final partial frame and flush at EOF.
- Estimate room noise only from detector-labelled non-speech. If there is less
  than 500 ms, leave SNR unavailable and explain that uncertainty.
- Add local playback, a seek slider, and tappable pause moments with 750 ms of
  context on each side. Pause on background and dispose on leaving the result.
- Store `silero_vad` provenance and analysis version 5 in the existing tables.

Detection remains an estimate. A recognized acoustic gap is not a claim that the
speaker intentionally paused, and a pitch gap is not a speech pause. Validate
boundaries through replay before interpreting them as delivery feedback.

## Next: English transcription and pitch calibration

1. Evaluate an offline English recognizer that returns timestamps for the saved
   WAV. Use the same audio source as analysis and playback. Do not open a second
   microphone or silently use network speech recognition.
2. Align recognized words and measured gaps; show ellipses with durations and
   tappable timestamps. ASR omissions and punctuation are not silence evidence.
3. Compare pitch candidates/confidence against labelled English samples and
   real-phone recordings; assess octave errors, low-register voices, quiet
   phrases, and unvoiced consonants before changing pitch thresholds again.
4. Improve pace against timestamped recognized words, retaining the syllable
   estimate and reporting uncertainty. Validate across accents and microphone
   distances before scores or coaching claims.

## Verification tools and evidence

- `flutter run -t tool/phone_pitch_diagnostics.dart`: analyze saved recordings
  on the phone, logging aggregate measurements only. Does not rewrite results.
- `dart run tool/compare_speech_detectors.dart path/to/clip.wav`: compare the
  energy reference against neural VAD locally. The CLI resolves the native Linux
  library through package configuration; Android resolves its bundled libraries.
- Native-model tests cover silence/noise rejection, isolate execution and model
  errors; mask tests cover continuous speech without independent noise samples.
- Replay tests cover context bounds, seek/resume, failures, and background or
  disposal during loading. Synthetic DSP acceptance tests remain in place.

Research sources:

- https://github.com/snakers4/silero-vad (model, design, license)
- https://k2-fsa.github.io/sherpa/onnx/vad/silero-vad.html (runtime integration)
- https://pub.dev/packages/sherpa_onnx/versions/1.13.8 (Flutter bindings)
- https://pub.dev/packages/just_audio/versions/0.10.6 (local replay)
- https://developer.android.com/reference/android/speech/SpeechRecognizer
  (platform ASR availability is device-dependent; no transcription implemented
  by this delivery)

Real-phone accuracy and performance require checking the actual marked audio.
Passing synthetic tests or changing the number of predicted pauses is not proof
that every pause is correct.
