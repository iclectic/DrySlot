import 'dart:math';

import 'weather_models.dart';

class CommuteWeatherService {
  const CommuteWeatherService();

  CommuteOverview buildCommute(
    List<HourlyForecast> hourly,
    DateTime now,
    List<SavedCommuteWindow> commuteWindows,
  ) {
    final templates = commuteWindows.isEmpty
        ? SavedCommuteWindow.defaults
        : commuteWindows;
    final windows = templates
        .map((template) => _scoreWindow(hourly, now, template))
        .toList(growable: false);
    final roughCount = windows
        .where((window) => window.tone == AdviceTone.wait)
        .length;
    final helpfulCount = windows
        .where((window) => window.tone == AdviceTone.go)
        .length;

    final summary = roughCount > 0
        ? '$roughCount saved ${roughCount == 1 ? 'routine looks' : 'routines look'} tricky today, so plan around them.'
        : helpfulCount == windows.length
        ? 'Your saved routines look straightforward today.'
        : 'Some routines look fine, but a few may need timing.';

    return CommuteOverview(windows: windows, summary: summary);
  }

  CommuteLeg _scoreWindow(
    List<HourlyForecast> hourly,
    DateTime now,
    SavedCommuteWindow template,
  ) {
    final start = _nextOccurrence(
      now,
      template.startMinutes,
      template.endMinutes,
    );
    final end = _endForOccurrence(
      start,
      template.startMinutes,
      template.endMinutes,
    );
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
        detail: 'No forecast is available for this saved routine yet.',
        summary: 'Forecast unavailable',
        score: 50,
      );
    }

    final avgRainChance =
        slots.fold<int>(0, (sum, slot) => sum + slot.precipitationProbability) /
        slots.length;
    final maxRain = slots.fold<double>(
      0,
      (value, slot) => max(value, slot.precipitationMm),
    );
    final maxWind = slots.fold<double>(
      0,
      (value, slot) => max(value, slot.windSpeedKph),
    );
    final minVisibility = slots.fold<double>(
      double.infinity,
      (value, slot) => min(value, slot.visibilityMeters),
    );

    final rainPenalty = avgRainChance * 0.35 + maxRain * 28;
    final windPenalty = max(0, maxWind - 18) * 1.6;
    final visibilityPenalty = minVisibility < 2500
        ? 18
        : minVisibility < 6000
        ? 9
        : 0;
    final rawScore = (100 - rainPenalty - windPenalty - visibilityPenalty)
        .round()
        .clamp(15, 98);

    AdviceTone tone;
    String summary;
    String detail;
    if (rawScore >= 75) {
      tone = AdviceTone.go;
      summary = 'Good window';
      detail = 'Mostly dry, with wind and visibility looking manageable.';
    } else if (rawScore >= 55) {
      tone = AdviceTone.watch;
      summary = 'A bit mixed';
      detail = 'Usable, but expect a few wet, breezy, or murky patches.';
    } else {
      tone = AdviceTone.wait;
      summary = 'Tricky spell';
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
}
