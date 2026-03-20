import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_settings_controller.dart';
import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/display_settings_controller.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../weather/data/weather_provider_config.dart';
import '../../weather/data/weather_repository.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displaySettingsControllerProvider);
    final analytics = ref.watch(analyticsSettingsControllerProvider);
    final preferences = ref.watch(appPreferencesControllerProvider);
    final dashboard = ref.watch(weatherDashboardControllerProvider);
    final provider = ref.watch(activeWeatherDataProviderProvider);

    return AtmosphericScaffold(
      title: 'Settings',
      subtitle:
          'Appearance, privacy, routine behaviour, and data source information.',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: <Widget>[
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Units', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  'This build uses UK defaults: °C, mm, and mph. A fuller unit switcher can sit here without changing the screen architecture.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Adaptive'),
                    ),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: <ThemeMode>{display.themeMode},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      ref
                          .read(displaySettingsControllerProvider.notifier)
                          .setThemeMode(selection.first);
                    }
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Large text mode'),
                  value: display.largeText,
                  onChanged: (value) => ref
                      .read(displaySettingsControllerProvider.notifier)
                      .setLargeText(value),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('High contrast'),
                  value: display.highContrast,
                  onChanged: (value) => ref
                      .read(displaySettingsControllerProvider.notifier)
                      .setHighContrast(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Alerts', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Weather notifications'),
                  subtitle: const Text(
                    'Morning briefings, routine nudges, and severe-weather prompts when those surfaces are enabled.',
                  ),
                  value: preferences.notificationsEnabled,
                  onChanged: (value) => ref
                      .read(appPreferencesControllerProvider.notifier)
                      .setNotificationsEnabled(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Home screen customisation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Routine support on home'),
                  subtitle: const Text(
                    'Show saved routines and commute summaries in the main daily view.',
                  ),
                  value: preferences.routineSupportEnabled,
                  onChanged: (value) => ref
                      .read(appPreferencesControllerProvider.notifier)
                      .setRoutineSupportEnabled(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Weather explanation mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ExplanationMode>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<ExplanationMode>>[
                    ButtonSegment(
                      value: ExplanationMode.simple,
                      label: Text('Simple'),
                    ),
                    ButtonSegment(
                      value: ExplanationMode.detailed,
                      label: Text('Detailed'),
                    ),
                  ],
                  selected: <ExplanationMode>{dashboard.explanationMode},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      ref
                          .read(weatherDashboardControllerProvider.notifier)
                          .setExplanationMode(selection.first);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Privacy', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Anonymous feature analytics'),
                  subtitle: const Text(
                    'Counts broad feature usage only. No exact locations, search terms, or routine labels are captured here.',
                  ),
                  value: analytics.enabled,
                  onChanged: (value) => ref
                      .read(analyticsSettingsControllerProvider.notifier)
                      .setEnabled(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Data source info',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Active weather provider: ${provider.label}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Dry Slots keeps weather providers behind repository interfaces so the app can switch APIs later without rewriting the product logic.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            onTap: () => context.push(RoutePaths.widgetPreview),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Widget preview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Preview the current weather, next rain, best dry slot, commute, and daily advice cards prepared for widgets.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('About', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Dry Slots is built for practical UK weather decisions: timing, routines, dry windows, and plain-English guidance.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
