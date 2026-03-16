import 'package:dry_slots/features/weather/domain/weather_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weather report serializes cleanly for offline caching', () {
    final report = WeatherReport(
      location: WeatherLocation.london,
      fetchedAt: DateTime(2026, 3, 16, 8),
      current: CurrentConditions(
        time: DateTime(2026, 3, 16, 8),
        temperatureC: 11,
        apparentTemperatureC: 9,
        weatherCode: 3,
        isDay: true,
        precipitationMm: 0.2,
        rainMm: 0.2,
        showersMm: 0,
        cloudCover: 64,
        windSpeedKph: 18,
        windGustKph: 24,
        visibilityMeters: 10000,
      ),
      minutely: <MinuteForecast>[
        MinuteForecast(
          time: DateTime(2026, 3, 16, 8),
          precipitationMm: 0.0,
          weatherCode: 3,
          windSpeedKph: 18,
          visibilityMeters: 10000,
          isDay: true,
        ),
      ],
      hourly: <HourlyForecast>[
        HourlyForecast(
          time: DateTime(2026, 3, 16, 8),
          temperatureC: 11,
          apparentTemperatureC: 9,
          precipitationProbability: 30,
          precipitationMm: 0.1,
          weatherCode: 3,
          windSpeedKph: 18,
          windGustKph: 24,
          visibilityMeters: 10000,
          cloudCover: 64,
          uvIndex: 1.4,
          isDay: true,
        ),
      ],
      today: DailyForecast(
        date: DateTime(2026, 3, 16),
        weatherCode: 3,
        maxTempC: 14,
        minTempC: 7,
        precipitationMm: 1.2,
        precipitationProbabilityMax: 30,
        maxWindKph: 24,
        uvIndexMax: 2.2,
        sunrise: DateTime(2026, 3, 16, 6, 17),
        sunset: DateTime(2026, 3, 16, 18, 8),
      ),
      daily: <DailyForecast>[
        DailyForecast(
          date: DateTime(2026, 3, 16),
          weatherCode: 3,
          maxTempC: 14,
          minTempC: 7,
          precipitationMm: 1.2,
          precipitationProbabilityMax: 30,
          maxWindKph: 24,
          uvIndexMax: 2.2,
          sunrise: DateTime(2026, 3, 16, 6, 17),
          sunset: DateTime(2026, 3, 16, 18, 8),
        ),
        DailyForecast(
          date: DateTime(2026, 3, 17),
          weatherCode: 1,
          maxTempC: 15,
          minTempC: 8,
          precipitationMm: 0.0,
          precipitationProbabilityMax: 10,
          maxWindKph: 18,
          uvIndexMax: 3.1,
          sunrise: DateTime(2026, 3, 17, 6, 15),
          sunset: DateTime(2026, 3, 17, 18, 10),
        ),
      ],
      usingFallback: false,
      sourceLabel: 'Live weather by Open-Meteo',
      officialWarnings: const <OfficialWarning>[
        OfficialWarning(
          title: 'Yellow warning of wind',
          summary: 'Strong gusts possible later.',
          severityLabel: 'Yellow warning',
          sourceLabel: 'Met Office official warning',
        ),
      ],
      sourceNote: 'Live forecast with UK-focused guidance.',
    );

    final restored = WeatherReport.fromJson(report.toJson());

    expect(restored.location.name, report.location.name);
    expect(restored.current.temperatureC, report.current.temperatureC);
    expect(restored.minutely.single.precipitationMm, 0.0);
    expect(restored.hourly.single.windGustKph, 24);
    expect(restored.daily, hasLength(2));
    expect(restored.officialWarnings.single.title, 'Yellow warning of wind');
    expect(restored.sourceNote, report.sourceNote);
  });
}
