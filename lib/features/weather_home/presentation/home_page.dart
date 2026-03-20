import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(weatherDashboardControllerProvider.notifier).initialize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherDashboardControllerProvider);
    final preferences = ref.watch(appPreferencesControllerProvider);
    final location = weatherState.selectedLocation;

    return AtmosphericScaffold(
      title: location.name,
      subtitle: weatherState.report == null
          ? location.subtitle
          : '${location.subtitle} • ${formatUpdated(weatherState.report!.fetchedAt)}',
      actions: <Widget>[
        IconButton(
          tooltip: 'Change location',
          onPressed: () => context.push(RoutePaths.locations),
          icon: const Icon(Icons.location_on_outlined),
        ),
        IconButton(
          tooltip: 'Alerts',
          onPressed: () => context.push(RoutePaths.alerts),
          icon: const Icon(Icons.warning_amber_rounded),
        ),
      ],
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          final pinnedRisk = guidance.risks.firstWhere(
            (risk) => risk.level != RiskLevel.calm,
            orElse: () => guidance.risks.first,
          );
          final topActivities = [...guidance.activities]
            ..sort((a, b) => b.score.compareTo(a.score));
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      guidance.headline.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guidance.headline.detail,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      child: Text(
                        guidance.headline.callToAction,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (pinnedRisk.level != RiskLevel.calm) ...<Widget>[
                AppSurfaceCard(
                  onTap: () => context.push(RoutePaths.alerts),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Heads up',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pinnedRisk.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pinnedRisk.detail,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _HomeLinkCard(
                title: 'Can I go out now?',
                value: guidance.nextHour.title,
                detail:
                    '${guidance.nextHour.detail} ${guidance.nextHour.departureAdvice}',
                route: RoutePaths.nextRain,
                icon: Icons.umbrella_outlined,
              ),
              const SizedBox(height: 16),
              _HomeLinkCard(
                title: 'Best time to go out today',
                value: guidance.dryWindow.headline,
                detail: guidance.dryWindow.note,
                route: RoutePaths.drySlots,
                icon: Icons.wb_sunny_outlined,
              ),
              const SizedBox(height: 16),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Simple guidance',
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
              AppSurfaceCard(
                onTap: () => context.push(RoutePaths.outfit),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'What should I wear?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      guidance.wearTips.first.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      guidance.wearTips.first.detail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (preferences.routineSupportEnabled)
                AppSurfaceCard(
                  onTap: () => context.push(RoutePaths.commute),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Saved routine snapshot',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        guidance.commute.summary,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (guidance.commute.windows.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 10),
                        Text(
                          guidance.commute.windows.first.summary,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                )
              else
                AppSurfaceCard(
                  onTap: () => context.push(RoutePaths.settings),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Routine support is off',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Turn it on to see commutes, school runs, and favourite daily windows here.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              AppSurfaceCard(
                onTap: () => context.push(RoutePaths.activities),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Activity scores',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...topActivities
                        .take(3)
                        .map(
                          (activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(activity.icon, size: 20),
                                const SizedBox(width: 10),
                                Expanded(child: Text(activity.name)),
                                Text(
                                  '${activity.score}/10',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSurfaceCard(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _QuickLinkChip(
                      label: 'Next rain',
                      onTap: () => context.push(RoutePaths.nextRain),
                    ),
                    _QuickLinkChip(
                      label: 'Dry slots',
                      onTap: () => context.push(RoutePaths.drySlots),
                    ),
                    _QuickLinkChip(
                      label: 'Commute',
                      onTap: () => context.push(RoutePaths.commute),
                    ),
                    _QuickLinkChip(
                      label: 'Activities',
                      onTap: () => context.push(RoutePaths.activities),
                    ),
                    _QuickLinkChip(
                      label: 'Outfit',
                      onTap: () => context.push(RoutePaths.outfit),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeLinkCard extends StatelessWidget {
  const _HomeLinkCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.route,
    required this.icon,
  });

  final String title;
  final String value;
  final String detail;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: () => context.push(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _QuickLinkChip extends StatelessWidget {
  const _QuickLinkChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}
