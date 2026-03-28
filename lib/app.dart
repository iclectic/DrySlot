import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/display_settings_controller.dart';

class DrySlotsApp extends ConsumerWidget {
  const DrySlotsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(displaySettingsControllerProvider);
    final router = ref.watch(appRouterProvider);
    final accessibility =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    final highContrast = settings.highContrast || accessibility.highContrast;
    final reduceMotion =
        accessibility.disableAnimations || accessibility.accessibleNavigation;

    // Swap signal colours before building themes.
    AppPalette.applyColorblindSafe(settings.colorblindSafe);

    return MaterialApp.router(
      title: 'Dry Slots',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLight(
        highContrast: highContrast,
        reduceMotion: reduceMotion,
      ),
      darkTheme: AppTheme.buildDark(
        highContrast: highContrast,
        reduceMotion: reduceMotion,
      ),
      themeMode: settings.themeMode,
      themeAnimationDuration: reduceMotion
          ? Duration.zero
          : kThemeAnimationDuration,
      routerConfig: router,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final combinedTextScale =
            mediaQuery.textScaler.scale(1) * settings.textScaleFactor;
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(combinedTextScale),
            highContrast: highContrast,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
