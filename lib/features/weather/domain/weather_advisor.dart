import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import 'weather_describer.dart';
import 'weather_interpreter.dart';
import 'weather_models.dart';

class WeatherAdvisor {
  const WeatherAdvisor();

  WeatherGuidance build(
    WeatherReport report, {
    required List<SavedCommuteWindow> commuteWindows,
    ExplanationMode explanationMode = ExplanationMode.simple,
  }) {
    final interpreter = WeatherInterpreter(explanationMode);

    final baseNextHour = _buildNextHourInsight(report);
    final baseDryWindow = _findBestDryWindow(report.hourly);
    final baseCommute = _buildCommute(report.hourly, report.fetchedAt, commuteWindows);
    final baseRisks = _buildRisks(report);
    final baseWearTips = _buildWearTips(report, baseNextHour);
    final baseActivities = _buildActivities(report, baseDryWindow, baseNextHour);
    final baseHeadline = _buildHeadline(report, baseNextHour, baseDryWindow, baseRisks);
    final baseSimpleSummary = _buildSimpleSummary(
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
      _buildWeekendPlanner(report.daily, report.fetchedAt),
      interpreter,
    );
    final simpleSummary = _interpretSummary(
      baseSimpleSummary,
      report,
      interpreter,
    );
    final homeCards = _buildHomeCards(
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

  NextHourInsight _buildNextHourInsight(WeatherReport report) {
    final slots = report.minutely.take(4).toList(growable: false);
    if (slots.isEmpty) {
      return const NextHourInsight(
        title: 'No minute-by-minute rain available',
        detail: 'Use the day summary below instead.',
        departureAdvice: 'Check the hourly outlook',
        tone: AdviceTone.watch,
        maxPrecipitationMm: 0,
      );
    }

    final now = report.fetchedAt;
    final firstRain = slots.where((slot) => slot.precipitationMm >= 0.08).firstOrNull;
    final maxPrecipitation = slots.fold<double>(
      0,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final rainingNow = report.current.precipitationMm >= 0.08 || slots.first.precipitationMm >= 0.08;

    if (firstRain == null && !rainingNow) {
      return const NextHourInsight(
        title: 'Dry for the next hour',
        detail: 'You have a clean slot to head out without rushing.',
        departureAdvice: 'Safe to head out now',
        tone: AdviceTone.go,
        maxPrecipitationMm: 0,
      );
    }

    if (rainingNow) {
      final tone = maxPrecipitation >= 0.8 ? AdviceTone.wait : AdviceTone.watch;
      final detail = maxPrecipitation >= 0.8
          ? 'Rain is already in and could stay punchy for a while.'
          : 'There is wet weather around right now, but it should stay light.';
      return NextHourInsight(
        title: maxPrecipitation >= 0.8 ? 'Wet right now' : 'Light rain is hovering',
        detail: detail,
        departureAdvice: tone == AdviceTone.wait ? 'Wait it out if you can' : 'Go only with a waterproof',
        tone: tone,
        maxPrecipitationMm: maxPrecipitation,
        minutesUntilRain: 0,
      );
    }

    final rainSlot = firstRain!;
    final minutesUntilRain = max(rainSlot.time.difference(now).inMinutes, 0);
    final intensity = rainIntensityLabel(maxPrecipitation);
    if (minutesUntilRain <= 20) {
      return NextHourInsight(
        title: 'Short dry slot before rain',
        detail: '$intensity is likely within about $minutesUntilRain minutes.',
        departureAdvice: 'Go soon if you are heading out',
        tone: AdviceTone.watch,
        maxPrecipitationMm: maxPrecipitation,
        minutesUntilRain: minutesUntilRain,
      );
    }

    return NextHourInsight(
      title: 'You have time before rain',
      detail: 'It looks dry for roughly $minutesUntilRain minutes, then $intensity may arrive.',
      departureAdvice: 'A good moment to leave now',
      tone: AdviceTone.go,
      maxPrecipitationMm: maxPrecipitation,
      minutesUntilRain: minutesUntilRain,
    );
  }

  DryWindowInsight _findBestDryWindow(List<HourlyForecast> hourly) {
    final candidates = hourly.take(14).toList(growable: false);
    if (candidates.isEmpty) {
      return const DryWindowInsight(
        headline: 'Dry window unavailable',
        isAvailable: false,
        start: null,
        end: null,
        duration: Duration.zero,
        note: 'Hourly data is not available yet.',
        confidenceLabel: 'Unknown',
        tone: AdviceTone.watch,
      );
    }

    final afternoon = candidates
        .where((slot) => slot.time.hour >= 12 && slot.time.hour < 18)
        .toList(growable: false);
    final afternoonLooksWet = afternoon.length >= 4 &&
        afternoon.every((slot) => !_isDryEnough(slot));

    List<HourlyForecast> currentRun = <HourlyForecast>[];
    List<HourlyForecast> bestRun = <HourlyForecast>[];

    for (final slot in candidates) {
      if (_isDryEnough(slot)) {
        currentRun.add(slot);
        if (currentRun.length > bestRun.length) {
          bestRun = List<HourlyForecast>.from(currentRun);
        }
      } else {
        currentRun = <HourlyForecast>[];
      }
    }

    if (bestRun.isEmpty) {
      if (afternoonLooksWet) {
        return const DryWindowInsight(
          headline: 'Rain likely all afternoon',
          isAvailable: false,
          start: null,
          end: null,
          duration: Duration.zero,
          note: 'The middle of the day looks unsettled, so outdoor plans stay awkward.',
          confidenceLabel: 'Low confidence',
          tone: AdviceTone.wait,
        );
      }

      final leastBad = candidates.reduce(
        (best, slot) => _slotPenalty(slot) < _slotPenalty(best) ? slot : best,
      );
      final start = leastBad.time;
      final end = leastBad.time.add(const Duration(hours: 1));
      return DryWindowInsight(
        headline: 'Short dry slot: ${_clock(start)} to ${_clock(end)}',
        isAvailable: true,
        start: start,
        end: end,
        duration: const Duration(hours: 1),
        note: 'Only a brief usable gap stands out, so keep plans tight and practical.',
        confidenceLabel: 'Low confidence',
        tone: AdviceTone.watch,
      );
    }

    final start = bestRun.first.time;
    final end = bestRun.last.time.add(const Duration(hours: 1));
    final duration = end.difference(start);
    final averageProbability = bestRun.fold<int>(
          0,
          (sum, slot) => sum + slot.precipitationProbability,
        ) /
        bestRun.length;
    final confidence = averageProbability < 18 ? 'High confidence' : 'Reasonable confidence';
    final isShortWindow = duration.inMinutes <= 75;
    final note = duration.inHours >= 3
        ? 'This is your clearest part of the day for errands, walks, or outdoor jobs.'
        : duration.inHours >= 2
            ? 'A practical block for the school run, errands, or a walk.'
            : 'A short but usable gap if you keep things moving.';

    return DryWindowInsight(
      headline: '${isShortWindow ? 'Short' : 'Best'} dry slot: ${_clock(start)} to ${_clock(end)}',
      isAvailable: true,
      start: start,
      end: end,
      duration: duration,
      note: note,
      confidenceLabel: confidence,
      tone: duration.inHours >= 2 ? AdviceTone.go : AdviceTone.watch,
    );
  }

  CommuteOverview _buildCommute(
    List<HourlyForecast> hourly,
    DateTime now,
    List<SavedCommuteWindow> commuteWindows,
  ) {
    final templates = commuteWindows.isEmpty ? SavedCommuteWindow.defaults : commuteWindows;
    final windows = templates
        .map((template) => _scoreWindow(hourly, now, template))
        .toList(growable: false);
    final roughCount = windows.where((window) => window.tone == AdviceTone.wait).length;
    final helpfulCount = windows.where((window) => window.tone == AdviceTone.go).length;

    final summary = roughCount > 0
        ? '$roughCount favourite ${roughCount == 1 ? 'routine looks' : 'routines look'} rough, so plan around them.'
        : helpfulCount == windows.length
            ? 'Your favourite routines look manageable today.'
            : 'A mixed picture across your favourite routines.';

    return CommuteOverview(
      windows: windows,
      summary: summary,
    );
  }

  CommuteLeg _scoreWindow(
    List<HourlyForecast> hourly,
    DateTime now,
    SavedCommuteWindow template,
  ) {
    final start = _nextOccurrence(now, template.startMinutes, template.endMinutes);
    final end = _endForOccurrence(start, template.startMinutes, template.endMinutes);
    final slots = hourly
        .where((slot) => !slot.time.isBefore(start) && slot.time.isBefore(end))
        .toList(growable: false);

    if (slots.isEmpty) {
      return CommuteLeg(
        id: template.id,
        label: template.label,
        start: start,
        end: end,
        tone: AdviceTone.watch,
        detail: 'No forecast is available for this saved time window yet.',
        summary: 'Forecast unavailable',
        score: 50,
      );
    }

    final avgRainChance = slots.fold<int>(0, (sum, slot) => sum + slot.precipitationProbability) / slots.length;
    final maxRain = slots.fold<double>(0, (value, slot) => max(value, slot.precipitationMm));
    final maxWind = slots.fold<double>(0, (value, slot) => max(value, slot.windSpeedKph));
    final minVisibility = slots.fold<double>(
      double.infinity,
      (value, slot) => min(value, slot.visibilityMeters),
    );

    final rainPenalty = avgRainChance * 0.35 + maxRain * 28;
    final windPenalty = max(0, maxWind - 18) * 1.6;
    final visibilityPenalty = minVisibility < 2500 ? 18 : minVisibility < 6000 ? 9 : 0;
    final rawScore = (100 - rainPenalty - windPenalty - visibilityPenalty)
        .round()
        .clamp(15, 98);

    AdviceTone tone;
    String summary;
    String detail;
    if (rawScore >= 75) {
      tone = AdviceTone.go;
      summary = 'Mostly smooth';
      detail = 'Mostly dry with manageable wind and visibility.';
    } else if (rawScore >= 55) {
      tone = AdviceTone.watch;
      summary = 'Changeable';
      detail = 'Usable, but expect some wet, breezy, or murky patches.';
    } else {
      tone = AdviceTone.wait;
      summary = 'Rough going';
      detail = 'Rain, wind, or poor visibility could make this window awkward.';
    }

    return CommuteLeg(
      id: template.id,
      label: template.label,
      start: start,
      end: end,
      tone: tone,
      detail: detail,
      summary: summary,
      score: rawScore,
    );
  }

  GuidanceHeadline _buildHeadline(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    List<RiskNote> risks,
  ) {
    final severeRisk = risks.any((risk) => risk.level == RiskLevel.high);
    if (severeRisk) {
      return GuidanceHeadline(
        title: 'Keep plans flexible today',
        detail: risks.first.detail,
        tone: AdviceTone.wait,
        callToAction: 'Stay weather-aware',
      );
    }

    if (nextHour.tone == AdviceTone.go && dryWindow.isAvailable && dryWindow.duration.inHours >= 2) {
      return GuidanceHeadline(
        title: 'Good day for outdoor jobs',
        detail: 'There is a clean start now and a reliable dry block later on.',
        tone: AdviceTone.go,
        callToAction: 'Use the dry slot',
      );
    }

    if (nextHour.tone == AdviceTone.wait && dryWindow.isAvailable && dryWindow.start != null) {
      return GuidanceHeadline(
        title: 'Hold off, then move later',
        detail: 'The best slot comes after the current wet patch clears.',
        tone: AdviceTone.watch,
        callToAction: 'Wait for the next dry gap',
      );
    }

    if (report.today.precipitationProbabilityMax >= 70) {
      return GuidanceHeadline(
        title: 'Plan around passing rain',
        detail: 'Today looks changeable, so time your outdoor plans carefully.',
        tone: AdviceTone.watch,
        callToAction: nextHour.departureAdvice,
      );
    }

    return GuidanceHeadline(
      title: 'A calm, usable weather day',
      detail: 'Nothing too disruptive stands out if you time things sensibly.',
      tone: AdviceTone.go,
      callToAction: nextHour.departureAdvice,
    );
  }

  List<WearTip> _buildWearTips(WeatherReport report, NextHourInsight nextHour) {
    final tips = <WearTip>[];

    final rainLikely =
        nextHour.maxPrecipitationMm >= 0.08 || report.today.precipitationProbabilityMax >= 50;
    final windy = report.today.maxWindKph >= 28;
    final chillyNow = report.current.apparentTemperatureC <= 8;
    final warmingLater = report.fetchedAt.hour < 11 &&
        report.today.maxTempC - report.current.apparentTemperatureC >= 5;

    if (rainLikely) {
      if (windy) {
        tips.add(const WearTip(
          title: 'Take a light waterproof',
          detail: 'Showers and gusts will favour a jacket over an umbrella.',
          icon: Icons.umbrella_rounded,
        ));
      } else {
        tips.add(const WearTip(
          title: 'Umbrella recommended',
          detail: 'Rain risk is high enough that it is worth taking one.',
          icon: Icons.umbrella_rounded,
        ));
      }
    }

    if (report.current.apparentTemperatureC >= 10 &&
        report.current.apparentTemperatureC <= 17 &&
        windy) {
      tips.add(const WearTip(
        title: 'Mild, but windy',
        detail: 'You will not need heavy layers, but gusts could cut through light clothing.',
        icon: Icons.air_rounded,
      ));
    }

    if (chillyNow && warmingLater) {
      tips.add(const WearTip(
        title: 'Cold start, warmer by noon',
        detail: 'Start with a jacket or jumper that you can take off later.',
        icon: Icons.wb_twilight_rounded,
      ));
    } else if (report.current.apparentTemperatureC <= 5 || report.today.minTempC <= 3) {
      tips.add(const WearTip(
        title: 'Wrap up well',
        detail: 'It feels cold enough for proper layers, especially early or in exposed spots.',
        icon: Icons.layers_rounded,
      ));
    } else if (report.current.apparentTemperatureC <= 13) {
      tips.add(const WearTip(
        title: 'Take a light layer',
        detail: 'A jumper or light jacket should be enough for most of the day.',
        icon: Icons.checkroom_rounded,
      ));
    }

    if (report.today.uvIndexMax >= 4 && report.today.precipitationProbabilityMax < 35) {
      tips.add(const WearTip(
        title: 'Sunglasses worth packing',
        detail: 'There should be enough brightness to make them useful.',
        icon: Icons.wb_sunny_outlined,
      ));
    }

    if (tips.isEmpty) {
      tips.add(const WearTip(
        title: 'Light layers should do',
        detail: 'Conditions look settled enough for normal daywear.',
        icon: Icons.directions_walk_rounded,
      ));
    }

    return tips.take(4).toList(growable: false);
  }

  List<ActivityRecommendation> _buildActivities(
    WeatherReport report,
    DryWindowInsight dryWindow,
    NextHourInsight nextHour,
  ) {
    final context = _ActivityContext.from(report, dryWindow, nextHour);
    return <ActivityRecommendation>[
      _scoreWalking(context),
      _scoreRunning(context),
      _scoreCycling(context),
      _scorePicnic(context),
      _scoreLaundryDrying(context),
      _scoreDogWalk(context),
      _scoreFootball(context),
      _scoreOutdoorCoffee(context),
    ];
  }

  List<RiskNote> _buildRisks(WeatherReport report) {
    final risks = <RiskNote>[];
    for (final warning in report.officialWarnings) {
      risks.add(
        RiskNote(
          title: warning.title,
          detail: warning.summary,
          level: _riskLevelFromSeverity(warning.severityLabel),
          icon: _iconForWarningText('${warning.title} ${warning.summary}'),
          source: AlertSource.official,
          sourceLabel: warning.sourceLabel,
          link: warning.link,
        ),
      );
    }

    final maxWind = max(report.today.maxWindKph, report.current.windGustKph);
    final maxHourlyRain = report.hourly.fold<double>(
      0,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final minVisibility = report.hourly.fold<double>(
      report.current.visibilityMeters,
      (value, slot) => min(value, slot.visibilityMeters),
    );
    final hasThunder = report.hourly.any((slot) => slot.weatherCode >= 95);
    final hasSnow = report.hourly.any((slot) => _isSnowCode(slot.weatherCode));
    final heatRisk = max(report.today.maxTempC, report.current.apparentTemperatureC) >= 28;
    final frostRisk = report.today.minTempC <= 1 || report.current.apparentTemperatureC <= 0;

    if (maxWind >= 46) {
      risks.add(const RiskNote(
        title: 'Blustery spells',
        detail: 'Stronger gusts could make exposed routes and cycling awkward.',
        level: RiskLevel.high,
        icon: Icons.air_rounded,
      ));
    } else if (maxWind >= 32) {
      risks.add(const RiskNote(
        title: 'Breezy periods',
        detail: 'Nothing extreme, but it may feel sharper than the temperature suggests.',
        level: RiskLevel.headsUp,
        icon: Icons.air_rounded,
      ));
    }

    if (maxHourlyRain >= 1.2) {
      risks.add(const RiskNote(
        title: 'Burst of heavy rain',
        detail: 'Some showers could be punchy enough to spoil an outdoor plan quickly.',
        level: RiskLevel.headsUp,
        icon: Icons.water_damage_rounded,
      ));
    }

    if (hasSnow) {
      risks.add(const RiskNote(
        title: 'Snow or wintry risk',
        detail: 'Wintry spells could make outdoor routes slippery and slower.',
        level: RiskLevel.headsUp,
        icon: Icons.ac_unit_rounded,
      ));
    }

    if (minVisibility <= 1500) {
      risks.add(const RiskNote(
        title: 'Reduced visibility',
        detail: 'Fog or murk could make the commute slower and gloomier.',
        level: RiskLevel.headsUp,
        icon: Icons.dehaze_rounded,
      ));
    }

    if (hasThunder) {
      risks.add(const RiskNote(
        title: 'Thunderstorm risk',
        detail: 'Keep outdoor plans flexible if storms develop nearby.',
        level: RiskLevel.high,
        icon: Icons.thunderstorm_rounded,
      ));
    }

    if (heatRisk) {
      risks.add(const RiskNote(
        title: 'Heat building later',
        detail: 'Warmer conditions could make exposed outdoor plans more draining.',
        level: RiskLevel.headsUp,
        icon: Icons.thermostat_rounded,
      ));
    }

    if (frostRisk) {
      risks.add(const RiskNote(
        title: 'Frosty start',
        detail: 'A cold start could leave pavements, cars, or grass slick early on.',
        level: RiskLevel.headsUp,
        icon: Icons.severe_cold_rounded,
      ));
    }

    if (risks.isEmpty) {
      risks.add(const RiskNote(
        title: 'No major disruption flagged',
        detail: 'The day looks manageable with normal UK-weather caution.',
        level: RiskLevel.calm,
        icon: Icons.verified_rounded,
      ));
    }

    return risks;
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
        interpreter.rainAmount(insight.maxPrecipitationMm, prefix: 'Peak burst'),
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
        interpreter.dryWindow(insight.start!, insight.end!, prefix: 'Best block'),
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
          final maxChance = slots.fold<int>(0, (value, slot) => max(value, slot.precipitationProbability));
          final maxWind = slots.fold<double>(0, (value, slot) => max(value, slot.windSpeedKph));
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
                if (minVisibility < 10000) interpreter.visibility(minVisibility),
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
      interpreter.temperatureRange(report.today.minTempC, report.today.maxTempC),
      interpreter.gust(max(report.today.maxWindKph, report.current.windGustKph)),
      if (dryWindow.isAvailable && dryWindow.start != null && dryWindow.end != null)
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
              interpreter.gust(max(report.today.maxWindKph, report.current.windGustKph)),
            if (tip.title.toLowerCase().contains('cold') ||
                tip.title.toLowerCase().contains('wrap') ||
                tip.title.toLowerCase().contains('layer'))
              interpreter.apparent(report.current.apparentTemperatureC),
            if (tip.title.toLowerCase().contains('cold') ||
                tip.title.toLowerCase().contains('wrap') ||
                tip.title.toLowerCase().contains('layer'))
              interpreter.temperatureRange(report.today.minTempC, report.today.maxTempC),
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
            if (risk.source == AlertSource.official) 'Source: ${risk.sourceLabel}.',
            if (lowerTitle.contains('wind') || lowerTitle.contains('breezy') || lowerTitle.contains('blustery'))
              interpreter.gust(maxWind),
            if (lowerTitle.contains('rain') || lowerTitle.contains('storm'))
              interpreter.rainAmount(maxRain, prefix: 'Peak hourly rain'),
            if (lowerTitle.contains('visibility') || lowerTitle.contains('fog') || lowerTitle.contains('murk'))
              interpreter.visibility(minVisibility),
            if (lowerTitle.contains('heat'))
              interpreter.temperatureRange(report.today.minTempC, report.today.maxTempC),
            if (lowerTitle.contains('frost') || lowerTitle.contains('snow') || lowerTitle.contains('wintry'))
              'Overnight lows could dip to ${formatTemperature(report.today.minTempC)}.',
            if (risk.link != null) 'More detail is available from the linked warning.',
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

  WeekendPlanner? _buildWeekendPlanner(
    List<DailyForecast> daily,
    DateTime now,
  ) {
    final upcomingWeekend = daily
        .where((day) =>
            !day.date.isBefore(DateTime(now.year, now.month, now.day)) &&
            (day.date.weekday == DateTime.saturday || day.date.weekday == DateTime.sunday))
        .take(2)
        .toList(growable: false);

    if (upcomingWeekend.isEmpty) {
      return null;
    }

    final weekendDays = upcomingWeekend
        .map(_buildWeekendDayPlan)
        .toList(growable: false);
    final sorted = [...upcomingWeekend]..sort((a, b) => _dayUsefulnessScore(b).compareTo(_dayUsefulnessScore(a)));
    final best = sorted.first;
    final worst = sorted.last;
    final scoreGap = _dayUsefulnessScore(best) - _dayUsefulnessScore(worst);

    final title = switch (weekendDays.length) {
      1 => '${_weekendLabel(weekendDays.first.date)} is worth planning around',
      _ when scoreGap >= 2.2 => '${_weekendLabel(best.date)} is your better outdoor day',
      _ when weekendDays.every((day) => day.tone == AdviceTone.go) => 'The weekend looks open for plans',
      _ when weekendDays.every((day) => day.tone == AdviceTone.wait) => 'Weekend plans look weather-led',
      _ => 'A mixed weekend picture',
    };

    final summary = switch (weekendDays.length) {
      1 => weekendDays.first.summary,
      _ when scoreGap >= 2.2 =>
        '${_weekendLabel(best.date)} looks easier for outdoor plans than ${_weekendLabel(worst.date).toLowerCase()}.',
      _ when weekendDays.every((day) => day.tone == AdviceTone.go) =>
        'Both days look usable for walks, errands, and time outside.',
      _ when weekendDays.every((day) => day.tone == AdviceTone.wait) =>
        'Rain or wind could interrupt plans on both days, so keep them flexible.',
      _ => 'One day looks more practical than the other, so choose your longer outdoor plans carefully.',
    };

    final tone = weekendDays.any((day) => day.tone == AdviceTone.go)
        ? weekendDays.any((day) => day.tone == AdviceTone.wait)
            ? AdviceTone.watch
            : AdviceTone.go
        : AdviceTone.wait;

    return WeekendPlanner(
      title: title,
      summary: summary,
      days: weekendDays,
      tone: tone,
    );
  }

  WeekendDayPlan _buildWeekendDayPlan(DailyForecast day) {
    final descriptor = describeWeatherCode(day.weatherCode, isDay: true);
    final label = _weekendLabel(day.date);
    final mostlyWet = day.precipitationProbabilityMax >= 70 || day.precipitationMm >= 4;
    final mixed = day.precipitationProbabilityMax >= 40 || day.precipitationMm >= 1.5;
    final windy = day.maxWindKph >= 30;
    final mild = day.maxTempC >= 14 && day.maxTempC <= 22;

    final tone = mostlyWet || windy && day.maxWindKph >= 36
        ? AdviceTone.wait
        : mixed || windy
            ? AdviceTone.watch
            : AdviceTone.go;

    final headline = tone == AdviceTone.go
        ? '$label looks like the easier pick'
        : tone == AdviceTone.watch
            ? '$label looks usable with some care'
            : '$label could be awkward outside';

    final summary = mostlyWet
        ? 'Wet spells look likely for much of the day.'
        : mixed && windy
            ? 'Changeable weather with some wind could interrupt longer outdoor plans.'
            : mixed
                ? 'There should be some usable gaps, but not an all-day banker.'
                : windy
                    ? 'Mostly dry, but breezier than ideal in exposed spots.'
                    : mild
                        ? 'Mostly dry and mild, with good scope for time outside.'
                        : '${descriptor.summary} with fairly manageable conditions.';

    return WeekendDayPlan(
      label: label,
      date: day.date,
      summary: summary,
      headline: headline,
      maxTempC: day.maxTempC,
      minTempC: day.minTempC,
      precipitationMm: day.precipitationMm,
      precipitationProbabilityMax: day.precipitationProbabilityMax,
      maxWindKph: day.maxWindKph,
      icon: descriptor.icon,
      tone: tone,
    );
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
                  interpreter.rainAmount(day.precipitationMm, prefix: 'Daily rainfall'),
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

  List<HomeSummaryCard> _buildHomeCards(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    CommuteOverview commute,
    String simpleSummary,
    WeatherInterpreter interpreter,
  ) {
    final currentDescriptor = describeWeatherCode(
      report.current.weatherCode,
      isDay: report.current.isDay,
    );

    final commuteTone = commute.windows.any((window) => window.tone == AdviceTone.wait)
        ? AdviceTone.wait
        : commute.windows.any((window) => window.tone == AdviceTone.watch)
            ? AdviceTone.watch
            : AdviceTone.go;

    return <HomeSummaryCard>[
      HomeSummaryCard(
        title: 'Current weather',
        value: '${formatTemperature(report.current.temperatureC)} ${currentDescriptor.label}',
        detail: interpreter.explain(
          'Feels like ${formatTemperature(report.current.apparentTemperatureC)}',
          details: <String>[
            interpreter.wind(report.current.windSpeedKph),
            interpreter.visibility(report.current.visibilityMeters),
          ],
        ),
        icon: currentDescriptor.icon,
        tone: AdviceTone.go,
      ),
      HomeSummaryCard(
        title: 'Next rain',
        value: nextHour.title,
        detail: interpreter.isDetailed ? nextHour.detail : nextHour.departureAdvice,
        icon: Icons.umbrella_rounded,
        tone: nextHour.tone,
      ),
      HomeSummaryCard(
        title: 'Best dry slot',
        value: dryWindow.headline,
        detail: dryWindow.note,
        icon: Icons.wb_sunny_outlined,
        tone: dryWindow.tone,
      ),
      HomeSummaryCard(
        title: 'Commute summary',
        value: commute.windows.isEmpty ? 'No routines saved' : _commuteHeadline(commute),
        detail: commute.summary,
        icon: Icons.commute_rounded,
        tone: commuteTone,
      ),
      HomeSummaryCard(
        title: 'Daily advice',
        value: _leadingSentence(simpleSummary),
        detail: _supportingSentences(simpleSummary).isNotEmpty
            ? _supportingSentences(simpleSummary)
            : report.officialWarnings.isNotEmpty
                ? '${report.officialWarnings.length} official warning${report.officialWarnings.length == 1 ? '' : 's'} available'
                : 'No official warnings matched your location',
        icon: Icons.chat_bubble_outline_rounded,
        tone: report.officialWarnings.isNotEmpty ? AdviceTone.watch : AdviceTone.go,
      ),
    ];
  }

  String _interpretSummary(
    String summary,
    WeatherReport report,
    WeatherInterpreter interpreter,
  ) {
    return interpreter.explain(
      summary,
      details: <String>[
        interpreter.temperatureRange(report.today.minTempC, report.today.maxTempC),
        interpreter.gust(max(report.today.maxWindKph, report.current.windGustKph)),
        interpreter.rainChance(report.today.precipitationProbabilityMax),
        if (report.officialWarnings.isNotEmpty)
          interpreter.count('official warning', report.officialWarnings.length),
      ],
    );
  }

  String _buildSimpleSummary(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    List<WearTip> wearTips,
  ) {
    final phrases = <String>[];
    final wearPhrase = _wearPhrase(wearTips);
    final breezyLater = report.today.maxWindKph >= 28;
    final coldLater = report.today.minTempC <= 6 || report.current.apparentTemperatureC <= 8;

    if ((nextHour.minutesUntilRain ?? 100) <= 20 && dryWindow.start != null) {
      phrases.add(
        'Rain expected within ${nextHour.minutesUntilRain} minutes. Best to leave after ${_clock(dryWindow.start!)}.',
      );
    } else if (dryWindow.isAvailable &&
        dryWindow.start != null &&
        dryWindow.end != null &&
        dryWindow.duration.inHours >= 2) {
      final segment = _timeBandPhrase(dryWindow.start!, dryWindow.end!);
      final breezePart = breezyLater ? ', breezy later,' : ',';
      phrases.add('Dry most of the $segment$breezePart $wearPhrase.');
    } else if (coldLater && breezyLater) {
      phrases.add('Cold and windy this evening. Wrap up if heading out.');
    } else {
      final descriptor = describeWeatherCode(
        report.current.weatherCode,
        isDay: report.current.isDay,
      );
      phrases.add('${descriptor.summary}. $wearPhrase.');
    }

    return phrases.join(' ').replaceAll('..', '.');
  }

  bool _isDryEnough(HourlyForecast slot) {
    return slot.precipitationProbability < 35 &&
        slot.precipitationMm < 0.15 &&
        slot.windSpeedKph < 32;
  }

  bool _isSnowCode(int code) {
    return <int>{71, 73, 75, 77, 85, 86}.contains(code);
  }

  DateTime _nextOccurrence(DateTime now, int startMinutes, int endMinutes) {
    final midnight = DateTime(now.year, now.month, now.day);
    var start = midnight.add(Duration(minutes: startMinutes));
    final end = _endForOccurrence(start, startMinutes, endMinutes);
    if (!now.isBefore(end)) {
      start = start.add(const Duration(days: 1));
    }
    return start;
  }

  DateTime _endForOccurrence(DateTime start, int startMinutes, int endMinutes) {
    final minutesDelta = endMinutes >= startMinutes
        ? endMinutes - startMinutes
        : 24 * 60 - startMinutes + endMinutes;
    return start.add(Duration(minutes: minutesDelta));
  }

  String _wearPhrase(List<WearTip> wearTips) {
    final first = wearTips.first.title.toLowerCase();
    if (first.contains('umbrella')) {
      return 'umbrella recommended';
    }
    if (first.contains('waterproof')) {
      return 'light waterproof recommended';
    }
    if (first.contains('mild, but windy')) {
      return 'a windproof layer is sensible';
    }
    if (first.contains('cold start')) {
      return 'layers recommended';
    }
    if (first.contains('light layer')) {
      return 'light jacket recommended';
    }
    if (first.contains('wrap up')) {
      return 'warm layers recommended';
    }
    if (first.contains('sunglasses')) {
      return 'light layers should do';
    }
    return 'normal layers should be fine';
  }

  String _timeBandPhrase(DateTime start, DateTime end) {
    if (start.hour >= 12 && end.hour <= 18) {
      return 'afternoon';
    }
    if (start.hour < 12 && end.hour <= 13) {
      return 'morning';
    }
    if (start.hour >= 17) {
      return 'evening';
    }
    return 'day';
  }

  double _dayUsefulnessScore(DailyForecast day) {
    var score = 8.0;
    score -= day.precipitationProbabilityMax >= 80
        ? 3.6
        : day.precipitationProbabilityMax >= 55
            ? 2.1
            : day.precipitationProbabilityMax >= 35
                ? 1.0
                : 0;
    score -= day.precipitationMm >= 6
        ? 2.8
        : day.precipitationMm >= 2
            ? 1.5
            : day.precipitationMm >= 0.6
                ? 0.8
                : 0;
    score -= day.maxWindKph >= 38
        ? 2.2
        : day.maxWindKph >= 28
            ? 1.0
            : 0;
    score += day.maxTempC >= 13 && day.maxTempC <= 22 ? 0.8 : 0;
    return score;
  }

  String _weekendLabel(DateTime date) {
    return switch (date.weekday) {
      DateTime.saturday => 'Saturday',
      DateTime.sunday => 'Sunday',
      _ => formatDateHeader(date),
    };
  }

  double _slotPenalty(HourlyForecast slot) {
    return slot.precipitationProbability +
        slot.precipitationMm * 40 +
        max(0, slot.windSpeedKph - 22);
  }

  String _clock(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _commuteHeadline(CommuteOverview commute) {
    final best = commute.windows.reduce((a, b) => a.score >= b.score ? a : b);
    return '${best.label}: ${best.score}/100';
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

  String _leadingSentence(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return text;
    }
    final punctuation = trimmed.indexOf(RegExp(r'[.!?]'));
    if (punctuation == -1 || punctuation == trimmed.length - 1) {
      return trimmed;
    }
    return trimmed.substring(0, punctuation + 1);
  }

  String _supportingSentences(String text) {
    final trimmed = text.trim();
    final leading = _leadingSentence(trimmed);
    final remainder = trimmed.substring(leading.length).trimLeft();
    return remainder;
  }

  RiskLevel _riskLevelFromSeverity(String severityLabel) {
    final lower = severityLabel.toLowerCase();
    if (lower.contains('red') || lower.contains('amber')) {
      return RiskLevel.high;
    }
    if (lower.contains('yellow')) {
      return RiskLevel.headsUp;
    }
    return RiskLevel.headsUp;
  }

  IconData _iconForWarningText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('wind')) {
      return Icons.air_rounded;
    }
    if (lower.contains('thunder')) {
      return Icons.thunderstorm_rounded;
    }
    if (lower.contains('snow') || lower.contains('ice')) {
      return Icons.ac_unit_rounded;
    }
    if (lower.contains('fog')) {
      return Icons.dehaze_rounded;
    }
    if (lower.contains('heat')) {
      return Icons.thermostat_rounded;
    }
    if (lower.contains('frost') || lower.contains('cold')) {
      return Icons.severe_cold_rounded;
    }
    return Icons.warning_amber_rounded;
  }

  ActivityRecommendation _scoreWalking(_ActivityContext context) {
    var raw = 8.5;
    raw -= _rainPenalty(context, heavy: 3.0, moderate: 1.8, light: 0.8);
    raw -= _windPenalty(context, strong: 2.0, moderate: 0.9);
    raw -= _coldPenalty(context, veryCold: 1.7, cool: 0.8);
    raw -= context.visibilityMeters < 2500 ? 1.0 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Walking',
      score: score,
      icon: Icons.hiking_rounded,
      detail: score >= 8
          ? 'Mostly dry and comfortable for getting about on foot.'
          : context.rainMm >= 0.7 || context.rainChance >= 70
              ? 'Showers are the main drag on an otherwise easy walk.'
              : context.windKph >= 30
                  ? 'Walkable, but gusts will make it feel less pleasant.'
                  : 'Usable enough, but expect some typical UK-weather friction.',
    );
  }

  ActivityRecommendation _scoreRunning(_ActivityContext context) {
    var raw = 8.2;
    raw -= _rainPenalty(context, heavy: 2.8, moderate: 1.6, light: 0.6);
    raw -= _windPenalty(context, strong: 2.4, moderate: 1.2);
    raw -= _heatPenalty(context, warm: 0.8, hot: 1.6);
    raw -= context.feelsLikeC <= 1 ? 1.1 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Running',
      score: score,
      icon: Icons.directions_run_rounded,
      detail: score >= 8
          ? 'A solid day for a run with no major weather blocker.'
          : context.windKph >= 30
              ? 'Wind is the main thing that could make a run feel harder.'
              : context.rainMm >= 0.7 || context.rainChance >= 70
                  ? 'Rain will make a run wetter than ideal.'
                  : 'Still runnable, but conditions are only average.',
    );
  }

  ActivityRecommendation _scoreCycling(_ActivityContext context) {
    var raw = 8.0;
    raw -= _rainPenalty(context, heavy: 3.1, moderate: 1.9, light: 0.8);
    raw -= _windPenalty(context, strong: 3.4, moderate: 1.8);
    raw -= context.visibilityMeters < 6000 ? 1.4 : 0;
    raw -= context.feelsLikeC <= 1 ? 0.8 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Cycling',
      score: score,
      icon: Icons.directions_bike_rounded,
      detail: score >= 8
          ? 'Mostly dry with manageable wind for riding.'
          : context.windKph >= 30
              ? 'Gusts are the biggest reason this ride could feel awkward.'
              : context.rainMm >= 0.7 || context.rainChance >= 70
                  ? 'Wet roads and rain risk drag the cycling score down.'
                  : 'Rideable enough, but not especially comfortable.',
    );
  }

  ActivityRecommendation _scorePicnic(_ActivityContext context) {
    var raw = 7.6;
    raw -= _rainPenalty(context, heavy: 4.0, moderate: 2.8, light: 1.2);
    raw -= _windPenalty(context, strong: 2.8, moderate: 1.3);
    raw -= _coolLeisurePenalty(context, cool: 1.2, cold: 2.0);
    raw += context.dryWindowMinutes >= 150
        ? 1.8
        : context.dryWindowMinutes >= 90
            ? 0.9
            : 0;
    raw += context.brightSkies ? 0.7 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Picnic',
      score: score,
      icon: Icons.lunch_dining_rounded,
      detail: score >= 8
          ? 'A decent dry block makes an outdoor sit-down realistic.'
          : context.dryWindowMinutes < 60
              ? 'There is not enough reliable dry time to make this easy.'
              : context.windKph >= 30
                  ? 'Wind and comfort are the main problems for a picnic.'
                  : 'Possible, but only if you stay flexible.',
    );
  }

  ActivityRecommendation _scoreLaundryDrying(_ActivityContext context) {
    var raw = 4.8;
    raw -= _rainPenalty(context, heavy: 5.0, moderate: 3.6, light: 1.5);
    raw += context.dryWindowMinutes >= 180
        ? 3.4
        : context.dryWindowMinutes >= 120
            ? 2.2
            : context.dryWindowMinutes >= 60
                ? 1.0
                : 0;
    raw += context.windKph >= 10 && context.windKph <= 28 ? 1.1 : 0;
    raw += context.brightSkies ? 0.8 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Laundry drying',
      score: score,
      icon: Icons.local_laundry_service_rounded,
      detail: score >= 8
          ? 'A long dry window gives washing a real chance outside.'
          : context.rainChance >= 60 || context.rainMm >= 0.7
              ? 'Rain risk is the big reason outdoor drying looks weak.'
              : 'You may get some drying done, but it is not a banker.',
    );
  }

  ActivityRecommendation _scoreDogWalk(_ActivityContext context) {
    var raw = 8.7;
    raw -= _rainPenalty(context, heavy: 2.7, moderate: 1.4, light: 0.6);
    raw -= _windPenalty(context, strong: 1.9, moderate: 0.7);
    raw -= _coldPenalty(context, veryCold: 1.8, cool: 0.8);
    final score = _score(raw);
    return _activity(
      name: 'Dog walk',
      score: score,
      icon: Icons.pets_rounded,
      detail: score >= 8
          ? 'Looks fine for a normal dog walk without much hassle.'
          : context.rainChance >= 60 || context.rainMm >= 0.7
              ? 'A wet patch is the main thing likely to spoil the walk.'
              : 'Still doable, but less pleasant than usual.',
    );
  }

  ActivityRecommendation _scoreFootball(_ActivityContext context) {
    var raw = 8.1;
    raw -= _rainPenalty(context, heavy: 3.0, moderate: 1.6, light: 0.7);
    raw -= _windPenalty(context, strong: 2.4, moderate: 1.1);
    raw -= _coolLeisurePenalty(context, cool: 0.7, cold: 1.4);
    raw -= context.dryWindowMinutes < 60 ? 1.2 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Football',
      score: score,
      icon: Icons.sports_soccer_rounded,
      detail: score >= 8
          ? 'Good enough for a kickabout with no major weather issue.'
          : context.windKph >= 30
              ? 'Wind will make the game feel messier than usual.'
              : context.rainChance >= 60 || context.rainMm >= 0.7
                  ? 'Rain is the biggest reason football looks less appealing.'
                  : 'Playable, but conditions are only middling.',
    );
  }

  ActivityRecommendation _scoreOutdoorCoffee(_ActivityContext context) {
    var raw = 7.4;
    raw -= _rainPenalty(context, heavy: 4.1, moderate: 2.9, light: 1.0);
    raw -= _windPenalty(context, strong: 2.6, moderate: 1.3);
    raw -= _coolLeisurePenalty(context, cool: 1.0, cold: 2.0);
    raw += context.brightSkies ? 0.7 : 0;
    final score = _score(raw);
    return _activity(
      name: 'Outdoor coffee',
      score: score,
      icon: Icons.coffee_rounded,
      detail: score >= 8
          ? 'There is enough comfort and dryness to sit outside for a drink.'
          : context.rainChance >= 60 || context.rainMm >= 0.7
              ? 'Rain makes this much less inviting.'
              : context.windKph >= 30
                  ? 'Wind knocks the comfort level down for sitting outside.'
                  : 'You might manage it, but it is not an obvious outdoor day.',
    );
  }

  ActivityRecommendation _activity({
    required String name,
    required int score,
    required String detail,
    required IconData icon,
  }) {
    return ActivityRecommendation(
      name: name,
      score: score,
      detail: detail,
      suitability: _suitabilityForScore(score),
      icon: icon,
    );
  }

  ActivitySuitability _suitabilityForScore(int score) {
    if (score >= 8) {
      return ActivitySuitability.great;
    }
    if (score >= 5) {
      return ActivitySuitability.okay;
    }
    return ActivitySuitability.poor;
  }

  int _score(double raw) => raw.round().clamp(0, 10);

  double _rainPenalty(
    _ActivityContext context, {
    required double heavy,
    required double moderate,
    required double light,
  }) {
    if (context.rainMm >= 1.0 || context.rainChance >= 80) {
      return heavy;
    }
    if (context.rainMm >= 0.35 || context.rainChance >= 55) {
      return moderate;
    }
    if (context.rainMm >= 0.08 || context.rainChance >= 35) {
      return light;
    }
    return 0;
  }

  double _windPenalty(
    _ActivityContext context, {
    required double strong,
    required double moderate,
  }) {
    if (context.windKph >= 34) {
      return strong;
    }
    if (context.windKph >= 24) {
      return moderate;
    }
    return 0;
  }

  double _coldPenalty(
    _ActivityContext context, {
    required double veryCold,
    required double cool,
  }) {
    if (context.feelsLikeC <= 1) {
      return veryCold;
    }
    if (context.feelsLikeC <= 7) {
      return cool;
    }
    return 0;
  }

  double _coolLeisurePenalty(
    _ActivityContext context, {
    required double cool,
    required double cold,
  }) {
    if (context.feelsLikeC < 9) {
      return cold;
    }
    if (context.feelsLikeC < 14) {
      return cool;
    }
    return 0;
  }

  double _heatPenalty(
    _ActivityContext context, {
    required double warm,
    required double hot,
  }) {
    if (context.feelsLikeC >= 26) {
      return hot;
    }
    if (context.feelsLikeC >= 21) {
      return warm;
    }
    return 0;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _ActivityContext {
  const _ActivityContext({
    required this.feelsLikeC,
    required this.rainChance,
    required this.rainMm,
    required this.windKph,
    required this.visibilityMeters,
    required this.dryWindowMinutes,
    required this.brightSkies,
  });

  final double feelsLikeC;
  final int rainChance;
  final double rainMm;
  final double windKph;
  final double visibilityMeters;
  final int dryWindowMinutes;
  final bool brightSkies;

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
    final maxRainMm = nearHours.fold<double>(
      max(report.current.precipitationMm, nextHour.maxPrecipitationMm),
      (value, slot) => max(value, slot.precipitationMm),
    );
    final maxWind = nearHours.fold<double>(
      max(report.current.windSpeedKph, report.today.maxWindKph),
      (value, slot) => max(value, slot.windSpeedKph),
    );
    final minVisibility = nearHours.fold<double>(
      report.current.visibilityMeters,
      (value, slot) => min(value, slot.visibilityMeters),
    );
    final averageCloud = nearHours.isEmpty
        ? report.current.cloudCover.toDouble()
        : nearHours.fold<int>(0, (sum, slot) => sum + slot.cloudCover) / nearHours.length;

    return _ActivityContext(
      feelsLikeC: report.current.apparentTemperatureC,
      rainChance: maxRainChance,
      rainMm: maxRainMm,
      windKph: maxWind,
      visibilityMeters: minVisibility,
      dryWindowMinutes: dryWindow.duration.inMinutes,
      brightSkies: report.today.uvIndexMax >= 3 && averageCloud < 55,
    );
  }
}
