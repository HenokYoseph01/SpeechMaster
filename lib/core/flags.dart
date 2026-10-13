class FeatureFlags {
  FeatureFlags._();

  static const bool aiCoach = bool.fromEnvironment(
    'AI_COACH',
    defaultValue: false,
  );

  // Unknown remote config is disabled. Phase 4 supplies the cached kill switch.
  static bool isAiCoachEnabled({required bool? remoteAllowsAiCoach}) =>
      aiCoach && remoteAllowsAiCoach == true;
}
