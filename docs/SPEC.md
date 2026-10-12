# Speech Coach App: Build Spec

Oct 12, 2026 · @Henok

Build a local-first Flutter app that records a 30 or 60 second speech, scores how expressive it sounds entirely on the phone, and gives varied, human-sounding tips. The paid AI coach is built in parallel but ships switched off behind a feature flag.

## Decisions

These are locked in. Four of them change what we discussed earlier, and each says why.

- **Platform:** Flutter, Android first. iOS comes later from the same codebase.
- **Local-first:** recordings, scores and progress live in SQLite and the app's files folder on the phone. No accounts in v1.
- **Pitch detection:** write our own YIN in Dart and run it in an `Isolate`. Do not use `pitch_detector_dart`. YIN is a short, stable algorithm, and an unmaintained dependency adds risk for no gain.
- **Paid tier:** build it now behind a feature flag that is off at launch. This replaces "comment it out": commented-out code rots and cannot be tested, while a flag keeps both paths compiling and under test.
- **Usage tracking:** anonymous event pings to a free Cloudflare Worker with a D1 database, plus a daily Telegram digest. This replaces "chunk a database backup into Telegram". Local-first means there is no central user database to back up, and Telegram bots can upload files up to about 50 MB (verify), so 15 MB chunks are not needed.
- **LLM:** a provider-agnostic adapter on the Worker. The free-tier key is shared by every user, so the app must always fall back to rule-based tips.
- **Languages:** English and Amharic interface from day one. Pitch, pace, pause and volume analysis is language-independent. Fillers and transcription are out of the MVP.

**Recording length:** two modes only, 30 s and 60 s, with an on-screen countdown. The fixed length makes users practice fitting their message into a set time, which trains pacing and pauses. Every threshold in this spec that mentions a time assumes these clip lengths.

## Free and paid tiers

The free tier is the whole product. The paid tier adds a personal coach on top and never takes a free feature away.

| Feature | Free (launch) | Plus (built, flag off) |
| --- | --- | --- |
| Record, analyze, replay | Unlimited | Unlimited |
| Pitch contour, pace, pauses, volume | Yes | Yes |
| Expressiveness score and sub-scores | Yes | Yes |
| Rule-based tips | 1 focus tip and 1 praise per recording | Same |
| Daily drills (8 types) | All | All |
| Progress timeline, streaks, personal bests | Yes | Yes |
| Themes and dark mode | All | All |
| Export and delete my data | Yes | Yes |
| AI coach feedback on each recording | No | Yes, monthly quota |
| Personalised weekly practice plan | No | Yes |
| Ask the coach a question about a result | No | Yes, monthly quota |

**Flag rules.** `FeatureFlags.aiCoach` is a compile-time constant (`--dart-define=AI_COACH=true`) combined with a remote kill switch from the Worker's `/v1/config` endpoint. When the flag is off, the coach screens, the paywall and the settings entry are not built into the widget tree. The `EntitlementService` interface ships with a `FreeEntitlements` implementation registered and a `PlusEntitlements` implementation written, tested and unregistered.

## Stack and project layout

Pin the latest stable version of each package when the project is created, and check pub.dev for recent releases before adding any dependency.

| Layer | Choice | Notes |
| --- | --- | --- |
| App | Flutter stable, Dart 3 | Android first, iOS later |
| State | `flutter_riverpod` | Providers per feature |
| Navigation | `go_router` | Deep links for notification taps |
| Database | `drift` + `sqlite3_flutter_libs` | Typed queries, migrations |
| Recording | `record` | WAV PCM16, 16 kHz, mono |
| Playback | `just_audio` | Seek to flagged moments |
| Charts | `CustomPainter` for the pitch contour, `fl_chart` for progress | The contour needs custom drawing |
| Notifications | `flutter_local_notifications` | Daily practice reminder |
| Localization | `flutter_localizations` + `intl` (ARB files) | `en`, `am` |
| HTTP | `dio` | Telemetry and coach calls |
| Purchases (later) | `purchases_flutter` (RevenueCat) or `in_app_purchase` | Behind the flag |
| Backend | Cloudflare Workers + D1 | Free tier, one Worker |

```text
lib/
  core/        theme/, flags.dart, router.dart, db/, l10n/, config/
  audio/       recorder.dart, dsp/ (yin.dart, vad.dart, metrics.dart), analysis_isolate.dart
  scoring/     scoring_config.dart, scorer.dart
  tips/        tip_engine.dart, tip_models.dart, assets: tips.json
  features/    onboarding/, home/, record/, results/, drills/, progress/, settings/
  features/coach/   (built only when FeatureFlags.aiCoach is true)
  telemetry/   events.dart, uploader.dart
assets/        scoring_config.json, tips.json, drills.json, prompts.json, fonts/
worker/        src/index.ts, schema.sql, wrangler.toml
test/          dsp/, scoring/, tips/
```

## Audio pipeline

Everything runs in one background `Isolate` (`analysis_isolate.dart`) that receives the WAV path and streams progress (0 to 1) back to the UI. Target: a 60-second clip analyzed in under 3 seconds on a low-end Android phone.

1. **Capture.** `record` package, WAV PCM16, 16 kHz, mono. Turn off auto-gain, echo cancellation and noise suppression so loudness changes survive. The user picks a 30 s or 60 s mode before recording, and the recorder stops automatically at the chosen length (the timer counts down so they practice pacing). A user can stop early, but never before 10 s.
2. **Load.** Read PCM into a `Float32List` scaled to -1..1. Keep the original for playback and a second copy downsampled to 8 kHz (low-pass, then take every 2nd sample) for pitch only.
3. **Frame energy.** 25 ms window, 10 ms hop. `dB = 20 * log10(rms + 1e-9)`. Smooth with a 5-frame median.
4. **Speech detection (VAD).** Noise floor = 10th percentile of frame dB. A frame is speech if `dB > noiseFloor + 10`. Fill gaps shorter than 120 ms and drop speech runs shorter than 80 ms. Speech segments = runs of speech frames.
5. **Pauses.** A pause is a gap between two speech segments of at least 250 ms. Ignore silence before the first and after the last segment. Classify: short 0.25-0.6 s, medium 0.6-1.5 s, long over 1.5 s.
6. **Pitch (YIN).** On the 8 kHz copy: 40 ms window (320 samples), 20 ms hop, speech frames only. Search lags for 70-400 Hz (tauMin 20, tauMax 114). Compute the difference function and the cumulative mean normalized difference (CMND). Take the first lag where CMND drops below 0.15, refine with parabolic interpolation, then `f0 = 8000 / lag`. If no lag qualifies, mark the frame unvoiced (null).
7. **Clean the contour.** Convert to semitones relative to the speaker's median: `st = 12 * log2(f0 / medianF0)`. Mark a frame null if it jumps more than 8 semitones from the previous voiced frame (octave error). Apply a 5-frame median, then a 3-frame moving average. Discard the clip's pitch metrics if fewer than 30 percent of speech frames are voiced.
8. **Syllable rate.** Band-pass the 16 kHz signal at 300-2500 Hz, take the energy envelope, smooth over 40 ms, then count peaks that are above the speech threshold, at least 100 ms apart, and sit on a voiced frame. Articulation rate = syllables / speech time. Speaking rate = syllables / total time.
9. **Windowed pace.** Split the clip into 5 s windows and compute syllables per second in each. `paceCV = std / mean` across windows that contain at least 2 s of speech.
10. **Quality gates.** Return warnings instead of a score when speech time is under 10 s, when `p90(dB) - noiseFloor` is under 15 dB (noisy room), when more than 1 percent of samples are clipped, or when the loudest speech frame is below -35 dBFS (mic too quiet).
11. **Output.** An `AnalysisResult` (fields below) plus a contour downsampled to 10 points per second for the chart and a list of pause intervals for the replay markers.

| Metric | Definition |
| --- | --- |
| `pitchRangeSt` | 90th minus 10th percentile of the semitone contour |
| `pitchStdSt` | Standard deviation of the semitone contour |
| `pitchMovementStPerS` | Mean absolute change between consecutive voiced frames, per second |
| `articulationRate`, `speakingRate` | Syllables per second (speech time, total time) |
| `paceCV` | Variation of syllable rate across 5 s windows |
| `loudnessRangeDb` | 95th minus 20th percentile of speech-frame dB |
| `energyTrendDb` | Mean dB of the last third minus the first third of speech |
| `pausesPerMin`, `pauseRatio` | Count of pauses per minute, pause time over total time |
| `longPauseCount`, `meanPauseMs` | Pauses over 1.5 s, average pause length |
| `snrDb`, `clippingPct` | Quality measures |

Words per minute is only a rough conversion (about syllables per second times 60 divided by 1.5 for English), so show it as "approximately" and only for English. Fillers are a nullable column reserved for a later release that adds on-device speech recognition.

## Scoring

Each sub-score maps one metric to 0-100: full marks inside the ideal band, falling in a straight line to 0 at the hard bounds. The overall score is the weighted average. **Every number below is a starting hypothesis.** Keep them in `assets/scoring_config.json` so they can be tuned after the calibration test without a code change.

| Sub-score | Metric | Ideal band | Zero at | Weight |
| --- | --- | --- | --- | --- |
| Pitch variety | 60% `pitchRangeSt`, 40% `pitchMovementStPerS` | range 7-14 st, movement 6-18 st/s | range 2 or 22, movement 1 or 30 | 30 |
| Pace | `articulationRate` | 3.8-5.5 syl/s | 2.0 or 8.0 | 15 |
| Pace variety | `paceCV` | 0.10-0.30 | 0 or 0.60 | 10 |
| Pausing | 50% `pausesPerMin`, 50% `pauseRatio` | 4-12 per min, 12-30 percent | 0 or 25 per min, 3 or 50 percent | 20 |
| Volume variety | `loudnessRangeDb` | 8-18 dB | 3 or 30 | 15 |
| Energy hold | `energyTrendDb` (only the drop counts) | 0 to -2 dB | -8 dB | 10 |

```json
{
  "version": 1,
  "profiles": {
    "default": {
      "pitchVariety": { "weight": 30, "range": { "lo": 7, "hi": 14, "zeroLo": 2, "zeroHi": 22, "w": 0.6 },
                        "movement": { "lo": 6, "hi": 18, "zeroLo": 1, "zeroHi": 30, "w": 0.4 } },
      "pace":        { "weight": 15, "lo": 3.8, "hi": 5.5, "zeroLo": 2.0, "zeroHi": 8.0 }
    }
  }
}
```

**Rules for the score.**

- Sub-score formula: `score = clamp(100 * (x - zeroLo) / (lo - zeroLo))` below the band, 100 inside, and the mirror above.
- Show the overall score, four rings (Pitch, Pace, Pauses, Volume, with pace variety folded into Pace and energy hold into Volume), and the change against the user's previous recording and personal best.
- Never show the score in red and never use words like "bad" or "poor". The low band is labelled "Room to grow".
- Profiles are per language. Ship `default` now. Syllable rate norms differ between languages, so add an `am` profile after calibration.
- **Calibration task (before launch).** Collect 30 clips of 30 s and 60 s (some flat, some lively, in English and Amharic), have at least 5 people rate each from 1 to 5 for "how engaging does this sound", and compare ratings against the overall score. Adjust bands and weights until the rank correlation is above 0.6, and record the result in the repo.

## Data model

On-device SQLite through `drift`. Timestamps are epoch milliseconds. Deleting a recording removes its audio file and cascades to its rows.

```sql
CREATE TABLE recordings (
  id TEXT PRIMARY KEY,            -- uuid v4
  created_at INTEGER NOT NULL,
  duration_ms INTEGER NOT NULL,
  target_ms INTEGER NOT NULL,     -- 30000 or 60000, the mode chosen
  audio_path TEXT NOT NULL,
  kind TEXT NOT NULL,             -- 'free' | 'prompt' | 'drill'
  prompt_id TEXT,
  drill_id TEXT,
  title TEXT,
  language TEXT NOT NULL,         -- 'en' | 'am' | ...
  analysis_version INTEGER NOT NULL,
  overall_score INTEGER,          -- null when quality gate failed
  deleted_at INTEGER
);

CREATE TABLE analysis_results (
  recording_id TEXT PRIMARY KEY REFERENCES recordings(id) ON DELETE CASCADE,
  pitch_median_hz REAL, pitch_range_st REAL, pitch_std_st REAL, pitch_movement_st_s REAL,
  articulation_rate REAL, speaking_rate REAL, pace_cv REAL,
  loudness_range_db REAL, energy_trend_db REAL,
  pauses_per_min REAL, pause_ratio REAL, long_pause_count INTEGER, mean_pause_ms INTEGER,
  speech_ms INTEGER, snr_db REAL, clipping_pct REAL,
  filler_count INTEGER,           -- reserved, null in the MVP
  score_pitch INTEGER, score_pace INTEGER, score_pace_var INTEGER,
  score_pause INTEGER, score_volume INTEGER, score_energy INTEGER,
  contour_json TEXT,              -- [[t_ms, semitones|null, db], ...] at 10 points/s
  pauses_json TEXT,               -- [[start_ms, end_ms], ...]
  flags_json TEXT                 -- quality warnings
);

CREATE TABLE tip_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recording_id TEXT NOT NULL REFERENCES recordings(id) ON DELETE CASCADE,
  rule_id TEXT NOT NULL,
  variant_id TEXT NOT NULL,
  kind TEXT NOT NULL,             -- 'focus' | 'praise' | 'quality'
  shown_at INTEGER NOT NULL,
  helpful INTEGER                 -- 1, 0 or null
);
CREATE INDEX idx_tip_log_rule ON tip_log(rule_id, shown_at DESC);

CREATE TABLE drill_sessions (
  id TEXT PRIMARY KEY,
  drill_id TEXT NOT NULL,
  started_at INTEGER NOT NULL,
  completed_at INTEGER,
  recording_id TEXT REFERENCES recordings(id) ON DELETE SET NULL,
  passed INTEGER                  -- 1 when the drill's target metric was met
);

CREATE TABLE daily_activity (
  day TEXT PRIMARY KEY,           -- 'YYYY-MM-DD' in local time
  practice_ms INTEGER NOT NULL DEFAULT 0,
  recordings INTEGER NOT NULL DEFAULT 0,
  drills INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
-- keys: display_name, goal, theme, dark_mode, language, install_id,
--       analytics_opt_in, reminder_time, onboarding_done

CREATE TABLE entitlements (   -- one row, id = 1
  id INTEGER PRIMARY KEY CHECK (id = 1),
  tier TEXT NOT NULL DEFAULT 'free',   -- 'free' | 'plus'
  expires_at INTEGER,
  source TEXT,
  token TEXT,                          -- signed token from the Worker
  updated_at INTEGER NOT NULL
);

CREATE TABLE ai_feedback (    -- empty until the flag is on
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recording_id TEXT NOT NULL REFERENCES recordings(id) ON DELETE CASCADE,
  created_at INTEGER NOT NULL,
  model TEXT, prompt_version INTEGER,
  body_json TEXT NOT NULL,
  tokens_in INTEGER, tokens_out INTEGER
);
```

**Derived, not stored:** streak length (consecutive days in `daily_activity`), personal bests (max per column), and "vs previous" deltas. Bump `analysis_version` whenever the DSP or scoring changes so old results can be re-analyzed from the saved audio.

## Tip engine

The goal is advice that reads like a coach wrote it fresh each time. Variety comes from four things: many variants per rule, a memory of what was shown, specifics filled in from the recording, and small pools of openers and closers.

**Each rule in `assets/tips.json` has:** `id`, `category`, `impact` (0.5-1.5), `cooldownDays`, a `trigger` (a pure Dart function registered by id), a `severity(result)` function returning 0-1, and 4-6 `variants`. A variant has an `id`, a `tone` (`coach`, `calm` or `playful`), a `text` with placeholders such as `{range}`, `{time}`, `{prevRange}`, and an optional `drillId`.

**Selection algorithm** (`TipEngine.pick(result, history, rng)`):

1. Run every trigger. If a quality gate failed, return only the quality tip and stop.
2. Score each triggered rule: `priority = severity * impact * novelty`. `novelty` is 1.0 normally, 0.3 if the rule was shown in either of the last 2 recordings, and 0 inside its cooldown.
3. Pick the highest-priority rule as the **focus tip**. Pick one **praise tip**: the best sub-score at 80 or above, else the biggest improvement over the previous recording, else the first-recording welcome.
4. For each, choose a variant: drop variants used in the last 10 shows of that rule, filter to the user's tone setting if one is set (default is a mix), then choose at random from what remains. If none remain, reset that rule's history.
5. Fill placeholders with real values: a timestamp where the pattern was strongest ("around 0:42"), the user's own numbers, and a comparison with their previous or best result.
6. Compose the final text: optional opener (shown 70 percent of the time) + the variant + a "Try this" line when the variant has a `drillId`, + optional closer (shown 40 percent of the time). Openers and closers come from pools of at least 12 lines each, and the same one is never used twice in a row.
7. Write to `tip_log`. Show "Helpful / Not really" buttons and store the answer in `helpful`. Down-weight variants that are often marked not helpful.

**Voice rules for every line you write:**

- Under 40 words, one action, specific to what the recording showed.
- Talk about the delivery, never the person: "your pitch stayed in a narrow range", not "you sound monotone".
- Start from what is working when there is something true to say.
- Plain words, no jargon unless explained once ("semitones" becomes "steps up and down").
- Seed the random generator from the recording id so the same recording always shows the same tip, which keeps tests deterministic.

```json
{
  "openers": ["Nice work getting this one recorded.", "Here's what stood out.", "Good effort, and here's one thing to try."],
  "closers": ["Try it once and re-record.", "Small change, big difference.", "You've got this."],
  "rules": [{
    "id": "flat_pitch", "category": "pitch", "impact": 1.0, "cooldownDays": 0,
    "variants": [
      { "id": "flat_pitch_1", "tone": "coach",  "text": "Your pitch moved only about {range} steps up and down. Pick the one key word in each sentence and lift your voice on it.", "drillId": "keyword_hunt" },
      { "id": "flat_pitch_2", "tone": "calm",   "text": "Your voice stayed in a narrow range, especially around {time}. Let it rise a little on the words that matter most.", "drillId": "exaggerate_it" },
      { "id": "flat_pitch_3", "tone": "playful", "text": "Imagine reading this to a five-year-old. Your pitch only moved {range} steps, so let that kid hear the excitement.", "drillId": "exaggerate_it" },
      { "id": "flat_pitch_4", "tone": "coach",  "text": "Emphasis lives in pitch. Choose your top three words in this talk and give each a clear lift.", "drillId": "keyword_hunt" }
    ]
  }]
}
```

## Starting tip rules

Implement these 27 rules first. The thresholds are starting values to tune during calibration. Each rule needs 4-6 variants written in the voice rules above; the sample line is the seed for the first variant. `st` means semitones, shown to users as "steps".

| ID | Fires when | What it teaches | Sample line |
| --- | --- | --- | --- |
| `q_too_short` | speech under 10 s | Record a bit longer | "That was a quick one. Try filling the full timer so I can hear your rhythm." |
| `q_noisy` | SNR under 15 dB | Find a quieter spot | "There's background noise here. A quieter corner will give you a fairer score." |
| `q_mic_quiet` | loudest speech under -35 dBFS | Hold the phone closer | "Your voice came in very softly. Try holding the phone about a hand's width away." |
| `q_clipping` | clipping over 1 percent | Back off from the mic | "Some parts were too loud for the mic. Move it a little farther away." |
| `flat_pitch` | `pitchRangeSt` under 4 | Lift on key words | "Your pitch moved about {range} steps. Lift your voice on the one word that matters in each sentence." |
| `narrow_pitch` | range 4 to 6.5 | Use the ends of sentences | "You're close. Try letting the end of your main points rise or fall more clearly." |
| `pitch_too_busy` | range over 18 and movement over 28 st/s | Choose where to move | "Your voice moves a lot. Pick the words that deserve it and keep the rest steadier." |
| `pitch_drift_down` | last-third median pitch 2 st below the first third | Keep landing high | "Your voice sank toward the end. Start your last point as high as your first." |
| `endings_all_fall` | over 80 percent of phrases end falling by 2 st or more | Vary phrase endings | "Almost every phrase ended the same way. Let a few rise, like a question or a cliffhanger." |
| `endings_all_rise` | over 70 percent of phrases end rising | Land statements | "Many phrases ended on a rise, which can sound unsure. Let your key statements land." |
| `pace_fast` | articulation over 6.2 syl/s | Slow down | "You moved at a quick pace. Aim for a short breath at every full stop." |
| `pace_slow` | articulation under 3.2 syl/s | Add energy | "Your pace was relaxed. Try keeping the same clarity at a slightly brisker rhythm." |
| `pace_constant` | `paceCV` under 0.08 | Vary your speed | "Your speed barely changed. Slow down for important ideas, speed up for the easy ones." |
| `rush_start` | first 8 s over 1.25x overall rate | Calm the opening | "Your first few sentences came quickly. Take a breath before you start." |
| `rush_end` | last 8 s over 1.25x overall rate | Finish steadily | "You sped up near the end. Slow down for your closing line so it lands." |
| `no_pauses` | under 2 pauses per min or ratio under 8 percent | Add pauses | "There were hardly any pauses. Try a full second of silence after your main point." |
| `too_many_pauses` | ratio over 40 percent or over 20 per min | Link your ideas | "There were lots of long gaps. A few note cards can help you glide between ideas." |
| `long_pauses` | 2 or more pauses over 2.5 s | Plan the next line | "A couple of long silences around {time}. Jot your next point down so you never lose it." |
| `pauses_same_length` | 5 or more pauses and std under 0.1 s | Vary your pauses | "Your pauses were all about the same length. Make the one before your big idea a bit longer." |
| `flat_volume` | `loudnessRangeDb` under 5 | Use loud and soft | "Your volume stayed very even. Try a little softer for a secret and stronger for a key point." |
| `volume_fade` | last third 4 dB or more below the first | Hold your energy | "Your voice faded as you went on. Take a breath and restart your energy for the last part." |
| `trailing_off` | over 60 percent of phrases drop 6 dB in their last 500 ms | Finish words | "Many sentences trailed off at the end. Aim to finish each one as strongly as it started." |
| `praise_pitch` | pitch sub-score at 80 or above | Praise | "Lovely variety in your voice. It really kept the ear interested." |
| `praise_pauses` | 3 or more medium pauses (0.6-1.5 s) | Praise | "Great use of pauses. They gave your ideas room to land." |
| `praise_improved` | overall at least 5 above previous | Praise | "That's {delta} points up from last time. Your practice is showing." |
| `praise_best` | new personal best | Praise | "A new personal best at {score}. Well done." |
| `praise_first` | first recording | Welcome | "You did the hardest part, which is starting. Here's one thing to try next." |

The `endings_*`, `rush_*` and `trailing_off` rules need a phrase list. Build phrases from the speech segments produced by the VAD, splitting at pauses of 400 ms or more, and measure the last 300 ms of each phrase.

## AI coach and server

The coach turns the same numbers the rules use into personal feedback. The model never hears the audio. It receives about 500 tokens of metrics and returns structured JSON, which keeps cost and privacy risk low.

```text
App  --(signed entitlement token + metrics JSON)-->  Worker /v1/coach  -->  LLM provider
App  <--(validated JSON, or 429/5xx)--               Worker              (key lives only here)
```

**Worker endpoints** (one Cloudflare Worker, D1 for storage):

| Route | Purpose |
| --- | --- |
| `GET /v1/config` | Remote kill switch, current prompt version, quota numbers. Cached on the device for 1 hour. |
| `POST /v1/event` | Anonymous usage events, batched (see Usage and revenue tracking). |
| `POST /v1/coach` | Flagged. Verify token, enforce quotas, call the LLM, validate and return JSON. |
| `POST /v1/revenue-webhook` | Flagged. Receives purchase events from the billing provider. |
| `POST /v1/telegram` | Telegram bot webhook for `/stats`, `/week`, `/revenue`. |

**Provider adapter.** `interface CoachProvider { complete(req): Promise<CoachReply> }` with one implementation for the chosen free-tier model. The model name and key are Worker environment variables, so switching provider never needs an app update. Evaluate Cloudflare Workers AI too, since it keeps everything on one platform and has a free daily allowance (verify the current limits).

**Request body** (max 2 KB, rejected if larger): `installId`, `promptVersion`, `language`, `goal`, the `analysis_results` metrics and sub-scores, the same metrics from the previous recording, and the last 3 coach summaries (one sentence each). No audio, no transcript, no name.

**Response schema** (the Worker validates it and retries once on invalid JSON):

```json
{ "summary": "2 sentences",
  "praise": "1 sentence about something that went well",
  "focus": { "title": "short", "why": "1-2 sentences", "steps": ["...", "...", "..."] },
  "plan": [{ "day": 1, "drillId": "pause_power", "minutes": 5 }] }
```

**System prompt (v1 draft).** "You are a warm, encouraging speaking coach. You receive measurements of one practice recording. Describe the delivery, never judge the person. Give exactly one focus area and one thing that went well. Use plain words and no jargon. Only recommend drills from this list: \<drill ids>. Do not mention numbers the user cannot see. Reply with JSON matching the schema and nothing else."

**Guardrails.**

- **Quotas:** per install per day and per month, plus a global daily cap stored in D1 so the shared free key is never exhausted. When a cap is hit, return 429 and the app shows the rule-based tips with "The coach is resting, try again later".
- **Timeouts:** 8 seconds, then fall back to rule-based tips. The app must work fully with the Worker offline.
- **Entitlements:** the billing provider's webhook (or Play purchase-token verification) marks an install as `plus` in D1. The Worker issues a signed token (HMAC, 24 hour life) that the app stores in `entitlements.token`. `/v1/coach` rejects requests without a valid token.
- **Secrets:** the LLM key, Telegram token and signing secret are Worker secrets, never in the app or the repo.
- **Before charging anyone:** read the provider's free-tier terms. Some limit commercial use, restrict some regions, or use prompts for model improvement. If the terms do not allow a paid product, move to a provider that does and keep the adapter as is.

## Usage and revenue tracking

The app stays local-first, so the only server-side data is anonymous counters. No audio, scores, transcripts or names are ever sent. Show a clear consent screen on first run and an opt-out switch in Settings, and write the privacy policy before the store listing.

**Events** (batched, sent at most once an hour, queued offline, identified by a random `install_id` stored in `settings`, never a device ID):

| Event | Sent when | Extra fields |
| --- | --- | --- |
| `install` | First launch | app version, platform, language |
| `session_start` | App opens, at most once a day | app version |
| `recording_done` | Analysis finished | duration bucket, overall score bucket (0-39, 40-59, 60-79, 80-100) |
| `drill_done` | Drill completed | `drill_id`, passed |
| `tip_feedback` | Helpful or not tapped | `rule_id`, helpful |
| `paywall_view`, `purchase_start` | Flagged, later | product id |

The Worker adds the country from Cloudflare's request header and discards the IP address.

**D1 tables** (`worker/schema.sql`):

```sql
CREATE TABLE installs (install_id TEXT PRIMARY KEY, first_seen INTEGER, last_seen INTEGER,
  country TEXT, platform TEXT, app_version TEXT, language TEXT);
CREATE TABLE activity (day TEXT, install_id TEXT, PRIMARY KEY (day, install_id));  -- one row per active user per day
CREATE TABLE events_daily (day TEXT, event TEXT, key TEXT, count INTEGER, PRIMARY KEY (day, event, key));
CREATE TABLE revenue_events (id TEXT PRIMARY KEY, install_id TEXT, product_id TEXT, type TEXT,
  amount_minor INTEGER, currency TEXT, period_months INTEGER, ts INTEGER, source TEXT);
CREATE TABLE subscriptions (install_id TEXT, product_id TEXT, status TEXT, started INTEGER, ends INTEGER,
  price_minor INTEGER, currency TEXT, period_months INTEGER, PRIMARY KEY (install_id, product_id));
```

**Metric definitions** (compute them in SQL inside the Worker):

- **DAU / WAU / MAU:** distinct `install_id` in `activity` over the last 1, 7 and 30 days.
- **Activation:** installs with at least one `recording_done` within 24 hours of `install`.
- **Retention D1 / D7 / D30:** share of an install-day cohort that is active exactly 1, 7 and 30 days later.
- **MRR:** sum over active subscriptions of `price_minor / period_months`, converted to one reporting currency at a rate set in config. **ARR = MRR x 12.**
- **Churn (monthly):** subscriptions that ended in the month divided by subscriptions active at its start.
- **ARPU / conversion:** MRR divided by MAU, and active paying installs divided by MAU.
- **Revenue:** sum of `revenue_events` of type `purchase` or `renewal`, minus `refund`, per day and per month.

**Telegram bot** (a second use of the same Worker, no extra hosting):

- Create the bot with BotFather. Store the token as a Worker secret and set the webhook to `/v1/telegram`.
- The bot answers **only your own chat ID** and ignores everyone else. Commands: `/stats` (installs, DAU, WAU, MAU, D1 and D7 retention), `/week` (the last 7 days by day), `/revenue` (MRR, ARR, revenue this month, active subscribers).
- A Worker cron trigger sends a daily digest at 08:00 Africa/Addis\_Ababa (05:00 UTC), for example: "Installs 12 (+3), DAU 41, D7 retention 24%, recordings 96, MRR 0".
- **Backup:** the analytics database is small aggregate data. A weekly cron can send one compressed JSON export as a Telegram document, which works up to about 50 MB (verify the limit). Only add chunking if an export ever approaches that size.
- **Revenue ingestion (later):** the billing provider calls `/v1/revenue-webhook` with a secret header. Verify it, write to `revenue_events` and `subscriptions`, and the bot reports it with no further code. RevenueCat has a free tier up to a monthly revenue threshold (verify).

## Design system

The feel is warm, bold and encouraging: sunny yellow against deep black, rounded shapes, big friendly buttons, and copy that sounds like a patient friend. Build every color as a token in a `ThemeExtension` so a theme is data, not code.

**Core palette (Honey, the default).**

| Token | Light | Dark |
| --- | --- | --- |
| `primary` (sun) | `#FFC629` | `#FFC629` |
| `onPrimary` | `#111111` | `#111111` |
| `background` | `#FFFBF0` | `#0F0F0E` |
| `surface` | `#FFFFFF` | `#1A1917` |
| `surfaceAlt` | `#FFF1C7` | `#262421` |
| `text` | `#111111` | `#F5F1E6` |
| `textMuted` | `#6B6558` | `#A8A294` |
| `growth` (good) | `#2FA866` | `#4CC98A` |
| `roomToGrow` (needs work) | `#E8890C` | `#F5A03A` |

Always put black text on yellow, never white. Do not use red anywhere for scores.

**Extra themes, all free at launch** (same tokens, different accent): *Ember* (coral `#FF7A59` on charcoal), *Meadow* (green `#58B368` on cream), *Dusk* (violet `#9B87F5` on near-black). Each has a light and a dark variant. Later, themes can become a cheap reward or perk without touching code.

**Type and shape.** A rounded sans such as Nunito for headings and body, with Noto Sans Ethiopic as the Amharic fallback. Bundle the font files in `assets/fonts` so the app works offline. Corner radius 20-28 dp, pill buttons, minimum 48 dp touch targets, 16 dp base spacing, generous whitespace.

**Screens.**

1. **Onboarding** (3 steps): welcome and optional name, pick a goal (sound more lively, calm my nerves, prepare a talk), microphone permission with a plain explanation that audio stays on the phone.
2. **Home:** today's drill card, a large Record button, streak, last score.
3. **Record:** prompt card, a 30 s / 60 s mode switch, a countdown ring, live waveform. Big yellow circle with a black mic that gently pulses.
4. **Analyzing:** a 2-4 second animated moment, never a bare spinner.
5. **Results:** animated score count-up, four rings, the pitch contour drawing left to right with a faint ghost line showing a livelier version, replay with tappable pause and focus markers, one focus tip and one praise tip with Helpful buttons.
6. **Practice:** drill library with the 8 drills below.
7. **Progress:** score timeline, personal bests, a calendar of practice days.
8. **Settings:** theme, dark mode, language, reminder time, analytics opt-out, export my data, delete my data, About.
9. **Flagged:** Coach feedback screen, Ask the coach, Paywall.

**Motion and personality.** Haptic tap on record start and stop. Rings fill with a springy ease. A quiet sparkle on a new personal best, with no confetti storms. Streaks are called a "sunrise streak" ("Day 4 of your sunrise streak"). Respect the system reduce-motion setting by turning animations into simple fades.

**Voice of the app.** Second person, warm, short. Say "Room to grow", never "weak". Celebrate showing up. Use the name from onboarding sparingly.

**Accessibility.** Every chart has a one-sentence text summary for screen readers, text scales with the system font size, contrast of at least 4.5:1 everywhere (black on the sun yellow is far above that), and all strings come from ARB files for English and Amharic.

## Build phases

Each phase ends when its acceptance checks pass. Give the coding agent one phase at a time.

**Phase 0: foundation**

- [ ] Flutter project, Riverpod, go\_router, drift schema from the Data model section, migrations
- [ ] Theme tokens for all four themes in light and dark, `FeatureFlags`, ARB files for `en` and `am`
- [ ] Check: app launches on a real Android phone, themes switch live, database opens and migrates

**Phase 1: record and analyze**

- [ ] Recorder screen with the 30 s / 60 s mode switch, auto-stop countdown and WAV capture with the settings in the Audio pipeline
- [ ] DSP in an isolate: energy, VAD, pauses, YIN, contour cleaning, syllable rate, quality gates
- [ ] Unit tests with synthetic audio: sine tones at known pitch (error under 1 semitone), a glide from 120 to 240 Hz, tones separated by silences (pauses detected within 50 ms), amplitude ramps (dB trend correct), a white-noise clip (rejected by the quality gate)
- [ ] Check: A 60 s clip analyzes in under 3 s on a low-end Android phone, and the UI stays at 60 fps while it runs

**Phase 2: results, scoring and tips**

- [ ] `scoring_config.json` loader and scorer with unit tests for each band edge
- [ ] Results screen with rings and the pitch contour painter
- [ ] Tip engine with the 27 rules, 4 or more variants each, and openers and closers
- [ ] Tests: a seeded recording always yields the same tip, no variant repeats within 10 shows of its rule, the quality tip pre-empts everything, cooldowns work
- [ ] Check: ten different test recordings give at least five different focus tips

**Phase 3: practice habit**

- [ ] The 8 drills below with prompt text banks, drill player and pass criteria
- [ ] Home screen, streaks (`daily_activity`), progress screen, daily reminder notification
- [ ] Settings: export and delete all data

| Drill | What the user does | Passes when |
| --- | --- | --- |
| `exaggerate_it` | Read a paragraph as if to a small child | `pitchRangeSt` at least 9 |
| `keyword_hunt` | Highlight one key word per sentence, then read lifting on it | Movement at least 8 st/s |
| `pause_power` | Read with a full second of silence at every full stop | At least 4 medium pauses |
| `pace_ladder` | Read the same text slow, normal, then brisk | Three distinct rates at least 15% apart |
| `strong_finish` | End each sentence as strongly as it began | `trailing_off` does not fire |
| `rise_and_fall` | Alternate questions and statements | Both rising and falling endings present |
| `story_beat` | Tell a 60 s story with three feelings | Overall score at least 60 |
| `one_minute_pitch` | Pitch an idea from a random prompt | Recording of at least 45 s in 60 s mode |

**Phase 4: telemetry and bot**

- [ ] Worker with `/v1/config`, `/v1/event`, D1 schema, consent screen, opt-out
- [ ] Telegram bot with `/stats`, `/week`, `/revenue`, the daily digest, and the weekly export
- [ ] Check: your own installs appear in `/stats` within an hour, and nothing is sent when opted out

**Phase 5: calibration and closed beta**

- [ ] Run the calibration test from the Scoring section and update the config
- [ ] Give 10-15 beta users the APK, collect "helpful" taps and a short survey, and tune bands and tips

**Phase 6: launch (Android)**

- [ ] Privacy policy, data-safety form, store listing. The Play Console has a one-time registration fee (verify the amount), and new personal accounts have had a closed-testing requirement before production access (verify). Until then share the APK in a Telegram channel or GitHub release.

**Phase 7: switch on Plus (after feedback)**

- [ ] Build `/v1/coach`, the coach screens, the paywall and `PlusEntitlements` behind `FeatureFlags.aiCoach`, tested with a staging flag
- [ ] Choose the billing route that works for your country, wire the webhook, then flip the flag
- [ ] Later: the stutter-friendly practice mode, developed with a speech-language pathologist

## Risks and things to verify

| Risk | Why it matters | What to do |
| --- | --- | --- |
| Scores that feel wrong | The whole product depends on the score matching what people hear | Run the calibration test and keep bands in the config file |
| Pitch errors on cheap mics or in noise | Octave jumps and false voicing distort the contour | Test on at least 5 phones, keep the octave filter and the quality gates |
| Free LLM key limits and terms | The quota is shared by all users and some free tiers restrict paid products | Keep rule-based tips as the always-on fallback, read the terms before charging, keep the provider adapter |
| Taking payments from Ethiopia | Global billing and payout options may not cover your country (verify) | Research billing and payout options early, in Phase 5, before building the paywall |
| Telegram, Cloudflare and RevenueCat free-tier limits | They change over time | Verify each limit on the provider's current page before relying on it |
| Syllable-based pace is approximate | Languages differ in syllable rates | Label words per minute as approximate, add per-language profiles |
| Microphone permission denied | Users get stuck on the record screen | Explain why on a settings-redirect screen |
| Wording that sounds like treatment | Medical claims carry legal risk | Describe it as practice and coaching and suggest a speech therapist for speech disorders |
| Privacy | Voice recordings are sensitive and local data protection law applies | Keep audio on the device, minimize analytics, publish a clear policy, check local rules |

**First test to run, before writing the full app:** a throwaway Flutter screen that records 30 seconds, runs YIN in an isolate and draws the contour. If that works smoothly on your own phone, every other piece in this spec is routine.
