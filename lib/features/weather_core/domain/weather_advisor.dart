import 'dart:math';

import '../../../core/utils/formatters.dart';
import '../../activities/domain/activity_score_service.dart';
import '../../alerts/domain/severe_alert_interpreter.dart';
import '../../commute/domain/commute_weather_service.dart';
import '../../dry_slots/domain/dry_slot_calculator.dart';
import '../../outfit/domain/outfit_recommendation_service.dart';
import '../../weather_home/domain/weather_summary_generator.dart';
import 'weather_interpreter.dart';
import 'weather_models.dart';

class WeatherAdvisor {
  const WeatherAdvisor({
    DrySlotCalculator drySlotCalculator = const DrySlotCalculator(),
    OutfitRecommendationService outfitRecommendationService =
        const OutfitRecommendationService(),
    ActivityScoreService activityScoreService = const ActivityScoreService(),
    CommuteWeatherService commuteWeatherService = const CommuteWeatherService(),
    WeatherSummaryGenerator weatherSummaryGenerator =
        const WeatherSummaryGenerator(),
    SevereAlertInterpreter severeAlertInterpreter =
        const SevereAlertInterpreter(),
  }) : _drySlotCalculator = drySlotCalculator,
       _outfitRecommendationService = outfitRecommendationService,
       _activityScoreService = activityScoreService,
       _commuteWeatherService = commuteWeatherService,
       _weatherSummaryGenerator = weatherSummaryGenerator,
       _severeAlertInterpreter = severeAlertInterpreter;

  final DrySlotCalculator _drySlotCalculator;
  final OutfitRecommendationService _outfitRecommendationService;
  final ActivityScoreService _activityScoreService;
  final CommuteWeatherService _commuteWeatherService;
  final WeatherSummaryGenerator _weatherSummaryGenerator;
  final SevereAlertInterpreter _severeAlertInterpreter;

  WeatherGuidance build(
    WeatherReport report, {
    required List<SavedCommuteWindow> commuteWindows,
    ExplanationMode explanationMode = ExplanationMode.simple,
  }) {
    final interpreter = WeatherInterpreter(explanationMode);

    final baseNextHour = _drySlotCalculator.buildNextHourInsight(report);
    final baseDryWindow = _drySlotCalculator.findBestDryWindow(report.hourly);
    final baseCommute = _commuteWeatherService.buildCommute(
      report.hourly,
      report.fetchedAt,
      commuteWindows,
    );
    final baseRisks = _severeAlertInterpreter.buildRisks(report);
    final baseWearTips = _outfitRecommendationService.buildWearTips(
      report,
      baseNextHour,
    );
    final baseActivities = _activityScoreService.buildActivities(
      report,
      baseDryWindow,
      baseNextHour,
    );
    final baseHeadline = _weatherSummaryGenerator.buildHeadline(
      report,
      baseNextHour,
      baseDryWindow,
      baseRisks,
    );
    final baseSimpleSummary = _weatherSummaryGenerator.buildSimpleSummary(
      report,
      baseNextHour,
      baseDryWindow,
      baseWearTips,
    );

    final nextHour = _interpretNextHour(baseNextHour, report, interpreter);
    final dryWindow = _interpretDryWindow(baseDryWindow, report, interpreter);
    final commute = _interpretCommute(baseCommute, report, interpreter);
    final risks = _interpretRisks(baseRisks, report, interpreter);
    final wearTips = _interpretWearTips(baseWearTips, report, interpreter);
    final activities = _interpretActivities(
      baseActivities,
      report,
      baseDryWindow,
      baseNextHour,
      interpreter,
    );
    final headline = _interpretHeadline(
      baseHeadline,
      report,
      dryWindow,
      risks,
      interpreter,
    );
    final weekendPlanner = _interpretWeekendPlanner(
      _drySlotCalculator.buildWeekendPlanner(report.daily, report.fetchedAt),
      interpreter,
    );
    final simpleSummary = _interpretSummary(
      baseSimpleSummary,
      report,
      interpreter,
    );
    final homeCards = _weatherSummaryGenerator.buildHomeCards(
      report,
      nextHour,
      dryWindow,
      commute,
      simpleSummary,
      interpreter,
    );

    return WeatherGuidance(
      headline: headline,
      nextHour: nextHour,
      dryWindow: dryWindow,
      commute: commute,
      wearTips: wearTips,
      activities: activities,
      risks: risks,
      simpleSummary: simpleSummary,
      highlightHours: report.hourly.take(6).toList(growable: false),
      homeCards: homeCards,
      weekendPlanner: weekendPlanner,
    );
  }

  NextHourInsight _interpretNextHour(
    NextHourInsight insight,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return insight;
    }

    final nextTwoHours = report.hourly.take(2);
    final maxChance = nextTwoHours.fold<int>(
      report.today.precipitationProbabilityMax,
      (value, slot) => max(value, slot.precipitationProbability),
    );
    final details = <String>[
      if (insight.minutesUntilRain != null)
        'Rain may arrive in about ${insight.minutesUntilRain} minutes.',
      if (insight.maxPrecipitationMm > 0.04)
        interpreter.rainAmount(
          insight.maxPrecipitationMm,
          prefix: 'Peak burst',
        ),
      interpreter.rainChance(maxChance),
      interpreter.wind(report.current.windSpeedKph),
      interpreter.visibility(report.current.visibilityMeters),
    ];

    return NextHourInsight(
      title: insight.title,
      detail: interpreter.explain(insight.detail, details: details),
      departureAdvice: insight.departureAdvice,
      tone: insight.tone,
      maxPrecipitationMm: insight.maxPrecipitationMm,
      minutesUntilRain: insight.minutesUntilRain,
    );
  }

  DryWindowInsight _interpretDryWindow(
    DryWindowInsight insight,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return insight;
    }

    final drySlots = insight.start != null && insight.end != null
        ? _slotsInWindow(report.hourly, insight.start!, insight.end!)
        : const <HourlyForecast>[];
    final maxChance = drySlots.fold<int>(
      report.today.precipitationProbabilityMax,
      (value, slot) => max(value, slot.precipitationProbability),
    );
    final maxWind = drySlots.fold<double>(
      report.today.maxWindKph,
      (value, slot) => max(value, slot.windSpeedKph),
    );
    final details = <String>[
      if (insight.start != null && insight.end != null)
        interpreter.dryWindow(
          insight.start!,
          insight.end!,
          prefix: 'Best block',
        ),
      'Confidence is ${insight.confidenceLabel.toLowerCase()}.',
      interpreter.rainChance(maxChance),
      interpreter.wind(maxWind),
    ];

    return DryWindowInsight(
      headline: insight.headline,
      isAvailable: insight.isAvailable,
      start: insight.start,
      end: insight.end,
      duration: insight.duration,
      note: interpreter.explain(insight.note, details: details),
      confidenceLabel: insight.confidenceLabel,
      tone: insight.tone,
    );
  }

  CommuteOverview _interpretCommute(
    CommuteOverview commute,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return commute;
    }

    final windows = commute.windows
        .map((leg) {
          final slots = _slotsInWindow(report.hourly, leg.start, leg.end);
          final maxChance = slots.fold<int>(
            0,
            (value, slot) => max(value, slot.precipitationProbability),
          );
          final maxWind = slots.fold<double>(
            0,
            (value, slot) => max(value, slot.windSpeedKph),
          );
          final minVisibility = slots.fold<double>(
            report.current.visibilityMeters,
            (value, slot) => min(value, slot.visibilityMeters),
          );

          return CommuteLeg(
            id: leg.id,
            label: leg.label,
            start: leg.start,
            end: leg.end,
            tone: leg.tone,
            detail: interpreter.explain(
              leg.detail,
              details: <String>[
                if (slots.isNotEmpty) interpreter.rainChance(maxChance),
                if (slots.isNotEmpty) interpreter.wind(maxWind),
                if (minVisibility < 10000)
                  interpreter.visibility(minVisibility),
              ],
            ),
            summary: leg.summary,
            score: leg.score,
          );
        })
        .toList(growable: false);

    final best = windows.reduce((a, b) => a.score >= b.score ? a : b);
    return CommuteOverview(
      windows: windows,
      summary: interpreter.explain(
        commute.summary,
        details: <String>[
          interpreter.count('saved routine', windows.length),
          'Best window is ${best.label} at ${best.score}/100.',
        ],
      ),
    );
  }

  GuidanceHeadline _interpretHeadline(
    GuidanceHeadline headline,
    WeatherReport report,
    DryWindowInsight dryWindow,
    List<RiskNote> risks,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return headline;
    }

    final details = <String>[
      interpreter.temperatureRange(
        report.today.minTempC,
        report.today.maxTempC,
      ),
      interpreter.gust(
        max(report.today.maxWindKph, report.current.windGustKph),
      ),
      if (dryWindow.isAvailable &&
          dryWindow.start != null &&
          dryWindow.end != null)
        interpreter.dryWindow(dryWindow.start!, dryWindow.end!),
      if (risks.isNotEmpty && risks.first.level != RiskLevel.calm)
        'Top weather flag: ${risks.first.title}.',
    ];

    return GuidanceHeadline(
      title: headline.title,
      detail: interpreter.explain(headline.detail, details: details),
      tone: headline.tone,
      callToAction: headline.callToAction,
    );
  }

  List<WearTip> _interpretWearTips(
    List<WearTip> wearTips,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return wearTips;
    }

    return wearTips
        .map((tip) {
          final details = <String>[
            if (tip.title.toLowerCase().contains('umbrella') ||
                tip.title.toLowerCase().contains('waterproof'))
              interpreter.rainChance(report.today.precipitationProbabilityMax),
            if (tip.title.toLowerCase().contains('umbrella') ||
                tip.title.toLowerCase().contains('waterproof'))
              interpreter.rainAmount(report.today.precipitationMm),
            if (tip.title.toLowerCase().contains('windy'))
              interpreter.gust(
                max(report.today.maxWindKph, report.current.windGustKph),
              ),
            if (tip.title.toLowerCase().contains('cold') ||
                tip.title.toLowerCase().contains('wrap') ||
                tip.title.toLowerCase().contains('layer'))
              interpreter.apparent(report.current.apparentTemperatureC),
            if (tip.title.toLowerCase().contains('cold') ||
                tip.title.toLowerCase().contains('wrap') ||
                tip.title.toLowerCase().contains('layer'))
              interpreter.temperatureRange(
                report.today.minTempC,
                report.today.maxTempC,
              ),
            if (tip.title.toLowerCase().contains('sunglasses'))
              'UV peaks around ${report.today.uvIndexMax.toStringAsFixed(1)}.',
          ];

          return WearTip(
            title: tip.title,
            detail: interpreter.explain(tip.detail, details: details),
            icon: tip.icon,
          );
        })
        .toList(growable: false);
  }

  List<ActivityRecommendation> _interpretActivities(
    List<ActivityRecommendation> activities,
    WeatherReport report,
    DryWindowInsight dryWindow,
    NextHourInsight nextHour,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return activities;
    }

    final context = _ActivityContext.from(report, dryWindow, nextHour);
    return activities
        .map((activity) {
          final details = <String>[
            interpreter.score(activity.name, activity.score),
            interpreter.rainChance(context.rainChance),
            interpreter.wind(context.windKph),
            if (activity.name == 'Cycling' || activity.name == 'Walking')
              interpreter.visibility(context.visibilityMeters),
            if (activity.name == 'Picnic' ||
                activity.name == 'Laundry drying' ||
                activity.name == 'Football' ||
                activity.name == 'Outdoor coffee')
              'Best dry block lasts about ${context.dryWindowMinutes} minutes.',
          ];

          return ActivityRecommendation(
            name: activity.name,
            score: activity.score,
            detail: interpreter.explain(activity.detail, details: details),
            suitability: activity.suitability,
            icon: activity.icon,
          );
        })
        .toList(growable: false);
  }

  List<RiskNote> _interpretRisks(
    List<RiskNote> risks,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    if (!interpreter.isDetailed) {
      return risks;
    }

    final maxWind = max(report.today.maxWindKph, report.current.windGustKph);
    final maxRain = report.hourly.fold<double>(
      report.current.precipitationMm,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final minVisibility = report.hourly.fold<double>(
      report.current.visibilityMeters,
      (value, slot) => min(value, slot.visibilityMeters),
    );

    return risks
        .map((risk) {
          final lowerTitle = risk.title.toLowerCase();
          final details = <String>[
            if (risk.source == AlertSource.official)
              'Source: ${risk.sourceLabel}.',
            if (lowerTitle.contains('wind') ||
                lowerTitle.contains('breezy') ||
                lowerTitle.contains('blustery'))
              interpreter.gust(maxWind),
            if (lowerTitle.contains('rain') || lowerTitle.contains('storm'))
              interpreter.rainAmount(maxRain, prefix: 'Peak hourly rain'),
            if (lowerTitle.contains('visibility') ||
                lowerTitle.contains('fog') ||
                lowerTitle.contains('murk'))
              interpreter.visibility(minVisibility),
            if (lowerTitle.contains('heat'))
              interpreter.temperatureRange(
                report.today.minTempC,
                report.today.maxTempC,
              ),
            if (lowerTitle.contains('frost') ||
                lowerTitle.contains('snow') ||
                lowerTitle.contains('wintry'))
              'Overnight lows could dip to ${formatTemperature(report.today.minTempC)}.',
            if (risk.link != null)
              'More detail is available from the linked warning.',
          ];

          return RiskNote(
            title: risk.title,
            detail: interpreter.explain(risk.detail, details: details),
            level: risk.level,
            icon: risk.icon,
            source: risk.source,
            sourceLabel: risk.sourceLabel,
            link: risk.link,
          );
        })
        .toList(growable: false);
  }

  WeekendPlanner? _interpretWeekendPlanner(
    WeekendPlanner? planner,
    WeatherInterpreter interpreter,
  ) {
    if (planner == null || !interpreter.isDetailed) {
      return planner;
    }

    final days = planner.days
        .map((day) {
          return WeekendDayPlan(
            label: day.label,
            date: day.date,
            summary: interpreter.explain(
              day.summary,
              details: <String>[
                'Daytime high near ${formatTemperature(day.maxTempC)}.',
                'Low near ${formatTemperature(day.minTempC)}.',
                interpreter.rainChance(day.precipitationProbabilityMax),
                if (day.precipitationMm > 0.04)
                  interpreter.rainAmount(
                    day.precipitationMm,
                    prefix: 'Daily rainfall',
                  ),
                interpreter.wind(day.maxWindKph),
              ],
            ),
            headline: day.headline,
            maxTempC: day.maxTempC,
            minTempC: day.minTempC,
            precipitationMm: day.precipitationMm,
            precipitationProbabilityMax: day.precipitationProbabilityMax,
            maxWindKph: day.maxWindKph,
            icon: day.icon,
            tone: day.tone,
          );
        })
        .toList(growable: false);

    return WeekendPlanner(
      title: planner.title,
      summary: interpreter.explain(
        planner.summary,
        details: days.map((day) => '${day.label}: ${day.summary}'),
      ),
      days: days,
      tone: planner.tone,
    );
  }

  String _interpretSummary(
    String summary,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    return interpreter.explain(
      summary,
      details: <String>[
        interpreter.temperatureRange(
          report.today.minTempC,
          report.today.maxTempC,
        ),
        interpreter.gust(
          max(report.today.maxWindKph, report.current.windGustKph),
        ),
        interpreter.rainChance(report.today.precipitationProbabilityMax),
        if (report.officialWarnings.isNotEmpty)
          interpreter.count('official warning', report.officialWarnings.length),
      ],
    );
  }

  List<HourlyForecast> _slotsInWindow(
    List<HourlyForecast> hourly,
    DateTime start,
    DateTime end,
  ) {
    return hourly
        .where((slot) => !slot.time.isBefore(start) && slot.time.isBefore(end))
        .toList(growable: false);
  }
}

class _ActivityContext {
  const _ActivityContext({
    required this.rainChance,
    required this.windKph,
    required this.visibilityMeters,
    required this.dryWindowMinutes,
  });

  final int rainChance;
  final double windKph;
  final double visibilityMeters;
  final int dryWindowMinutes;

  factory _ActivityContext.from(
    WeatherReport report,
    DryWindowInsight dryWindow,
    NextHourInsight nextHour,
  ) {
    final nearHours = report.hourly.take(6).toList(growable: false);
    final maxRainChance = nearHours.fold<int>(
      report.today.precipitationProbabilityMax,
      (value, slot) => max(value, slot.precipitationProbability),
    );
    final maxWind = nearHours.fold<double>(
      max(report.current.windSpeedKph, report.today.maxWindKph),
      (value, slot) => max(value, slot.windSpeedKph),
    );
    final minVisibility = nearHours.fold<double>(
      report.current.visibilityMeters,
      (value, slot) => min(value, slot.visibilityMeters),
    );

    return _ActivityContext(
      rainChance: maxRainChance,
      windKph: maxWind,
      visibilityMeters: minVisibility,
      dryWindowMinutes: dryWindow.duration.inMinutes,
    );
  }
}
