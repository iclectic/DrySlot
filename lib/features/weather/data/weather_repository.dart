import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../domain/weather_models.dart';

abstract class WeatherRepository {
  Future<WeatherReport> fetchWeather(WeatherLocation location);

  Future<List<WeatherLocation>> searchLocations(String query);
}

class OpenMeteoWeatherRepository implements WeatherRepository {
  OpenMeteoWeatherRepository({http.Client? client})
      : _client = client ?? http.Client(),
        _fallback = const DemoWeatherRepository();

  final http.Client _client;
  final DemoWeatherRepository _fallback;

  void close() => _client.close();

  @override
  Future<WeatherReport> fetchWeather(WeatherLocation location) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      <String, String>{
        'latitude': location.latitude.toStringAsFixed(4),
        'longitude': location.longitude.toStringAsFixed(4),
        'timezone': location.timezone,
        'forecast_days': '2',
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

    try {
      final warningsFuture = _fetchOfficialWarnings(location);
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Forecast request failed: ${response.statusCode}');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final warnings = await warningsFuture;
      return _parseReport(location, json, warnings);
    } catch (_) {
      return _fallback.fetchWeather(location);
    }
  }

  @override
  Future<List<WeatherLocation>> searchLocations(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.length < 2) {
      return _filterPresets(cleanQuery);
    }

    final uri = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      <String, String>{
        'name': cleanQuery,
        'count': '8',
        'language': 'en',
        'countryCode': 'GB',
        'format': 'json',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Geocoding failed');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (json['results'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(_mapLocation)
          .toList(growable: false);

      if (results.isEmpty) {
        return _filterPresets(cleanQuery);
      }

      final seen = <String>{};
      return results.where((location) {
        final key = '${location.name}-${location.region}-${location.latitude}-${location.longitude}';
        return seen.add(key);
      }).toList(growable: false);
    } catch (_) {
      return _filterPresets(cleanQuery);
    }
  }

  WeatherReport _parseReport(
    WeatherLocation location,
    Map<String, dynamic> json,
    List<OfficialWarning> officialWarnings,
  ) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final hourlyJson = json['hourly'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final hourly = _parseHourly(hourlyJson);
    final current = CurrentConditions(
      time: _parseDateTime(currentJson['time'] as String?),
      temperatureC: _asDouble(currentJson['temperature_2m']),
      apparentTemperatureC: _asDouble(currentJson['apparent_temperature']),
      weatherCode: _asInt(currentJson['weather_code']),
      isDay: _asInt(currentJson['is_day']) == 1,
      precipitationMm: _asDouble(currentJson['precipitation']),
      rainMm: _asDouble(currentJson['rain']),
      showersMm: _asDouble(currentJson['showers']),
      cloudCover: _asInt(currentJson['cloud_cover']),
      windSpeedKph: _asDouble(currentJson['wind_speed_10m']),
      windGustKph: _asDouble(currentJson['wind_gusts_10m']),
      visibilityMeters: _asDouble(currentJson['visibility'], fallback: 10000),
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
      usingFallback: false,
      sourceLabel: 'Live weather by Open-Meteo',
      officialWarnings: officialWarnings,
      sourceNote: 'Live forecast with UK-focused guidance.',
    );
  }

  Future<List<OfficialWarning>> _fetchOfficialWarnings(WeatherLocation location) async {
    try {
      final uri = Uri.https(
        'weather.metoffice.gov.uk',
        '/public/data/PWSCache/WarningsRSS/Region/UK',
      );
      final response = await _client.get(uri);
      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        return const <OfficialWarning>[];
      }

      final document = XmlDocument.parse(response.body);
      final warnings = document.findAllElements('item').map((item) {
        final title = _xmlText(item, 'title');
        final summary = _stripHtml(_xmlText(item, 'description'));
        final link = _xmlText(item, 'link');
        return OfficialWarning(
          title: title,
          summary: summary,
          severityLabel: _severityLabel('$title $summary'),
          sourceLabel: 'Met Office official warning',
          link: link.isEmpty ? null : link,
        );
      }).where((warning) => warning.title.isNotEmpty).toList(growable: false);

      final matching = warnings.where((warning) {
        return _warningMatchesLocation(warning, location);
      }).take(3).toList(growable: false);

      if (matching.isNotEmpty) {
        return matching;
      }
      if (warnings.length == 1) {
        return warnings.take(1).toList(growable: false);
      }
      return const <OfficialWarning>[];
    } catch (_) {
      return const <OfficialWarning>[];
    }
  }

  List<MinuteForecast> _parseMinutely(
    Map<String, dynamic>? json,
    List<HourlyForecast> hourly,
    CurrentConditions current,
  ) {
    if (json == null) {
      return _minutelyFromHourly(hourly, current);
    }

    final times = _asStringList(json['time']);
    final precipitation = _asNumList(json['precipitation']);
    final weatherCode = _asNumList(json['weather_code']);
    final wind = _asNumList(json['wind_speed_10m']);
    final visibility = _asNumList(json['visibility']);
    final length = [
      times.length,
      precipitation.length,
      weatherCode.length,
      wind.length,
      visibility.length,
    ].reduce(min);

    if (length == 0) {
      return _minutelyFromHourly(hourly, current);
    }

    return List<MinuteForecast>.generate(length, (index) {
      return MinuteForecast(
        time: _parseDateTime(times[index]),
        precipitationMm: precipitation[index],
        weatherCode: weatherCode[index].round(),
        windSpeedKph: wind[index],
        visibilityMeters: visibility[index],
        isDay: _parseDateTime(times[index]).hour >= 7 && _parseDateTime(times[index]).hour < 19,
      );
    }, growable: false);
  }

  List<MinuteForecast> _minutelyFromHourly(List<HourlyForecast> hourly, CurrentConditions current) {
    final baseSlots = hourly.take(2).toList(growable: false);
    if (baseSlots.isEmpty) {
      return <MinuteForecast>[
        MinuteForecast(
          time: current.time,
          precipitationMm: current.precipitationMm,
          weatherCode: current.weatherCode,
          windSpeedKph: current.windSpeedKph,
          visibilityMeters: current.visibilityMeters,
          isDay: current.isDay,
        ),
      ];
    }

    final slots = <MinuteForecast>[];
    for (final hour in baseSlots) {
      for (var quarter = 0; quarter < 4; quarter += 1) {
        slots.add(
          MinuteForecast(
            time: hour.time.add(Duration(minutes: quarter * 15)),
            precipitationMm: hour.precipitationMm / 4,
            weatherCode: hour.weatherCode,
            windSpeedKph: hour.windSpeedKph,
            visibilityMeters: hour.visibilityMeters,
            isDay: hour.isDay,
          ),
        );
      }
    }
    return slots;
  }

  List<HourlyForecast> _parseHourly(Map<String, dynamic> json) {
    final times = _asStringList(json['time']);
    final temperature = _asNumList(json['temperature_2m']);
    final apparent = _asNumList(json['apparent_temperature']);
    final rainChance = _asNumList(json['precipitation_probability']);
    final rain = _asNumList(json['precipitation']);
    final weatherCode = _asNumList(json['weather_code']);
    final wind = _asNumList(json['wind_speed_10m']);
    final gust = _asNumList(json['wind_gusts_10m']);
    final visibility = _asNumList(json['visibility']);
    final cloudCover = _asNumList(json['cloud_cover']);
    final uv = _asNumList(json['uv_index']);
    final isDay = _asNumList(json['is_day']);

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
        time: _parseDateTime(times[index]),
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
    final times = _asStringList(json['time']);
    final weatherCode = _asNumList(json['weather_code']);
    final maxTemp = _asNumList(json['temperature_2m_max']);
    final minTemp = _asNumList(json['temperature_2m_min']);
    final rain = _asNumList(json['precipitation_sum']);
    final rainChance = _asNumList(json['precipitation_probability_max']);
    final wind = _asNumList(json['wind_speed_10m_max']);
    final uv = _asNumList(json['uv_index_max']);
    final sunrise = _asStringList(json['sunrise']);
    final sunset = _asStringList(json['sunset']);

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
        date: _parseDateTime(times[index]),
        weatherCode: weatherCode[index].round(),
        maxTempC: maxTemp[index],
        minTempC: minTemp[index],
        precipitationMm: rain[index],
        precipitationProbabilityMax: rainChance[index].round(),
        maxWindKph: wind[index],
        uvIndexMax: uv[index],
        sunrise: _parseDateTime(sunrise[index]),
        sunset: _parseDateTime(sunset[index]),
      );
    }, growable: false);
  }

  WeatherLocation _mapLocation(Map<String, dynamic> json) {
    return WeatherLocation(
      name: json['name'] as String? ?? 'Unknown',
      region: json['admin1'] as String? ?? '',
      country: json['country'] as String? ?? 'United Kingdom',
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      timezone: json['timezone'] as String? ?? 'Europe/London',
    );
  }

  List<WeatherLocation> _filterPresets(String query) {
    if (query.isEmpty) {
      return WeatherLocation.presets;
    }

    final lower = query.toLowerCase();
    return WeatherLocation.presets.where((location) {
      return location.name.toLowerCase().contains(lower) ||
          location.region.toLowerCase().contains(lower);
    }).toList(growable: false);
  }

  List<String> _asStringList(dynamic value) {
    return (value as List<dynamic>? ?? <dynamic>[])
        .map((entry) => entry.toString())
        .toList(growable: false);
  }

  List<double> _asNumList(dynamic value) {
    return (value as List<dynamic>? ?? <dynamic>[])
        .map((entry) => _asDouble(entry))
        .toList(growable: false);
  }

  double _asDouble(dynamic value, {double fallback = 0}) {
    return (value as num?)?.toDouble() ?? fallback;
  }

  int _asInt(dynamic value) {
    return (value as num?)?.round() ?? 0;
  }

  DateTime _parseDateTime(String? value) {
    return DateTime.tryParse(value ?? '') ?? DateTime.now();
  }

  String _xmlText(XmlElement element, String name) {
    return element.getElement(name)?.innerText.trim() ?? '';
  }

  String _stripHtml(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _severityLabel(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('red')) {
      return 'Red warning';
    }
    if (lower.contains('amber')) {
      return 'Amber warning';
    }
    if (lower.contains('yellow')) {
      return 'Yellow warning';
    }
    return 'Official warning';
  }

  bool _warningMatchesLocation(OfficialWarning warning, WeatherLocation location) {
    final text = '${warning.title} ${warning.summary}'.toLowerCase();
    final keywords = <String>{
      location.name.toLowerCase(),
      location.region.toLowerCase(),
      ..._regionalKeywords(location),
    }.where((keyword) => keyword.trim().isNotEmpty);

    return keywords.any(text.contains);
  }

  Set<String> _regionalKeywords(WeatherLocation location) {
    final lowerName = location.name.toLowerCase();
    final lowerRegion = location.region.toLowerCase();

    if (lowerRegion.contains('wales') || lowerName.contains('cardiff')) {
      return const <String>{'wales'};
    }
    if (lowerRegion.contains('northern ireland') || lowerName.contains('belfast')) {
      return const <String>{'northern ireland'};
    }
    if (lowerRegion.contains('scotland') ||
        lowerName.contains('edinburgh') ||
        lowerName.contains('glasgow')) {
      return const <String>{'scotland'};
    }
    if (lowerName.contains('london') || lowerRegion.contains('london')) {
      return const <String>{'london', 'south east england'};
    }
    if (lowerName.contains('manchester')) {
      return const <String>{'north west england'};
    }
    if (lowerName.contains('leeds')) {
      return const <String>{'yorkshire', 'the humber'};
    }
    if (lowerName.contains('birmingham')) {
      return const <String>{'west midlands'};
    }
    if (lowerName.contains('bristol')) {
      return const <String>{'south west england'};
    }
    return const <String>{'england'};
  }
}

class DemoWeatherRepository implements WeatherRepository {
  const DemoWeatherRepository();

  @override
  Future<WeatherReport> fetchWeather(WeatherLocation location) async {
    final now = DateTime.now();
    final seed = location.name.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    final drift = (seed % 5).toDouble();
    final current = CurrentConditions(
      time: now,
      temperatureC: 11 + drift * 0.8,
      apparentTemperatureC: 9 + drift * 0.5,
      weatherCode: 3,
      isDay: now.hour >= 7 && now.hour < 19,
      precipitationMm: 0,
      rainMm: 0,
      showersMm: 0,
      cloudCover: 62,
      windSpeedKph: 17 + drift,
      windGustKph: 24 + drift,
      visibilityMeters: 12000,
    );

    final minutely = List<MinuteForecast>.generate(8, (index) {
      final double pulse = index == 2 || index == 3
          ? 0.25 + drift * 0.03
          : index >= 5
              ? 0.05
              : 0;
      return MinuteForecast(
        time: now.add(Duration(minutes: index * 15)),
        precipitationMm: pulse,
        weatherCode: pulse > 0.08 ? 80 : 3,
        windSpeedKph: current.windSpeedKph + index * 0.7,
        visibilityMeters: pulse > 0.08 ? 7000 : 12000,
        isDay: current.isDay,
      );
    }, growable: false);

    final hourly = List<HourlyForecast>.generate(24, (index) {
      final time = DateTime(now.year, now.month, now.day, now.hour).add(Duration(hours: index));
      final afternoon = time.hour >= 12 && time.hour <= 16;
      final evening = time.hour >= 17 && time.hour <= 21;
      final double precipitationMm = afternoon
          ? 0
          : evening
              ? 0.18
              : index < 2
                  ? 0.32
                  : 0.08;
      final chance = afternoon ? 12 : evening ? 35 : index < 2 ? 62 : 25;
      final wind = afternoon ? 16 + drift : 22 + drift;
      return HourlyForecast(
        time: time,
        temperatureC: 10 + sin((index + drift) / 3) * 3 + (afternoon ? 2.5 : 0),
        apparentTemperatureC: 8 + sin((index + drift) / 3) * 2.5,
        precipitationProbability: chance,
        precipitationMm: precipitationMm,
        weatherCode: precipitationMm > 0.1 ? 80 : afternoon ? 1 : 3,
        windSpeedKph: wind,
        windGustKph: wind + 8,
        visibilityMeters: precipitationMm > 0.1 ? 6500 : 14000,
        cloudCover: afternoon ? 28 : 68,
        uvIndex: afternoon ? 3.5 : 0.4,
        isDay: time.hour >= 7 && time.hour < 19,
      );
    }, growable: false);

    final sunrise = DateTime(now.year, now.month, now.day, 6, 28);
    final sunset = DateTime(now.year, now.month, now.day, 18, 9);

    return WeatherReport(
      location: location,
      fetchedAt: now,
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: DailyForecast(
        date: now,
        weatherCode: 3,
        maxTempC: 15,
        minTempC: 7,
        precipitationMm: 1.3,
        precipitationProbabilityMax: 62,
        maxWindKph: 29,
        uvIndexMax: 4,
        sunrise: sunrise,
        sunset: sunset,
      ),
      usingFallback: true,
      sourceLabel: 'Sample outlook',
      officialWarnings: drift >= 3
          ? const <OfficialWarning>[
              OfficialWarning(
                title: 'Yellow warning of wind',
                summary: 'Met Office warning feed unavailable, showing a built-in sample warning.',
                severityLabel: 'Yellow warning',
                sourceLabel: 'Sample official warning',
              ),
            ]
          : const <OfficialWarning>[],
      sourceNote: 'Live forecast unavailable, so Dry Slots is showing a built-in demo.',
    );
  }

  @override
  Future<List<WeatherLocation>> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      return WeatherLocation.presets;
    }
    final lower = query.trim().toLowerCase();
    return WeatherLocation.presets.where((location) {
      return location.name.toLowerCase().contains(lower) ||
          location.region.toLowerCase().contains(lower);
    }).toList(growable: false);
  }
}
