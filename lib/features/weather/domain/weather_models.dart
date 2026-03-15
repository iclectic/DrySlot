import 'package:flutter/material.dart';

enum AdviceTone { go, watch, wait }

enum ActivitySuitability { great, okay, poor }

enum RiskLevel { calm, headsUp, high }

class WeatherLocation {
  const WeatherLocation({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;

  String get subtitle {
    if (region.isEmpty || region == name) {
      return country;
    }
    return '$region, $country';
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'name': name,
      'region': region,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
    };
  }

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      name: json['name'] as String? ?? 'Unknown',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? 'United Kingdom',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      timezone: json['timezone'] as String? ?? 'Europe/London',
    );
  }

  static const london = WeatherLocation(
    name: 'London',
    region: 'Greater London',
    country: 'United Kingdom',
    latitude: 51.5072,
    longitude: -0.1276,
    timezone: 'Europe/London',
  );

  static const presets = <WeatherLocation>[
    london,
    WeatherLocation(
      name: 'Manchester',
      region: 'England',
      country: 'United Kingdom',
      latitude: 53.4808,
      longitude: -2.2426,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Birmingham',
      region: 'England',
      country: 'United Kingdom',
      latitude: 52.4862,
      longitude: -1.8904,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Leeds',
      region: 'England',
      country: 'United Kingdom',
      latitude: 53.8008,
      longitude: -1.5491,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Bristol',
      region: 'England',
      country: 'United Kingdom',
      latitude: 51.4545,
      longitude: -2.5879,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Cardiff',
      region: 'Wales',
      country: 'United Kingdom',
      latitude: 51.4816,
      longitude: -3.1791,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Edinburgh',
      region: 'Scotland',
      country: 'United Kingdom',
      latitude: 55.9533,
      longitude: -3.1883,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Glasgow',
      region: 'Scotland',
      country: 'United Kingdom',
      latitude: 55.8642,
      longitude: -4.2518,
      timezone: 'Europe/London',
    ),
    WeatherLocation(
      name: 'Belfast',
      region: 'Northern Ireland',
      country: 'United Kingdom',
      latitude: 54.5973,
      longitude: -5.9301,
      timezone: 'Europe/London',
    ),
  ];
}

class SavedCommuteWindow {
  const SavedCommuteWindow({
    required this.id,
    required this.label,
    required this.startMinutes,
    required this.endMinutes,
  });

  final String id;
  final String label;
  final int startMinutes;
  final int endMinutes;

  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'label': label,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
    };
  }

  factory SavedCommuteWindow.fromJson(Map<String, dynamic> json) {
    return SavedCommuteWindow(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: json['label'] as String? ?? 'Saved window',
      startMinutes: (json['startMinutes'] as num?)?.toInt() ?? 480,
      endMinutes: (json['endMinutes'] as num?)?.toInt() ?? 540,
    );
  }

  SavedCommuteWindow copyWith({
    String? id,
    String? label,
    int? startMinutes,
    int? endMinutes,
  }) {
    return SavedCommuteWindow(
      id: id ?? this.id,
      label: label ?? this.label,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
    );
  }

  static const defaults = <SavedCommuteWindow>[
    SavedCommuteWindow(
      id: 'morning-commute',
      label: 'Morning commute',
      startMinutes: 7 * 60 + 30,
      endMinutes: 8 * 60 + 30,
    ),
    SavedCommuteWindow(
      id: 'evening-commute',
      label: 'Evening commute',
      startMinutes: 17 * 60,
      endMinutes: 18 * 60,
    ),
    SavedCommuteWindow(
      id: 'school-run',
      label: 'School run',
      startMinutes: 8 * 60,
      endMinutes: 8 * 60 + 45,
    ),
    SavedCommuteWindow(
      id: 'gym-walk',
      label: 'Walk to the gym',
      startMinutes: 18 * 60 + 30,
      endMinutes: 19 * 60 + 15,
    ),
  ];
}

class CurrentConditions {
  const CurrentConditions({
    required this.time,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.weatherCode,
    required this.isDay,
    required this.precipitationMm,
    required this.rainMm,
    required this.showersMm,
    required this.cloudCover,
    required this.windSpeedKph,
    required this.windGustKph,
    required this.visibilityMeters,
  });

  final DateTime time;
  final double temperatureC;
  final double apparentTemperatureC;
  final int weatherCode;
  final bool isDay;
  final double precipitationMm;
  final double rainMm;
  final double showersMm;
  final int cloudCover;
  final double windSpeedKph;
  final double windGustKph;
  final double visibilityMeters;
}

class MinuteForecast {
  const MinuteForecast({
    required this.time,
    required this.precipitationMm,
    required this.weatherCode,
    required this.windSpeedKph,
    required this.visibilityMeters,
    required this.isDay,
  });

  final DateTime time;
  final double precipitationMm;
  final int weatherCode;
  final double windSpeedKph;
  final double visibilityMeters;
  final bool isDay;
}

class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.precipitationProbability,
    required this.precipitationMm,
    required this.weatherCode,
    required this.windSpeedKph,
    required this.windGustKph,
    required this.visibilityMeters,
    required this.cloudCover,
    required this.uvIndex,
    required this.isDay,
  });

  final DateTime time;
  final double temperatureC;
  final double apparentTemperatureC;
  final int precipitationProbability;
  final double precipitationMm;
  final int weatherCode;
  final double windSpeedKph;
  final double windGustKph;
  final double visibilityMeters;
  final int cloudCover;
  final double uvIndex;
  final bool isDay;
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTempC,
    required this.minTempC,
    required this.precipitationMm,
    required this.precipitationProbabilityMax,
    required this.maxWindKph,
    required this.uvIndexMax,
    required this.sunrise,
    required this.sunset,
  });

  final DateTime date;
  final int weatherCode;
  final double maxTempC;
  final double minTempC;
  final double precipitationMm;
  final int precipitationProbabilityMax;
  final double maxWindKph;
  final double uvIndexMax;
  final DateTime sunrise;
  final DateTime sunset;
}

class WeatherReport {
  const WeatherReport({
    required this.location,
    required this.fetchedAt,
    required this.current,
    required this.minutely,
    required this.hourly,
    required this.today,
    required this.usingFallback,
    required this.sourceLabel,
    this.sourceNote,
  });

  final WeatherLocation location;
  final DateTime fetchedAt;
  final CurrentConditions current;
  final List<MinuteForecast> minutely;
  final List<HourlyForecast> hourly;
  final DailyForecast today;
  final bool usingFallback;
  final String sourceLabel;
  final String? sourceNote;
}

class GuidanceHeadline {
  const GuidanceHeadline({
    required this.title,
    required this.detail,
    required this.tone,
    required this.callToAction,
  });

  final String title;
  final String detail;
  final AdviceTone tone;
  final String callToAction;
}

class NextHourInsight {
  const NextHourInsight({
    required this.title,
    required this.detail,
    required this.departureAdvice,
    required this.tone,
    required this.maxPrecipitationMm,
    this.minutesUntilRain,
  });

  final String title;
  final String detail;
  final String departureAdvice;
  final AdviceTone tone;
  final double maxPrecipitationMm;
  final int? minutesUntilRain;
}

class DryWindowInsight {
  const DryWindowInsight({
    required this.headline,
    required this.isAvailable,
    required this.start,
    required this.end,
    required this.duration,
    required this.note,
    required this.confidenceLabel,
    required this.tone,
  });

  final String headline;
  final bool isAvailable;
  final DateTime? start;
  final DateTime? end;
  final Duration duration;
  final String note;
  final String confidenceLabel;
  final AdviceTone tone;
}

class CommuteLeg {
  const CommuteLeg({
    required this.id,
    required this.label,
    required this.start,
    required this.end,
    required this.tone,
    required this.detail,
    required this.summary,
    required this.score,
  });

  final String id;
  final String label;
  final DateTime start;
  final DateTime end;
  final AdviceTone tone;
  final String detail;
  final String summary;
  final int score;
}

class CommuteOverview {
  const CommuteOverview({
    required this.windows,
    required this.summary,
  });

  final List<CommuteLeg> windows;
  final String summary;
}

class WearTip {
  const WearTip({
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;
}

class ActivityRecommendation {
  const ActivityRecommendation({
    required this.name,
    required this.detail,
    required this.suitability,
    required this.icon,
  });

  final String name;
  final String detail;
  final ActivitySuitability suitability;
  final IconData icon;
}

class RiskNote {
  const RiskNote({
    required this.title,
    required this.detail,
    required this.level,
    required this.icon,
  });

  final String title;
  final String detail;
  final RiskLevel level;
  final IconData icon;
}

class WeatherGuidance {
  const WeatherGuidance({
    required this.headline,
    required this.nextHour,
    required this.dryWindow,
    required this.commute,
    required this.wearTips,
    required this.activities,
    required this.risks,
    required this.simpleSummary,
    required this.highlightHours,
  });

  final GuidanceHeadline headline;
  final NextHourInsight nextHour;
  final DryWindowInsight dryWindow;
  final CommuteOverview commute;
  final List<WearTip> wearTips;
  final List<ActivityRecommendation> activities;
  final List<RiskNote> risks;
  final String simpleSummary;
  final List<HourlyForecast> highlightHours;
}
