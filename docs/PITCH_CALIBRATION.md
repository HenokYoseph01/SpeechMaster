# Pitch calibration — analysis version 6

## Reproduced failure and correction

The frame detector accepted the first YIN normalized-difference minimum below
0.25. A dominant second harmonic could meet that threshold at half the real
period, displaying twice the known fundamental frequency.

Version 6 examines the local minimum near twice that selected lag. It prefers
that period only when the normalized difference is less than 20% of the original
and improves by more than 0.02. Both settings are in `assets/audio_config.json`.
This is a narrow octave correction, not a full pYIN or temporal candidate tracker.
The search is bounded to 70–400 Hz; range and voicing threshold are unchanged.
A clean high voice must not be halved simply because its multiples also fit.

`YinEstimate.periodicity` reports 1 minus the selected normalized difference.
It describes periodic fit, not an accuracy probability: even a wrong harmonic
can fit well. It is available for diagnostics rather than presented as a score.

## Repeatable synthetic evidence

Run `dart run tool/pitch_calibration.dart` from the repository root. The tool
prints aggregate results and failed parameter cases, never recorded audio.
The sweep covers 90 frames: fundamentals 70, 80, 100, 150 and 190 Hz, fundamental
amplitudes relative to the second harmonic of 1, 0.3 and 0.1, overall amplitudes
0.01 and 0.3, and phases 0, 0.7 and 2.1 radians. A third harmonic has amplitude
0.15 relative to the second. This is a designed stress set, not speech accuracy.

Before correction: 60 octave errors, zero missing frames, worst absolute error
12.236 semitones. After correction: zero octave errors, zero missing frames,
worst error 0.0061 semitones. An octave error here means absolute error >6
semitones. Additional regression tests cover clean 150–400 Hz tones, seeded
noise, silence, actual register changes, and harmonic WAV downsampling.

## Real-speech limits and next validation

`tool/phone_pitch_diagnostics.dart` runs production neural VAD and pitch analysis
on saved private WAVs, logging only aggregate results without rewriting them.
Those recordings have no independently measured fundamental labels. Successful
analysis, fewer jumps or a different median cannot establish pitch accuracy.

Next validation needs labelled English speech, ideally with laryngograph-based
fundamental references, and a comparison of voiced/unvoiced errors, octave
errors and cent error. Quiet speech, breathy/creaky voice, rumble, rapidly
changing pitch and fundamentals outside 70–400 Hz remain important limitations.
A weak fundamental that is absent altogether cannot be recovered reliably by
this check. Existing results retain their original analysis version.

Reference: de Cheveigné & Kawahara (2002), *YIN, a fundamental frequency estimator
for speech and music*, https://pubmed.ncbi.nlm.nih.gov/12002874/ . The twice-period
comparison and its settings are this project's heuristic, not a claim of
implementing all refinement steps from the paper.

On-device check (2026-10-14, Samsung SM G998U1): all 16 saved clips completed
version 6 analysis with pitch previews, without rewriting their stored results.
The 30-second clip took 2408 ms in the diagnostic debug build; total analysis
times ranged from 676 to 2464 ms. These are runtime checks, not accuracy labels.
Final verification: formatting clean, analysis no issues, 106 tests passed.
