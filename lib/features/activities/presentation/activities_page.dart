import 'package:flutter/material.dart';

import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather/presentation/weather_dashboard_page.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Activity planner',
      subtitle:
          'Simple out-of-ten scores with enough context to trust the decision.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          final activities = [...guidance.activities]
            ..sort((a, b) => b.score.compareTo(a.score));
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: activities
                .map(
                  (activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppSurfaceCard(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) =>
                              ActivityDetailSheet(activity: activity),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(activity.icon, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  activity.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity.detail,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${activity.score}/10',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }
}
