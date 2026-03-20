import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather/domain/weather_models.dart';

class DrySlotsPage extends StatelessWidget {
  const DrySlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Dry slots',
      subtitle: 'The most useful dry windows today, ranked for practical use.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          final windows = _buildDryWindows(report.hourly);
          final best = windows.isEmpty ? null : windows.first;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      guidance.dryWindow.headline,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guidance.dryWindow.note,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      guidance.dryWindow.confidenceLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (best != null) ...<Widget>[
                Text(
                  'Best window',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        best.headline,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        best.reason,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'All useful windows',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              if (windows.isEmpty)
                AppSurfaceCard(
                  child: Text(
                    'No clearly useful dry window stands out today, so shorter trips and flexible timing will help.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ...windows.map(
                (window) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          window.headline,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          window.reason,
                          style: Theme.of(context).textTheme.bodyMedium,
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

class _DryWindowCandidate {
  const _DryWindowCandidate({
    required this.headline,
    required this.reason,
    required this.score,
  });

  final String headline;
  final String reason;
  final double score;
}

List<_DryWindowCandidate> _buildDryWindows(List<HourlyForecast> hourly) {
  final slots = hourly.take(14).toList(growable: false);
  final windows = <List<HourlyForecast>>[];
  var current = <HourlyForecast>[];

  for (final slot in slots) {
    final dryEnough =
        slot.precipitationProbability < 35 &&
        slot.precipitationMm < 0.15 &&
        slot.windSpeedKph < 32;
    if (dryEnough) {
      current = <HourlyForecast>[...current, slot];
      continue;
    }
    if (current.isNotEmpty) {
      windows.add(current);
      current = <HourlyForecast>[];
    }
  }
  if (current.isNotEmpty) {
    windows.add(current);
  }

  final candidates = windows
      .map((window) {
        final start = window.first.time;
        final end = window.last.time.add(const Duration(hours: 1));
        final duration = end.difference(start);
        final avgChance =
            window.fold<int>(
              0,
              (sum, slot) => sum + slot.precipitationProbability,
            ) /
            window.length;
        final avgWind =
            window.fold<double>(0, (sum, slot) => sum + slot.windSpeedKph) /
            window.length;
        final score =
            duration.inMinutes / 30 +
            (40 - avgChance) / 20 +
            (32 - avgWind) / 12;
        final reason = duration.inHours >= 2
            ? 'Long enough for errands, walks, or outdoor jobs, with lower rain risk than the rest of the day.'
            : 'Short, but still usable if you keep the plan tight.';
        return _DryWindowCandidate(
          headline:
              '${duration.inMinutes <= 75 ? 'Short' : 'Dry'} slot: ${formatTimeRange(start, end)}',
          reason: reason,
          score: score,
        );
      })
      .toList(growable: false);

  candidates.sort((a, b) => b.score.compareTo(a.score));
  return candidates;
}
