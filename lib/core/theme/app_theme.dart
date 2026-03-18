import 'package:flutter/material.dart';

sealed class AppPalette {
  static const midnight = Color(0xFF07141D);
  static const deepSea = Color(0xFF102434);
  static const storm = Color(0xFF1B4256);
  static const dawn = Color(0xFFF5F8FC);
  static const pearl = Color(0xFFE8F0F7);
  static const harbor = Color(0xFFD8E7F2);
  static const ink = Color(0xFF123041);
  static const slate = Color(0xFF577181);
  static const sky = Color(0xFF7FC3EA);
  static const teal = Color(0xFF69D4C4);
  static const amber = Color(0xFFF2C77A);
  static const coral = Color(0xFFF28A6D);
  static const mist = Color(0xFFF3F7FB);
  static const snow = Color(0xFFE8F1F8);
  static const muted = Color(0xFF9FB4C2);
  static const border = Color(0x33FFFFFF);
  static const glow = Color(0x14000000);
}

final class AppTheme {
  static ThemeData buildLight({
    bool highContrast = false,
    bool reduceMotion = false,
  }) => _build(
    Brightness.light,
    highContrast: highContrast,
    reduceMotion: reduceMotion,
  );

  static ThemeData buildDark({
    bool highContrast = false,
    bool reduceMotion = false,
  }) => _build(
    Brightness.dark,
    highContrast: highContrast,
    reduceMotion: reduceMotion,
  );

  static ThemeData _build(
    Brightness brightness, {
    required bool highContrast,
    required bool reduceMotion,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.sky,
      brightness: brightness,
      primary: AppPalette.sky,
      secondary: AppPalette.teal,
      tertiary: AppPalette.amber,
      surface: isDark ? AppPalette.deepSea : AppPalette.dawn,
      error: AppPalette.coral,
    );

    final baseTextTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    ).textTheme;
    final primaryText = isDark
        ? Colors.white
        : (highContrast ? AppPalette.midnight : AppPalette.ink);
    final secondaryText = highContrast
        ? primaryText
        : (isDark ? AppPalette.muted : AppPalette.slate);
    final surfaceFill = isDark
        ? Colors.white.withValues(alpha: highContrast ? 0.16 : 0.06)
        : Colors.white.withValues(alpha: highContrast ? 0.96 : 0.78);
    final selectedFill = isDark
        ? Colors.white.withValues(alpha: highContrast ? 0.24 : 0.14)
        : AppPalette.sky.withValues(alpha: highContrast ? 0.28 : 0.18);
    final outline = highContrast
        ? (isDark
              ? Colors.white.withValues(alpha: 0.28)
              : AppPalette.ink.withValues(alpha: 0.24))
        : (isDark
              ? Colors.white.withValues(alpha: 0.1)
              : AppPalette.ink.withValues(alpha: 0.08));
    final filledButtonBackground = isDark
        ? Colors.white.withValues(alpha: highContrast ? 0.24 : 0.12)
        : AppPalette.ink.withValues(alpha: highContrast ? 1.0 : 0.92);

    final textTheme = baseTextTheme.copyWith(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 1.04,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.1,
        color: primaryText,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: primaryText,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: isDark ? AppPalette.snow : AppPalette.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: secondaryText,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      labelMedium: TextStyle(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: secondaryText,
      ),
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      splashFactory: reduceMotion
          ? NoSplash.splashFactory
          : InkSparkle.splashFactory,
      cardColor: surfaceFill,
      dividerColor: outline,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      iconTheme: IconThemeData(color: primaryText),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryText,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceFill,
        selectedColor: selectedFill,
        secondarySelectedColor: selectedFill,
        side: BorderSide(color: outline),
        labelStyle: textTheme.labelLarge!,
        secondaryLabelStyle: textTheme.labelLarge!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceFill,
        hintStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppPalette.sky, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: filledButtonBackground,
          foregroundColor: isDark ? AppPalette.mist : AppPalette.dawn,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppPalette.sky,
        linearTrackColor: Color(0x1A000000),
      ),
    );
  }
}
