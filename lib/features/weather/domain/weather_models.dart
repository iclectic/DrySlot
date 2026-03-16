import 'package:flutter/material.dart';

enum AdviceTone { go, watch, wait }

enum ActivitySuitability { great, okay, poor }

enum RiskLevel { calm, headsUp, high }

enum AlertSource { forecast, official }

enum ExplanationMode { simple, detailed }

extension ExplanationModeX on ExplanationMode {
  String get label => switch (this) {
    ExplanationMode.simple => 'Simple',
    ExplanationMode.detailed => 'Detailed',
  };

  String get description => switch (this) {
    ExplanationMode.simple => 'Plain English with the main answer first.',
    ExplanationMode.detailed =>
      'Adds supporting metrics and fuller forecast context.',
  };
}

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
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
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
      id: 'morning-walk',
      label: 'My morning walk',
      startMinutes: 7 * 60,
      endMinutes: 7 * 60 + 45,
    ),
    SavedCommuteWindow(
      id: 'my-commute',
      label: 'My commute',
      startMinutes: 8 * 60,
      endMinutes: 8 * 60 + 45,
    ),
    SavedCommuteWindow(
      id: 'lunch-break',
      label: 'Lunch break outside',
      startMinutes: 12 * 60 + 15,
      endMinutes: 13 * 60,
    ),
    SavedCommuteWindow(
      id: 'school-pickup',
      label: 'School pickup',
      startMinutes: 15 * 60,
      endMinutes: 15 * 60 + 45,
    ),
    SavedCommuteWindow(
      id: 'gym-walk',
      label: 'Gym walk',
      startMinutes: 18 * 60,
      endMinutes: 18 * 60 + 45,
    ),
    SavedCommuteWindow(
      id: 'evening-jog',
      label: 'Evening jog',
      startMinutes: 17 * 60,
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

  Map<String, Object> toJson() {
    return <String, Object>{
      'time': time.toIso8601String(),
      'temperatureC': temperatureC,
      'apparentTemperatureC': apparentTemperatureC,
      'weatherCode': weatherCode,
      'isDay': isDay,
      'precipitationMm': precipitationMm,
      'rainMm': rainMm,
      'showersMm': showersMm,
      'cloudCover': cloudCover,
      'windSpeedKph': windSpeedKph,
      'windGustKph': windGustKph,
      'visibilityMeters': visibilityMeters,
    };
  }

  factory CurrentConditions.fromJson(Map<String, dynamic> json) {
    return CurrentConditions(
      time: _parseDateTime(json['time']),
      temperatureC: _asDouble(json['temperatureC']),
      apparentTemperatureC: _asDouble(json['apparentTemperatureC']),
      weatherCode: _asInt(json['weatherCode']),
      isDay: json['isDay'] as bool? ?? true,
      precipitationMm: _asDouble(json['precipitationMm']),
      rainMm: _asDouble(json['rainMm']),
      showersMm: _asDouble(json['showersMm']),
      cloudCover: _asInt(json['cloudCover']),
      windSpeedKph: _asDouble(json['windSpeedKph']),
      windGustKph: _asDouble(json['windGustKph']),
      visibilityMeters: _asDouble(json['visibilityMeters'], fallback: 10000),
    );
  }
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

  Map<String, Object> toJson() {
    return <String, Object>{
      'time': time.toIso8601String(),
      'precipitationMm': precipitationMm,
      'weatherCode': weatherCode,
      'windSpeedKph': windSpeedKph,
      'visibilityMeters': visibilityMeters,
      'isDay': isDay,
    };
  }

  factory MinuteForecast.fromJson(Map<String, dynamic> json) {
    return MinuteForecast(
      time: _parseDateTime(json['time']),
      precipitationMm: _asDouble(json['precipitationMm']),
      weatherCode: _asInt(json['weatherCode']),
      windSpeedKph: _asDouble(json['windSpeedKph']),
      visibilityMeters: _asDouble(json['visibilityMeters'], fallback: 10000),
      isDay: json['isDay'] as bool? ?? true,
    );
  }
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

  Map<String, Object> toJson() {
    return <String, Object>{
      'time': time.toIso8601String(),
      'temperatureC': temperatureC,
      'apparentTemperatureC': apparentTemperatureC,
      'precipitationProbability': precipitationProbability,
      'precipitationMm': precipitationMm,
      'weatherCode': weatherCode,
      'windSpeedKph': windSpeedKph,
      'windGustKph': windGustKph,
      'visibilityMeters': visibilityMeters,
      'cloudCover': cloudCover,
      'uvIndex': uvIndex,
      'isDay': isDay,
    };
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: _parseDateTime(json['time']),
      temperatureC: _asDouble(json['temperatureC']),
      apparentTemperatureC: _asDouble(json['apparentTemperatureC']),
      precipitationProbability: _asInt(json['precipitationProbability']),
      precipitationMm: _asDouble(json['precipitationMm']),
      weatherCode: _asInt(json['weatherCode']),
      windSpeedKph: _asDouble(json['windSpeedKph']),
      windGustKph: _asDouble(json['windGustKph']),
      visibilityMeters: _asDouble(json['visibilityMeters'], fallback: 10000),
      cloudCover: _asInt(json['cloudCover']),
      uvIndex: _asDouble(json['uvIndex']),
      isDay: json['isDay'] as bool? ?? true,
    );
  }
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

  Map<String, Object> toJson() {
    return <String, Object>{
      'date': date.toIso8601String(),
      'weatherCode': weatherCode,
      'maxTempC': maxTempC,
      'minTempC': minTempC,
      'precipitationMm': precipitationMm,
      'precipitationProbabilityMax': precipitationProbabilityMax,
      'maxWindKph': maxWindKph,
      'uvIndexMax': uvIndexMax,
      'sunrise': sunrise.toIso8601String(),
      'sunset': sunset.toIso8601String(),
    };
  }

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: _parseDateTime(json['date']),
      weatherCode: _asInt(json['weatherCode']),
      maxTempC: _asDouble(json['maxTempC']),
      minTempC: _asDouble(json['minTempC']),
      precipitationMm: _asDouble(json['precipitationMm']),
      precipitationProbabilityMax: _asInt(json['precipitationProbabilityMax']),
      maxWindKph: _asDouble(json['maxWindKph']),
      uvIndexMax: _asDouble(json['uvIndexMax']),
      sunrise: _parseDateTime(json['sunrise']),
      sunset: _parseDateTime(json['sunset']),
    );
  }
}

class WeatherReport {
  const WeatherReport({
    required this.location,
    required this.fetchedAt,
    required this.current,
    required this.minutely,
    required this.hourly,
    required this.today,
    required this.daily,
    required this.usingFallback,
    required this.sourceLabel,
    this.officialWarnings = const <OfficialWarning>[],
    this.sourceNote,
  });

  final WeatherLocation location;
  final DateTime fetchedAt;
  final CurrentConditions current;
  final List<MinuteForecast> minutely;
  final List<HourlyForecast> hourly;
  final DailyForecast today;
  final List<DailyForecast> daily;
  final bool usingFallback;
  final String sourceLabel;
  final List<OfficialWarning> officialWarnings;
  final String? sourceNote;

  WeatherReport copyWith({
    WeatherLocation? location,
    DateTime? fetchedAt,
    CurrentConditions? current,
    List<MinuteForecast>? minutely,
    List<HourlyForecast>? hourly,
    DailyForecast? today,
    List<DailyForecast>? daily,
    bool? usingFallback,
    String? sourceLabel,
    List<OfficialWarning>? officialWarnings,
    String? sourceNote,
  }) {
    return WeatherReport(
      location: location ?? this.location,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      current: current ?? this.current,
      minutely: minutely ?? this.minutely,
      hourly: hourly ?? this.hourly,
      today: today ?? this.today,
      daily: daily ?? this.daily,
      usingFallback: usingFallback ?? this.usingFallback,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      officialWarnings: officialWarnings ?? this.officialWarnings,
      sourceNote: sourceNote ?? this.sourceNote,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'location': location.toJson(),
      'fetchedAt': fetchedAt.toIso8601String(),
      'current': current.toJson(),
      'minutely': minutely.map((slot) => slot.toJson()).toList(growable: false),
      'hourly': hourly.map((slot) => slot.toJson()).toList(growable: false),
      'today': today.toJson(),
      'daily': daily.map((day) => day.toJson()).toList(growable: false),
      'usingFallback': usingFallback,
      'sourceLabel': sourceLabel,
      'officialWarnings': officialWarnings
          .map((warning) => warning.toJson())
          .toList(growable: false),
      'sourceNote': sourceNote,
    };
  }

  factory WeatherReport.fromJson(Map<String, dynamic> json) {
    return WeatherReport(
      location: WeatherLocation.fromJson(
        (json['location'] as Map<Object?, Object?>?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      fetchedAt: _parseDateTime(json['fetchedAt']),
      current: CurrentConditions.fromJson(
        (json['current'] as Map<Object?, Object?>?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      minutely: _mapList(json['minutely'], MinuteForecast.fromJson),
      hourly: _mapList(json['hourly'], HourlyForecast.fromJson),
      today: DailyForecast.fromJson(
        (json['today'] as Map<Object?, Object?>?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      daily: _mapList(json['daily'], DailyForecast.fromJson),
      usingFallback: json['usingFallback'] as bool? ?? false,
      sourceLabel: json['sourceLabel'] as String? ?? 'Saved forecast',
      officialWarnings: _mapList(
        json['officialWarnings'],
        OfficialWarning.fromJson,
      ),
      sourceNote: json['sourceNote'] as String?,
    );
  }
}

class OfficialWarning {
  const OfficialWarning({
    required this.title,
    required this.summary,
    required this.severityLabel,
    required this.sourceLabel,
    this.link,
  });

  final String title;
  final String summary;
  final String severityLabel;
  final String sourceLabel;
  final String? link;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title,
      'summary': summary,
      'severityLabel': severityLabel,
      'sourceLabel': sourceLabel,
      'link': link,
    };
  }

  factory OfficialWarning.fromJson(Map<String, dynamic> json) {
    return OfficialWarning(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      severityLabel: json['severityLabel'] as String? ?? 'Official warning',
      sourceLabel:
          json['sourceLabel'] as String? ?? 'Met Office official warning',
      link: json['link'] as String?,
    );
  }
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
  const CommuteOverview({required this.windows, required this.summary});

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
    required this.score,
    required this.detail,
    required this.suitability,
    required this.icon,
  });

  final String name;
  final int score;
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
    this.source = AlertSource.forecast,
    this.sourceLabel = 'Forecast signal',
    this.link,
  });

  final String title;
  final String detail;
  final RiskLevel level;
  final IconData icon;
  final AlertSource source;
  final String sourceLabel;
  final String? link;
}

class HomeSummaryCard {
  const HomeSummaryCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final AdviceTone tone;
}

class WeekendDayPlan {
  const WeekendDayPlan({
    required this.label,
    required this.date,
    required this.summary,
    required this.headline,
    required this.maxTempC,
    required this.minTempC,
    required this.precipitationMm,
    required this.precipitationProbabilityMax,
    required this.maxWindKph,
    required this.icon,
    required this.tone,
  });

  final String label;
  final DateTime date;
  final String summary;
  final String headline;
  final double maxTempC;
  final double minTempC;
  final double precipitationMm;
  final int precipitationProbabilityMax;
  final double maxWindKph;
  final IconData icon;
  final AdviceTone tone;
}

class WeekendPlanner {
  const WeekendPlanner({
    required this.title,
    required this.summary,
    required this.days,
    required this.tone,
  });

  final String title;
  final String summary;
  final List<WeekendDayPlan> days;
  final AdviceTone tone;
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
    required this.homeCards,
    required this.weekendPlanner,
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
  final List<HomeSummaryCard> homeCards;
  final WeekendPlanner? weekendPlanner;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  return (value as num?)?.toDouble() ?? fallback;
}

int _asInt(dynamic value) {
  return (value as num?)?.toInt() ?? 0;
}

DateTime _parseDateTime(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}

List<T> _mapList<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) builder,
) {
  return (value as List<dynamic>? ?? const <dynamic>[])
      .whereType<Map>()
      .map((entry) => builder(entry.cast<String, dynamic>()))
      .toList(growable: false);
}
