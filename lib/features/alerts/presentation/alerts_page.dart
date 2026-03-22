import 'package:flutter/material.dart';

import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather_core/domain/weather_models.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Alerts',
      subtitle:
          'Official warnings first, then practical caution signals from the forecast.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: guidance.risks
                .map(
                  (risk) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Icon(risk.icon),
                              Text(
                                risk.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Chip(
                                label: Text(
                                  risk.source == AlertSource.official
                                      ? 'Official'
                                      : 'Forecast',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            risk.detail,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (risk.link != null) ...<Widget>[
                            const SizedBox(height: 10),
                            Text(
                              risk.link!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
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
