import 'package:flutter/material.dart';

import 'weather_models.dart';

class OutfitRecommendationService {
  const OutfitRecommendationService();

  List<WearTip> buildWearTips(WeatherReport report, NextHourInsight nextHour) {
    final tips = <WearTip>[];

    final rainLikely =
        nextHour.maxPrecipitationMm >= 0.08 ||
        report.today.precipitationProbabilityMax >= 50;
    final windy = report.today.maxWindKph >= 28;
    final chillyNow = report.current.apparentTemperatureC <= 8;
    final warmingLater =
        report.fetchedAt.hour < 11 &&
        report.today.maxTempC - report.current.apparentTemperatureC >= 5;

    if (rainLikely) {
      if (windy) {
        tips.add(
          const WearTip(
            title: 'Take a light waterproof',
            detail: 'Showers and gusts will favour a jacket over an umbrella.',
            icon: Icons.umbrella_rounded,
          ),
        );
      } else {
        tips.add(
          const WearTip(
            title: 'Umbrella recommended',
            detail: 'Rain risk is high enough that it is worth taking one.',
            icon: Icons.umbrella_rounded,
          ),
        );
      }
    }

    if (report.current.apparentTemperatureC >= 10 &&
        report.current.apparentTemperatureC <= 17 &&
        windy) {
      tips.add(
        const WearTip(
          title: 'Mild, but windy',
          detail:
              'You will not need heavy layers, but gusts could cut through light clothing.',
          icon: Icons.air_rounded,
        ),
      );
    }

    if (chillyNow && warmingLater) {
      tips.add(
        const WearTip(
          title: 'Cold start, warmer by noon',
          detail: 'Start with a jacket or jumper that you can take off later.',
          icon: Icons.wb_twilight_rounded,
        ),
      );
    } else if (report.current.apparentTemperatureC <= 5 ||
        report.today.minTempC <= 3) {
      tips.add(
        const WearTip(
          title: 'Wrap up well',
          detail:
              'It feels cold enough for proper layers, especially early or in exposed spots.',
          icon: Icons.layers_rounded,
        ),
      );
    } else if (report.current.apparentTemperatureC <= 13) {
      tips.add(
        const WearTip(
          title: 'Take a light layer',
          detail:
              'A jumper or light jacket should be enough for most of the day.',
          icon: Icons.checkroom_rounded,
        ),
      );
    }

    if (report.today.uvIndexMax >= 4 &&
        report.today.precipitationProbabilityMax < 35) {
      tips.add(
        const WearTip(
          title: 'Sunglasses worth packing',
          detail: 'There should be enough brightness to make them useful.',
          icon: Icons.wb_sunny_outlined,
        ),
      );
    }

    if (tips.isEmpty) {
      tips.add(
        const WearTip(
          title: 'Light layers should do',
          detail: 'Conditions look settled enough for normal daywear.',
          icon: Icons.directions_walk_rounded,
        ),
      );
    }

    return tips.take(4).toList(growable: false);
  }
}
