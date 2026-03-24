import '../domain/weather_models.dart';
import 'weather_provider_config.dart';
import 'weather_repository_support.dart';

class WeatherApiWeatherRepository extends BaseNetworkWeatherRepository {
  WeatherApiWeatherRepository({
    required String apiKey,
    required super.dio,
    required super.localStore,
    super.fallback,
  }) : _apiKey = apiKey,
       super(provider: WeatherDataProvider.weatherApi);

  final String _apiKey;

  @override
  Future<WeatherReport> fetchLiveWeather(
    WeatherLocation location,
    List<OfficialWarning> officialWarnings,
  ) async {
    final response = await dio.get<Object?>(
      'https://api.weatherapi.com/v1/forecast.json',
      queryParameters: <String, String>{
        'key': _apiKey,
        'q': '${location.latitude},${location.longitude}',
        'days': '7',
        'alerts': 'yes',
        'aqi': 'no',
      },
    );
    final json = jsonMap(response.data);
    return _parseReport(location, json, officialWarnings);
  }

  @override
  Future<List<WeatherLocation>> searchRemoteLocations(String cleanQuery) async {
    final response = await dio.get<Object?>(
      'https://api.weatherapi.com/v1/search.json',
      queryParameters: <String, String>{'key': _apiKey, 'q': cleanQuery},
    );

    return asMapList(response.data)
        .map((entry) {
          return WeatherLocation(
            name: entry['name'] as String? ?? 'Unknown',
            region: entry['region'] as String? ?? '',
            country: entry['country'] as String? ?? 'United Kingdom',
            latitude: asDouble(entry['lat']),
            longitude: asDouble(entry['lon']),
            timezone: entry['tz_id'] as String? ?? 'Europe/London',
          );
        })
        .where((location) {
          return location.country.toLowerCase().contains('united kingdom') ||
              location.country.toLowerCase().contains('uk');
        })
        .toList(growable: false);
  }

  WeatherReport _parseReport(
    WeatherLocation location,
    Map<String, dynamic> json,
    List<OfficialWarning> officialWarnings,
  ) {
    final locationJson =
        json['location'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final currentJson =
        json['current'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final forecastJson =
        json['forecast'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final forecastDays = asMapList(forecastJson['forecastday']);
    final normalizedLocation = location.copyWith(
      name: locationJson['name'] as String? ?? location.name,
      region: locationJson['region'] as String? ?? location.region,
      country: locationJson['country'] as String? ?? location.country,
      latitude: asDouble(locationJson['lat'], fallback: location.latitude),
      longitude: asDouble(locationJson['lon'], fallback: location.longitude),
      timezone: locationJson['tz_id'] as String? ?? location.timezone,
    );

    final hourly = _parseHourly(forecastDays);
    final current = CurrentConditions(
      time: parseDateTime(
        currentJson['last_updated'] as String? ??
            locationJson['localtime'] as String?,
      ),
      temperatureC: asDouble(currentJson['temp_c']),
      apparentTemperatureC: asDouble(currentJson['feelslike_c']),
      weatherCode: _mapWeatherCode(
        (currentJson['condition'] as Map<String, dynamic>?)?['code'],
      ),
      isDay: asInt(currentJson['is_day']) == 1,
      precipitationMm: asDouble(currentJson['precip_mm']),
      rainMm: asDouble(currentJson['precip_mm']),
      showersMm: asDouble(currentJson['precip_mm']),
      cloudCover: asInt(currentJson['cloud']),
      windSpeedKph: asDouble(currentJson['wind_kph']),
      windGustKph: asDouble(currentJson['gust_kph']),
      visibilityMeters: asDouble(currentJson['vis_km']) * 1000,
    );
    final daily = _parseDaily(forecastDays);
    final minutely = minutelyFromHourly(hourly, current);

    return WeatherReport(
      location: normalizedLocation,
      fetchedAt: DateTime.now(),
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: daily.first,
      daily: daily,
      usingFallback: false,
      sourceLabel: 'Live weather by WeatherAPI.com',
      officialWarnings: officialWarnings,
      sourceNote:
          'Live forecast via WeatherAPI.com with Met Office warnings when available.',
    );
  }

  List<HourlyForecast> _parseHourly(List<Map<String, dynamic>> forecastDays) {
    final hours = forecastDays
        .expand<Map<String, dynamic>>((day) => asMapList(day['hour']))
        .toList(growable: false);

    return hours
        .map((entry) {
          return HourlyForecast(
            time: parseDateTime(entry['time'] as String?),
            temperatureC: asDouble(entry['temp_c']),
            apparentTemperatureC: asDouble(entry['feelslike_c']),
            precipitationProbability: asInt(entry['chance_of_rain']),
            precipitationMm: asDouble(entry['precip_mm']),
            weatherCode: _mapWeatherCode(
              (entry['condition'] as Map<String, dynamic>?)?['code'],
            ),
            windSpeedKph: asDouble(entry['wind_kph']),
            windGustKph: asDouble(entry['gust_kph']),
            visibilityMeters: asDouble(entry['vis_km']) * 1000,
            cloudCover: asInt(entry['cloud']),
            uvIndex: asDouble(entry['uv']),
            isDay: asInt(entry['is_day']) == 1,
          );
        })
        .toList(growable: false);
  }

  List<DailyForecast> _parseDaily(List<Map<String, dynamic>> forecastDays) {
    if (forecastDays.isEmpty) {
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

    return forecastDays
        .map((entry) {
          final date = parseDateTime(entry['date'] as String?);
          final day =
              entry['day'] as Map<String, dynamic>? ?? <String, dynamic>{};
          final astro =
              entry['astro'] as Map<String, dynamic>? ?? <String, dynamic>{};
          return DailyForecast(
            date: date,
            weatherCode: _mapWeatherCode(
              (day['condition'] as Map<String, dynamic>?)?['code'],
            ),
            maxTempC: asDouble(day['maxtemp_c']),
            minTempC: asDouble(day['mintemp_c']),
            precipitationMm: asDouble(day['totalprecip_mm']),
            precipitationProbabilityMax: asInt(day['daily_chance_of_rain']),
            maxWindKph: asDouble(day['maxwind_kph']),
            uvIndexMax: asDouble(day['uv']),
            sunrise: _parseWeatherApiClock(
              date,
              astro['sunrise'] as String?,
              fallbackHour: 7,
            ),
            sunset: _parseWeatherApiClock(
              date,
              astro['sunset'] as String?,
              fallbackHour: 18,
            ),
          );
        })
        .toList(growable: false);
  }

  DateTime _parseWeatherApiClock(
    DateTime date,
    String? value, {
    required int fallbackHour,
  }) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return DateTime(date.year, date.month, date.day, fallbackHour);
    }

    final parts = raw.split(' ');
    if (parts.length != 2) {
      return DateTime(date.year, date.month, date.day, fallbackHour);
    }

    final clock = parts.first.split(':');
    if (clock.length != 2) {
      return DateTime(date.year, date.month, date.day, fallbackHour);
    }

    final rawHour = int.tryParse(clock.first);
    final minute = int.tryParse(clock.last);
    final meridiem = parts.last.toUpperCase();
    if (rawHour == null || minute == null) {
      return DateTime(date.year, date.month, date.day, fallbackHour);
    }

    var hour = rawHour % 12;
    if (meridiem == 'PM') {
      hour += 12;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  int _mapWeatherCode(dynamic rawCode) {
    final code = asInt(rawCode);
    return switch (code) {
      1000 => 0,
      1003 => 2,
      1006 || 1009 => 3,
      1030 || 1135 => 45,
      1147 => 48,
      1063 || 1150 => 51,
      1153 => 53,
      1072 || 1168 => 56,
      1171 => 57,
      1180 || 1183 => 61,
      1186 || 1189 => 63,
      1192 || 1195 => 65,
      1198 => 66,
      1201 => 67,
      1066 || 1210 || 1213 => 71,
      1216 || 1219 => 73,
      1114 || 1117 || 1222 || 1225 => 75,
      1237 => 77,
      1204 || 1249 || 1261 => 85,
      1207 || 1252 || 1264 => 86,
      1240 => 80,
      1243 => 81,
      1246 => 82,
      1087 || 1273 || 1279 => 95,
      1276 => 96,
      1282 => 99,
      1255 => 85,
      1258 => 86,
      _ => 3,
    };
  }
}
