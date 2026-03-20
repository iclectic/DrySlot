import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';
import '../../weather/presentation/weather_dashboard_page.dart';

class RoutinesPage extends ConsumerWidget {
  const RoutinesPage({super.key});

  Future<void> _manage(BuildContext context, WidgetRef ref) async {
    final state = ref.read(weatherDashboardControllerProvider);
    final result = await showModalBottomSheet<List<SavedCommuteWindow>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CommuteWindowsSheet(initialWindows: state.commuteWindows),
    );
    if (result != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .saveCommuteWindows(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesControllerProvider);
    final state = ref.watch(weatherDashboardControllerProvider);
    return AtmosphericScaffold(
      title: 'Routines',
      subtitle: 'Create, edit, and keep the daily windows that matter most.',
      actions: <Widget>[
        IconButton(
          onPressed: () => _manage(context, ref),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      body: preferences.routineSupportEnabled
          ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              children: state.commuteWindows
                  .map(
                    (window) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppSurfaceCard(
                        onTap: () => _manage(context, ref),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              window.label,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatMinutes(
                                window.startMinutes,
                                window.endMinutes,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            )
          : EmptyStatePanel(
              title: 'Routine support is turned off',
              detail:
                  'Enable it in settings when you want school runs, gym walks, and daily routines summarised automatically.',
              action: FilledButton(
                onPressed: () => ref
                    .read(appPreferencesControllerProvider.notifier)
                    .setRoutineSupportEnabled(true),
                child: const Text('Enable routines'),
              ),
            ),
    );
  }
}

String _formatMinutes(int startMinutes, int endMinutes) {
  final startHour = (startMinutes ~/ 60) % 24;
  final startMinute = startMinutes % 60;
  final endHour = (endMinutes ~/ 60) % 24;
  final endMinute = endMinutes % 60;
  return '${_formatClock(startHour, startMinute)} to ${_formatClock(endHour, endMinute)}';
}

String _formatClock(int hour, int minute) {
  final displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;
  final suffix = hour >= 12 ? 'pm' : 'am';
  return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
}
