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
      'Your recording stays on this phone. We use the microphone to draw how your pitch moves.';

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
  String get analyzingPitch => 'Drawing the movement in your voice…';

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
      'Your audio is still on this phone. The pitch chart couldn\'t finish. Please try again.';

  @override
  String get recordingSaveFailed =>
      'Your audio is still on this phone. It couldn\'t be added to your practice. Please try again.';

  @override
  String get retryPitchAnalysis => 'Try drawing the chart again';

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
}
