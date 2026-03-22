import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../weather/domain/weather_describer.dart';
import '../../weather/domain/weather_interpreter.dart';
import '../../weather_core/domain/weather_models.dart';

class WeatherSummaryGenerator {
  const WeatherSummaryGenerator();

  GuidanceHeadline buildHeadline(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    List<RiskNote> risks,
  ) {
    final severeRisk = risks.any((risk) => risk.level == RiskLevel.high);
    if (severeRisk) {
      return GuidanceHeadline(
        title: 'Keep a backup plan today',
        detail: risks.first.detail,
        tone: AdviceTone.wait,
        callToAction: 'Keep an eye on alerts',
      );
    }

    if (nextHour.tone == AdviceTone.go &&
        dryWindow.isAvailable &&
        dryWindow.duration.inHours >= 2) {
      return GuidanceHeadline(
        title: 'A good day to get out',
        detail: 'It starts well and there is a useful dry window later on.',
        tone: AdviceTone.go,
        callToAction: 'Use the best dry slot',
      );
    }

    if (nextHour.tone == AdviceTone.wait &&
        dryWindow.isAvailable &&
        dryWindow.start != null) {
      return GuidanceHeadline(
        title: 'Wait a bit, then head out',
        detail: 'The better window comes after the current wet patch clears.',
        tone: AdviceTone.watch,
        callToAction: 'Wait for the dry gap',
      );
    }

    if (report.today.precipitationProbabilityMax >= 70) {
      return GuidanceHeadline(
        title: 'Plan around the showers',
        detail: 'There are usable gaps today, but timing will matter.',
        tone: AdviceTone.watch,
        callToAction: nextHour.departureAdvice,
      );
    }

    return GuidanceHeadline(
      title: 'A steady day for getting things done',
      detail: 'Nothing too disruptive stands out if you time things sensibly.',
      tone: AdviceTone.go,
      callToAction: nextHour.departureAdvice,
    );
  }

  String buildSimpleSummary(
    WeatherReport report,
    NextHourInsight nextHour,
    DryWindowInsight dryWindow,
    List<WearTip> wearTips,
  ) {
    final phrases = <String>[];
    final wearPhrase = _wearPhrase(wearTips);
    final breezyLater = report.today.maxWindKph >= 28;
    final coldLater =
        report.today.minTempC <= 6 || report.current.apparentTemperatureC <= 8;

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

  List<HomeSummaryCard> buildHomeCards(
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

    final commuteTone =
        commute.windows.any((window) => window.tone == AdviceTone.wait)
        ? AdviceTone.wait
        : commute.windows.any((window) => window.tone == AdviceTone.watch)
        ? AdviceTone.watch
        : AdviceTone.go;

    return <HomeSummaryCard>[
      HomeSummaryCard(
        title: 'Current weather',
        value:
            '${formatTemperature(report.current.temperatureC)} ${currentDescriptor.label}',
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
        detail: interpreter.isDetailed
            ? nextHour.detail
            : nextHour.departureAdvice,
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
        value: commute.windows.isEmpty
            ? 'No routines saved'
            : _commuteHeadline(commute),
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
        tone: report.officialWarnings.isNotEmpty
            ? AdviceTone.watch
            : AdviceTone.go,
      ),
    ];
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

  String _clock(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _commuteHeadline(CommuteOverview commute) {
    final best = commute.windows.reduce((a, b) => a.score >= b.score ? a : b);
    return '${best.label}: ${best.score}/100';
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
    return trimmed.substring(leading.length).trimLeft();
  }
}
