import 'package:dry_slots/features/weather/domain/weather_advisor.dart';
import 'package:dry_slots/features/weather/domain/weather_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const advisor = WeatherAdvisor();
  const savedWindows = <SavedCommuteWindow>[
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

  WeatherReport makeReport({
    required List<MinuteForecast> minutely,
    required List<HourlyForecast> hourly,
    required CurrentConditions current,
    required DailyForecast today,
  }) {
    return WeatherReport(
      location: WeatherLocation.london,
      fetchedAt: current.time,
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: today,
      usingFallback: false,
      sourceLabel: 'Test',
    );
  }

  test('builds a go-now next hour insight when the next hour is dry', () {
    final now = DateTime(2026, 3, 15, 8);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 12,
        apparentTemperatureC: 11,
        weatherCode: 1,
        isDay: true,
        precipitationMm: 0,
        rainMm: 0,
        showersMm: 0,
        cloudCover: 30,
        windSpeedKph: 11,
        windGustKph: 15,
        visibilityMeters: 12000,
      ),
      minutely: List<MinuteForecast>.generate(4, (index) {
        return MinuteForecast(
          time: now.add(Duration(minutes: index * 15)),
          precipitationMm: 0,
          weatherCode: 1,
          windSpeedKph: 12,
          visibilityMeters: 12000,
          isDay: true,
        );
      }),
      hourly: List<HourlyForecast>.generate(8, (index) {
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 12 + index * 0.4,
          apparentTemperatureC: 11 + index * 0.4,
          precipitationProbability: 8,
          precipitationMm: 0,
          weatherCode: 1,
          windSpeedKph: 12,
          windGustKph: 18,
          visibilityMeters: 14000,
          cloudCover: 25,
          uvIndex: 2.5,
          isDay: true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 1,
        maxTempC: 16,
        minTempC: 8,
        precipitationMm: 0.2,
        precipitationProbabilityMax: 15,
        maxWindKph: 18,
        uvIndexMax: 3.2,
        sunrise: DateTime(2026, 3, 15, 6, 24),
        sunset: DateTime(2026, 3, 15, 18, 11),
      ),
    );

    final guidance = advisor.build(report, commuteWindows: savedWindows);

    expect(guidance.nextHour.tone, AdviceTone.go);
    expect(guidance.nextHour.departureAdvice, contains('head out'));
    expect(guidance.dryWindow.duration.inHours, greaterThanOrEqualTo(2));
  });

  test('flags rougher conditions when rain is already in', () {
    final now = DateTime(2026, 3, 15, 17);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 9,
        apparentTemperatureC: 6,
        weatherCode: 80,
        isDay: true,
        precipitationMm: 0.9,
        rainMm: 0.9,
        showersMm: 0,
        cloudCover: 82,
        windSpeedKph: 26,
        windGustKph: 36,
        visibilityMeters: 6500,
      ),
      minutely: List<MinuteForecast>.generate(4, (index) {
        return MinuteForecast(
          time: now.add(Duration(minutes: index * 15)),
          precipitationMm: 0.85,
          weatherCode: 80,
          windSpeedKph: 28,
          visibilityMeters: 6000,
          isDay: true,
        );
      }),
      hourly: List<HourlyForecast>.generate(8, (index) {
        final dryLater = index >= 3;
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 9,
          apparentTemperatureC: 7,
          precipitationProbability: dryLater ? 18 : 78,
          precipitationMm: dryLater ? 0.02 : 1.3,
          weatherCode: dryLater ? 3 : 80,
          windSpeedKph: dryLater ? 18 : 31,
          windGustKph: dryLater ? 24 : 42,
          visibilityMeters: dryLater ? 12000 : 5000,
          cloudCover: dryLater ? 32 : 86,
          uvIndex: 0.1,
          isDay: dryLater ? false : true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 80,
        maxTempC: 12,
        minTempC: 7,
        precipitationMm: 8.4,
        precipitationProbabilityMax: 84,
        maxWindKph: 36,
        uvIndexMax: 1.3,
        sunrise: DateTime(2026, 3, 15, 6, 18),
        sunset: DateTime(2026, 3, 15, 18, 6),
      ),
    );

    final guidance = advisor.build(report, commuteWindows: savedWindows);

    expect(guidance.nextHour.tone, isNot(AdviceTone.go));
    expect(guidance.risks.first.level, isNot(RiskLevel.calm));
    expect(guidance.headline.detail, isNotEmpty);
  });

  test('uses saved commute windows when scoring journeys', () {
    final now = DateTime(2026, 3, 15, 7);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 10,
        apparentTemperatureC: 8,
        weatherCode: 3,
        isDay: true,
        precipitationMm: 0,
        rainMm: 0,
        showersMm: 0,
        cloudCover: 50,
        windSpeedKph: 14,
        windGustKph: 18,
        visibilityMeters: 12000,
      ),
      minutely: const <MinuteForecast>[],
      hourly: List<HourlyForecast>.generate(16, (index) {
        final time = now.add(Duration(hours: index));
        final wetSchoolRun = index == 1;
        return HourlyForecast(
          time: time,
          temperatureC: 10,
          apparentTemperatureC: 8,
          precipitationProbability: wetSchoolRun ? 70 : 15,
          precipitationMm: wetSchoolRun ? 1.0 : 0.02,
          weatherCode: wetSchoolRun ? 80 : 3,
          windSpeedKph: wetSchoolRun ? 24 : 12,
          windGustKph: wetSchoolRun ? 32 : 18,
          visibilityMeters: wetSchoolRun ? 5000 : 12000,
          cloudCover: wetSchoolRun ? 78 : 35,
          uvIndex: 1,
          isDay: time.hour >= 7 && time.hour < 19,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 3,
        maxTempC: 13,
        minTempC: 7,
        precipitationMm: 2.1,
        precipitationProbabilityMax: 70,
        maxWindKph: 24,
        uvIndexMax: 2,
        sunrise: DateTime(2026, 3, 15, 6, 18),
        sunset: DateTime(2026, 3, 15, 18, 6),
      ),
    );

    final guidance = advisor.build(report, commuteWindows: savedWindows);

    expect(guidance.commute.windows, hasLength(2));
    expect(guidance.commute.windows.first.label, 'School run');
    expect(guidance.commute.windows.last.label, 'Walk to the gym');
  });
}
