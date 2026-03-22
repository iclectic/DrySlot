import 'dart:math';

import '../../../core/utils/formatters.dart';
import '../../weather/domain/weather_describer.dart';
import '../../weather_core/domain/weather_models.dart';

class DrySlotCalculator {
  const DrySlotCalculator();

  NextHourInsight buildNextHourInsight(WeatherReport report) {
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
    final firstRain = slots
        .where((slot) => slot.precipitationMm >= 0.08)
        .firstOrNull;
    final maxPrecipitation = slots.fold<double>(
      0,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final rainingNow =
        report.current.precipitationMm >= 0.08 ||
        slots.first.precipitationMm >= 0.08;

    if (firstRain == null && !rainingNow) {
      return const NextHourInsight(
        title: 'Dry for the next hour',
        detail: 'Dry for a while yet, so you can head out without rushing.',
        departureAdvice: 'Safe to head out now',
        tone: AdviceTone.go,
        maxPrecipitationMm: 0,
      );
    }

    if (rainingNow) {
      final tone = maxPrecipitation >= 0.8 ? AdviceTone.wait : AdviceTone.watch;
      final detail = maxPrecipitation >= 0.8
          ? 'Rain is already in and could stay lively for a bit.'
          : 'There is rain about right now, though it should stay fairly light.';
      return NextHourInsight(
        title: maxPrecipitation >= 0.8
            ? 'Wet right now'
            : 'Light rain is hovering',
        detail: detail,
        departureAdvice: tone == AdviceTone.wait
            ? 'Wait it out if you can'
            : 'Go only with a waterproof',
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
      detail:
          'Dry for roughly $minutesUntilRain minutes, then $intensity may move in.',
      departureAdvice: 'A good moment to leave now',
      tone: AdviceTone.go,
      maxPrecipitationMm: maxPrecipitation,
      minutesUntilRain: minutesUntilRain,
    );
  }

  DryWindowInsight findBestDryWindow(List<HourlyForecast> hourly) {
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
    final afternoonLooksWet =
        afternoon.length >= 4 && afternoon.every((slot) => !_isDryEnough(slot));

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
          note:
              'The middle of the day looks unsettled, so longer outdoor plans may be awkward.',
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
        note:
            'Only a brief useful gap stands out, so keep plans tight and practical.',
        confidenceLabel: 'Low confidence',
        tone: AdviceTone.watch,
      );
    }

    final start = bestRun.first.time;
    final end = bestRun.last.time.add(const Duration(hours: 1));
    final duration = end.difference(start);
    final averageProbability =
        bestRun.fold<int>(
          0,
          (sum, slot) => sum + slot.precipitationProbability,
        ) /
        bestRun.length;
    final confidence = averageProbability < 18
        ? 'High confidence'
        : 'Reasonable confidence';
    final isShortWindow = duration.inMinutes <= 75;
    final note = duration.inHours >= 3
        ? 'This looks like the clearest part of the day for errands, walks, or outdoor jobs.'
        : duration.inHours >= 2
        ? 'A practical window for the school run, errands, or a walk.'
        : 'A short but usable gap if you keep things moving.';

    return DryWindowInsight(
      headline:
          '${isShortWindow ? 'Short' : 'Best'} dry slot: ${_clock(start)} to ${_clock(end)}',
      isAvailable: true,
      start: start,
      end: end,
      duration: duration,
      note: note,
      confidenceLabel: confidence,
      tone: duration.inHours >= 2 ? AdviceTone.go : AdviceTone.watch,
    );
  }

  WeekendPlanner? buildWeekendPlanner(List<DailyForecast> daily, DateTime now) {
    final upcomingWeekend = daily
        .where(
          (day) =>
              !day.date.isBefore(DateTime(now.year, now.month, now.day)) &&
              (day.date.weekday == DateTime.saturday ||
                  day.date.weekday == DateTime.sunday),
        )
        .take(2)
        .toList(growable: false);

    if (upcomingWeekend.isEmpty) {
      return null;
    }

    final weekendDays = upcomingWeekend
        .map(_buildWeekendDayPlan)
        .toList(growable: false);
    final sorted = [
      ...upcomingWeekend,
    ]..sort((a, b) => _dayUsefulnessScore(b).compareTo(_dayUsefulnessScore(a)));
    final best = sorted.first;
    final worst = sorted.last;
    final scoreGap = _dayUsefulnessScore(best) - _dayUsefulnessScore(worst);

    final title = switch (weekendDays.length) {
      1 => '${_weekendLabel(weekendDays.first.date)} is worth planning around',
      _ when scoreGap >= 2.2 =>
        '${_weekendLabel(best.date)} is your better outdoor day',
      _ when weekendDays.every((day) => day.tone == AdviceTone.go) =>
        'The weekend looks open for plans',
      _ when weekendDays.every((day) => day.tone == AdviceTone.wait) =>
        'Weekend plans look weather-led',
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
      _ =>
        'One day looks more practical than the other, so choose your longer outdoor plans carefully.',
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
    final mostlyWet =
        day.precipitationProbabilityMax >= 70 || day.precipitationMm >= 4;
    final mixed =
        day.precipitationProbabilityMax >= 40 || day.precipitationMm >= 1.5;
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

  bool _isDryEnough(HourlyForecast slot) {
    return slot.precipitationProbability < 35 &&
        slot.precipitationMm < 0.15 &&
        slot.windSpeedKph < 32;
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

  double _slotPenalty(HourlyForecast slot) {
    return slot.precipitationProbability +
        slot.precipitationMm * 40 +
        max(0, slot.windSpeedKph - 22);
  }

  String _weekendLabel(DateTime date) {
    return switch (date.weekday) {
      DateTime.saturday => 'Saturday',
      DateTime.sunday => 'Sunday',
      _ => formatDateHeader(date),
    };
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
