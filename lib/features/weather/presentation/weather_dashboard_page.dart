import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../data/weather_repository.dart';
import '../domain/weather_describer.dart';
import '../domain/weather_models.dart';
import 'weather_dashboard_controller.dart';

class WeatherDashboardPage extends StatefulWidget {
  const WeatherDashboardPage({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  State<WeatherDashboardPage> createState() => _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  late final OpenMeteoWeatherRepository _repository;
  late final WeatherDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _repository = OpenMeteoWeatherRepository();
    _controller = WeatherDashboardController(
      repository: _repository,
      preferences: widget.preferences,
    );
    unawaited(_controller.initialize());
  }

  @override
  void dispose() {
    _controller.dispose();
    _repository.close();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LocationSearchSheet(
          repository: _repository,
          selectedLocation: _controller.selectedLocation,
        );
      },
    );

    if (picked != null) {
      await _controller.refresh(location: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading && !_controller.hasData) {
          return const _LoadingView();
        }

        if (!_controller.hasData) {
          return _ErrorView(onRetry: _controller.refresh);
        }

        final report = _controller.report!;
        final guidance = _controller.guidance!;
        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppPalette.midnight,
                  Color(0xFF0D2231),
                  AppPalette.deepSea,
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                const _AmbientBackground(),
                SafeArea(
                  child: RefreshIndicator.adaptive(
                    onRefresh: _controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      children: <Widget>[
                        _HeroCard(
                          report: report,
                          guidance: guidance,
                          refreshing: _controller.isRefreshing,
                          onRefresh: _controller.refresh,
                          onPickLocation: _openLocationPicker,
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 940;
                            final leftColumn = <Widget>[
                              _NextHourCard(report: report, guidance: guidance),
                              const SizedBox(height: 16),
                              _DryWindowCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _WearCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _RiskCard(guidance: guidance),
                            ];
                            final rightColumn = <Widget>[
                              _HourlyStripCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _CommuteCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _ActivitiesCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _FooterNote(report: report),
                            ];

                            if (!wide) {
                              return Column(
                                children: <Widget>[
                                  ...leftColumn.take(1),
                                  ...rightColumn.take(1),
                                  ...leftColumn.skip(1).take(1),
                                  ...rightColumn.skip(1).take(1),
                                  ...leftColumn.skip(2).take(1),
                                  ...rightColumn.skip(2).take(1),
                                  ...leftColumn.skip(3),
                                  ...rightColumn.skip(3),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(children: leftColumn),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(children: rightColumn),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.report,
    required this.guidance,
    required this.refreshing,
    required this.onRefresh,
    required this.onPickLocation,
  });

  final WeatherReport report;
  final WeatherGuidance guidance;
  final bool refreshing;
  final Future<void> Function() onRefresh;
  final VoidCallback onPickLocation;

  @override
  Widget build(BuildContext context) {
    final descriptor = describeWeatherCode(
      report.current.weatherCode,
      isDay: report.current.isDay,
    );
    final theme = Theme.of(context);

    return GlassCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.04),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dry Slots',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppPalette.sky,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guidance.headline.title,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      guidance.headline.detail,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton.tonalIcon(
                onPressed: refreshing ? null : onRefresh,
                icon: Icon(refreshing ? Icons.sync_rounded : Icons.refresh_rounded),
                label: Text(refreshing ? 'Refreshing' : 'Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _SoftChip(
                icon: Icons.place_rounded,
                label: report.location.name,
                onTap: onPickLocation,
              ),
              _SoftChip(
                icon: descriptor.icon,
                label: descriptor.label,
              ),
              _SoftChip(
                icon: report.usingFallback ? Icons.dataset_outlined : Icons.cloud_sync_rounded,
                label: report.sourceLabel,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 74,
                width: 74,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(descriptor.icon, size: 38, color: AppPalette.sky),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      descriptor.summary,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      guidance.simpleSummary,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatTemperature(report.current.temperatureC),
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 52),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MetricTile(
                label: 'Feels like',
                value: formatTemperature(report.current.apparentTemperatureC),
                icon: Icons.device_thermostat_rounded,
              ),
              _MetricTile(
                label: 'Wind',
                value: formatWind(report.current.windSpeedKph),
                icon: Icons.air_rounded,
              ),
              _MetricTile(
                label: 'Rain today',
                value: formatRain(report.today.precipitationMm),
                icon: Icons.water_drop_rounded,
              ),
              _MetricTile(
                label: 'Updated',
                value: formatCompactClock(report.fetchedAt),
                icon: Icons.schedule_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              _TonePill(
                tone: guidance.nextHour.tone,
                label: guidance.nextHour.departureAdvice,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  formatDateHeader(report.fetchedAt),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextHourCard extends StatelessWidget {
  const _NextHourCard({required this.report, required this.guidance});

  final WeatherReport report;
  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    final slots = report.minutely.take(4).toList(growable: false);
    final maxPrecipitation = slots.fold<double>(
      0,
      (value, slot) => value > slot.precipitationMm ? value : slot.precipitationMm,
    );

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Next Hour Rain',
            title: 'Should you head out now?',
            icon: Icons.timeline_rounded,
          ),
          const SizedBox(height: 10),
          Text(guidance.nextHour.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(guidance.nextHour.detail, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: slots.map((slot) {
                final normalized = maxPrecipitation == 0
                    ? 0.12
                    : (slot.precipitationMm / maxPrecipitation).clamp(0.14, 1.0);
                final isWet = slot.precipitationMm >= 0.08;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          formatRain(slot.precipitationMm),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          height: 18 + normalized * 62,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: <Color>[
                                isWet ? AppPalette.sky : AppPalette.teal.withValues(alpha: 0.72),
                                Colors.white.withValues(alpha: 0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppPalette.sky.withValues(alpha: 0.22),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slot == slots.first ? 'Now' : formatCompactClock(slot.time),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MiniStat(label: 'Max burst', value: formatRain(guidance.nextHour.maxPrecipitationMm)),
              _MiniStat(label: 'Visibility', value: formatVisibility(report.current.visibilityMeters)),
              _MiniStat(label: 'Wind', value: formatWind(report.current.windSpeedKph)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DryWindowCard extends StatelessWidget {
  const _DryWindowCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    final window = guidance.dryWindow;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Best Dry Window',
            title: 'Use the cleanest part of the day',
            icon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 14),
          if (window.isAvailable && window.start != null && window.end != null) ...<Widget>[
            Text(
              formatTimeRange(window.start!, window.end!),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _TonePill(
                  tone: window.tone,
                  label: formatDurationShort(window.duration),
                ),
                _SoftChip(
                  icon: Icons.verified_outlined,
                  label: window.confidenceLabel,
                ),
              ],
            ),
          ] else ...<Widget>[
            Text(
              'No reliable dry block stands out',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
          const SizedBox(height: 14),
          Text(window.note, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HourlyStripCard extends StatelessWidget {
  const _HourlyStripCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'At A Glance',
            title: 'Next six hours',
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: guidance.highlightHours.map((slot) {
              final descriptor = describeWeatherCode(
                slot.weatherCode,
                isDay: slot.isDay,
              );
              return Container(
                width: 94,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      formatCompactClock(slot.time),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    Icon(descriptor.icon, color: AppPalette.sky),
                    const SizedBox(height: 10),
                    Text(
                      formatTemperature(slot.temperatureC),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatPercent(slot.precipitationProbability),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _CommuteCard extends StatelessWidget {
  const _CommuteCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Commute',
            title: 'How the key travel windows look',
            icon: Icons.commute_rounded,
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(child: _CommuteTile(leg: guidance.commute.morning)),
              const SizedBox(width: 12),
              Expanded(child: _CommuteTile(leg: guidance.commute.evening)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WearCard extends StatelessWidget {
  const _WearCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'What To Wear',
            title: 'Practical kit for today',
            icon: Icons.checkroom_rounded,
          ),
          const SizedBox(height: 18),
          ...guidance.wearTips.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(tip.icon, color: AppPalette.teal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(tip.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(tip.detail, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActivitiesCard extends StatelessWidget {
  const _ActivitiesCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Suitable Today',
            title: 'How the day stacks up for real plans',
            icon: Icons.event_available_rounded,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: guidance.activities.map((activity) {
              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
                child: _ActivityTile(activity: activity),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Severe Risk',
            title: 'Anything worth a second look?',
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 18),
          ...guidance.risks.map((risk) {
            final color = switch (risk.level) {
              RiskLevel.calm => AppPalette.teal,
              RiskLevel.headsUp => AppPalette.amber,
              RiskLevel.high => AppPalette.coral,
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.24)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(risk.icon, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(risk.title, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(risk.detail, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 20),
      child: Text(
        report.sourceNote ??
            'Weather data is provided by Open-Meteo when live forecasts are available.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _CommuteTile extends StatelessWidget {
  const _CommuteTile({required this.leg});

  final CommuteLeg leg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(leg.label, style: Theme.of(context).textTheme.titleLarge),
              ),
              _TonePill(
                tone: leg.tone,
                label: '${leg.score}/100',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(formatTimeRange(leg.start, leg.end), style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(leg.detail, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityRecommendation activity;

  @override
  Widget build(BuildContext context) {
    final color = switch (activity.suitability) {
      ActivitySuitability.great => AppPalette.teal,
      ActivitySuitability.okay => AppPalette.amber,
      ActivitySuitability.poor => AppPalette.coral,
    };
    final label = switch (activity.suitability) {
      ActivitySuitability.great => 'Good',
      ActivitySuitability.okay => 'Manageable',
      ActivitySuitability.poor => 'Low confidence',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(activity.icon, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(activity.name, style: Theme.of(context).textTheme.titleMedium),
              ),
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 10),
          Text(activity.detail, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: AppPalette.sky, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _TonePill extends StatelessWidget {
  const _TonePill({required this.tone, required this.label});

  final AdviceTone tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AdviceTone.go => AppPalette.teal,
      AdviceTone.watch => AppPalette.amber,
      AdviceTone.wait => AppPalette.coral,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: AppPalette.sky),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: content,
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.gradient,
  });

  final Widget child;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.09),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppPalette.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppPalette.glow,
                blurRadius: 26,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppPalette.sky),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppPalette.sky),
              ),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppPalette.midnight,
              AppPalette.deepSea,
              Color(0xFF163A4D),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            _AmbientBackground(),
            Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 22),
                    Text(
                      'Building your weather day plan...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppPalette.midnight,
              AppPalette.deepSea,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.cloud_off_rounded, size: 44, color: AppPalette.coral),
                  const SizedBox(height: 16),
                  Text('Weather feed unavailable', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Dry Slots could not load the forecast. Try again in a moment.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            left: -60,
            child: _GlowOrb(
              size: 260,
              color: AppPalette.sky.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            top: 220,
            right: -90,
            child: _GlowOrb(
              size: 240,
              color: AppPalette.teal.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -100,
            left: 40,
            child: _GlowOrb(
              size: 280,
              color: AppPalette.amber.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class LocationSearchSheet extends StatefulWidget {
  const LocationSearchSheet({
    super.key,
    required this.repository,
    required this.selectedLocation,
  });

  final WeatherRepository repository;
  final WeatherLocation selectedLocation;

  @override
  State<LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<LocationSearchSheet> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;
  List<WeatherLocation> _results = WeatherLocation.presets;
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _handleSearch(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.length < 2) {
      setState(() {
        _loading = false;
        _results = _filterPresets(query);
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 280), () async {
      setState(() {
        _loading = true;
      });
      final results = await widget.repository.searchLocations(query);
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _results = results;
      });
    });
  }

  List<WeatherLocation> _filterPresets(String query) {
    if (query.isEmpty) {
      return WeatherLocation.presets;
    }
    final lower = query.toLowerCase();
    return WeatherLocation.presets.where((location) {
      return location.name.toLowerCase().contains(lower) ||
          location.region.toLowerCase().contains(lower);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF081520),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              Container(
                height: 5,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Choose a UK location', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Search towns and cities, or pick a quick preset.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      onChanged: _handleSearch,
                      autofocus: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search UK town or city',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _results.length + (_loading ? 1 : 0),
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (_loading && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                      );
                    }
                    final offset = _loading ? index - 1 : index;
                    final location = _results[offset];
                    final selected = location.name == widget.selectedLocation.name &&
                        location.region == widget.selectedLocation.region;
                    return InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => Navigator.of(context).pop(location),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: selected
                                ? AppPalette.sky.withValues(alpha: 0.45)
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.place_rounded, color: AppPalette.sky),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(location.name, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(location.subtitle, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check_circle_rounded, color: AppPalette.teal),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
