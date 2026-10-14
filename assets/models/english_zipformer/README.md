# Offline English recognition model

English-only Zipformer-small transducer, trained on LibriSpeech. This is a
bundled local model, not an Android system recognizer or a network API.

- Publisher: https://huggingface.co/csukuangfj/sherpa-onnx-zipformer-small-en-2023-06-26
- Pinned revision: `e8add5377a6cb7b629b5a0e08d6afe7a73442814`
- Upstream training model: https://huggingface.co/Zengwei/icefall-asr-librispeech-zipformer-small-2023-05-16
- License: Apache 2.0, complete notice included in `LICENSE` and the app bundle.
- Encoder: `encoder-epoch-99-avg-1.int8.onnx` (renamed `encoder.int8.onnx`).
- Decoder: `decoder-epoch-99-avg-1.onnx` (renamed `decoder.onnx`).
- Joiner: `joiner-epoch-99-avg-1.int8.onnx` (renamed `joiner.int8.onnx`).
- Tokens: `tokens.txt`, unchanged.

SHA-256 checksums:

```text
3a6ac78a31cc2c60ca8c1e2e2f43c878fbbcaf051ada4900e0a42ef8ba53d375 encoder.int8.onnx
1621a13eaa7f6fc52380f025ee2a6a05b56a87754ab5a0f4f580a3928f3467a2 decoder.onnx
6b183b6ec656e4d3ca6b86d0aeca992dac14df80aae6b416d7c068d0ff2bd4d7 joiner.int8.onnx
49e3c2646595fd907228b3c6787069658f67b17377c60aeb8619c4551b2316fb tokens.txt
```

Use the runtime's actual token-emission timestamps; do not distribute words
evenly across a clip. Group SentencePiece subwords into words. These are
approximate recognition timestamps, not forced alignment or verified silence.
The audio is decoded in overlapping chunks for bounded memory and cancellation
between chunks; an in-flight native decode completes before native cleanup.

Known limitation: this compact read-English model can omit or substitute words,
especially with accents, background noise, music, or unclear speech. Replay is
the verification tool. Near-digital silence is excluded to avoid spurious words.
