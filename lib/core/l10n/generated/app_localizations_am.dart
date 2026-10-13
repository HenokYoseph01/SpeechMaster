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
      'ቅጂዎ በዚህ ስልክ ላይ ይቀመጣል። ቅላፄን፣ ፍጥነትን፣ እረፍቶችንና የድምፅ መጠንን በስልኩ ላይ እንለካለን።';

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
  String get analyzingPitch => 'ቅላፄን፣ ፍጥነትን፣ እረፍቶችንና የድምፅ መጠንን በመተንተን ላይ…';

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
      'ድምፅዎ አሁንም በዚህ ስልክ ላይ ነው። ትንተናውን ማጠናቀቅ አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get recordingSaveFailed =>
      'ድምፅዎ አሁንም በዚህ ስልክ ላይ ነው። ወደ ልምምድዎ ማከል አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get retryPitchAnalysis => 'ትንተናውን እንደገና ይሞክሩ';

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

  @override
  String get deliverySummaryTitle => 'የንግግርዎ አጭር መግለጫ';

  @override
  String get deliveryPreviewNote => 'እነዚህ ለአሁኑ መለኪያዎች ናቸው። ልምምድዎ ገና ውጤት የለውም።';

  @override
  String get deliveryQualityTitle => 'ለቀጣይ ግልጽ ቅጂ';

  @override
  String get qualityMoreSpeech => 'ለመለካት የሚበቃ ንግግር እንዲኖር ትንሽ ረዘም ብለው ይናገሩ።';

  @override
  String get qualityQuieterRoom =>
      'የጀርባ ድምፅ ከእርስዎ ድምፅ መጠን ጋር ተቀራራቢ ነው። ይበልጥ ፀጥ ያለ ቦታ ይሞክሩ።';

  @override
  String get qualityStepBack =>
      'አንዳንድ ድምፆች የማይክሮፎኑን ከፍተኛ ወሰን ነክተዋል። ትንሽ ራቅ ብለው በተፈጥሮ ድምፅዎ ይናገሩ።';

  @override
  String get qualityMoveCloser => 'ቅጂው ዝቅተኛ ድምፅ አለው። ወደ ማይክሮፎኑ ትንሽ ይቅረቡ።';

  @override
  String detectedSpeech(String seconds) {
    return 'የተገኘ ንግግር፦ $seconds ሰ';
  }

  @override
  String deliveryPauses(int count, String seconds) {
    return '$count እረፍቶች፣ በድምሩ $seconds ሰ';
  }

  @override
  String deliveryPauseKinds(int short, int medium, int long) {
    return '$short አጫጭር፣ $medium መካከለኛ፣ $long ረጅም';
  }

  @override
  String deliveryPauseShare(String percent) {
    return 'በእረፍት ያለፈ ጊዜ፦ $percent';
  }

  @override
  String deliverySpeakingRate(String rate) {
    return 'የተገመተ ፍጥነት፦ $rate ክፍለ ድምፆች/ሰ';
  }

  @override
  String deliveryArticulationRate(String rate) {
    return 'በመናገር ጊዜ፦ $rate ክፍለ ድምፆች/ሰ';
  }

  @override
  String deliveryApproximateWpm(String rate) {
    return 'ለእንግሊዝኛ በግምት $rate ቃላት/ደቂቃ';
  }

  @override
  String deliveryPaceVariation(String percent) {
    return 'የፍጥነት ልዩነት፦ $percent';
  }

  @override
  String deliveryVolumeRange(String range) {
    return 'የድምፅ መጠን ልዩነት፦ $range dB';
  }

  @override
  String deliveryEnergyTrend(String trend) {
    return 'የመጨረሻ ድምፅ ከመጀመሪያው አንፃር፦ $trend dB';
  }

  @override
  String deliveryPitchRange(String range) {
    return 'የቅላፄ ክልል፦ $range ሴሚቶኖች';
  }

  @override
  String get deliveryPitchLimited =>
      'አንዳንድ የቅላፄ መለኪያዎች አልተገኙም። ግራፉ ግልጽ ክፍሎችን አሁንም ማሳየት ይችላል።';

  @override
  String get deliveryPaceUnavailable => 'ፍጥነትን ለመገመት የሚበቁ ባለቅላፄ ድምፆች አልተገኙም።';

  @override
  String get deliveryPaceExplanation =>
      'ፍጥነት ከባለቅላፄ ድምፆች ይገመታል። ግልጽ ያልሆኑ ድምፆች ሊያመልጡ ይችላሉ፤ ይህ የቃላት ቆጠራ አይደለም። በመጀመሪያና በመጨረሻ ያለው ዝምታ እንደ እረፍት አይቆጠርም።';
}
