import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell_page.dart';
import '../../features/activities/presentation/activities_page.dart';
import '../../features/alerts/presentation/alerts_page.dart';
import '../../features/commute/presentation/commute_page.dart';
import '../../features/dry_slots/presentation/dry_slots_page.dart';
import '../../features/locations/presentation/locations_page.dart';
import '../../features/next_rain/presentation/next_rain_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/onboarding/presentation/splash_page.dart';
import '../../features/outfit/presentation/outfit_page.dart';
import '../../features/planner/presentation/planner_page.dart';
import '../../features/routines/presentation/routines_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/weather_home/presentation/home_page.dart';
import '../../features/widgets_preview/presentation/widget_preview_page.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 0, child: HomePage()),
      ),
      GoRoute(
        path: RoutePaths.planner,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: PlannerPage()),
      ),
      GoRoute(
        path: RoutePaths.nextRain,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: NextRainPage()),
      ),
      GoRoute(
        path: RoutePaths.drySlots,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: DrySlotsPage()),
      ),
      GoRoute(
        path: RoutePaths.commute,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: CommutePage()),
      ),
      GoRoute(
        path: RoutePaths.activities,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: ActivitiesPage()),
      ),
      GoRoute(
        path: RoutePaths.outfit,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: OutfitPage()),
      ),
      GoRoute(
        path: RoutePaths.alerts,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 1, child: AlertsPage()),
      ),
      GoRoute(
        path: RoutePaths.routines,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 2, child: RoutinesPage()),
      ),
      GoRoute(
        path: RoutePaths.locations,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 0, child: LocationsPage()),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 3, child: SettingsPage()),
      ),
      GoRoute(
        path: RoutePaths.widgetPreview,
        builder: (context, state) =>
            const AppShellPage(currentIndex: 3, child: WidgetPreviewPage()),
      ),
    ],
  );
});
