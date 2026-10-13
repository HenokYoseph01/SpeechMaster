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
    for (final entry in values.entries) {
      final value = entry.value;
      if (value is! num ||
          !value.isFinite ||
          (entry.key != 'waveformFloorDb' && value <= 0)) {
        throw const FormatException(
          'Audio settings must be positive finite numbers',
        );
      }
    }
    if (captureSampleRate != 16000 ||
        pitchSampleRate != 8000 ||
        minimumRecordingMs != 10000 ||
        waveformFloorDb >= 0 ||
        lowPassTaps < 3 ||
        lowPassTaps.isEven ||
        energyMedianFrames.isEven ||
        pitchMedianFrames.isEven ||
        pitchAverageFrames.isEven ||
        lowPassCutoffHz >= pitchSampleRate / 2 ||
        pitchMinimumHz >= pitchMaximumHz ||
        yinThreshold >= 1 ||
        minimumVoicedRatio > 1 ||
        noiseFloorPercentile > 100 ||
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
  int get contourPointsPerSecond => _int('contourPointsPerSecond');
  int get lowPassTaps => _int('lowPassTaps');
  double get lowPassCutoffHz => _double('lowPassCutoffHz');
  double get chartMinimumSpanSemitones => _double('chartMinimumSpanSemitones');
  double get waveformFloorDb => _double('waveformFloorDb');
  int get waveformHistoryPoints => _int('waveformHistoryPoints');
  int get pitchFrameSamples => pitchSampleRate * pitchFrameMs ~/ 1000;
  int get pitchHopSamples => pitchSampleRate * pitchHopMs ~/ 1000;
}
