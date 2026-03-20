import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather/domain/weather_models.dart';

class NextRainPage extends StatelessWidget {
  const NextRainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Next rain',
      subtitle:
          'Minute by minute where supported, otherwise the nearest useful breakdown.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          final slots = report.minutely.take(8).toList(growable: false);
          final firstRain = slots
              .where((slot) => slot.precipitationMm >= 0.08)
              .firstOrNull;
          final rainRun = _rainRun(slots);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      guidance.nextHour.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guidance.nextHour.detail,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      guidance.nextHour.departureAdvice,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppSurfaceCard(
                      child: _MetricBlock(
                        label: 'Rain start',
                        value: firstRain == null
                            ? 'Not showing'
                            : formatClock(firstRain.time),
                        detail: firstRain == null
                            ? 'No meaningful rain showing in the next hour.'
                            : 'Estimated from the next supported time slots.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppSurfaceCard(
                      child: _MetricBlock(
                        label: 'Rain end',
                        value: rainRun == null
                            ? 'N/A'
                            : formatClock(rainRun.end),
                        detail: rainRun == null
                            ? 'No continuous wet spell identified right now.'
                            : 'Based on the same short-range forecast run.',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: _MetricBlock(
                  label: 'Confidence',
                  value: _confidenceLabel(report, slots),
                  detail: _timelineLabel(slots),
                ),
              ),
              const SizedBox(height: 16),
              Text('Timeline', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ...slots.map(
                (slot) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppSurfaceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 72,
                          child: Text(
                            formatClock(slot.time),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: min(slot.precipitationMm / 1.2, 1),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 74,
                          child: Text(
                            formatRain(slot.precipitationMm),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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

class _RainRun {
  const _RainRun({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 10),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(detail, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

_RainRun? _rainRun(List<MinuteForecast> slots) {
  final wet = slots
      .where((slot) => slot.precipitationMm >= 0.08)
      .toList(growable: false);
  if (wet.isEmpty) {
    return null;
  }
  return _RainRun(start: wet.first.time, end: wet.last.time);
}

String _confidenceLabel(WeatherReport report, List<MinuteForecast> slots) {
  if (slots.length >= 8 && report.sourceLabel.contains('OpenWeather')) {
    return 'High';
  }
  if (slots.length >= 4) {
    return 'Practical';
  }
  return 'Limited';
}

String _timelineLabel(List<MinuteForecast> slots) {
  if (slots.length < 2) {
    return 'Very short-range detail is limited right now.';
  }
  final gap = slots[1].time.difference(slots[0].time).inMinutes;
  return gap <= 5
      ? 'Using minute-level forecast support.'
      : 'Using the nearest supported short-range breakdown.';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
