import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_models.freezed.dart';
part 'weather_models.g.dart';

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

@freezed
abstract class WeatherLocation with _$WeatherLocation {
  const WeatherLocation._();

  const factory WeatherLocation({
    required String name,
    required String region,
    required String country,
    required double latitude,
    required double longitude,
    required String timezone,
  }) = _WeatherLocation;

  factory WeatherLocation.fromJson(Map<String, dynamic> json) =>
      _$WeatherLocationFromJson(json);

  String get subtitle {
    if (region.isEmpty || region == name) {
      return country;
    }
    return '$region, $country';
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

@freezed
abstract class SavedCommuteWindow with _$SavedCommuteWindow {
  const SavedCommuteWindow._();

  const factory SavedCommuteWindow({
    @Default('') String id,
    @Default('Saved window') String label,
    @Default(480) int startMinutes,
    @Default(540) int endMinutes,
  }) = _SavedCommuteWindow;

  factory SavedCommuteWindow.fromJson(Map<String, dynamic> json) =>
      _$SavedCommuteWindowFromJson(json);

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

@freezed
abstract class CurrentConditions with _$CurrentConditions {
  const factory CurrentConditions({
    required DateTime time,
    required double temperatureC,
    required double apparentTemperatureC,
    required int weatherCode,
    required bool isDay,
    required double precipitationMm,
    required double rainMm,
    required double showersMm,
    required int cloudCover,
    required double windSpeedKph,
    required double windGustKph,
    required double visibilityMeters,
  }) = _CurrentConditions;

  factory CurrentConditions.fromJson(Map<String, dynamic> json) =>
      _$CurrentConditionsFromJson(json);
}

@freezed
abstract class MinuteForecast with _$MinuteForecast {
  const factory MinuteForecast({
    required DateTime time,
    required double precipitationMm,
    required int weatherCode,
    required double windSpeedKph,
    required double visibilityMeters,
    required bool isDay,
  }) = _MinuteForecast;

  factory MinuteForecast.fromJson(Map<String, dynamic> json) =>
      _$MinuteForecastFromJson(json);
}

@freezed
abstract class HourlyForecast with _$HourlyForecast {
  const factory HourlyForecast({
    required DateTime time,
    required double temperatureC,
    required double apparentTemperatureC,
    required int precipitationProbability,
    required double precipitationMm,
    required int weatherCode,
    required double windSpeedKph,
    required double windGustKph,
    required double visibilityMeters,
    required int cloudCover,
    required double uvIndex,
    required bool isDay,
  }) = _HourlyForecast;

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);
}

@freezed
abstract class DailyForecast with _$DailyForecast {
  const factory DailyForecast({
    required DateTime date,
    required int weatherCode,
    required double maxTempC,
    required double minTempC,
    required double precipitationMm,
    required int precipitationProbabilityMax,
    required double maxWindKph,
    required double uvIndexMax,
    required DateTime sunrise,
    required DateTime sunset,
  }) = _DailyForecast;

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);
}

@freezed
abstract class OfficialWarning with _$OfficialWarning {
  const factory OfficialWarning({
    required String title,
    required String summary,
    required String severityLabel,
    required String sourceLabel,
    String? link,
  }) = _OfficialWarning;

  factory OfficialWarning.fromJson(Map<String, dynamic> json) =>
      _$OfficialWarningFromJson(json);
}

@freezed
abstract class WeatherReport with _$WeatherReport {
  const factory WeatherReport({
    required WeatherLocation location,
    required DateTime fetchedAt,
    required CurrentConditions current,
    required List<MinuteForecast> minutely,
    required List<HourlyForecast> hourly,
    required DailyForecast today,
    required List<DailyForecast> daily,
    required bool usingFallback,
    required String sourceLabel,
    @Default(<OfficialWarning>[]) List<OfficialWarning> officialWarnings,
    String? sourceNote,
  }) = _WeatherReport;

  factory WeatherReport.fromJson(Map<String, dynamic> json) =>
      _$WeatherReportFromJson(json);
}

@freezed
abstract class GuidanceHeadline with _$GuidanceHeadline {
  const factory GuidanceHeadline({
    required String title,
    required String detail,
    required AdviceTone tone,
    required String callToAction,
  }) = _GuidanceHeadline;
}

@freezed
abstract class NextHourInsight with _$NextHourInsight {
  const factory NextHourInsight({
    required String title,
    required String detail,
    required String departureAdvice,
    required AdviceTone tone,
    required double maxPrecipitationMm,
    int? minutesUntilRain,
  }) = _NextHourInsight;
}

@freezed
abstract class DryWindowInsight with _$DryWindowInsight {
  const factory DryWindowInsight({
    required String headline,
    required bool isAvailable,
    required DateTime? start,
    required DateTime? end,
    required Duration duration,
    required String note,
    required String confidenceLabel,
    required AdviceTone tone,
  }) = _DryWindowInsight;
}

@freezed
abstract class CommuteLeg with _$CommuteLeg {
  const factory CommuteLeg({
    required String id,
    required String label,
    required DateTime start,
    required DateTime end,
    required AdviceTone tone,
    required String detail,
    required String summary,
    required int score,
  }) = _CommuteLeg;
}

@freezed
abstract class CommuteOverview with _$CommuteOverview {
  const factory CommuteOverview({
    required List<CommuteLeg> windows,
    required String summary,
  }) = _CommuteOverview;
}

@freezed
abstract class WearTip with _$WearTip {
  const factory WearTip({
    required String title,
    required String detail,
    required IconData icon,
  }) = _WearTip;
}

@freezed
abstract class ActivityRecommendation with _$ActivityRecommendation {
  const factory ActivityRecommendation({
    required String name,
    required int score,
    required String detail,
    required ActivitySuitability suitability,
    required IconData icon,
  }) = _ActivityRecommendation;
}

@freezed
abstract class RiskNote with _$RiskNote {
  const factory RiskNote({
    required String title,
    required String detail,
    required RiskLevel level,
    required IconData icon,
    @Default(AlertSource.forecast) AlertSource source,
    @Default('Forecast signal') String sourceLabel,
    String? link,
  }) = _RiskNote;
}

@freezed
abstract class HomeSummaryCard with _$HomeSummaryCard {
  const factory HomeSummaryCard({
    required String title,
    required String value,
    required String detail,
    required IconData icon,
    required AdviceTone tone,
  }) = _HomeSummaryCard;
}

@freezed
abstract class WeekendDayPlan with _$WeekendDayPlan {
  const factory WeekendDayPlan({
    required String label,
    required DateTime date,
    required String summary,
    required String headline,
    required double maxTempC,
    required double minTempC,
    required double precipitationMm,
    required int precipitationProbabilityMax,
    required double maxWindKph,
    required IconData icon,
    required AdviceTone tone,
  }) = _WeekendDayPlan;
}

@freezed
abstract class WeekendPlanner with _$WeekendPlanner {
  const factory WeekendPlanner({
    required String title,
    required String summary,
    required List<WeekendDayPlan> days,
    required AdviceTone tone,
  }) = _WeekendPlanner;
}

@freezed
abstract class WeatherGuidance with _$WeatherGuidance {
  const factory WeatherGuidance({
    required GuidanceHeadline headline,
    required NextHourInsight nextHour,
    required DryWindowInsight dryWindow,
    required CommuteOverview commute,
    required List<WearTip> wearTips,
    required List<ActivityRecommendation> activities,
    required List<RiskNote> risks,
    required String simpleSummary,
    required List<HourlyForecast> highlightHours,
    required List<HomeSummaryCard> homeCards,
    required WeekendPlanner? weekendPlanner,
  }) = _WeatherGuidance;
}
