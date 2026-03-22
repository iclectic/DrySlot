import 'dart:math';

import 'package:flutter/material.dart';

import '../../weather_core/domain/weather_models.dart';

class SevereAlertInterpreter {
  const SevereAlertInterpreter();

  List<RiskNote> buildRisks(WeatherReport report) {
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
    final heatRisk =
        max(report.today.maxTempC, report.current.apparentTemperatureC) >= 28;
    final frostRisk =
        report.today.minTempC <= 1 || report.current.apparentTemperatureC <= 0;

    if (maxWind >= 46) {
      risks.add(
        const RiskNote(
          title: 'Blustery spells',
          detail:
              'Stronger gusts could make exposed routes and cycling awkward.',
          level: RiskLevel.high,
          icon: Icons.air_rounded,
        ),
      );
    } else if (maxWind >= 32) {
      risks.add(
        const RiskNote(
          title: 'Breezy periods',
          detail:
              'Nothing extreme, but it may feel sharper than the temperature suggests.',
          level: RiskLevel.headsUp,
          icon: Icons.air_rounded,
        ),
      );
    }

    if (maxHourlyRain >= 1.2) {
      risks.add(
        const RiskNote(
          title: 'Burst of heavy rain',
          detail:
              'Some showers could be punchy enough to spoil an outdoor plan quickly.',
          level: RiskLevel.headsUp,
          icon: Icons.water_damage_rounded,
        ),
      );
    }

    if (hasSnow) {
      risks.add(
        const RiskNote(
          title: 'Snow or wintry risk',
          detail:
              'Wintry spells could make outdoor routes slippery and slower.',
          level: RiskLevel.headsUp,
          icon: Icons.ac_unit_rounded,
        ),
      );
    }

    if (minVisibility <= 1500) {
      risks.add(
        const RiskNote(
          title: 'Reduced visibility',
          detail:
              'Fog or murk could slow things down and make travel feel drearier.',
          level: RiskLevel.headsUp,
          icon: Icons.dehaze_rounded,
        ),
      );
    }

    if (hasThunder) {
      risks.add(
        const RiskNote(
          title: 'Thunderstorm risk',
          detail: 'Keep outdoor plans flexible if storms develop nearby.',
          level: RiskLevel.high,
          icon: Icons.thunderstorm_rounded,
        ),
      );
    }

    if (heatRisk) {
      risks.add(
        const RiskNote(
          title: 'Heat building later',
          detail:
              'Warmer conditions could make exposed outdoor plans more draining.',
          level: RiskLevel.headsUp,
          icon: Icons.thermostat_rounded,
        ),
      );
    }

    if (frostRisk) {
      risks.add(
        const RiskNote(
          title: 'Frosty start',
          detail:
              'A cold start could leave pavements, cars, or grass slick early on.',
          level: RiskLevel.headsUp,
          icon: Icons.severe_cold_rounded,
        ),
      );
    }

    if (risks.isEmpty) {
      risks.add(
        const RiskNote(
          title: 'Nothing major flagged',
          detail:
              'The day looks manageable with the usual bit of UK-weather caution.',
          level: RiskLevel.calm,
          icon: Icons.verified_rounded,
        ),
      );
    }

    return risks;
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

  bool _isSnowCode(int code) {
    return <int>{71, 73, 75, 77, 85, 86}.contains(code);
  }
}
