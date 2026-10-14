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

Optional English transcription is now implemented after a recording completes:
tap Transcribe recording to run the bundled quantized Zipformer-small model.
This step does not delay or replace pitch/pause analysis. Recognized words carry
actual token-emission timestamps, grouped into words and labelled approximate.
Overlapping 20-second chunks bound working memory, with unique ownership of
timestamps in overlap regions. Leaving the screen cancels between chunks and
allows an in-flight native decode to clean up safely.

The transcript view offers selectable text and replayable word chips with the
acoustic `… duration …` pause markers interleaved by time. Playback highlights
the current word or measured pause. No pause is inferred from punctuation or an
ASR omission. Transcription is a hypothesis to check against replay; it does not
change existing acoustic pace, pitch or quality metrics. After transcription, a
separate recognized-word pace summary shows word count, whole-recording WPM,
and configurable 10-second windows. Partial windows use their actual duration.
Rates include silence; empty recognition leaves the average unavailable. ASR
omissions remain uncertainty, never inferred silence. Pitch calibration now checks for a substantially deeper difference minimum
at twice the selected period before accepting a dominant second harmonic.
The main voicing threshold and pitch range remain unchanged. Analysis version
6 distinguishes new results; old recordings are not rewritten.

Transcripts are cached in `<recording.wav>.transcript.json` beside private audio,
with source size/mtime and model version validation, atomic writes and save retry.
No database schema changes are needed. Future export/delete operations must
include these sidecars. The reference test fixture is public LibriSpeech audio,
with attribution in `test/fixtures/README.md`; it is not bundled in the app.

Deployment note: the previous split ARM64 release used Android version code
2001 while a default debug APK used 1, blocking data-preserving debug updates.
Version 0.2.0 now uses code 2002 and `force-version-code-ignoring-abi=true`, so
split and debug builds share a consistent app version code. Future releases
should increment the pubspec build number normally; do not uninstall to update.

1. Validate the bundled English recognizer and approximate timestamps across
   accents, noise and normal delivery using the same saved WAV as replay.
2. Check the word/pause alignment on real continuous-speech and deliberate-pause
   takes. ASR omissions and punctuation are not silence evidence.
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
- `flutter run -t tool/phone_transcript_diagnostics.dart`: transcribe one latest
  saved WAV and verify local cache reopening. Logs counts/timing only, not text.

Research sources:

- https://github.com/snakers4/silero-vad (model, design, license)
- https://k2-fsa.github.io/sherpa/onnx/vad/silero-vad.html (runtime integration)
- https://pub.dev/packages/sherpa_onnx/versions/1.13.8 (Flutter bindings)
- https://pub.dev/packages/just_audio/versions/0.10.6 (local replay)
- https://developer.android.com/reference/android/speech/SpeechRecognizer
  (platform ASR is device-dependent and is not used by the bundled recognizer)
- https://huggingface.co/csukuangfj/sherpa-onnx-zipformer-small-en-2023-06-26
  (pinned offline English model, Apache 2.0)

Real-phone accuracy and performance require checking the actual marked audio.
Passing synthetic tests or changing the number of predicted pauses is not proof
that every pause is correct.
