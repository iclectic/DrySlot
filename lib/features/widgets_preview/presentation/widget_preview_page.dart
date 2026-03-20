import 'package:flutter/material.dart';

import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';

class WidgetPreviewPage extends StatelessWidget {
  const WidgetPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Widget preview',
      subtitle:
          'Clean, glanceable home-screen cards for the surfaces that matter most.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: guidance.homeCards
                .map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 140,
                      child: AppSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(card.icon),
                            const Spacer(),
                            Text(
                              card.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card.value,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card.detail,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
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
