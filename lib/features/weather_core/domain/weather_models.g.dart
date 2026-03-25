// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherLocation _$WeatherLocationFromJson(Map<String, dynamic> json) =>
    _WeatherLocation(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$WeatherLocationToJson(_WeatherLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
    };

_SavedCommuteWindow _$SavedCommuteWindowFromJson(Map<String, dynamic> json) =>
    _SavedCommuteWindow(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? 'Saved window',
      startMinutes: (json['startMinutes'] as num?)?.toInt() ?? 480,
      endMinutes: (json['endMinutes'] as num?)?.toInt() ?? 540,
    );

Map<String, dynamic> _$SavedCommuteWindowToJson(_SavedCommuteWindow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'startMinutes': instance.startMinutes,
      'endMinutes': instance.endMinutes,
    };

_CurrentConditions _$CurrentConditionsFromJson(Map<String, dynamic> json) =>
    _CurrentConditions(
      time: DateTime.parse(json['time'] as String),
      temperatureC: (json['temperatureC'] as num).toDouble(),
      apparentTemperatureC: (json['apparentTemperatureC'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      isDay: json['isDay'] as bool,
      precipitationMm: (json['precipitationMm'] as num).toDouble(),
      rainMm: (json['rainMm'] as num).toDouble(),
      showersMm: (json['showersMm'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toInt(),
      windSpeedKph: (json['windSpeedKph'] as num).toDouble(),
      windGustKph: (json['windGustKph'] as num).toDouble(),
      visibilityMeters: (json['visibilityMeters'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentConditionsToJson(_CurrentConditions instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperatureC': instance.temperatureC,
      'apparentTemperatureC': instance.apparentTemperatureC,
      'weatherCode': instance.weatherCode,
      'isDay': instance.isDay,
      'precipitationMm': instance.precipitationMm,
      'rainMm': instance.rainMm,
      'showersMm': instance.showersMm,
      'cloudCover': instance.cloudCover,
      'windSpeedKph': instance.windSpeedKph,
      'windGustKph': instance.windGustKph,
      'visibilityMeters': instance.visibilityMeters,
    };

_MinuteForecast _$MinuteForecastFromJson(Map<String, dynamic> json) =>
    _MinuteForecast(
      time: DateTime.parse(json['time'] as String),
      precipitationMm: (json['precipitationMm'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      windSpeedKph: (json['windSpeedKph'] as num).toDouble(),
      visibilityMeters: (json['visibilityMeters'] as num).toDouble(),
      isDay: json['isDay'] as bool,
    );

Map<String, dynamic> _$MinuteForecastToJson(_MinuteForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'precipitationMm': instance.precipitationMm,
      'weatherCode': instance.weatherCode,
      'windSpeedKph': instance.windSpeedKph,
      'visibilityMeters': instance.visibilityMeters,
      'isDay': instance.isDay,
    };

_HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    _HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperatureC: (json['temperatureC'] as num).toDouble(),
      apparentTemperatureC: (json['apparentTemperatureC'] as num).toDouble(),
      precipitationProbability: (json['precipitationProbability'] as num)
          .toInt(),
      precipitationMm: (json['precipitationMm'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      windSpeedKph: (json['windSpeedKph'] as num).toDouble(),
      windGustKph: (json['windGustKph'] as num).toDouble(),
      visibilityMeters: (json['visibilityMeters'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toInt(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      isDay: json['isDay'] as bool,
    );

Map<String, dynamic> _$HourlyForecastToJson(_HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperatureC': instance.temperatureC,
      'apparentTemperatureC': instance.apparentTemperatureC,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationMm': instance.precipitationMm,
      'weatherCode': instance.weatherCode,
      'windSpeedKph': instance.windSpeedKph,
      'windGustKph': instance.windGustKph,
      'visibilityMeters': instance.visibilityMeters,
      'cloudCover': instance.cloudCover,
      'uvIndex': instance.uvIndex,
      'isDay': instance.isDay,
    };

_DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    _DailyForecast(
      date: DateTime.parse(json['date'] as String),
      weatherCode: (json['weatherCode'] as num).toInt(),
      maxTempC: (json['maxTempC'] as num).toDouble(),
      minTempC: (json['minTempC'] as num).toDouble(),
      precipitationMm: (json['precipitationMm'] as num).toDouble(),
      precipitationProbabilityMax: (json['precipitationProbabilityMax'] as num)
          .toInt(),
      maxWindKph: (json['maxWindKph'] as num).toDouble(),
      uvIndexMax: (json['uvIndexMax'] as num).toDouble(),
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
    );

Map<String, dynamic> _$DailyForecastToJson(_DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'weatherCode': instance.weatherCode,
      'maxTempC': instance.maxTempC,
      'minTempC': instance.minTempC,
      'precipitationMm': instance.precipitationMm,
      'precipitationProbabilityMax': instance.precipitationProbabilityMax,
      'maxWindKph': instance.maxWindKph,
      'uvIndexMax': instance.uvIndexMax,
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
    };

_OfficialWarning _$OfficialWarningFromJson(Map<String, dynamic> json) =>
    _OfficialWarning(
      title: json['title'] as String,
      summary: json['summary'] as String,
      severityLabel: json['severityLabel'] as String,
      sourceLabel: json['sourceLabel'] as String,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$OfficialWarningToJson(_OfficialWarning instance) =>
    <String, dynamic>{
      'title': instance.title,
      'summary': instance.summary,
      'severityLabel': instance.severityLabel,
      'sourceLabel': instance.sourceLabel,
      'link': instance.link,
    };

_WeatherReport _$WeatherReportFromJson(
  Map<String, dynamic> json,
) => _WeatherReport(
  location: WeatherLocation.fromJson(json['location'] as Map<String, dynamic>),
  fetchedAt: DateTime.parse(json['fetchedAt'] as String),
  current: CurrentConditions.fromJson(json['current'] as Map<String, dynamic>),
  minutely: (json['minutely'] as List<dynamic>)
      .map((e) => MinuteForecast.fromJson(e as Map<String, dynamic>))
      .toList(),
  hourly: (json['hourly'] as List<dynamic>)
      .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
      .toList(),
  today: DailyForecast.fromJson(json['today'] as Map<String, dynamic>),
  daily: (json['daily'] as List<dynamic>)
      .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
      .toList(),
  usingFallback: json['usingFallback'] as bool,
  sourceLabel: json['sourceLabel'] as String,
  officialWarnings:
      (json['officialWarnings'] as List<dynamic>?)
          ?.map((e) => OfficialWarning.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OfficialWarning>[],
  sourceNote: json['sourceNote'] as String?,
);

Map<String, dynamic> _$WeatherReportToJson(
  _WeatherReport instance,
) => <String, dynamic>{
  'location': instance.location.toJson(),
  'fetchedAt': instance.fetchedAt.toIso8601String(),
  'current': instance.current.toJson(),
  'minutely': instance.minutely.map((e) => e.toJson()).toList(),
  'hourly': instance.hourly.map((e) => e.toJson()).toList(),
  'today': instance.today.toJson(),
  'daily': instance.daily.map((e) => e.toJson()).toList(),
  'usingFallback': instance.usingFallback,
  'sourceLabel': instance.sourceLabel,
  'officialWarnings': instance.officialWarnings.map((e) => e.toJson()).toList(),
  'sourceNote': instance.sourceNote,
};
