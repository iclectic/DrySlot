import 'dart:math';

import 'package:flutter/material.dart';

import 'weather_describer.dart';
import 'weather_models.dart';

class WeatherAdvisor {
  const WeatherAdvisor();

  WeatherGuidance build(
    WeatherReport report, {
    required List<SavedCommuteWindow> commuteWindows,
  }) {
    final nextHour = _buildNextHourInsight(report);
    final dryWindow = _findBestDryWindow(report.hourly);
    final commute = _buildCommute(report.hourly, report.fetchedAt, commuteWindows);
    final risks = _buildRisks(report);
    final wearTips = _buildWearTips(report, nextHour);
    final activities = _buildActivities(report, dryWindow, nextHour);
    final headline = _buildHeadline(report, nextHour, dryWindow, risks);
    final simpleSummary = _buildSimpleSummary(
      report,
      nextHour,
      dryWindow,
      wearTips,
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
        ? '$roughCount saved ${roughCount == 1 ? 'journey looks' : 'journeys look'} rough, so time them carefully.'
        : helpfulCount == windows.length
            ? 'Your saved journeys look manageable today.'
            : 'A mixed picture across your saved journeys.';

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
        title: 'Light jacket',
        detail: 'A light layer should keep the edge off.',
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
        suitability: nextHour.tone == AdviceTone.wait
            ? ActivitySuitability.okay
            : ActivitySuitability.great,
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
        suitability: shortWindowRain < 0.4
            ? ActivitySuitability.great
            : ActivitySuitability.okay,
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
    if (first.contains('waterproof')) {
      return 'waterproof recommended';
    }
    if (first.contains('light jacket')) {
      return 'light jacket recommended';
    }
    if (first.contains('warm')) {
      return 'warm layers recommended';
    }
    if (first.contains('windproof')) {
      return 'windproof layer recommended';
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
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
