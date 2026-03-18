import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

import '../domain/weather_models.dart';
import '../domain/weather_repository.dart';
import 'weather_local_store.dart';
import 'weather_provider_config.dart';

abstract class BaseNetworkWeatherRepository implements WeatherRepository {
  BaseNetworkWeatherRepository({
    required Dio dio,
    required WeatherLocalStore localStore,
    required this.provider,
    DemoWeatherRepository fallback = const DemoWeatherRepository(),
  }) : _dio = dio,
       _localStore = localStore,
       _fallback = fallback;

  final Dio _dio;
  final WeatherLocalStore _localStore;
  final DemoWeatherRepository _fallback;
  final WeatherDataProvider provider;

  Dio get dio => _dio;

  @override
  Future<WeatherReport> fetchWeather(WeatherLocation location) async {
    final warningsFuture = fetchOfficialWarnings(location);

    try {
      final warnings = await warningsFuture;
      final report = await fetchLiveWeather(location, warnings);
      await _localStore.cacheReport(report, provider: provider);
      return report;
    } catch (_) {
      final cached = _localStore.getCachedReport(location, provider: provider);
      if (cached != null) {
        return cached.copyWith(
          usingFallback: true,
          sourceLabel: 'Saved forecast',
          sourceNote:
              'Showing the most recent saved forecast because live weather is unavailable.',
        );
      }
      return _fallback.fetchWeather(location);
    }
  }

  @override
  Future<List<WeatherLocation>> searchLocations(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.length < 2) {
      return filterPresets(cleanQuery);
    }

    try {
      final results = await searchRemoteLocations(cleanQuery);
      if (results.isEmpty) {
        return filterPresets(cleanQuery);
      }

      final seen = <String>{};
      return results
          .where((location) {
            final key =
                '${location.name}-${location.region}-${location.latitude}-${location.longitude}';
            return seen.add(key);
          })
          .toList(growable: false);
    } catch (_) {
      return filterPresets(cleanQuery);
    }
  }

  Future<WeatherReport> fetchLiveWeather(
    WeatherLocation location,
    List<OfficialWarning> officialWarnings,
  );

  Future<List<WeatherLocation>> searchRemoteLocations(String cleanQuery);

  List<WeatherLocation> filterPresets(String query) {
    if (query.isEmpty) {
      return WeatherLocation.presets;
    }

    final lower = query.toLowerCase();
    return WeatherLocation.presets
        .where((location) {
          return location.name.toLowerCase().contains(lower) ||
              location.region.toLowerCase().contains(lower);
        })
        .toList(growable: false);
  }

  Future<List<OfficialWarning>> fetchOfficialWarnings(
    WeatherLocation location,
  ) async {
    try {
      final response = await dio.get<String>(
        'https://weather.metoffice.gov.uk/public/data/PWSCache/WarningsRSS/Region/UK',
        options: Options(responseType: ResponseType.plain),
      );
      final body = response.data?.trim() ?? '';
      if (body.isEmpty) {
        return const <OfficialWarning>[];
      }

      final document = XmlDocument.parse(body);
      final warnings = document
          .findAllElements('item')
          .map((item) {
            final title = xmlText(item, 'title');
            final summary = stripHtml(xmlText(item, 'description'));
            final link = xmlText(item, 'link');
            return OfficialWarning(
              title: title,
              summary: summary,
              severityLabel: severityLabel('$title $summary'),
              sourceLabel: 'Met Office official warning',
              link: link.isEmpty ? null : link,
            );
          })
          .where((warning) => warning.title.isNotEmpty)
          .toList(growable: false);

      final matching = warnings
          .where((warning) => warningMatchesLocation(warning, location))
          .take(3)
          .toList(growable: false);

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

  Map<String, dynamic> jsonMap(Object? data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String && data.isNotEmpty) {
      return (jsonDecode(data) as Map<Object?, Object?>)
          .cast<String, dynamic>();
    }
    throw const FormatException('Unexpected response payload');
  }

  List<Map<String, dynamic>> asMapList(dynamic value) {
    return (value as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map>()
        .map((entry) => entry.cast<String, dynamic>())
        .toList(growable: false);
  }

  List<String> asStringList(dynamic value) {
    return (value as List<dynamic>? ?? const <dynamic>[])
        .map((entry) => entry.toString())
        .toList(growable: false);
  }

  List<double> asNumList(dynamic value) {
    return (value as List<dynamic>? ?? const <dynamic>[])
        .map((entry) => asDouble(entry))
        .toList(growable: false);
  }

  double asDouble(dynamic value, {double fallback = 0}) {
    return (value as num?)?.toDouble() ?? fallback;
  }

  int asInt(dynamic value) {
    return (value as num?)?.round() ?? 0;
  }

  DateTime parseDateTime(String? value) {
    return DateTime.tryParse(value ?? '') ?? DateTime.now();
  }

  DateTime unixToLocalDateTime(dynamic seconds) {
    final raw = (seconds as num?)?.toInt();
    if (raw == null) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(
      raw * 1000,
      isUtc: true,
    ).toLocal();
  }

  List<MinuteForecast> minutelyFromHourly(
    List<HourlyForecast> hourly,
    CurrentConditions current, {
    int slotCount = 8,
  }) {
    final hoursNeeded = max(1, (slotCount / 4).ceil());
    final baseSlots = hourly.take(hoursNeeded).toList(growable: false);
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
    return slots.take(slotCount).toList(growable: false);
  }

  String xmlText(XmlElement element, String name) {
    return element.getElement(name)?.innerText.trim() ?? '';
  }

  String stripHtml(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String severityLabel(String value) {
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

  bool warningMatchesLocation(
    OfficialWarning warning,
    WeatherLocation location,
  ) {
    final text = '${warning.title} ${warning.summary}'.toLowerCase();
    final keywords = <String>{
      location.name.toLowerCase(),
      location.region.toLowerCase(),
      ...regionalKeywords(location),
    }.where((keyword) => keyword.trim().isNotEmpty);

    return keywords.any(text.contains);
  }

  Set<String> regionalKeywords(WeatherLocation location) {
    final lowerName = location.name.toLowerCase();
    final lowerRegion = location.region.toLowerCase();

    if (lowerRegion.contains('wales') || lowerName.contains('cardiff')) {
      return const <String>{'wales'};
    }
    if (lowerRegion.contains('northern ireland') ||
        lowerName.contains('belfast')) {
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
    final seed = location.name.codeUnits.fold<int>(
      0,
      (sum, unit) => sum + unit,
    );
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
      final pulse = index == 2 || index == 3
          ? 0.25 + drift * 0.03
          : index >= 5
          ? 0.05
          : 0.0;
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
      final time = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      ).add(Duration(hours: index));
      final afternoon = time.hour >= 12 && time.hour <= 16;
      final evening = time.hour >= 17 && time.hour <= 21;
      final precipitationMm = afternoon
          ? 0.0
          : evening
          ? 0.18
          : index < 2
          ? 0.32
          : 0.08;
      final chance = afternoon
          ? 12
          : evening
          ? 35
          : index < 2
          ? 62
          : 25;
      final wind = afternoon ? 16 + drift : 22 + drift;
      return HourlyForecast(
        time: time,
        temperatureC: 10 + sin((index + drift) / 3) * 3 + (afternoon ? 2.5 : 0),
        apparentTemperatureC: 8 + sin((index + drift) / 3) * 2.5,
        precipitationProbability: chance,
        precipitationMm: precipitationMm,
        weatherCode: precipitationMm > 0.1
            ? 80
            : afternoon
            ? 1
            : 3,
        windSpeedKph: wind,
        windGustKph: wind + 8,
        visibilityMeters: precipitationMm > 0.1 ? 6500 : 14000,
        cloudCover: afternoon ? 28 : 68,
        uvIndex: afternoon ? 3.5 : 0.4,
        isDay: time.hour >= 7 && time.hour < 19,
      );
    }, growable: false);

    final daily = List<DailyForecast>.generate(7, (index) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: index));
      final weekend = date.weekday >= DateTime.saturday;
      final unsettled = index == 0 || index == 4;
      final bright = date.weekday == DateTime.saturday;
      final maxTemp = 14 + sin((index + drift) / 2) * 2 + (bright ? 2 : 0);
      final minTemp = 6 + sin((index + drift) / 2);
      final rain = unsettled
          ? 3.2 + drift * 0.3
          : weekend
          ? 0.4 + drift * 0.1
          : 1.2;
      final rainChance = unsettled
          ? 72
          : weekend
          ? 18
          : 38;
      return DailyForecast(
        date: date,
        weatherCode: unsettled
            ? 80
            : bright
            ? 1
            : weekend
            ? 2
            : 3,
        maxTempC: maxTemp,
        minTempC: minTemp,
        precipitationMm: rain,
        precipitationProbabilityMax: rainChance,
        maxWindKph: weekend ? 18 + drift : 26 + drift,
        uvIndexMax: bright ? 4.8 : 2.4,
        sunrise: DateTime(date.year, date.month, date.day, 6, 40),
        sunset: DateTime(date.year, date.month, date.day, 18, 15),
      );
    }, growable: false);

    return WeatherReport(
      location: location,
      fetchedAt: now,
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: daily.first,
      daily: daily,
      usingFallback: true,
      sourceLabel: 'Demo forecast',
      sourceNote:
          'Showing a built-in sample forecast while live weather is unavailable.',
    );
  }

  @override
  Future<List<WeatherLocation>> searchLocations(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return WeatherLocation.presets;
    }

    return WeatherLocation.presets
        .where((location) {
          return location.name.toLowerCase().contains(cleanQuery) ||
              location.region.toLowerCase().contains(cleanQuery);
        })
        .toList(growable: false);
  }
}
