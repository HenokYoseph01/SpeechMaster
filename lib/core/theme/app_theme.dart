import 'package:flutter/material.dart';

enum AppTheme { honey, ember, meadow, dusk }

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.textMuted,
    required this.growth,
    required this.roomToGrow,
  });

  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color text;
  final Color textMuted;
  final Color growth;
  final Color roomToGrow;

  static const _light = AppColors(
    primary: Color(0xFFFFC629),
    onPrimary: Color(0xFF111111),
    background: Color(0xFFFFFBF0),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFFF1C7),
    text: Color(0xFF111111),
    textMuted: Color(0xFF6B6558),
    growth: Color(0xFF2FA866),
    roomToGrow: Color(0xFFE8890C),
  );
  static const _dark = AppColors(
    primary: Color(0xFFFFC629),
    onPrimary: Color(0xFF111111),
    background: Color(0xFF0F0F0E),
    surface: Color(0xFF1A1917),
    surfaceAlt: Color(0xFF262421),
    text: Color(0xFFF5F1E6),
    textMuted: Color(0xFFA8A294),
    growth: Color(0xFF4CC98A),
    roomToGrow: Color(0xFFF5A03A),
  );

  static AppColors palette(AppTheme theme, Brightness brightness) {
    final base = brightness == Brightness.dark ? _dark : _light;
    return base.copyWith(
      primary: switch (theme) {
        AppTheme.honey => base.primary,
        AppTheme.ember => const Color(0xFFFF7A59),
        AppTheme.meadow => const Color(0xFF58B368),
        AppTheme.dusk => const Color(0xFF9B87F5),
      },
    );
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? text,
    Color? textMuted,
    Color? growth,
    Color? roomToGrow,
  }) => AppColors(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceAlt: surfaceAlt ?? this.surfaceAlt,
    text: text ?? this.text,
    textMuted: textMuted ?? this.textMuted,
    growth: growth ?? this.growth,
    roomToGrow: roomToGrow ?? this.roomToGrow,
  );

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      growth: Color.lerp(growth, other.growth, t)!,
      roomToGrow: Color.lerp(roomToGrow, other.roomToGrow, t)!,
    );
  }
}

ThemeData buildTheme(AppTheme theme, Brightness brightness) {
  final colors = AppColors.palette(theme, brightness);
  final scheme =
      ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ).copyWith(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.surfaceAlt,
        onPrimaryContainer: colors.text,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        secondaryContainer: colors.surfaceAlt,
        onSecondaryContainer: colors.text,
        surface: colors.surface,
        onSurface: colors.text,
        onSurfaceVariant: colors.textMuted,
        outline: colors.textMuted,
        surfaceContainerHighest: colors.surfaceAlt,
      );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    fontFamily: 'Nunito',
    fontFamilyFallback: const ['NotoSansEthiopic'],
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.text,
      surfaceTintColor: colors.background,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(16),
    ),
  );
}
