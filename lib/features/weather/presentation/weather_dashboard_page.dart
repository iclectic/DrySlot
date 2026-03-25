import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/app_analytics.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../activities/presentation/activity_detail_sheet.dart';
import '../../locations/presentation/location_search_sheet.dart';
import '../../routines/presentation/commute_windows_sheet.dart';
import '../../settings/presentation/display_settings_sheet.dart';
import '../../weather_core/domain/weather_describer.dart';
import '../../weather_core/domain/weather_models.dart';
import '../../weather_core/presentation/weather_dashboard_controller.dart';
import '../../weather_core/data/weather_repository.dart';

class WeatherDashboardPage extends ConsumerStatefulWidget {
  const WeatherDashboardPage({super.key});

  @override
  ConsumerState<WeatherDashboardPage> createState() =>
      _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends ConsumerState<WeatherDashboardPage> {
  bool _showMoreDetail = false;
  String? _lastAnalyticsSnapshot;

  @override
  void initState() {
    super.initState();
    unawaited(
      ref.read(weatherDashboardControllerProvider.notifier).initialize(),
    );
  }

  Future<void> _openLocationPicker() async {
    final state = ref.read(weatherDashboardControllerProvider);
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LocationSearchSheet(
          repository: ref.read(weatherRepositoryProvider),
          selectedLocation: state.selectedLocation,
        );
      },
    );

    if (picked != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .refresh(location: picked);
    }
  }

  Future<void> _openCommuteWindowManager() async {
    final state = ref.read(weatherDashboardControllerProvider);
    final result = await showModalBottomSheet<List<SavedCommuteWindow>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommuteWindowsSheet(initialWindows: state.commuteWindows);
      },
    );

    if (result != null) {
      final existingIds = state.commuteWindows
          .map((window) => window.id)
          .toSet();
      final createdCount = result
          .where((window) => !existingIds.contains(window.id))
          .length;
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .saveCommuteWindows(result);
      if (createdCount > 0) {
        unawaited(
          ref
              .read(appAnalyticsProvider)
              .trackRoutineCreated(
                createdCount: createdCount,
                totalCount: result.length,
              ),
        );
      }
    }
  }

  Future<void> _openComparisonPicker() async {
    final state = ref.read(weatherDashboardControllerProvider);
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LocationSearchSheet(
          repository: ref.read(weatherRepositoryProvider),
          selectedLocation: state.comparisonLocation ?? state.selectedLocation,
        );
      },
    );

    if (picked != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .setComparisonLocation(picked);
    }
  }

  Future<void> _openDisplaySettings() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const DisplaySettingsSheet();
      },
    );
  }

  Future<void> _openActivityDetails(ActivityRecommendation activity) async {
    unawaited(
      ref
          .read(appAnalyticsProvider)
          .trackActivityCardTapped(activity: activity),
    );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ActivityDetailSheet(activity: activity);
      },
    );
  }

  void _trackDashboardInsights(WeatherDashboardState state) {
    final report = state.report;
    final guidance = state.guidance;
    if (report == null || guidance == null) {
      return;
    }

    final snapshot =
        '${report.location.name}:${report.fetchedAt.toIso8601String()}:${guidance.dryWindow.headline}:${guidance.commute.windows.length}';
    if (_lastAnalyticsSnapshot == snapshot) {
      return;
    }
    _lastAnalyticsSnapshot = snapshot;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final analytics = ref.read(appAnalyticsProvider);
      unawaited(analytics.trackBestDrySlotViewed(window: guidance.dryWindow));
      unawaited(
        analytics.trackCommuteChecked(
          routineCount: guidance.commute.windows.length,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherDashboardControllerProvider);
    if (state.isLoading && !state.hasData) {
      return const _LoadingView();
    }

    if (!state.hasData) {
      return _ErrorView(
        onRetry: () =>
            ref.read(weatherDashboardControllerProvider.notifier).refresh(),
      );
    }

    final report = state.report!;
    final guidance = state.guidance!;
    _trackDashboardInsights(state);
    final priorityRisk = _shouldPinRisk(guidance);
    final detailCards = <Widget>[
      _HourlyStripCard(
        guidance: guidance,
        explanationMode: state.explanationMode,
      ),
      const SizedBox(height: 16),
      _ActivitiesCard(
        guidance: guidance,
        onTap: (activity) {
          unawaited(_openActivityDetails(activity));
        },
      ),
      const SizedBox(height: 16),
      if (!priorityRisk) ...<Widget>[
        _RiskCard(guidance: guidance),
        const SizedBox(height: 16),
      ],
      _WidgetSummaryStrip(guidance: guidance),
    ];
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: _pageBackgroundGradient(context)),
        child: Stack(
          children: <Widget>[
            const _AmbientBackground(),
            SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: () => ref
                    .read(weatherDashboardControllerProvider.notifier)
                    .refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: <Widget>[
                    _HeroCard(
                      report: report,
                      guidance: guidance,
                      explanationMode: state.explanationMode,
                      refreshing: state.isRefreshing,
                      onRefresh: () => ref
                          .read(weatherDashboardControllerProvider.notifier)
                          .refresh(),
                      onPickLocation: _openLocationPicker,
                      onOpenDisplaySettings: _openDisplaySettings,
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 940;
                        final leftColumn = <Widget>[
                          _NextHourCard(
                            report: report,
                            guidance: guidance,
                            explanationMode: state.explanationMode,
                          ),
                          const SizedBox(height: 16),
                          _DryWindowCard(guidance: guidance),
                          const SizedBox(height: 16),
                          _DailyGuidanceCard(
                            guidance: guidance,
                            explanationMode: state.explanationMode,
                          ),
                          const SizedBox(height: 16),
                          if (priorityRisk) ...<Widget>[
                            _RiskCard(guidance: guidance),
                            const SizedBox(height: 16),
                          ],
                          _CommuteCard(
                            guidance: guidance,
                            onManageWindows: _openCommuteWindowManager,
                          ),
                          const SizedBox(height: 16),
                          _WearCard(guidance: guidance),
                        ];
                        final rightColumn = <Widget>[
                          _WeekendPlannerCard(guidance: guidance),
                          const SizedBox(height: 16),
                          _CompareCitiesCard(
                            primaryReport: report,
                            primaryGuidance: guidance,
                            comparisonLocation: state.comparisonLocation,
                            comparisonReport: state.comparisonReport,
                            comparisonGuidance: state.comparisonGuidance,
                            onChooseLocation: _openComparisonPicker,
                            onClear: () => ref
                                .read(
                                  weatherDashboardControllerProvider.notifier,
                                )
                                .clearComparisonLocation(),
                          ),
                          const SizedBox(height: 16),
                          _DetailToggleCard(
                            expanded: _showMoreDetail,
                            includesRisk: !priorityRisk,
                            onToggle: () {
                              setState(() {
                                _showMoreDetail = !_showMoreDetail;
                              });
                            },
                          ),
                          if (_showMoreDetail) ...<Widget>[
                            const SizedBox(height: 16),
                            ...detailCards,
                          ],
                          const SizedBox(height: 16),
                          _FooterNote(report: report),
                        ];
                        final narrowCards = <Widget>[
                          _NextHourCard(
                            report: report,
                            guidance: guidance,
                            explanationMode: state.explanationMode,
                          ),
                          const SizedBox(height: 16),
                          _DryWindowCard(guidance: guidance),
                          const SizedBox(height: 16),
                          _DailyGuidanceCard(
                            guidance: guidance,
                            explanationMode: state.explanationMode,
                          ),
                          const SizedBox(height: 16),
                          if (priorityRisk) ...<Widget>[
                            _RiskCard(guidance: guidance),
                            const SizedBox(height: 16),
                          ],
                          _CommuteCard(
                            guidance: guidance,
                            onManageWindows: _openCommuteWindowManager,
                          ),
                          const SizedBox(height: 16),
                          _WearCard(guidance: guidance),
                          const SizedBox(height: 16),
                          _WeekendPlannerCard(guidance: guidance),
                          const SizedBox(height: 16),
                          _CompareCitiesCard(
                            primaryReport: report,
                            primaryGuidance: guidance,
                            comparisonLocation: state.comparisonLocation,
                            comparisonReport: state.comparisonReport,
                            comparisonGuidance: state.comparisonGuidance,
                            onChooseLocation: _openComparisonPicker,
                            onClear: () => ref
                                .read(
                                  weatherDashboardControllerProvider.notifier,
                                )
                                .clearComparisonLocation(),
                          ),
                          const SizedBox(height: 16),
                          _DetailToggleCard(
                            expanded: _showMoreDetail,
                            includesRisk: !priorityRisk,
                            onToggle: () {
                              setState(() {
                                _showMoreDetail = !_showMoreDetail;
                              });
                            },
                          ),
                          if (_showMoreDetail) ...<Widget>[
                            const SizedBox(height: 16),
                            ...detailCards,
                            const SizedBox(height: 16),
                          ],
                          const SizedBox(height: 16),
                          _FooterNote(report: report),
                        ];

                        if (!wide) {
                          return Column(children: narrowCards);
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: Column(children: leftColumn)),
                            const SizedBox(width: 16),
                            Expanded(child: Column(children: rightColumn)),
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
  }
}

bool _shouldPinRisk(WeatherGuidance guidance) {
  return guidance.risks.any(
    (risk) =>
        risk.level == RiskLevel.high || risk.source == AlertSource.official,
  );
}

bool _highContrast(BuildContext context) {
  return MediaQuery.maybeOf(context)?.highContrast ?? false;
}

bool _reduceMotion(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery != null) {
    return mediaQuery.disableAnimations || mediaQuery.accessibleNavigation;
  }
  final features =
      WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
  return features.disableAnimations || features.accessibleNavigation;
}

LinearGradient _pageBackgroundGradient(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  return isDark
      ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppPalette.midnight,
            highContrast ? const Color(0xFF081520) : const Color(0xFF0D2231),
            highContrast ? const Color(0xFF123041) : AppPalette.deepSea,
          ],
        )
      : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppPalette.dawn,
            highContrast ? Colors.white : const Color(0xFFF7FBFE),
            highContrast ? AppPalette.snow : AppPalette.pearl,
          ],
        );
}

LinearGradient _glassGradient(BuildContext context, {bool prominent = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  if (isDark && prominent) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.white.withValues(alpha: highContrast ? 0.2 : 0.12),
        Colors.white.withValues(alpha: highContrast ? 0.08 : 0.04),
      ],
    );
  }
  if (isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.white.withValues(alpha: highContrast ? 0.16 : 0.09),
        Colors.white.withValues(alpha: highContrast ? 0.06 : 0.03),
      ],
    );
  }
  if (prominent) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        highContrast ? Colors.white : const Color(0xF9FFFFFF),
        highContrast ? AppPalette.mist : const Color(0xF3F3FAFF),
      ],
    );
  }
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      highContrast ? Colors.white : const Color(0xF7FFFFFF),
      highContrast ? AppPalette.snow : const Color(0xEEF1F7FB),
    ],
  );
}

Color _surfaceFill(BuildContext context, {bool strong = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  if (isDark) {
    return Colors.white.withValues(
      alpha: strong
          ? (highContrast ? 0.18 : 0.08)
          : (highContrast ? 0.12 : 0.05),
    );
  }
  return strong
      ? (highContrast ? Colors.white : const Color(0xFFF9FCFF))
      : (highContrast ? const Color(0xFFFBFDFF) : const Color(0xF2FFFFFF));
}

Color _surfaceBorder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  return isDark
      ? Colors.white.withValues(alpha: highContrast ? 0.24 : 0.08)
      : AppPalette.ink.withValues(alpha: highContrast ? 0.22 : 0.08);
}

Color _ambientOrbColor(
  BuildContext context,
  Color darkColor,
  Color lightColor,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? darkColor : lightColor;
}

Color _glowShadow(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highContrast = _highContrast(context);
  if (highContrast) {
    return isDark ? Colors.black.withValues(alpha: 0.18) : Colors.transparent;
  }
  return isDark ? AppPalette.glow : AppPalette.ink.withValues(alpha: 0.08);
}

String _comfortSummary(double apparentTemperatureC) {
  if (apparentTemperatureC <= 1) {
    return 'Very cold';
  }
  if (apparentTemperatureC <= 7) {
    return 'Chilly';
  }
  if (apparentTemperatureC <= 13) {
    return 'Cool';
  }
  if (apparentTemperatureC <= 19) {
    return 'Mild';
  }
  if (apparentTemperatureC <= 25) {
    return 'Warm';
  }
  return 'Hot';
}

String _windSummary(double windSpeedKph) {
  if (windSpeedKph < 12) {
    return 'Light';
  }
  if (windSpeedKph < 24) {
    return 'Breezy';
  }
  if (windSpeedKph < 36) {
    return 'Windy';
  }
  return 'Very windy';
}

String _dayAheadSummary(DailyForecast today) {
  if (today.precipitationProbabilityMax >= 70 || today.precipitationMm >= 4) {
    return 'Wet spells';
  }
  if (today.precipitationProbabilityMax >= 35 || today.precipitationMm >= 1) {
    return 'Changeable';
  }
  return 'Mostly dry';
}

String _visibilitySummary(double meters) {
  if (meters < 1500) {
    return 'Poor';
  }
  if (meters < 6000) {
    return 'A bit murky';
  }
  return 'Clear';
}

String _rainSummary(double millimetres) {
  if (millimetres < 0.08) {
    return 'Dry';
  }
  if (millimetres < 0.35) {
    return 'Light showers';
  }
  if (millimetres < 1) {
    return 'Rainy';
  }
  return 'Heavy rain';
}

String _hourlyOutlookLabel(HourlyForecast slot) {
  if (slot.precipitationMm >= 0.8 || slot.precipitationProbability >= 70) {
    return 'Wet';
  }
  if (slot.precipitationMm >= 0.08 || slot.precipitationProbability >= 35) {
    return 'Showers';
  }
  final descriptor = describeWeatherCode(slot.weatherCode, isDay: slot.isDay);
  if (descriptor.label.toLowerCase().contains('clear') ||
      descriptor.label.toLowerCase().contains('sun')) {
    return 'Bright';
  }
  if (slot.cloudCover >= 70) {
    return 'Cloudy';
  }
  return 'Dry';
}

int _outdoorReadinessScore(WeatherReport report, WeatherGuidance guidance) {
  var score = 60;
  score += guidance.nextHour.tone == AdviceTone.go
      ? 12
      : guidance.nextHour.tone == AdviceTone.watch
      ? 3
      : -12;
  score += guidance.dryWindow.isAvailable
      ? guidance.dryWindow.duration.inMinutes >= 120
            ? 14
            : 6
      : -8;
  score -= report.today.precipitationProbabilityMax >= 70
      ? 16
      : report.today.precipitationProbabilityMax >= 40
      ? 8
      : 0;
  score -= report.today.maxWindKph >= 34
      ? 10
      : report.today.maxWindKph >= 24
      ? 5
      : 0;
  score += report.today.maxTempC >= 13 && report.today.maxTempC <= 22 ? 5 : 0;
  return score.clamp(0, 100);
}

String _comparisonHeadline(
  WeatherReport primaryReport,
  WeatherGuidance primaryGuidance,
  WeatherReport comparisonReport,
  WeatherGuidance comparisonGuidance,
) {
  final primaryScore = _outdoorReadinessScore(primaryReport, primaryGuidance);
  final comparisonScore = _outdoorReadinessScore(
    comparisonReport,
    comparisonGuidance,
  );
  final diff = (primaryScore - comparisonScore).abs();
  if (diff < 8) {
    return 'Both cities look fairly close today';
  }
  final winner = primaryScore > comparisonScore
      ? primaryReport.location.name
      : comparisonReport.location.name;
  return '$winner looks like the easier outdoor choice';
}

String _comparisonDetail(
  WeatherReport primaryReport,
  WeatherGuidance primaryGuidance,
  WeatherReport comparisonReport,
  WeatherGuidance comparisonGuidance,
) {
  final warmer = primaryReport.today.maxTempC >= comparisonReport.today.maxTempC
      ? primaryReport.location.name
      : comparisonReport.location.name;
  final drier =
      primaryReport.today.precipitationProbabilityMax <=
          comparisonReport.today.precipitationProbabilityMax
      ? primaryReport.location.name
      : comparisonReport.location.name;
  final betterDrySlot =
      primaryGuidance.dryWindow.duration >=
          comparisonGuidance.dryWindow.duration
      ? primaryReport.location.name
      : comparisonReport.location.name;
  return '$warmer is warmer, $drier has the lower rain risk, and $betterDrySlot has the stronger dry slot.';
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.report,
    required this.guidance,
    required this.explanationMode,
    required this.refreshing,
    required this.onRefresh,
    required this.onPickLocation,
    required this.onOpenDisplaySettings,
  });

  final WeatherReport report;
  final WeatherGuidance guidance;
  final ExplanationMode explanationMode;
  final bool refreshing;
  final Future<void> Function() onRefresh;
  final VoidCallback onPickLocation;
  final VoidCallback onOpenDisplaySettings;

  @override
  Widget build(BuildContext context) {
    final descriptor = describeWeatherCode(
      report.current.weatherCode,
      isDay: report.current.isDay,
    );
    final theme = Theme.of(context);
    final metricTiles = explanationMode == ExplanationMode.detailed
        ? <Widget>[
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
          ]
        : <Widget>[
            _MetricTile(
              label: 'Comfort',
              value: _comfortSummary(report.current.apparentTemperatureC),
              icon: Icons.self_improvement_rounded,
            ),
            _MetricTile(
              label: 'Wind feel',
              value: _windSummary(report.current.windSpeedKph),
              icon: Icons.air_rounded,
            ),
            _MetricTile(
              label: 'Day ahead',
              value: _dayAheadSummary(report.today),
              icon: Icons.event_available_rounded,
            ),
            _MetricTile(
              label: 'Updated',
              value: formatCompactClock(report.fetchedAt),
              icon: Icons.schedule_rounded,
            ),
          ];

    return GlassCard(
      gradient: _glassGradient(context, prominent: true),
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
                icon: Icon(
                  refreshing ? Icons.sync_rounded : Icons.refresh_rounded,
                ),
                label: Text(refreshing ? 'Refreshing' : 'Refresh'),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: onOpenDisplaySettings,
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Display settings',
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
                semanticHint: 'Opens the UK location picker',
              ),
              _SoftChip(icon: descriptor.icon, label: descriptor.label),
              _SoftChip(
                icon: report.usingFallback
                    ? Icons.dataset_outlined
                    : Icons.cloud_sync_rounded,
                label: report.sourceLabel,
              ),
              _SoftChip(
                icon: explanationMode == ExplanationMode.simple
                    ? Icons.auto_awesome_outlined
                    : Icons.tune_rounded,
                label: '${explanationMode.label} guidance',
                onTap: onOpenDisplaySettings,
                semanticHint: 'Opens display and guidance settings',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 74,
                width: 74,
                decoration: BoxDecoration(
                  color: _surfaceFill(context, strong: true),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(descriptor.icon, size: 38, color: AppPalette.sky),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(descriptor.summary, style: theme.textTheme.titleLarge),
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
          Wrap(spacing: 12, runSpacing: 12, children: metricTiles),
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
            eyebrow: 'Home Widgets',
            title: 'What will your quick-glance cards say?',
            icon: Icons.widgets_outlined,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: guidance.homeCards
                .map((card) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 220,
                      maxWidth: 280,
                    ),
                    child: _WidgetSummaryTile(card: card),
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _NextHourCard extends StatelessWidget {
  const _NextHourCard({
    required this.report,
    required this.guidance,
    required this.explanationMode,
  });

  final WeatherReport report;
  final WeatherGuidance guidance;
  final ExplanationMode explanationMode;

  @override
  Widget build(BuildContext context) {
    final slots = report.minutely.take(4).toList(growable: false);
    final maxPrecipitation = slots.fold<double>(
      0,
      (value, slot) =>
          value > slot.precipitationMm ? value : slot.precipitationMm,
    );

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Next Hour Rain',
            title: 'Can you head out now?',
            icon: Icons.timeline_rounded,
          ),
          const SizedBox(height: 10),
          Text(
            guidance.nextHour.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            guidance.nextHour.detail,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: slots
                  .map((slot) {
                    final label = slot == slots.first
                        ? 'Now'
                        : formatCompactClock(slot.time);
                    final normalized = maxPrecipitation == 0
                        ? 0.12
                        : (slot.precipitationMm / maxPrecipitation).clamp(
                            0.14,
                            1.0,
                          );
                    final isWet = slot.precipitationMm >= 0.08;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Semantics(
                          container: true,
                          label:
                              '$label, ${formatRain(slot.precipitationMm)} of rain expected',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                formatRain(slot.precipitationMm),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: _reduceMotion(context)
                                    ? Duration.zero
                                    : const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                height: 18 + normalized * 62,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      isWet
                                          ? AppPalette.sky
                                          : AppPalette.teal.withValues(
                                              alpha: 0.72,
                                            ),
                                      Colors.white.withValues(alpha: 0.9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: AppPalette.sky.withValues(
                                        alpha: 0.22,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                label,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: explanationMode == ExplanationMode.detailed
                ? <Widget>[
                    _MiniStat(
                      label: 'Max burst',
                      value: formatRain(guidance.nextHour.maxPrecipitationMm),
                    ),
                    _MiniStat(
                      label: 'Visibility',
                      value: formatVisibility(report.current.visibilityMeters),
                    ),
                    _MiniStat(
                      label: 'Wind',
                      value: formatWind(report.current.windSpeedKph),
                    ),
                  ]
                : <Widget>[
                    _MiniStat(
                      label: 'Rain outlook',
                      value: _rainSummary(guidance.nextHour.maxPrecipitationMm),
                    ),
                    _MiniStat(
                      label: 'Air clarity',
                      value: _visibilitySummary(
                        report.current.visibilityMeters,
                      ),
                    ),
                    _MiniStat(
                      label: 'Wind feel',
                      value: _windSummary(report.current.windSpeedKph),
                    ),
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
            title: 'When is the best time to head out?',
            icon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 14),
          Text(
            window.headline,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (window.isAvailable &&
              window.start != null &&
              window.end != null) ...<Widget>[
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
  const _HourlyStripCard({
    required this.guidance,
    required this.explanationMode,
  });

  final WeatherGuidance guidance;
  final ExplanationMode explanationMode;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Next Six Hours',
            title: 'How does the next stretch look?',
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: guidance.highlightHours
                .map((slot) {
                  final descriptor = describeWeatherCode(
                    slot.weatherCode,
                    isDay: slot.isDay,
                  );
                  return Container(
                    width: 94,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: _surfaceFill(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _surfaceBorder(context)),
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
                          explanationMode == ExplanationMode.detailed
                              ? formatPercent(slot.precipitationProbability)
                              : _hourlyOutlookLabel(slot),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _DailyGuidanceCard extends StatelessWidget {
  const _DailyGuidanceCard({
    required this.guidance,
    required this.explanationMode,
  });

  final WeatherGuidance guidance;
  final ExplanationMode explanationMode;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionHeader(
            eyebrow: 'Daily Advice',
            title: 'What should you do today?',
            icon: Icons.chat_bubble_outline_rounded,
          ),
          const SizedBox(height: 18),
          Text(
            guidance.simpleSummary,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _TonePill(
                tone: guidance.headline.tone,
                label: guidance.headline.callToAction,
              ),
              _SoftChip(
                icon: explanationMode == ExplanationMode.simple
                    ? Icons.auto_awesome_outlined
                    : Icons.tune_rounded,
                label: explanationMode == ExplanationMode.simple
                    ? 'Plain-English view'
                    : 'Detailed weather view',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekendPlannerCard extends StatelessWidget {
  const _WeekendPlannerCard({required this.guidance});

  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    final planner = guidance.weekendPlanner;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Weekend Planner',
            title: 'Which weekend day looks better?',
            icon: Icons.calendar_view_week_rounded,
          ),
          const SizedBox(height: 18),
          if (planner == null) ...<Widget>[
            Text(
              'Weekend outlook unavailable',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Dry Slots needs a longer-range forecast before it can steer weekend plans.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ] else ...<Widget>[
            Text(
              planner.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              planner.summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: planner.days
                  .map((day) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 240,
                        maxWidth: 320,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surfaceFill(context),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: _surfaceBorder(context)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    color: _surfaceFill(context, strong: true),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(day.icon, color: AppPalette.sky),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        day.label,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        day.headline,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                _TonePill(
                                  tone: day.tone,
                                  label: '${day.maxTempC.round()}°',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              day.summary,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompareCitiesCard extends StatelessWidget {
  const _CompareCitiesCard({
    required this.primaryReport,
    required this.primaryGuidance,
    required this.comparisonLocation,
    required this.comparisonReport,
    required this.comparisonGuidance,
    required this.onChooseLocation,
    required this.onClear,
  });

  final WeatherReport primaryReport;
  final WeatherGuidance primaryGuidance;
  final WeatherLocation? comparisonLocation;
  final WeatherReport? comparisonReport;
  final WeatherGuidance? comparisonGuidance;
  final VoidCallback onChooseLocation;
  final Future<void> Function() onClear;

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
                  eyebrow: 'Compare Two Cities',
                  title: 'Which city looks better today?',
                  icon: Icons.compare_arrows_rounded,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: onChooseLocation,
                icon: const Icon(Icons.add_location_alt_rounded),
                label: Text(comparisonReport == null ? 'Choose' : 'Change'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (comparisonReport == null ||
              comparisonGuidance == null) ...<Widget>[
            Text(
              'Compare today with another UK city',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Useful for checking where the better dry slot, calmer routine, or warmer window is.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ] else ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _ComparisonCityTile(
                    location: primaryReport.location,
                    report: primaryReport,
                    guidance: primaryGuidance,
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ComparisonCityTile(
                    location: comparisonReport!.location,
                    report: comparisonReport!,
                    guidance: comparisonGuidance!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surfaceFill(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _surfaceBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _comparisonHeadline(
                      primaryReport,
                      primaryGuidance,
                      comparisonReport!,
                      comparisonGuidance!,
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _comparisonDetail(
                      primaryReport,
                      primaryGuidance,
                      comparisonReport!,
                      comparisonGuidance!,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  unawaited(onClear());
                },
                icon: const Icon(Icons.close_rounded),
                label: const Text('Clear comparison'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CommuteCard extends StatelessWidget {
  const _CommuteCard({required this.guidance, required this.onManageWindows});

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
                  title: 'How do your routines look?',
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
            title: 'What should you wear?',
            icon: Icons.checkroom_rounded,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surfaceFill(context),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _surfaceBorder(context)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: _surfaceFill(context, strong: true),
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
                      color: _surfaceFill(context, strong: true),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(tip.icon, color: AppPalette.teal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tip.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tip.detail,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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

class _DetailToggleCard extends StatelessWidget {
  const _DetailToggleCard({
    required this.expanded,
    required this.includesRisk,
    required this.onToggle,
  });

  final bool expanded;
  final bool includesRisk;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'More Detail',
            title: 'Need the fuller picture?',
            icon: Icons.unfold_more_rounded,
          ),
          const SizedBox(height: 14),
          Text(
            expanded
                ? 'Extra forecast detail is open below. Collapse it again when you want a calmer view.'
                : includesRisk
                ? 'Open the next-six-hours view, activity scores, quieter alerts, and widget cards without crowding the main dashboard.'
                : 'Open the next-six-hours view, activity scores, and widget cards without crowding the main dashboard.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              const _SoftChip(
                icon: Icons.schedule_rounded,
                label: 'Next 6 hours',
              ),
              const _SoftChip(
                icon: Icons.event_available_rounded,
                label: 'Activities',
              ),
              if (includesRisk)
                const _SoftChip(
                  icon: Icons.warning_amber_rounded,
                  label: 'Alerts',
                ),
              const _SoftChip(
                icon: Icons.widgets_outlined,
                label: 'Home widgets',
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.tonalIcon(
            onPressed: onToggle,
            icon: Icon(
              expanded
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
            ),
            label: Text(expanded ? 'Hide extra detail' : 'Show more detail'),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesCard extends StatelessWidget {
  const _ActivitiesCard({required this.guidance, required this.onTap});

  final WeatherGuidance guidance;
  final ValueChanged<ActivityRecommendation> onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(
            eyebrow: 'Activity Scores',
            title: 'What can you do outside?',
            icon: Icons.event_available_rounded,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: guidance.activities
                .map((activity) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 240,
                      maxWidth: 320,
                    ),
                    child: _ActivityTile(
                      activity: activity,
                      onTap: () => onTap(activity),
                    ),
                  );
                })
                .toList(growable: false),
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
            title: 'Anything to watch for?',
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
                          Text(
                            risk.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            risk.detail,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          _SourcePill(label: risk.sourceLabel, color: color),
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
    return MergeSemantics(
      child: Semantics(
        container: true,
        label:
            '${leg.label}, ${leg.score} out of 100, ${formatTimeRange(leg.start, leg.end)}. ${leg.summary}. ${leg.detail}',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surfaceFill(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _surfaceBorder(context)),
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
                        Text(
                          leg.label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          leg.summary,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _TonePill(tone: leg.tone, label: '${leg.score}/100'),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatTimeRange(leg.start, leg.end),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(leg.detail, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComparisonCityTile extends StatelessWidget {
  const _ComparisonCityTile({
    required this.location,
    required this.report,
    required this.guidance,
    this.isPrimary = false,
  });

  final WeatherLocation location;
  final WeatherReport report;
  final WeatherGuidance guidance;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        container: true,
        label:
            '${location.name}, ${formatTemperature(report.current.temperatureC)}. ${guidance.nextHour.departureAdvice}. ${guidance.dryWindow.headline}',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surfaceFill(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isPrimary
                  ? AppPalette.sky.withValues(alpha: 0.3)
                  : _surfaceBorder(context),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (isPrimary)
                    _SourcePill(label: 'Current', color: AppPalette.sky),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formatTemperature(report.current.temperatureC),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                guidance.nextHour.departureAdvice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                guidance.dryWindow.headline,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity, required this.onTap});

  final ActivityRecommendation activity;
  final VoidCallback onTap;

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

    return MergeSemantics(
      child: Semantics(
        button: true,
        label:
            '${activity.name}, ${activity.score} out of 10, $label. ${activity.detail}',
        hint: 'Double tap for a fuller explanation',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surfaceFill(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _surfaceBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(activity.icon, color: color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activity.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${activity.score}/10',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(color: color),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: color),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activity.detail,
                    style: Theme.of(context).textTheme.bodySmall,
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
    return MergeSemantics(
      child: Semantics(
        container: true,
        label: '${card.title}. ${card.value}. ${card.detail}',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surfaceFill(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _surfaceBorder(context)),
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
              Text(card.value, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                card.detail,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourcePill extends StatelessWidget {
  const _SourcePill({required this.label, required this.color});

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
        color: _surfaceFill(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _surfaceBorder(context)),
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
        color: _surfaceFill(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _surfaceBorder(context)),
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
    this.semanticHint,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _surfaceFill(context, strong: true),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _surfaceBorder(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18, color: AppPalette.sky),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return MergeSemantics(child: content);
    }

    return Semantics(
      button: true,
      label: label,
      hint: semanticHint,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: content,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.gradient});

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
            gradient: gradient ?? _glassGradient(context),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _surfaceBorder(context)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _glowShadow(context),
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
            color: _surfaceFill(context, strong: true),
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
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppPalette.sky),
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
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: _pageBackgroundGradient(context)),
        child: Stack(
          children: <Widget>[
            const _AmbientBackground(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(strokeWidth: 3),
                    const SizedBox(height: 22),
                    Text(
                      'Working out today\'s best weather windows...',
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
        decoration: BoxDecoration(gradient: _pageBackgroundGradient(context)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 44,
                    color: AppPalette.coral,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Weather feed unavailable',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dry Slots could not load today\'s forecast. Try again in a moment.',
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
              color: _ambientOrbColor(
                context,
                AppPalette.sky.withValues(alpha: 0.14),
                AppPalette.sky.withValues(alpha: 0.14),
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -90,
            child: _GlowOrb(
              size: 240,
              color: _ambientOrbColor(
                context,
                AppPalette.teal.withValues(alpha: 0.12),
                AppPalette.teal.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: 40,
            child: _GlowOrb(
              size: 280,
              color: _ambientOrbColor(
                context,
                AppPalette.amber.withValues(alpha: 0.08),
                AppPalette.amber.withValues(alpha: 0.08),
              ),
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
          colors: <Color>[color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
