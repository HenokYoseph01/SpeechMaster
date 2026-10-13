// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'የንግግር አሰልጣኝ';

  @override
  String get welcomeTitle => 'ለድምፅዎ ቦታ ይስጡ';

  @override
  String get welcomeBody => 'በየቀኑ ትንሽ ልምምድ።';

  @override
  String get settings => 'ቅንብሮች';

  @override
  String get appearance => 'ለእርስዎ የሚስማማ ያድርጉት';

  @override
  String get theme => 'ገጽታ';

  @override
  String get honey => 'ማር';

  @override
  String get ember => 'ፍም';

  @override
  String get meadow => 'መስክ';

  @override
  String get dusk => 'ምሽት';

  @override
  String get displayMode => 'ማሳያ';

  @override
  String get system => 'የመሣሪያውን ቅንብር ይጠቀሙ';

  @override
  String get light => 'ብርሃን';

  @override
  String get dark => 'ጨለማ';

  @override
  String get language => 'ቋንቋ';

  @override
  String get english => 'English';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get pageNotFound => 'ወደ መነሻ እንመለስ';

  @override
  String get home => 'መነሻ';

  @override
  String get startingApp => 'የልምምድ ቦታዎን በማዘጋጀት ላይ…';

  @override
  String get storageOpenFailed => 'የልምምድ ቦታዎን መክፈት አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get settingsSaveFailed => 'ለውጦችዎን ማስቀመጥ አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get retry => 'እንደገና ይሞክሩ';

  @override
  String get record => 'ይቅረጹ';

  @override
  String get recordTitle => 'ድምፅዎን ትንሽ ያለማምዱ';

  @override
  String get recordPrivacy =>
      'ቅጂዎ በዚህ ስልክ ላይ ይቀመጣል። ማይክሮፎኑን የድምፅዎን ቅላፄ እንቅስቃሴ ለመሳል እንጠቀማለን።';

  @override
  String durationSeconds(int seconds) {
    return '$seconds ሰ';
  }

  @override
  String secondsRemaining(int seconds) {
    return '$seconds ሰከንዶች ቀርተዋል';
  }

  @override
  String get startRecording => 'መቅረጽ ይጀምሩ';

  @override
  String get recordAgain => 'እንደገና ይለማመዱ';

  @override
  String get stopRecording => 'ቀረጻውን ያጠናቅቁ';

  @override
  String stopAfterSeconds(int seconds) {
    return 'ከ$seconds ሰከንዶች በኋላ ማጠናቀቅ ይችላሉ።';
  }

  @override
  String get discardRecording => 'ቀረጻውን ይሰርዙ';

  @override
  String get recordingNow => 'በራስዎ ፍጥነት ይናገሩ';

  @override
  String get preparingMicrophone => 'ማይክሮፎንዎን በማዘጋጀት ላይ…';

  @override
  String get finishingRecording => 'ቀረጻዎን በማጠናቀቅ ላይ…';

  @override
  String get analyzingPitch => 'የድምፅዎን እንቅስቃሴ በመሳል ላይ…';

  @override
  String get discardingRecording => 'ይህን ቅጂ በማስወገድ ላይ…';

  @override
  String get microphoneDenied =>
      'የማይክሮፎን ፈቃድ ተዘግቷል። በስልክዎ የመተግበሪያ ቅንብሮች ውስጥ ያብሩት፣ ከዚያ ተመልሰው ይሞክሩ።';

  @override
  String get openAppSettings => 'የመተግበሪያ ቅንብሮችን ይክፈቱ';

  @override
  String get recordingInterrupted => 'ያ ቀረጻ ተቋርጧል። እንደገና እንሞክር።';

  @override
  String get recordingFailed => 'ቀረጻውን መጀመር ወይም ማጠናቀቅ አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get pitchAnalysisFailed =>
      'ድምፅዎ አሁንም በዚህ ስልክ ላይ ነው። የቅላፄ ግራፉን ማጠናቀቅ አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get recordingSaveFailed =>
      'ድምፅዎ አሁንም በዚህ ስልክ ላይ ነው። ወደ ልምምድዎ ማከል አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get retryPitchAnalysis => 'ግራፉን እንደገና ይሳሉ';

  @override
  String get recordingSaved => 'ልምምድዎ በዚህ ስልክ ላይ ተቀምጧል።';

  @override
  String get pitchChartTitle => 'ቅላፄዎ እንዴት ተንቀሳቀሰ';

  @override
  String get pitchChartExplanation =>
      'መስመሩ ከመደበኛ ቅላፄዎ አንፃር መውጣትና መውረድን ያሳያል። ክፍተቶች ግልጽ ቅላፄ የሌላቸው ጊዜያት ናቸው።';

  @override
  String get noPitchFound =>
      'መስመር ለመሳል የሚበቃ ግልጽ ቅላፄ አልተገኘም። በፀጥታ ቦታ ወደ ማይክሮፎኑ ትንሽ ቀርበው ለመናገር ይሞክሩ።';

  @override
  String pitchSummary(String low, String high, int seconds) {
    return 'በ$seconds ሰከንዶች ውስጥ፣ ቅላፄዎ ከመደበኛ ቅላፄዎ አንፃር ከ$low እስከ $high ሴሚቶኖች ተንቀሳቅሷል።';
  }

  @override
  String get microphoneLevel => 'የማይክሮፎን ድምፅ ደረጃ';

  @override
  String get recordingDuration => 'የቀረጻ ርዝመት';
}
