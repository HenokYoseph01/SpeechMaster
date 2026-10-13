import 'package:flutter_test/flutter_test.dart';
import 'package:speech_coach/core/flags.dart';

void main() {
  const expectedBuildFlag = bool.fromEnvironment(
    'EXPECT_AI_COACH',
    defaultValue: false,
  );

  test('coach compile-time flag has the expected build value', () {
    expect(FeatureFlags.aiCoach, expectedBuildFlag);
  });

  test('coach needs explicit remote permission and the build flag', () {
    expect(FeatureFlags.isAiCoachEnabled(remoteAllowsAiCoach: null), isFalse);
    expect(FeatureFlags.isAiCoachEnabled(remoteAllowsAiCoach: false), isFalse);
    expect(
      FeatureFlags.isAiCoachEnabled(remoteAllowsAiCoach: true),
      expectedBuildFlag,
    );
  });
}
