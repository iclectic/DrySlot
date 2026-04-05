import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/analytics/analytics_settings_controller.dart';
import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/services/notification_permission_service.dart';
import '../../../core/services/notification_preferences_controller.dart';
import '../../../core/theme/display_settings_controller.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../weather_core/data/weather_provider_config.dart';
import '../../weather_core/data/weather_repository.dart';
import '../../weather_core/domain/weather_models.dart';
import '../../weather_core/presentation/weather_dashboard_controller.dart';

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
          _AlertsSettingsCard(preferences: preferences),
          const SizedBox(height: 16),
          AppSurfaceCard(
            onTap: () => context.push(RoutePaths.locations),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Location access',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Switch location, use your current place, or add a comparison city from the locations screen.',
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
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => context.push(RoutePaths.privacyPolicy),
                  icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                  label: const Text('Privacy policy'),
                ),
                const SizedBox(height: 4),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final info = snapshot.data!;
                    return Text(
                      'Version ${info.version} (${info.buildNumber})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertsSettingsCard extends ConsumerWidget {
  const _AlertsSettingsCard({required this.preferences});

  final AppPreferencesState preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifPrefs = ref.watch(notificationPreferencesProvider);
    final notifCtrl = ref.read(notificationPreferencesProvider.notifier);

    String formatTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Alerts', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Weather notifications'),
            subtitle: const Text(
              'Master toggle for all proactive weather alerts.',
            ),
            value: preferences.notificationsEnabled,
            onChanged: (value) async {
              if (!value) {
                await ref
                    .read(appPreferencesControllerProvider.notifier)
                    .setNotificationsEnabled(false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weather notifications are off for now.'),
                    ),
                  );
                }
                return;
              }

              final result = await ref
                  .read(notificationPermissionServiceProvider)
                  .requestPermission();
              await ref
                  .read(appPreferencesControllerProvider.notifier)
                  .setNotificationsEnabled(result.isGranted);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.message)),
                );
              }
            },
          ),
          if (preferences.notificationsEnabled) ...<Widget>[
            const Divider(height: 24),
            Text(
              'Alert types',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Rain approaching'),
              subtitle: const Text(
                'Heads-up when rain is expected within 15 minutes.',
              ),
              value: notifPrefs.rainAlerts,
              onChanged: (v) => notifCtrl.setRainAlerts(v),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Commute warnings'),
              subtitle: const Text(
                'Alert when a saved commute window has a poor forecast.',
              ),
              value: notifPrefs.commuteWarnings,
              onChanged: (v) => notifCtrl.setCommuteWarnings(v),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dry window opening'),
              subtitle: const Text(
                'Nudge when a worthwhile dry stretch is about to start.',
              ),
              value: notifPrefs.dryWindowAlerts,
              onChanged: (v) => notifCtrl.setDryWindowAlerts(v),
            ),
            const Divider(height: 24),
            Text(
              'Quiet hours',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enable quiet hours'),
              subtitle: Text(
                notifPrefs.quietHoursEnabled
                    ? 'No alerts between ${formatTime(notifPrefs.quietStart)} and ${formatTime(notifPrefs.quietEnd)}.'
                    : 'Alerts can arrive at any time.',
              ),
              value: notifPrefs.quietHoursEnabled,
              onChanged: (v) => notifCtrl.setQuietHoursEnabled(v),
            ),
            if (notifPrefs.quietHoursEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: notifPrefs.quietStart,
                            helpText: 'Quiet hours start',
                          );
                          if (picked != null) {
                            await notifCtrl.setQuietStart(picked);
                          }
                        },
                        child: Text('Start: ${formatTime(notifPrefs.quietStart)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: notifPrefs.quietEnd,
                            helpText: 'Quiet hours end',
                          );
                          if (picked != null) {
                            await notifCtrl.setQuietEnd(picked);
                          }
                        },
                        child: Text('End: ${formatTime(notifPrefs.quietEnd)}'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
