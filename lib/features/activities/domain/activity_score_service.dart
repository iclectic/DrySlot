import 'dart:math';

import 'package:flutter/material.dart';

import '../../weather_core/domain/weather_models.dart';

class ActivityScoreService {
  const ActivityScoreService();

  List<ActivityRecommendation> buildActivities(
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
        : nearHours.fold<int>(0, (sum, slot) => sum + slot.cloudCover) /
              nearHours.length;

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
