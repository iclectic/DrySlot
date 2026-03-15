import 'dart:math';

import 'package:flutter/material.dart';

import 'weather_describer.dart';
import 'weather_models.dart';

class WeatherAdvisor {
  const WeatherAdvisor();

  WeatherGuidance build(WeatherReport report) {
    final nextHour = _buildNextHourInsight(report);
    final dryWindow = _findBestDryWindow(report.hourly);
    final commute = _buildCommute(report.hourly, report.fetchedAt);
    final risks = _buildRisks(report);
    final wearTips = _buildWearTips(report, nextHour);
    final activities = _buildActivities(report, dryWindow, nextHour);
    final headline = _buildHeadline(report, nextHour, dryWindow, risks);
    final simpleSummary = _buildSimpleSummary(report, nextHour, dryWindow, risks);

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
      );
    }

    return NextHourInsight(
      title: 'You have time before rain',
      detail: 'It looks dry for roughly $minutesUntilRain minutes, then $intensity may arrive.',
      departureAdvice: 'A good moment to leave now',
      tone: AdviceTone.go,
      maxPrecipitationMm: maxPrecipitation,
    );
  }

  DryWindowInsight _findBestDryWindow(List<HourlyForecast> hourly) {
    final candidates = hourly.take(12).toList(growable: false);
    if (candidates.isEmpty) {
      return const DryWindowInsight(
        isAvailable: false,
        start: null,
        end: null,
        duration: Duration.zero,
        note: 'Hourly data is not available yet.',
        confidenceLabel: 'Unknown',
        tone: AdviceTone.watch,
      );
    }

    List<HourlyForecast> currentRun = <HourlyForecast>[];
    List<HourlyForecast> bestRun = <HourlyForecast>[];

    for (final slot in candidates) {
      final dryEnough = slot.precipitationProbability < 35 &&
          slot.precipitationMm < 0.15 &&
          slot.windSpeedKph < 32;

      if (dryEnough) {
        currentRun.add(slot);
        if (currentRun.length > bestRun.length) {
          bestRun = List<HourlyForecast>.from(currentRun);
        }
      } else {
        currentRun = <HourlyForecast>[];
      }
    }

    if (bestRun.isEmpty) {
      final leastBad = candidates.reduce(
        (best, slot) => _slotPenalty(slot) < _slotPenalty(best) ? slot : best,
      );
      return DryWindowInsight(
        isAvailable: true,
        start: leastBad.time,
        end: leastBad.time.add(const Duration(hours: 1)),
        duration: const Duration(hours: 1),
        note: 'Conditions stay mixed, so use the least-wet hour you can find.',
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
    final note = duration.inHours >= 3
        ? 'This is your best block for walks, errands, or getting washing out.'
        : duration.inHours >= 2
            ? 'A practical slot for the school run, errands, or a walk.'
            : 'A short but usable gap if you keep things moving.';

    return DryWindowInsight(
      isAvailable: true,
      start: start,
      end: end,
      duration: duration,
      note: note,
      confidenceLabel: confidence,
      tone: duration.inHours >= 2 ? AdviceTone.go : AdviceTone.watch,
    );
  }

  CommuteOverview _buildCommute(List<HourlyForecast> hourly, DateTime now) {
    return CommuteOverview(
      morning: _scoreWindow(hourly, _nextWindow(now, 7, 9), 'Morning'),
      evening: _scoreWindow(hourly, _nextWindow(now, 16, 18), 'Evening'),
    );
  }

  CommuteLeg _scoreWindow(List<HourlyForecast> hourly, ({DateTime start, DateTime end}) window, String label) {
    final slots = hourly
        .where((slot) => !slot.time.isBefore(window.start) && slot.time.isBefore(window.end))
        .toList(growable: false);

    if (slots.isEmpty) {
      return CommuteLeg(
        label: label,
        start: window.start,
        end: window.end,
        tone: AdviceTone.watch,
        detail: 'No commute forecast available yet.',
        score: 50,
      );
    }

    final avgRainChance = slots.fold<int>(0, (sum, slot) => sum + slot.precipitationProbability) / slots.length;
    final maxRain = slots.fold<double>(0, (value, slot) => max(value, slot.precipitationMm));
    final maxWind = slots.fold<double>(0, (value, slot) => max(value, slot.windSpeedKph));
    final minVisibility = slots.fold<double>(double.infinity, (value, slot) => min(value, slot.visibilityMeters));

    final rainPenalty = avgRainChance * 0.35 + maxRain * 28;
    final windPenalty = max(0, maxWind - 18) * 1.6;
    final visibilityPenalty = minVisibility < 2500 ? 18 : minVisibility < 6000 ? 9 : 0;
    final rawScore = (100 - rainPenalty - windPenalty - visibilityPenalty).round().clamp(15, 98);

    AdviceTone tone;
    String detail;
    if (rawScore >= 75) {
      tone = AdviceTone.go;
      detail = 'Mostly smooth with manageable rain risk.';
    } else if (rawScore >= 55) {
      tone = AdviceTone.watch;
      detail = 'Usable, but expect some wet or breezy patches.';
    } else {
      tone = AdviceTone.wait;
      detail = 'Likely to feel rough with rain, wind, or poor visibility.';
    }

    return CommuteLeg(
      label: label,
      start: window.start,
      end: window.end,
      tone: tone,
      detail: detail,
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

    if (nextHour.maxPrecipitationMm >= 0.08 || report.today.precipitationProbabilityMax >= 45) {
      tips.add(const WearTip(
        title: 'Waterproof layer',
        detail: 'Rain risk is high enough to justify a jacket or umbrella.',
        icon: Icons.umbrella_rounded,
      ));
    }

    if (report.current.apparentTemperatureC <= 7 || report.today.minTempC <= 4) {
      tips.add(const WearTip(
        title: 'Warm layers',
        detail: 'It will feel chilly, especially in exposed spots.',
        icon: Icons.layers_rounded,
      ));
    } else if (report.current.apparentTemperatureC <= 13) {
      tips.add(const WearTip(
        title: 'Light extra layer',
        detail: 'A jumper or overshirt should be enough.',
        icon: Icons.checkroom_rounded,
      ));
    }

    if (report.today.maxWindKph >= 30) {
      tips.add(const WearTip(
        title: 'Windproof outerwear',
        detail: 'Breezy spells will make it feel cooler than the temperature suggests.',
        icon: Icons.air_rounded,
      ));
    }

    if (report.today.uvIndexMax >= 4 && report.today.precipitationProbabilityMax < 35) {
      tips.add(const WearTip(
        title: 'Sunglasses',
        detail: 'There should be enough brightness to make them worthwhile.',
        icon: Icons.wb_sunny_outlined,
      ));
    }

    if (tips.isEmpty) {
      tips.add(const WearTip(
        title: 'Normal day kit',
        detail: 'Standard layers and comfortable shoes should do the job.',
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
    final currentTemp = report.current.apparentTemperatureC;
    final nextFourHours = report.hourly.take(4).toList(growable: false);
    final shortWindowRain = nextFourHours.fold<double>(
      0,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final shortWindowWind = nextFourHours.fold<double>(
      0,
      (value, slot) => max(value, slot.windSpeedKph),
    );

    return <ActivityRecommendation>[
      ActivityRecommendation(
        name: 'School run',
        detail: nextHour.tone == AdviceTone.wait
            ? 'Give yourself extra buffer and pack waterproofs.'
            : 'Looks manageable if you head out on time.',
        suitability: nextHour.tone == AdviceTone.wait ? ActivitySuitability.okay : ActivitySuitability.great,
        icon: Icons.family_restroom_rounded,
      ),
      ActivityRecommendation(
        name: 'Run or walk',
        detail: dryWindow.duration.inMinutes >= 90
            ? 'There is a useful dry patch for exercise.'
            : 'Keep it short unless you are happy with mixed weather.',
        suitability: dryWindow.duration.inMinutes >= 90
            ? ActivitySuitability.great
            : dryWindow.duration.inMinutes >= 45
                ? ActivitySuitability.okay
                : ActivitySuitability.poor,
        icon: Icons.directions_run_rounded,
      ),
      ActivityRecommendation(
        name: 'Errands',
        detail: shortWindowRain < 0.4
            ? 'Low enough rain risk for a practical trip.'
            : 'Still doable, but try to stack jobs into the drier period.',
        suitability: shortWindowRain < 0.4 ? ActivitySuitability.great : ActivitySuitability.okay,
        icon: Icons.shopping_bag_rounded,
      ),
      ActivityRecommendation(
        name: 'Cycling',
        detail: shortWindowWind < 24 && shortWindowRain < 0.35
            ? 'Conditions should stay reasonably comfortable.'
            : 'Wind or rain could make it a slog.',
        suitability: shortWindowWind < 24 && shortWindowRain < 0.35
            ? ActivitySuitability.great
            : shortWindowWind < 32
                ? ActivitySuitability.okay
                : ActivitySuitability.poor,
        icon: Icons.directions_bike_rounded,
      ),
      ActivityRecommendation(
        name: 'Outdoor lunch',
        detail: currentTemp >= 12 && dryWindow.duration.inMinutes >= 60
            ? 'There is enough comfort and a dry enough spell to enjoy it.'
            : 'Better kept flexible today.',
        suitability: currentTemp >= 12 && dryWindow.duration.inMinutes >= 60
            ? ActivitySuitability.great
            : currentTemp >= 9
                ? ActivitySuitability.okay
                : ActivitySuitability.poor,
        icon: Icons.deck_rounded,
      ),
    ];
  }

  List<RiskNote> _buildRisks(WeatherReport report) {
    final risks = <RiskNote>[];
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

  String _buildSimpleSummary(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    List<RiskNote> risks,
  ) {
    final descriptor = describeWeatherCode(
      report.current.weatherCode,
      isDay: report.current.isDay,
    );
    final riskLead = risks.first.level == RiskLevel.calm ? 'No major risks stand out.' : '${risks.first.title} could matter.';
    final dryLead = dryWindow.isAvailable && dryWindow.start != null && dryWindow.end != null
        ? 'Best dry window: ${_compactTime(dryWindow.start!)} to ${_compactTime(dryWindow.end!)}.'
        : 'Dry windows look patchy today.';
    return '${descriptor.summary}. ${nextHour.detail} $dryLead $riskLead';
  }

  ({DateTime start, DateTime end}) _nextWindow(DateTime now, int startHour, int endHour) {
    final todayStart = DateTime(now.year, now.month, now.day, startHour);
    final todayEnd = DateTime(now.year, now.month, now.day, endHour);
    if (now.isBefore(todayEnd)) {
      return (start: todayStart, end: todayEnd);
    }
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    return (start: tomorrowStart, end: tomorrowStart.add(Duration(hours: endHour - startHour)));
  }

  double _slotPenalty(HourlyForecast slot) {
    return slot.precipitationProbability + slot.precipitationMm * 40 + max(0, slot.windSpeedKph - 22);
  }

  String _compactTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
