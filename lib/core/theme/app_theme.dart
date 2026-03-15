import 'package:flutter/material.dart';

sealed class AppPalette {
  static const midnight = Color(0xFF07141D);
  static const deepSea = Color(0xFF102434);
  static const storm = Color(0xFF1B4256);
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
  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.sky,
      brightness: Brightness.dark,
      primary: AppPalette.sky,
      secondary: AppPalette.teal,
      tertiary: AppPalette.amber,
      surface: AppPalette.deepSea,
      error: AppPalette.coral,
    );

    final textTheme = ThemeData.dark(useMaterial3: true).textTheme.copyWith(
      displaySmall: const TextStyle(
        fontSize: 34,
        height: 1.04,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.1,
        color: AppPalette.mist,
      ),
      headlineMedium: const TextStyle(
        fontSize: 26,
        height: 1.14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: AppPalette.mist,
      ),
      headlineSmall: const TextStyle(
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: AppPalette.mist,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppPalette.mist,
      ),
      titleMedium: const TextStyle(
        fontSize: 15,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AppPalette.mist,
      ),
      bodyLarge: const TextStyle(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppPalette.snow,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppPalette.muted,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: AppPalette.muted,
      ),
      labelLarge: const TextStyle(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: AppPalette.mist,
      ),
      labelMedium: const TextStyle(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppPalette.muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      splashFactory: InkSparkle.splashFactory,
      cardColor: Colors.white.withValues(alpha: 0.06),
      dividerColor: Colors.white.withValues(alpha: 0.08),
      iconTheme: const IconThemeData(color: AppPalette.mist),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppPalette.mist,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.06),
        selectedColor: Colors.white.withValues(alpha: 0.14),
        secondarySelectedColor: Colors.white.withValues(alpha: 0.18),
        side: const BorderSide(color: AppPalette.border),
        labelStyle: textTheme.labelLarge!,
        secondaryLabelStyle: textTheme.labelLarge!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        hintStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppPalette.sky, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          foregroundColor: AppPalette.mist,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppPalette.sky,
        linearTrackColor: Color(0x1FFFFFFF),
      ),
    );
  }
}
