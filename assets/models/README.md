# Bundled speech detector

- Model: sherpa-onnx's Silero VAD ONNX release asset, mono 16 kHz, 512-sample windows.
- Download: https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/silero_vad.onnx
- SHA-256: `9e2449e1087496d8d4caba907f23e0bd3f78d91fa552479bb9c23ac09cbb1fd6`
- License: MIT, Silero Team; the complete notice is in `SILERO_LICENSE` and bundled in the APK.
- Runtime: pinned `sherpa_onnx` 1.13.8. Model inference and WAV analysis run in the background isolate.

The model is bundled, copied to the app's private files on first analysis, and
never downloaded at runtime. Audio is never uploaded. An initialization error
returns an analysis error rather than silently returning to volume-only VAD.

Pure-Dart synthetic-tone tests continue to exercise the energy reference
detector. Production recordings use neural VAD through `analyzeRecording`.
