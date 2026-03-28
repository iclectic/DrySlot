import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_settings_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/display_settings_controller.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../weather_core/domain/weather_models.dart';
import '../../weather_core/presentation/weather_dashboard_controller.dart';

class DisplaySettingsSheet extends ConsumerWidget {
  const DisplaySettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(displaySettingsControllerProvider);
    final dashboard = ref.watch(weatherDashboardControllerProvider);
    final analytics = ref.watch(analyticsSettingsControllerProvider);

    return AppSheetFrame(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const AppSheetHandle(),
            const SizedBox(height: 18),
            Text(
              'Display settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep the app calm by default, switch on deeper forecast detail when you want it, and tune readability to suit you.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Text(
              'Weather detail',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SegmentedButton<ExplanationMode>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<ExplanationMode>>[
                ButtonSegment<ExplanationMode>(
                  value: ExplanationMode.simple,
                  icon: Icon(Icons.auto_awesome_outlined),
                  label: Text('Simple'),
                ),
                ButtonSegment<ExplanationMode>(
                  value: ExplanationMode.detailed,
                  icon: Icon(Icons.tune_rounded),
                  label: Text('Detailed'),
                ),
              ],
              selected: <ExplanationMode>{dashboard.explanationMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  unawaited(
                    ref
                        .read(weatherDashboardControllerProvider.notifier)
                        .setExplanationMode(selection.first),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              dashboard.explanationMode.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            Text('Theme mode', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto_rounded),
                  label: Text('Adaptive'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_rounded),
                  label: Text('Light'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_rounded),
                  label: Text('Dark'),
                ),
              ],
              selected: <ThemeMode>{settings.themeMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  unawaited(
                    ref
                        .read(displaySettingsControllerProvider.notifier)
                        .setThemeMode(selection.first),
                  );
                }
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Accessibility',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _SettingsSwitchTile(
              icon: Icons.text_fields_rounded,
              title: 'Large text mode',
              detail:
                  'Respects system text scaling and adds extra headroom across cards and sheets.',
              value: settings.largeText,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(displaySettingsControllerProvider.notifier)
                      .setLargeText(value),
                );
              },
            ),
            const SizedBox(height: 12),
            _SettingsSwitchTile(
              icon: Icons.contrast_rounded,
              title: 'High contrast',
              detail:
                  'Strengthens text, outlines, and surfaces for easier scanning in bright or low-vision conditions.',
              value: settings.highContrast,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(displaySettingsControllerProvider.notifier)
                      .setHighContrast(value),
                );
              },
            ),
            const SizedBox(height: 12),
            _SettingsSwitchTile(
              icon: Icons.palette_outlined,
              title: 'Colorblind-safe palette',
              detail:
                  'Replaces the go / watch / wait signal colours with an Okabe-Ito palette optimised for deuteranopia and protanopia.',
              value: settings.colorblindSafe,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(displaySettingsControllerProvider.notifier)
                      .setColorblindSafe(value),
                );
              },
            ),
            const SizedBox(height: 18),
            Text('Privacy', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            _SettingsSwitchTile(
              icon: Icons.analytics_outlined,
              title: 'Anonymous feature analytics',
              detail:
                  'Tracks only broad feature usage counts. Dry Slots does not record routine labels, search terms, or exact locations here.',
              value: analytics.enabled,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(analyticsSettingsControllerProvider.notifier)
                      .setEnabled(value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appSheetSurfaceFill(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: appSheetSurfaceBorder(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: appSheetSurfaceFill(context, strong: true),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppPalette.sky),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(detail, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
