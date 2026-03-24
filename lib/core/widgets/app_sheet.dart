import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppSheetFrame extends StatelessWidget {
  const AppSheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appSheetBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: appSheetSurfaceBorder(context)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class AppSheetHandle extends StatelessWidget {
  const AppSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 5,
        width: 46,
        decoration: BoxDecoration(
          color: appSheetHandleColor(context),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

Color appSheetSurfaceFill(BuildContext context, {bool strong = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  if (isDark) {
    return Colors.white.withValues(
      alpha: strong
          ? (highContrast ? 0.18 : 0.08)
          : (highContrast ? 0.12 : 0.05),
    );
  }
  return strong
      ? (highContrast ? Colors.white : const Color(0xFFF9FCFF))
      : (highContrast ? const Color(0xFFFBFDFF) : const Color(0xF2FFFFFF));
}

Color appSheetSurfaceBorder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  return isDark
      ? Colors.white.withValues(alpha: highContrast ? 0.24 : 0.08)
      : AppPalette.ink.withValues(alpha: highContrast ? 0.22 : 0.08);
}

Color appSheetBackground(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  return isDark
      ? (highContrast ? const Color(0xFF06111A) : const Color(0xFF081520))
      : (highContrast ? Colors.white : const Color(0xFFF5F9FD));
}

Color appSheetHandleColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  return isDark
      ? Colors.white.withValues(alpha: highContrast ? 0.34 : 0.22)
      : AppPalette.ink.withValues(alpha: highContrast ? 0.28 : 0.18);
}

bool _highContrast(BuildContext context) {
  return MediaQuery.maybeOf(context)?.highContrast ?? false;
}
