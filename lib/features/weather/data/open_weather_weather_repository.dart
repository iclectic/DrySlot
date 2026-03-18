import 'dart:math';

import '../domain/weather_models.dart';
import 'weather_provider_config.dart';
import 'weather_repository_support.dart';

class OpenWeatherWeatherRepository extends BaseNetworkWeatherRepository {
  OpenWeatherWeatherRepository({
    required String apiKey,
    required super.dio,
    required super.localStore,
    super.fallback,
  }) : _apiKey = apiKey,
       super(provider: WeatherDataProvider.openWeather);

  final String _apiKey;

  @override
  Future<WeatherReport> fetchLiveWeather(
    WeatherLocation location,
    List<OfficialWarning> officialWarnings,
  ) async {
    final response = await dio.get<Object?>(
      'https://api.openweathermap.org/data/3.0/onecall',
      queryParameters: <String, String>{
        'lat': location.latitude.toStringAsFixed(4),
        'lon': location.longitude.toStringAsFixed(4),
        'units': 'metric',
        'appid': _apiKey,
      },
    );

    final json = jsonMap(response.data);
    return _parseReport(location, json, officialWarnings);
  }

  @override
  Future<List<WeatherLocation>> searchRemoteLocations(String cleanQuery) async {
    final response = await dio.get<Object?>(
      'https://api.openweathermap.org/geo/1.0/direct',
      queryParameters: <String, String>{
        'q': '$cleanQuery,GB',
        'limit': '8',
        'appid': _apiKey,
      },
    );

    return asMapList(response.data)
        .map((entry) {
          return WeatherLocation(
            name: entry['name'] as String? ?? 'Unknown',
            region: entry['state'] as String? ?? '',
            country: entry['country'] as String? ?? 'United Kingdom',
            latitude: asDouble(entry['lat']),
            longitude: asDouble(entry['lon']),
            timezone: 'Europe/London',
          );
        })
        .toList(growable: false);
  }

  WeatherReport _parseReport(
    WeatherLocation location,
    Map<String, dynamic> json,
    List<OfficialWarning> officialWarnings,
  ) {
    final currentJson =
        json['current'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final hourlyJson = asMapList(json['hourly']);
    final dailyJson = asMapList(json['daily']);
    final hourly = _parseHourly(hourlyJson);
    final current = CurrentConditions(
      time: unixToLocalDateTime(currentJson['dt']),
      temperatureC: asDouble(currentJson['temp']),
      apparentTemperatureC: asDouble(currentJson['feels_like']),
      weatherCode: _mapWeatherCode(_weatherId(currentJson['weather'])),
      isDay: _isDay(currentJson['sunrise'], currentJson['sunset']),
      precipitationMm:
          _precipitationFromWeatherMap(currentJson['rain']) +
          _precipitationFromWeatherMap(currentJson['snow']),
      rainMm: _precipitationFromWeatherMap(currentJson['rain']),
      showersMm: _precipitationFromWeatherMap(currentJson['rain']),
      cloudCover: asInt(currentJson['clouds']),
      windSpeedKph: _metersPerSecondToKph(currentJson['wind_speed']),
      windGustKph: _metersPerSecondToKph(currentJson['wind_gust']),
      visibilityMeters: asDouble(currentJson['visibility'], fallback: 10000),
    );
    final minutely = _parseMinutely(
      asMapList(json['minutely']),
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
      sourceLabel: 'Live weather by OpenWeather',
      officialWarnings: officialWarnings,
      sourceNote:
          'Live forecast via OpenWeather with Met Office warnings when available.',
    );
  }

  List<MinuteForecast> _parseMinutely(
    List<Map<String, dynamic>> minutelyJson,
    List<HourlyForecast> hourly,
    CurrentConditions current,
  ) {
    if (minutelyJson.isEmpty) {
      return minutelyFromHourly(hourly, current, slotCount: 4);
    }

    final quarterSlots = <MinuteForecast>[];
    for (var bucketIndex = 0; bucketIndex < 4; bucketIndex += 1) {
      final start = bucketIndex * 15;
      final end = min(minutelyJson.length, start + 15);
      if (start >= end) {
        break;
      }

      final bucket = minutelyJson.sublist(start, end);
      final reference = bucketIndex < hourly.length
          ? hourly[bucketIndex]
          : null;
      final averageRate =
          bucket.fold<double>(
            0,
            (sum, entry) => sum + asDouble(entry['precipitation']),
          ) /
          bucket.length;

      quarterSlots.add(
        MinuteForecast(
          time: unixToLocalDateTime(bucket.first['dt']),
          precipitationMm: averageRate * 0.25,
          weatherCode: reference?.weatherCode ?? current.weatherCode,
          windSpeedKph: reference?.windSpeedKph ?? current.windSpeedKph,
          visibilityMeters:
              reference?.visibilityMeters ?? current.visibilityMeters,
          isDay: reference?.isDay ?? current.isDay,
        ),
      );
    }

    return quarterSlots.isEmpty
        ? minutelyFromHourly(hourly, current, slotCount: 4)
        : quarterSlots;
  }

  List<HourlyForecast> _parseHourly(List<Map<String, dynamic>> hours) {
    return hours
        .map((entry) {
          return HourlyForecast(
            time: unixToLocalDateTime(entry['dt']),
            temperatureC: asDouble(entry['temp']),
            apparentTemperatureC: asDouble(entry['feels_like']),
            precipitationProbability: (asDouble(entry['pop']) * 100).round(),
            precipitationMm:
                _precipitationFromWeatherMap(entry['rain']) +
                _precipitationFromWeatherMap(entry['snow']),
            weatherCode: _mapWeatherCode(_weatherId(entry['weather'])),
            windSpeedKph: _metersPerSecondToKph(entry['wind_speed']),
            windGustKph: _metersPerSecondToKph(entry['wind_gust']),
            visibilityMeters: asDouble(entry['visibility'], fallback: 10000),
            cloudCover: asInt(entry['clouds']),
            uvIndex: asDouble(entry['uvi']),
            isDay: _isHourDay(entry['dt'], entry['sunrise'], entry['sunset']),
          );
        })
        .toList(growable: false);
  }

  List<DailyForecast> _parseDaily(List<Map<String, dynamic>> days) {
    if (days.isEmpty) {
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

    return days
        .map((entry) {
          final temp =
              entry['temp'] as Map<String, dynamic>? ?? <String, dynamic>{};
          return DailyForecast(
            date: unixToLocalDateTime(entry['dt']),
            weatherCode: _mapWeatherCode(_weatherId(entry['weather'])),
            maxTempC: asDouble(temp['max']),
            minTempC: asDouble(temp['min']),
            precipitationMm: asDouble(entry['rain']) + asDouble(entry['snow']),
            precipitationProbabilityMax: (asDouble(entry['pop']) * 100).round(),
            maxWindKph: _metersPerSecondToKph(entry['wind_speed']),
            uvIndexMax: asDouble(entry['uvi']),
            sunrise: unixToLocalDateTime(entry['sunrise']),
            sunset: unixToLocalDateTime(entry['sunset']),
          );
        })
        .toList(growable: false);
  }

  double _precipitationFromWeatherMap(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is Map) {
      final map = value.cast<Object?, Object?>();
      final oneHour = map['1h'] ?? map['3h'];
      return (oneHour as num?)?.toDouble() ?? 0;
    }
    return 0;
  }

  int _weatherId(dynamic weather) {
    final items = weather as List<dynamic>? ?? const <dynamic>[];
    if (items.isEmpty) {
      return 803;
    }
    final first = items.first;
    if (first is Map) {
      return asInt(first['id']);
    }
    return 803;
  }

  bool _isDay(dynamic sunrise, dynamic sunset) {
    final now = DateTime.now();
    final sunriseTime = unixToLocalDateTime(sunrise);
    final sunsetTime = unixToLocalDateTime(sunset);
    return now.isAfter(sunriseTime) && now.isBefore(sunsetTime);
  }

  bool _isHourDay(dynamic dt, dynamic sunrise, dynamic sunset) {
    final time = unixToLocalDateTime(dt);
    final sunriseTime = sunrise == null
        ? DateTime(time.year, time.month, time.day, 7)
        : unixToLocalDateTime(sunrise);
    final sunsetTime = sunset == null
        ? DateTime(time.year, time.month, time.day, 18)
        : unixToLocalDateTime(sunset);
    return time.isAfter(sunriseTime) && time.isBefore(sunsetTime);
  }

  double _metersPerSecondToKph(dynamic value) {
    return asDouble(value) * 3.6;
  }

  int _mapWeatherCode(int code) {
    return switch (code) {
      >= 200 && < 300 => 95,
      >= 300 && < 311 => 51,
      >= 311 && < 400 => 53,
      500 => 61,
      501 => 63,
      >= 502 && <= 504 => 65,
      511 => 66,
      520 => 80,
      521 => 81,
      >= 522 && <= 531 => 82,
      600 => 71,
      601 => 73,
      >= 602 && <= 622 => 75,
      >= 701 && <= 741 => 45,
      >= 751 && <= 771 => 45,
      781 => 99,
      800 => 0,
      801 => 1,
      802 => 2,
      >= 803 && <= 804 => 3,
      _ => 3,
    };
  }
}
