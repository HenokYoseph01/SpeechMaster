// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Speech Coach';

  @override
  String get welcomeTitle => 'Make room for your voice';

  @override
  String get welcomeBody => 'A little practice, one day at a time.';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Make it yours';

  @override
  String get theme => 'Theme';

  @override
  String get honey => 'Honey';

  @override
  String get ember => 'Ember';

  @override
  String get meadow => 'Meadow';

  @override
  String get dusk => 'Dusk';

  @override
  String get displayMode => 'Display';

  @override
  String get system => 'Use device setting';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get pageNotFound => 'Let\'s head back';

  @override
  String get home => 'Home';

  @override
  String get startingApp => 'Getting your practice space ready…';

  @override
  String get storageOpenFailed =>
      'Your practice space couldn\'t open. Please try again.';

  @override
  String get settingsSaveFailed =>
      'Your changes couldn\'t be saved. Please try again.';

  @override
  String get retry => 'Try again';

  @override
  String get record => 'Record';

  @override
  String get recordTitle => 'Give your voice a little practice';

  @override
  String get recordPrivacy =>
      'Your recording stays on this phone. We measure pitch, pace, pauses, and volume locally.';

  @override
  String durationSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String secondsRemaining(int seconds) {
    return '$seconds seconds left';
  }

  @override
  String get startRecording => 'Start recording';

  @override
  String get recordAgain => 'Practice again';

  @override
  String get stopRecording => 'Finish recording';

  @override
  String stopAfterSeconds(int seconds) {
    return 'You can finish after $seconds seconds.';
  }

  @override
  String get discardRecording => 'Discard recording';

  @override
  String get recordingNow => 'Speak at your own pace';

  @override
  String get preparingMicrophone => 'Getting your microphone ready…';

  @override
  String get finishingRecording => 'Finishing your recording…';

  @override
  String get analyzingPitch => 'Listening for pitch, pace, pauses, and volume…';

  @override
  String get discardingRecording => 'Putting that take aside…';

  @override
  String get microphoneDenied =>
      'Microphone access is off. Enable it in your phone\'s app settings, then come back and try again.';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get recordingInterrupted =>
      'That recording was interrupted. Let\'s try again.';

  @override
  String get recordingFailed =>
      'The recording couldn\'t start or finish. Please try again.';

  @override
  String get pitchAnalysisFailed =>
      'Your audio is still on this phone. The analysis couldn\'t finish. Please try again.';

  @override
  String get recordingSaveFailed =>
      'Your audio is still on this phone. It couldn\'t be added to your practice. Please try again.';

  @override
  String get retryPitchAnalysis => 'Try the analysis again';

  @override
  String get recordingSaved => 'Your practice is saved on this phone.';

  @override
  String get pitchChartTitle => 'How your pitch moved';

  @override
  String get pitchChartExplanation =>
      'The line shows rises and falls relative to your usual tone. Gaps are moments without a clear pitch.';

  @override
  String get noPitchFound =>
      'There wasn\'t enough clear pitch to draw a line. Try speaking a little closer to the microphone in a quiet place.';

  @override
  String pitchSummary(String low, String high, int seconds) {
    return 'Your pitch moved from $low to $high semitones relative to your usual tone over $seconds seconds.';
  }

  @override
  String get microphoneLevel => 'Live microphone level';

  @override
  String get recordingDuration => 'Recording length';

  @override
  String get deliverySummaryTitle => 'Your delivery at a glance';

  @override
  String get deliveryPreviewNote =>
      'These are measurements for now. Your practice doesn\'t have a score yet.';

  @override
  String get deliveryQualityTitle => 'For a clearer next take';

  @override
  String get qualityMoreSpeech =>
      'Try speaking for a little longer so there is enough speech to measure.';

  @override
  String get qualityQuieterRoom =>
      'Background sound is close to your voice level. Try a quieter spot.';

  @override
  String get qualityStepBack =>
      'Some sound reached the microphone\'s limit. Try speaking naturally a little farther away.';

  @override
  String get qualityMoveCloser =>
      'The recording is quiet. Try moving a little closer to the microphone.';

  @override
  String detectedSpeech(String seconds) {
    return 'Speech detected: $seconds s';
  }

  @override
  String deliveryPauses(int count, String seconds) {
    return '$count detected pauses, lasting $seconds s in total';
  }

  @override
  String deliveryPauseKinds(int short, int medium, int long) {
    return '$short short, $medium medium, $long long';
  }

  @override
  String deliveryPauseShare(String percent) {
    return 'Time in pauses: $percent';
  }

  @override
  String deliverySpeakingRate(String rate) {
    return 'Estimated pace: $rate syllables/s';
  }

  @override
  String deliveryArticulationRate(String rate) {
    return 'While speaking: $rate syllables/s';
  }

  @override
  String deliveryApproximateWpm(String rate) {
    return 'Approximately $rate words/min for English';
  }

  @override
  String deliveryPaceVariation(String percent) {
    return 'Pace variation: $percent';
  }

  @override
  String deliveryVolumeRange(String range) {
    return 'Volume variation: $range dB';
  }

  @override
  String deliveryEnergyTrend(String trend) {
    return 'Ending energy: $trend dB compared with the start';
  }

  @override
  String deliveryPitchRange(String range) {
    return 'Pitch range: $range semitones';
  }

  @override
  String get deliveryPitchLimited =>
      'Some pitch measurements aren\'t available. The chart can still show clear segments.';

  @override
  String get deliveryPaceUnavailable =>
      'There weren\'t enough voiced sounds to estimate pace.';

  @override
  String get deliveryPaceExplanation =>
      'Pace and pauses are estimates. Replay a marked gap to check it. Opening and closing silence aren\'t counted as pauses.';

  @override
  String get deliveryNoiseUncertain =>
      'There wasn\'t enough background-only audio to estimate room noise reliably.';

  @override
  String get replayTitle => 'Listen back';

  @override
  String get replayExplanation =>
      'Tap a detected pause to hear it with the words around it. Your audio stays on this phone.';

  @override
  String get playRecording => 'Play recording';

  @override
  String get pausePlayback => 'Pause playback';

  @override
  String get playbackFailed =>
      'The recording couldn\'t play. Tap Play to try again.';

  @override
  String replayPosition(String position, String duration) {
    return '$position / $duration s';
  }

  @override
  String get pauseMarkersTitle => 'Detected pause moments';

  @override
  String get noDetectedPauses => 'No internal pauses detected.';

  @override
  String pauseMarker(String start, String end) {
    return '$start–$end s';
  }
}
