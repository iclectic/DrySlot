import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_paths.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';

class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AtmosphericScaffold(
      title: 'Planner',
      subtitle:
          'Insight first, detail second. Jump straight to the part of the day you care about.',
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Today at a glance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      guidance.simpleSummary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...<({String title, String detail, String route, IconData icon})>[
                (
                  title: 'Next rain',
                  detail: guidance.nextHour.title,
                  route: RoutePaths.nextRain,
                  icon: Icons.umbrella_outlined,
                ),
                (
                  title: 'Dry slots',
                  detail: guidance.dryWindow.headline,
                  route: RoutePaths.drySlots,
                  icon: Icons.wb_sunny_outlined,
                ),
                (
                  title: 'Commute',
                  detail: guidance.commute.summary,
                  route: RoutePaths.commute,
                  icon: Icons.route_outlined,
                ),
                (
                  title: 'Activities',
                  detail: 'Scores for walking, running, cycling, and more.',
                  route: RoutePaths.activities,
                  icon: Icons.directions_walk_outlined,
                ),
                (
                  title: 'Outfit',
                  detail: guidance.wearTips.first.title,
                  route: RoutePaths.outfit,
                  icon: Icons.checkroom_outlined,
                ),
                (
                  title: 'Alerts',
                  detail: guidance.risks.first.title,
                  route: RoutePaths.alerts,
                  icon: Icons.warning_amber_rounded,
                ),
                (
                  title: 'Widget preview',
                  detail:
                      'See the clean home-screen cards prepared for widgets.',
                  route: RoutePaths.widgetPreview,
                  icon: Icons.widgets_outlined,
                ),
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppSurfaceCard(
                    onTap: () => context.push(item.route),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.12),
                          ),
                          child: Icon(item.icon),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.detail,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
