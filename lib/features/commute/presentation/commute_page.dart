import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';
import '../../weather/presentation/weather_dashboard_page.dart';

class CommutePage extends ConsumerWidget {
  const CommutePage({super.key});

  Future<void> _manageRoutines(BuildContext context, WidgetRef ref) async {
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
    return AtmosphericScaffold(
      title: 'Commute',
      subtitle: 'Weather guidance for the routines you care about most.',
      showBack: true,
      actions: <Widget>[
        IconButton(
          onPressed: preferences.routineSupportEnabled
              ? () => _manageRoutines(context, ref)
              : null,
          icon: const Icon(Icons.edit_calendar_outlined),
        ),
      ],
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          if (!preferences.routineSupportEnabled) {
            return EmptyStatePanel(
              title: 'Routine support is off',
              detail:
                  'Turn it on in settings when you want school runs, commutes, and favourite walks summarised here.',
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      guidance.commute.summary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...guidance.commute.windows.map(
                (leg) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          leg.label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${leg.summary} • ${leg.score}/100',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          leg.detail,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _extraSuggestion(leg),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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

String _extraSuggestion(CommuteLeg leg) {
  if (leg.score >= 75) {
    return 'Suggestion: usual timing should be fine, though a light layer may still help.';
  }
  if (leg.score >= 50) {
    return 'Suggestion: take a coat or small waterproof and give yourself a little extra margin.';
  }
  return 'Suggestion: leave earlier if you can, carry a waterproof, and expect rougher going.';
}
