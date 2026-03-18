import 'dart:math';

import '../domain/weather_models.dart';
import 'weather_provider_config.dart';
import 'weather_repository_support.dart';

class OpenMeteoWeatherRepository extends BaseNetworkWeatherRepository {
  OpenMeteoWeatherRepository({
    required super.dio,
    required super.localStore,
    super.fallback,
  }) : super(provider: WeatherDataProvider.openMeteo);

  @override
  Future<WeatherReport> fetchLiveWeather(
    WeatherLocation location,
    List<OfficialWarning> officialWarnings,
  ) async {
    final response = await dio.get<Object?>(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: <String, String>{
        'latitude': location.latitude.toStringAsFixed(4),
        'longitude': location.longitude.toStringAsFixed(4),
        'timezone': location.timezone,
        'forecast_days': '7',
        'forecast_minutely_15': '8',
        'current':
            'temperature_2m,apparent_temperature,is_day,precipitation,rain,showers,weather_code,cloud_cover,wind_speed_10m,wind_gusts_10m,visibility',
        'minutely_15': 'precipitation,weather_code,wind_speed_10m,visibility',
        'hourly':
            'temperature_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,wind_speed_10m,wind_gusts_10m,visibility,cloud_cover,uv_index,is_day',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,uv_index_max,sunrise,sunset',
      },
    );

    final json = jsonMap(response.data);
    return _parseReport(location, json, officialWarnings);
  }

  @override
  Future<List<WeatherLocation>> searchRemoteLocations(String cleanQuery) async {
    final response = await dio.get<Object?>(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: <String, String>{
        'name': cleanQuery,
        'count': '8',
        'language': 'en',
        'countryCode': 'GB',
        'format': 'json',
      },
    );
    final json = jsonMap(response.data);
    return asMapList(json['results']).map(_mapLocation).toList(growable: false);
  }

  WeatherReport _parseReport(
    WeatherLocation location,
    Map<String, dynamic> json,
    List<OfficialWarning> officialWarnings,
  ) {
    final currentJson =
        json['current'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final hourlyJson =
        json['hourly'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final dailyJson =
        json['daily'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final hourly = _parseHourly(hourlyJson);
    final current = CurrentConditions(
      time: parseDateTime(currentJson['time'] as String?),
      temperatureC: asDouble(currentJson['temperature_2m']),
      apparentTemperatureC: asDouble(currentJson['apparent_temperature']),
      weatherCode: asInt(currentJson['weather_code']),
      isDay: asInt(currentJson['is_day']) == 1,
      precipitationMm: asDouble(currentJson['precipitation']),
      rainMm: asDouble(currentJson['rain']),
      showersMm: asDouble(currentJson['showers']),
      cloudCover: asInt(currentJson['cloud_cover']),
      windSpeedKph: asDouble(currentJson['wind_speed_10m']),
      windGustKph: asDouble(currentJson['wind_gusts_10m']),
      visibilityMeters: asDouble(currentJson['visibility'], fallback: 10000),
    );
    final minutely = _parseMinutely(
      json['minutely_15'] as Map<String, dynamic>?,
      hourly,
      current,
    );
    final daily = _parseDaily(dailyJson);

    return WeatherReport(
      location: location,
      fetchedAt: DateTime.now(),
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: daily.first,
      daily: daily,
      usingFallback: false,
      sourceLabel: 'Live weather by Open-Meteo',
      officialWarnings: officialWarnings,
      sourceNote: 'Live forecast with UK-focused guidance.',
    );
  }

  List<MinuteForecast> _parseMinutely(
    Map<String, dynamic>? json,
    List<HourlyForecast> hourly,
    CurrentConditions current,
  ) {
    if (json == null) {
      return minutelyFromHourly(hourly, current);
    }

    final times = asStringList(json['time']);
    final precipitation = asNumList(json['precipitation']);
    final weatherCode = asNumList(json['weather_code']);
    final wind = asNumList(json['wind_speed_10m']);
    final visibility = asNumList(json['visibility']);
    final length = [
      times.length,
      precipitation.length,
      weatherCode.length,
      wind.length,
      visibility.length,
    ].reduce(min);

    if (length == 0) {
      return minutelyFromHourly(hourly, current);
    }

    return List<MinuteForecast>.generate(length, (index) {
      final time = parseDateTime(times[index]);
      return MinuteForecast(
        time: time,
        precipitationMm: precipitation[index],
        weatherCode: weatherCode[index].round(),
        windSpeedKph: wind[index],
        visibilityMeters: visibility[index],
        isDay: time.hour >= 7 && time.hour < 19,
      );
    }, growable: false);
  }

  List<HourlyForecast> _parseHourly(Map<String, dynamic> json) {
    final times = asStringList(json['time']);
    final temperature = asNumList(json['temperature_2m']);
    final apparent = asNumList(json['apparent_temperature']);
    final rainChance = asNumList(json['precipitation_probability']);
    final rain = asNumList(json['precipitation']);
    final weatherCode = asNumList(json['weather_code']);
    final wind = asNumList(json['wind_speed_10m']);
    final gust = asNumList(json['wind_gusts_10m']);
    final visibility = asNumList(json['visibility']);
    final cloudCover = asNumList(json['cloud_cover']);
    final uv = asNumList(json['uv_index']);
    final isDay = asNumList(json['is_day']);

    final length = [
      times.length,
      temperature.length,
      apparent.length,
      rainChance.length,
      rain.length,
      weatherCode.length,
      wind.length,
      gust.length,
      visibility.length,
      cloudCover.length,
      uv.length,
      isDay.length,
    ].reduce(min);

    return List<HourlyForecast>.generate(length, (index) {
      return HourlyForecast(
        time: parseDateTime(times[index]),
        temperatureC: temperature[index],
        apparentTemperatureC: apparent[index],
        precipitationProbability: rainChance[index].round(),
        precipitationMm: rain[index],
        weatherCode: weatherCode[index].round(),
        windSpeedKph: wind[index],
        windGustKph: gust[index],
        visibilityMeters: visibility[index],
        cloudCover: cloudCover[index].round(),
        uvIndex: uv[index],
        isDay: isDay[index].round() == 1,
      );
    }, growable: false);
  }

  List<DailyForecast> _parseDaily(Map<String, dynamic> json) {
    final times = asStringList(json['time']);
    final weatherCode = asNumList(json['weather_code']);
    final maxTemp = asNumList(json['temperature_2m_max']);
    final minTemp = asNumList(json['temperature_2m_min']);
    final rain = asNumList(json['precipitation_sum']);
    final rainChance = asNumList(json['precipitation_probability_max']);
    final wind = asNumList(json['wind_speed_10m_max']);
    final uv = asNumList(json['uv_index_max']);
    final sunrise = asStringList(json['sunrise']);
    final sunset = asStringList(json['sunset']);

    final length = [
      times.length,
      weatherCode.length,
      maxTemp.length,
      minTemp.length,
      rain.length,
      rainChance.length,
      wind.length,
      uv.length,
      sunrise.length,
      sunset.length,
    ].reduce(min);

    if (length == 0) {
      final now = DateTime.now();
      return <DailyForecast>[
        DailyForecast(
          date: now,
          weatherCode: 3,
          maxTempC: 12,
          minTempC: 6,
          precipitationMm: 0,
          precipitationProbabilityMax: 0,
          maxWindKph: 12,
          uvIndexMax: 2,
          sunrise: DateTime(now.year, now.month, now.day, 7),
          sunset: DateTime(now.year, now.month, now.day, 18),
        ),
      ];
    }

    return List<DailyForecast>.generate(length, (index) {
      return DailyForecast(
        date: parseDateTime(times[index]),
        weatherCode: weatherCode[index].round(),
        maxTempC: maxTemp[index],
        minTempC: minTemp[index],
        precipitationMm: rain[index],
        precipitationProbabilityMax: rainChance[index].round(),
        maxWindKph: wind[index],
        uvIndexMax: uv[index],
        sunrise: parseDateTime(sunrise[index]),
        sunset: parseDateTime(sunset[index]),
      );
    }, growable: false);
  }

  WeatherLocation _mapLocation(Map<String, dynamic> json) {
    return WeatherLocation(
      name: json['name'] as String? ?? 'Unknown',
      region: json['admin1'] as String? ?? '',
      country: json['country'] as String? ?? 'United Kingdom',
      latitude: asDouble(json['latitude']),
      longitude: asDouble(json['longitude']),
      timezone: json['timezone'] as String? ?? 'Europe/London',
    );
  }
}
