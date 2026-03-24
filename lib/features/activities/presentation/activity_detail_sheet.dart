import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../weather_core/domain/weather_models.dart';

class ActivityDetailSheet extends StatelessWidget {
  const ActivityDetailSheet({super.key, required this.activity});

  final ActivityRecommendation activity;

  @override
  Widget build(BuildContext context) {
    final color = switch (activity.suitability) {
      ActivitySuitability.great => AppPalette.teal,
      ActivitySuitability.okay => AppPalette.amber,
      ActivitySuitability.poor => AppPalette.coral,
    };
    final outlook = switch (activity.suitability) {
      ActivitySuitability.great => 'Strong fit for the day',
      ActivitySuitability.okay => 'Usable with a bit of care',
      ActivitySuitability.poor => 'Probably better to skip or delay',
    };

    return AppSheetFrame(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const AppSheetHandle(),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(activity.icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        activity.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$outlook, scored ${activity.score} out of 10.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appSheetSurfaceFill(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: appSheetSurfaceBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${activity.score}/10',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.detail,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Scores stay practical and privacy-friendly. They reflect weather comfort, timing, rain, and wind, not where you personally go.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
