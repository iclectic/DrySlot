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

  Future<void> _openCommuteWindowManager() async {
    final result = await showModalBottomSheet<List<SavedCommuteWindow>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommuteWindowsSheet(
          initialWindows: _controller.commuteWindows,
        );
      },
    );

    if (result != null) {
      await _controller.saveCommuteWindows(result);
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
                        _WidgetSummaryStrip(guidance: guidance),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 940;
                            final leftColumn = <Widget>[
                              _NextHourCard(report: report, guidance: guidance),
                              const SizedBox(height: 16),
                              _DryWindowCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _DailyGuidanceCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _WearCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _RiskCard(guidance: guidance),
                            ];
                            final rightColumn = <Widget>[
                              _HourlyStripCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _CommuteCard(
                                guidance: guidance,
                                onManageWindows: _openCommuteWindowManager,
                              ),
                              const SizedBox(height: 16),
                              _ActivitiesCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _FooterNote(report: report),
                            ];
                            final narrowCards = <Widget>[
                              _NextHourCard(report: report, guidance: guidance),
                              const SizedBox(height: 16),
                              _HourlyStripCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _DryWindowCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _DailyGuidanceCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _CommuteCard(
                                guidance: guidance,
                                onManageWindows: _openCommuteWindowManager,
                              ),
                              const SizedBox(height: 16),
                              _WearCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _ActivitiesCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _RiskCard(guidance: guidance),
                              const SizedBox(height: 16),
                              _FooterNote(report: report),
                            ];

                            if (!wide) {
                              return Column(children: narrowCards);
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

class _WidgetSummaryStrip extends StatelessWidget {
  const _WidgetSummaryStrip({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Clean Widgets',
            title: 'Widget-ready home summaries',
            icon: Icons.widgets_outlined,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: guidance.homeCards.map((card) {
              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
                child: _WidgetSummaryTile(card: card),
              );
            }).toList(growable: false),
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
          Text(
            window.headline,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (window.isAvailable && window.start != null && window.end != null) ...<Widget>[
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

class _DailyGuidanceCard extends StatelessWidget {
  const _DailyGuidanceCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Simple Daily Guidance',
            title: 'Plain English, not weather jargon',
            icon: Icons.chat_bubble_outline_rounded,
          ),
          const SizedBox(height: 18),
          Text(
            guidance.simpleSummary,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _CommuteCard extends StatelessWidget {
  const _CommuteCard({
    required this.guidance,
    required this.onManageWindows,
  });

  final WeatherGuidance guidance;
  final VoidCallback onManageWindows;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: _SectionHeader(
                  eyebrow: 'Favourite Routines',
                  title: 'Your saved windows, scored daily',
                  icon: Icons.commute_rounded,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: onManageWindows,
                icon: const Icon(Icons.edit_calendar_rounded),
                label: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            guidance.commute.summary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ...guidance.commute.windows.map((leg) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CommuteTile(leg: leg),
            );
          }),
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
    final primaryTip = guidance.wearTips.first;
    final secondaryTips = guidance.wearTips.skip(1).toList(growable: false);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Outfit Suggestion',
            title: 'Practical clothing guidance',
            icon: Icons.checkroom_rounded,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(primaryTip.icon, color: AppPalette.teal),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        primaryTip.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        primaryTip.detail,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (secondaryTips.isNotEmpty) const SizedBox(height: 14),
          ...secondaryTips.map((tip) {
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
            eyebrow: 'Activity Scores',
            title: 'Simple scores out of 10',
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
            eyebrow: 'Severe Weather Alerts',
            title: 'Forecast risks and official warnings',
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
                          const SizedBox(height: 8),
                          _SourcePill(
                            label: risk.sourceLabel,
                            color: color,
                          ),
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
            'Weather data is provided by Open-Meteo, with Met Office warnings shown where available.',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(leg.label, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      leg.summary,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
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
      ActivitySuitability.great => 'Strong',
      ActivitySuitability.okay => 'Mixed',
      ActivitySuitability.poor => 'Weak',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${activity.score}/10',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(activity.detail, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _WidgetSummaryTile extends StatelessWidget {
  const _WidgetSummaryTile({required this.card});

  final HomeSummaryCard card;

  @override
  Widget build(BuildContext context) {
    final color = switch (card.tone) {
      AdviceTone.go => AppPalette.teal,
      AdviceTone.watch => AppPalette.amber,
      AdviceTone.wait => AppPalette.coral,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(card.icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  card.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            card.value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            card.detail,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SourcePill extends StatelessWidget {
  const _SourcePill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
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

class CommuteWindowsSheet extends StatefulWidget {
  const CommuteWindowsSheet({
    super.key,
    required this.initialWindows,
  });

  final List<SavedCommuteWindow> initialWindows;

  @override
  State<CommuteWindowsSheet> createState() => _CommuteWindowsSheetState();
}

class _CommuteWindowsSheetState extends State<CommuteWindowsSheet> {
  late List<SavedCommuteWindow> _windows;

  @override
  void initState() {
    super.initState();
    _windows = List<SavedCommuteWindow>.from(widget.initialWindows);
  }

  Future<void> _editWindow([SavedCommuteWindow? existing]) async {
    final result = await showModalBottomSheet<SavedCommuteWindow>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommuteWindowEditorSheet(
          initialWindow: existing,
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      final index = _windows.indexWhere((window) => window.id == result.id);
      if (index == -1) {
        _windows = <SavedCommuteWindow>[..._windows, result];
      } else {
        _windows = <SavedCommuteWindow>[
          ..._windows.take(index),
          result,
          ..._windows.skip(index + 1),
        ];
      }
      _windows.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.48,
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
                    Text(
                      'Favourite routines',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save the routines you care about and Dry Slots will summarise them each day.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.tonalIcon(
                          onPressed: _editWindow,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add routine'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _windows = SavedCommuteWindow.defaults;
                            });
                          },
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Reset examples'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _windows.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final window = _windows[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () => _editWindow(window),
                              borderRadius: BorderRadius.circular(18),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.schedule_rounded, color: AppPalette.sky),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          window.label,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatWindowMinutes(
                                            window.startMinutes,
                                            window.endMinutes,
                                          ),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _windows = _windows
                                    .where((item) => item.id != window.id)
                                    .toList(growable: false);
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_windows),
                    child: const Text('Save routines'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommuteWindowEditorSheet extends StatefulWidget {
  const CommuteWindowEditorSheet({
    super.key,
    this.initialWindow,
  });

  final SavedCommuteWindow? initialWindow;

  @override
  State<CommuteWindowEditorSheet> createState() => _CommuteWindowEditorSheetState();
}

class _CommuteWindowEditorSheetState extends State<CommuteWindowEditorSheet> {
  late final TextEditingController _labelController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialWindow;
    _labelController = TextEditingController(text: initial?.label ?? '');
    _startTime = _minutesToTimeOfDay(initial?.startMinutes ?? 8 * 60);
    _endTime = _minutesToTimeOfDay(initial?.endMinutes ?? 9 * 60);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  void _save() {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      return;
    }
    final window = SavedCommuteWindow(
      id: widget.initialWindow?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      label: label,
      startMinutes: _timeOfDayToMinutes(_startTime),
      endMinutes: _timeOfDayToMinutes(_endTime),
    );
    Navigator.of(context).pop(window);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF081520),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.initialWindow == null ? 'Add favourite routine' : 'Edit favourite routine',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _labelController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    hintText: 'Evening jog',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _TimeField(
                        label: 'Start',
                        value: _formatTimeOfDay(_startTime),
                        onTap: () => _pickTime(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimeField(
                        label: 'End',
                        value: _formatTimeOfDay(_endTime),
                        onTap: () => _pickTime(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Save window'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

String _formatWindowMinutes(int startMinutes, int endMinutes) {
  final start = _minutesToTimeOfDay(startMinutes);
  final end = _minutesToTimeOfDay(endMinutes);
  return '${_formatTimeOfDay(start)} to ${_formatTimeOfDay(end)}';
}

TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
  final normalized = ((totalMinutes % (24 * 60)) + (24 * 60)) % (24 * 60);
  return TimeOfDay(
    hour: normalized ~/ 60,
    minute: normalized % 60,
  );
}

int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour == 0
      ? 12
      : time.hour > 12
          ? time.hour - 12
          : time.hour;
  final suffix = time.hour >= 12 ? 'pm' : 'am';
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $suffix';
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
