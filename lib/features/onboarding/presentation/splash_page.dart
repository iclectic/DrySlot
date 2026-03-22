import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_theme.dart';
import '../../weather_core/presentation/weather_dashboard_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_boot);
  }

  Future<void> _boot() async {
    await Future.wait<void>(<Future<void>>[
      ref.read(weatherDashboardControllerProvider.notifier).initialize(),
      Future<void>.delayed(const Duration(milliseconds: 850)),
    ]);
    if (!mounted) {
      return;
    }
    final preferences = ref.read(appPreferencesControllerProvider);
    context.go(
      preferences.onboardingCompleted ? RoutePaths.home : RoutePaths.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppPalette.dawn, AppPalette.pearl],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: AppPalette.ink,
              ),
              child: const Icon(
                Icons.wb_cloudy_outlined,
                color: AppPalette.dawn,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text('Dry Slots', style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Practical weather for real days out.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
