class AudioConfig {
  AudioConfig.fromJson(Map<String, dynamic> json)
    : values = Map.unmodifiable(json) {
    for (final key in _integerKeys) {
      final value = values[key];
      if (value is! num ||
          !value.isFinite ||
          value != value.toInt() ||
          value <= 0) {
        throw FormatException('Expected a positive integer for $key');
      }
    }
    for (final key in {...values.keys, ..._integerKeys, ..._numberKeys}) {
      final value = values[key];
      if (value is! num ||
          !value.isFinite ||
          (!_negativeKeys.contains(key) && value <= 0)) {
        throw const FormatException(
          'Audio settings must be positive finite numbers',
        );
      }
    }
    if (captureSampleRate != 16000 ||
        pitchSampleRate != 8000 ||
        minimumRecordingMs != 10000 ||
        waveformFloorDb >= 0 ||
        qualityQuietFrameDb >= 0 ||
        syllableMinimumDb >= 0 ||
        neuralVadThreshold >= 1 ||
        neuralVadWindowSamples != 512 ||
        lowPassTaps < 3 ||
        lowPassTaps.isEven ||
        energyMedianFrames.isEven ||
        pitchMedianFrames.isEven ||
        pitchAverageFrames.isEven ||
        lowPassCutoffHz >= pitchSampleRate / 2 ||
        pitchMinimumHz >= pitchMaximumHz ||
        yinThreshold >= 1 ||
        minimumVoicedRatio > 1 ||
        chartMinimumVoicedRatio > minimumVoicedRatio ||
        noiseFloorPercentile > 100 ||
        clippingSampleThreshold > 1 ||
        qualityMaximumClippingPct > 100 ||
        pauseMinimumMs >= pauseShortUpperMs ||
        pauseShortUpperMs >= pauseMediumUpperMs ||
        syllableBandLowHz >= syllableBandHighHz ||
        syllableBandHighHz >= captureSampleRate / 2 ||
        syllableSmoothMs < energyHopMs ||
        paceMinimumSpeechMs > paceWindowMs ||
        pitchRangeLowPercentile >= pitchRangeHighPercentile ||
        pitchRangeHighPercentile > 100 ||
        loudnessLowPercentile >= loudnessHighPercentile ||
        loudnessHighPercentile > 100 ||
        qualitySnrPercentile > 100 ||
        energyHopMs > energyFrameMs ||
        pitchHopMs > pitchFrameMs ||
        pitchFrameSamples <= (pitchSampleRate / pitchMinimumHz).ceil() * 2 ||
        contourPointsPerSecond > 1000 / pitchHopMs) {
      throw const FormatException('Unsupported audio settings');
    }
  }

  final Map<String, dynamic> values;
  static const _integerKeys = [
    'analysisVersion',
    'captureSampleRate',
    'pitchSampleRate',
    'minimumRecordingMs',
    'amplitudeIntervalMs',
    'countdownIntervalMs',
    'energyFrameMs',
    'energyHopMs',
    'energyMedianFrames',
    'fillSpeechGapMs',
    'minimumSpeechRunMs',
    'pitchFrameMs',
    'pitchHopMs',
    'pitchMedianFrames',
    'pitchAverageFrames',
    'contourPointsPerSecond',
    'lowPassTaps',
    'waveformHistoryPoints',
    'pauseMinimumMs',
    'pauseShortUpperMs',
    'pauseMediumUpperMs',
    'syllableSmoothMs',
    'syllableMinimumGapMs',
    'paceWindowMs',
    'paceMinimumSpeechMs',
    'qualityMinimumSpeechMs',
    'neuralVadMinimumSilenceMs',
    'neuralVadMinimumSpeechMs',
    'neuralVadWindowSamples',
    'neuralVadMaxSpeechMs',
    'neuralNoiseMinimumMs',
    'playbackContextMs',
  ];
  static const _negativeKeys = {
    'waveformFloorDb',
    'qualityQuietFrameDb',
    'syllableMinimumDb',
  };
  static const _numberKeys = [
    'rmsEpsilon',
    'noiseFloorPercentile',
    'speechMarginDb',
    'pitchMinimumHz',
    'pitchMaximumHz',
    'yinThreshold',
    'octaveJumpSemitones',
    'minimumVoicedRatio',
    'chartMinimumVoicedRatio',
    'lowPassCutoffHz',
    'chartMinimumSpanSemitones',
    'waveformFloorDb',
    'syllableBandLowHz',
    'syllableBandHighHz',
    'qualityMinimumSnrDb',
    'qualityMaximumClippingPct',
    'clippingSampleThreshold',
    'qualityQuietFrameDb',
    'pitchRangeLowPercentile',
    'pitchRangeHighPercentile',
    'loudnessLowPercentile',
    'loudnessHighPercentile',
    'qualitySnrPercentile',
    'englishSyllablesPerWord',
    'neuralVadThreshold',
    'syllableMinimumDb',
  ];
  int _int(String key) => (values[key] as num).toInt();
  double _double(String key) => (values[key] as num).toDouble();
  int get analysisVersion => _int('analysisVersion');
  int get captureSampleRate => _int('captureSampleRate');
  int get pitchSampleRate => _int('pitchSampleRate');
  int get minimumRecordingMs => _int('minimumRecordingMs');
  int get amplitudeIntervalMs => _int('amplitudeIntervalMs');
  int get countdownIntervalMs => _int('countdownIntervalMs');
  int get energyFrameMs => _int('energyFrameMs');
  int get energyHopMs => _int('energyHopMs');
  int get energyMedianFrames => _int('energyMedianFrames');
  double get rmsEpsilon => _double('rmsEpsilon');
  double get noiseFloorPercentile => _double('noiseFloorPercentile');
  double get speechMarginDb => _double('speechMarginDb');
  int get fillSpeechGapMs => _int('fillSpeechGapMs');
  int get minimumSpeechRunMs => _int('minimumSpeechRunMs');
  int get pitchFrameMs => _int('pitchFrameMs');
  int get pitchHopMs => _int('pitchHopMs');
  double get pitchMinimumHz => _double('pitchMinimumHz');
  double get pitchMaximumHz => _double('pitchMaximumHz');
  double get yinThreshold => _double('yinThreshold');
  double get octaveJumpSemitones => _double('octaveJumpSemitones');
  int get pitchMedianFrames => _int('pitchMedianFrames');
  int get pitchAverageFrames => _int('pitchAverageFrames');
  double get minimumVoicedRatio => _double('minimumVoicedRatio');
  double get chartMinimumVoicedRatio => _double('chartMinimumVoicedRatio');
  int get contourPointsPerSecond => _int('contourPointsPerSecond');
  int get lowPassTaps => _int('lowPassTaps');
  double get lowPassCutoffHz => _double('lowPassCutoffHz');
  double get chartMinimumSpanSemitones => _double('chartMinimumSpanSemitones');
  double get waveformFloorDb => _double('waveformFloorDb');
  int get waveformHistoryPoints => _int('waveformHistoryPoints');
  int get pauseMinimumMs => _int('pauseMinimumMs');
  int get pauseShortUpperMs => _int('pauseShortUpperMs');
  int get pauseMediumUpperMs => _int('pauseMediumUpperMs');
  double get syllableBandLowHz => _double('syllableBandLowHz');
  double get syllableBandHighHz => _double('syllableBandHighHz');
  int get syllableSmoothMs => _int('syllableSmoothMs');
  int get syllableMinimumGapMs => _int('syllableMinimumGapMs');
  int get paceWindowMs => _int('paceWindowMs');
  int get paceMinimumSpeechMs => _int('paceMinimumSpeechMs');
  int get qualityMinimumSpeechMs => _int('qualityMinimumSpeechMs');
  double get qualityMinimumSnrDb => _double('qualityMinimumSnrDb');
  double get qualityMaximumClippingPct => _double('qualityMaximumClippingPct');
  double get clippingSampleThreshold => _double('clippingSampleThreshold');
  double get qualityQuietFrameDb => _double('qualityQuietFrameDb');
  double get pitchRangeLowPercentile => _double('pitchRangeLowPercentile');
  double get pitchRangeHighPercentile => _double('pitchRangeHighPercentile');
  double get loudnessLowPercentile => _double('loudnessLowPercentile');
  double get loudnessHighPercentile => _double('loudnessHighPercentile');
  double get qualitySnrPercentile => _double('qualitySnrPercentile');
  double get englishSyllablesPerWord => _double('englishSyllablesPerWord');
  double get neuralVadThreshold => _double('neuralVadThreshold');
  int get neuralVadMinimumSilenceMs => _int('neuralVadMinimumSilenceMs');
  int get neuralVadMinimumSpeechMs => _int('neuralVadMinimumSpeechMs');
  int get neuralVadWindowSamples => _int('neuralVadWindowSamples');
  int get neuralVadMaxSpeechMs => _int('neuralVadMaxSpeechMs');
  int get neuralNoiseMinimumMs => _int('neuralNoiseMinimumMs');
  double get syllableMinimumDb => _double('syllableMinimumDb');
  int get playbackContextMs => _int('playbackContextMs');
  int get pitchFrameSamples => pitchSampleRate * pitchFrameMs ~/ 1000;
  int get pitchHopSamples => pitchSampleRate * pitchHopMs ~/ 1000;
}
