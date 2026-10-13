import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech Coach'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Make room for your voice'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A little practice, one day at a time.'**
  String get welcomeBody;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @honey.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get honey;

  /// No description provided for @ember.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get ember;

  /// No description provided for @meadow.
  ///
  /// In en, this message translates to:
  /// **'Meadow'**
  String get meadow;

  /// No description provided for @dusk.
  ///
  /// In en, this message translates to:
  /// **'Dusk'**
  String get dusk;

  /// No description provided for @displayMode.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displayMode;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'Use device setting'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'አማርኛ'**
  String get amharic;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Let\'s head back'**
  String get pageNotFound;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @startingApp.
  ///
  /// In en, this message translates to:
  /// **'Getting your practice space ready…'**
  String get startingApp;

  /// No description provided for @storageOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Your practice space couldn\'t open. Please try again.'**
  String get storageOpenFailed;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your changes couldn\'t be saved. Please try again.'**
  String get settingsSaveFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @recordTitle.
  ///
  /// In en, this message translates to:
  /// **'Give your voice a little practice'**
  String get recordTitle;

  /// No description provided for @recordPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your recording stays on this phone. We use the microphone to draw how your pitch moves.'**
  String get recordPrivacy;

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationSeconds(int seconds);

  /// No description provided for @secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds left'**
  String secondsRemaining(int seconds);

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @recordAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice again'**
  String get recordAgain;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Finish recording'**
  String get stopRecording;

  /// No description provided for @stopAfterSeconds.
  ///
  /// In en, this message translates to:
  /// **'You can finish after {seconds} seconds.'**
  String stopAfterSeconds(int seconds);

  /// No description provided for @discardRecording.
  ///
  /// In en, this message translates to:
  /// **'Discard recording'**
  String get discardRecording;

  /// No description provided for @recordingNow.
  ///
  /// In en, this message translates to:
  /// **'Speak at your own pace'**
  String get recordingNow;

  /// No description provided for @preparingMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Getting your microphone ready…'**
  String get preparingMicrophone;

  /// No description provided for @finishingRecording.
  ///
  /// In en, this message translates to:
  /// **'Finishing your recording…'**
  String get finishingRecording;

  /// No description provided for @analyzingPitch.
  ///
  /// In en, this message translates to:
  /// **'Drawing the movement in your voice…'**
  String get analyzingPitch;

  /// No description provided for @discardingRecording.
  ///
  /// In en, this message translates to:
  /// **'Putting that take aside…'**
  String get discardingRecording;

  /// No description provided for @microphoneDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is off. Enable it in your phone\'s app settings, then come back and try again.'**
  String get microphoneDenied;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @recordingInterrupted.
  ///
  /// In en, this message translates to:
  /// **'That recording was interrupted. Let\'s try again.'**
  String get recordingInterrupted;

  /// No description provided for @recordingFailed.
  ///
  /// In en, this message translates to:
  /// **'The recording couldn\'t start or finish. Please try again.'**
  String get recordingFailed;

  /// No description provided for @pitchAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Your audio is still on this phone. The pitch chart couldn\'t finish. Please try again.'**
  String get pitchAnalysisFailed;

  /// No description provided for @recordingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your audio is still on this phone. It couldn\'t be added to your practice. Please try again.'**
  String get recordingSaveFailed;

  /// No description provided for @retryPitchAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Try drawing the chart again'**
  String get retryPitchAnalysis;

  /// No description provided for @recordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Your practice is saved on this phone.'**
  String get recordingSaved;

  /// No description provided for @pitchChartTitle.
  ///
  /// In en, this message translates to:
  /// **'How your pitch moved'**
  String get pitchChartTitle;

  /// No description provided for @pitchChartExplanation.
  ///
  /// In en, this message translates to:
  /// **'The line shows rises and falls relative to your usual tone. Gaps are moments without a clear pitch.'**
  String get pitchChartExplanation;

  /// No description provided for @noPitchFound.
  ///
  /// In en, this message translates to:
  /// **'There wasn\'t enough clear pitch to draw a line. Try speaking a little closer to the microphone in a quiet place.'**
  String get noPitchFound;

  /// No description provided for @pitchSummary.
  ///
  /// In en, this message translates to:
  /// **'Your pitch moved from {low} to {high} semitones relative to your usual tone over {seconds} seconds.'**
  String pitchSummary(String low, String high, int seconds);

  /// No description provided for @microphoneLevel.
  ///
  /// In en, this message translates to:
  /// **'Live microphone level'**
  String get microphoneLevel;

  /// No description provided for @recordingDuration.
  ///
  /// In en, this message translates to:
  /// **'Recording length'**
  String get recordingDuration;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
