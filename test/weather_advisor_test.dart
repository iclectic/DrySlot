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
    List<DailyForecast>? daily,
    List<OfficialWarning> officialWarnings = const <OfficialWarning>[],
  }) {
    final dailyForecast =
        daily ??
        List<DailyForecast>.generate(7, (index) {
          final date = DateTime(
            today.date.year,
            today.date.month,
            today.date.day,
          ).add(Duration(days: index));
          return DailyForecast(
            date: date,
            weatherCode: today.weatherCode,
            maxTempC: today.maxTempC,
            minTempC: today.minTempC,
            precipitationMm: today.precipitationMm,
            precipitationProbabilityMax: today.precipitationProbabilityMax,
            maxWindKph: today.maxWindKph,
            uvIndexMax: today.uvIndexMax,
            sunrise: DateTime(
              date.year,
              date.month,
              date.day,
              today.sunrise.hour,
              today.sunrise.minute,
            ),
            sunset: DateTime(
              date.year,
              date.month,
              date.day,
              today.sunset.hour,
              today.sunset.minute,
            ),
          );
        }, growable: false);
    return WeatherReport(
      location: WeatherLocation.london,
      fetchedAt: current.time,
      current: current,
      minutely: minutely,
      hourly: hourly,
      today: today,
      daily: dailyForecast,
      usingFallback: false,
      sourceLabel: 'Test',
      officialWarnings: officialWarnings,
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

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

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

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

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

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

    expect(guidance.commute.windows, hasLength(2));
    expect(guidance.commute.windows.first.label, 'School run');
    expect(guidance.commute.windows.last.label, 'Walk to the gym');
  });

  test('generates outfit suggestions using practical plain-English labels', () {
    final now = DateTime(2026, 3, 15, 7, 30);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 7,
        apparentTemperatureC: 5,
        weatherCode: 61,
        isDay: true,
        precipitationMm: 0.2,
        rainMm: 0.2,
        showersMm: 0,
        cloudCover: 80,
        windSpeedKph: 18,
        windGustKph: 22,
        visibilityMeters: 11000,
      ),
      minutely: List<MinuteForecast>.generate(4, (index) {
        return MinuteForecast(
          time: now.add(Duration(minutes: index * 15)),
          precipitationMm: index >= 1 ? 0.15 : 0,
          weatherCode: index >= 1 ? 61 : 3,
          windSpeedKph: 18,
          visibilityMeters: 11000,
          isDay: true,
        );
      }),
      hourly: List<HourlyForecast>.generate(8, (index) {
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 7.0 + index,
          apparentTemperatureC: 5.0 + index,
          precipitationProbability: index < 2 ? 65 : 25,
          precipitationMm: index < 2 ? 0.4 : 0.02,
          weatherCode: index < 2 ? 61 : 3,
          windSpeedKph: 18,
          windGustKph: 24,
          visibilityMeters: 12000,
          cloudCover: index < 2 ? 80 : 40,
          uvIndex: 2,
          isDay: true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 61,
        maxTempC: 14,
        minTempC: 4,
        precipitationMm: 1.8,
        precipitationProbabilityMax: 65,
        maxWindKph: 20,
        uvIndexMax: 2.4,
        sunrise: DateTime(2026, 3, 15, 6, 18),
        sunset: DateTime(2026, 3, 15, 18, 6),
      ),
    );

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

    expect(
      guidance.wearTips.first.title,
      anyOf('Umbrella recommended', 'Take a light waterproof'),
    );
    expect(
      guidance.wearTips.map((tip) => tip.title),
      contains('Cold start, warmer by noon'),
    );
  });

  test('returns all required activity scores out of ten', () {
    final now = DateTime(2026, 3, 15, 12);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 15,
        apparentTemperatureC: 14,
        weatherCode: 1,
        isDay: true,
        precipitationMm: 0,
        rainMm: 0,
        showersMm: 0,
        cloudCover: 28,
        windSpeedKph: 12,
        windGustKph: 18,
        visibilityMeters: 16000,
      ),
      minutely: List<MinuteForecast>.generate(4, (index) {
        return MinuteForecast(
          time: now.add(Duration(minutes: index * 15)),
          precipitationMm: 0,
          weatherCode: 1,
          windSpeedKph: 12,
          visibilityMeters: 16000,
          isDay: true,
        );
      }),
      hourly: List<HourlyForecast>.generate(8, (index) {
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 15,
          apparentTemperatureC: 14,
          precipitationProbability: 10,
          precipitationMm: 0,
          weatherCode: 1,
          windSpeedKph: 12,
          windGustKph: 18,
          visibilityMeters: 16000,
          cloudCover: 30,
          uvIndex: 3.5,
          isDay: true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 1,
        maxTempC: 17,
        minTempC: 9,
        precipitationMm: 0,
        precipitationProbabilityMax: 10,
        maxWindKph: 16,
        uvIndexMax: 4,
        sunrise: DateTime(2026, 3, 15, 6, 18),
        sunset: DateTime(2026, 3, 15, 18, 6),
      ),
    );

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

    final names = guidance.activities
        .map((activity) => activity.name)
        .toList(growable: false);
    expect(names, <String>[
      'Walking',
      'Running',
      'Cycling',
      'Picnic',
      'Laundry drying',
      'Dog walk',
      'Football',
      'Outdoor coffee',
    ]);
    for (final activity in guidance.activities) {
      expect(activity.score, inInclusiveRange(0, 10));
    }
  });

  test(
    'surfaces official warnings in severe alerts and builds widget-ready cards',
    () {
      final now = DateTime(2026, 3, 15, 9);
      final report = makeReport(
        current: CurrentConditions(
          time: now,
          temperatureC: 11,
          apparentTemperatureC: 9,
          weatherCode: 3,
          isDay: true,
          precipitationMm: 0,
          rainMm: 0,
          showersMm: 0,
          cloudCover: 62,
          windSpeedKph: 20,
          windGustKph: 28,
          visibilityMeters: 12000,
        ),
        minutely: List<MinuteForecast>.generate(4, (index) {
          return MinuteForecast(
            time: now.add(Duration(minutes: index * 15)),
            precipitationMm: 0,
            weatherCode: 3,
            windSpeedKph: 18,
            visibilityMeters: 12000,
            isDay: true,
          );
        }),
        hourly: List<HourlyForecast>.generate(8, (index) {
          return HourlyForecast(
            time: now.add(Duration(hours: index)),
            temperatureC: 11,
            apparentTemperatureC: 9,
            precipitationProbability: 20,
            precipitationMm: 0.05,
            weatherCode: 3,
            windSpeedKph: 20,
            windGustKph: 28,
            visibilityMeters: 12000,
            cloudCover: 60,
            uvIndex: 1.5,
            isDay: true,
          );
        }),
        today: DailyForecast(
          date: now,
          weatherCode: 3,
          maxTempC: 13,
          minTempC: 5,
          precipitationMm: 0.5,
          precipitationProbabilityMax: 20,
          maxWindKph: 30,
          uvIndexMax: 2,
          sunrise: DateTime(2026, 3, 15, 6, 18),
          sunset: DateTime(2026, 3, 15, 18, 6),
        ),
        officialWarnings: const <OfficialWarning>[
          OfficialWarning(
            title: 'Yellow warning of wind',
            summary: 'Official warning in force for the London area.',
            severityLabel: 'Yellow warning',
            sourceLabel: 'Met Office official warning',
          ),
        ],
      );

      final guidance = advisor.build(
        report,
        commuteWindows: savedWindows,
        explanationMode: ExplanationMode.simple,
      );

      expect(guidance.risks.first.source, AlertSource.official);
      expect(guidance.homeCards, hasLength(5));
      expect(
        guidance.homeCards.map((card) => card.title),
        containsAll(<String>[
          'Current weather',
          'Next rain',
          'Best dry slot',
          'Commute summary',
          'Daily advice',
        ]),
      );
    },
  );

  test('adds supporting metrics only in detailed explanation mode', () {
    final now = DateTime(2026, 3, 15, 8);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 11,
        apparentTemperatureC: 9,
        weatherCode: 3,
        isDay: true,
        precipitationMm: 0.1,
        rainMm: 0.1,
        showersMm: 0,
        cloudCover: 58,
        windSpeedKph: 22,
        windGustKph: 30,
        visibilityMeters: 8500,
      ),
      minutely: List<MinuteForecast>.generate(4, (index) {
        return MinuteForecast(
          time: now.add(Duration(minutes: index * 15)),
          precipitationMm: index >= 2 ? 0.25 : 0,
          weatherCode: index >= 2 ? 61 : 3,
          windSpeedKph: 22,
          visibilityMeters: 8500,
          isDay: true,
        );
      }),
      hourly: List<HourlyForecast>.generate(8, (index) {
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 11 + index * 0.5,
          apparentTemperatureC: 9 + index * 0.5,
          precipitationProbability: index < 2 ? 55 : 20,
          precipitationMm: index < 2 ? 0.4 : 0.05,
          weatherCode: index < 2 ? 61 : 3,
          windSpeedKph: 22,
          windGustKph: 30,
          visibilityMeters: 8500,
          cloudCover: 58,
          uvIndex: 1.8,
          isDay: true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 61,
        maxTempC: 15,
        minTempC: 8,
        precipitationMm: 2.3,
        precipitationProbabilityMax: 55,
        maxWindKph: 24,
        uvIndexMax: 2.2,
        sunrise: DateTime(2026, 3, 15, 6, 18),
        sunset: DateTime(2026, 3, 15, 18, 6),
      ),
    );

    final simpleGuidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );
    final detailedGuidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.detailed,
    );

    expect(
      simpleGuidance.nextHour.detail,
      isNot(contains('Visibility is around')),
    );
    expect(
      simpleGuidance.simpleSummary,
      isNot(contains('Temperatures range from')),
    );
    expect(detailedGuidance.nextHour.detail, contains('Visibility is around'));
    expect(detailedGuidance.simpleSummary, contains('Temperatures range from'));
    expect(detailedGuidance.commute.summary, contains('saved routine'));
  });

  test('builds a weekend planner from multi-day forecasts', () {
    final now = DateTime(2026, 3, 19, 9);
    final report = makeReport(
      current: CurrentConditions(
        time: now,
        temperatureC: 10,
        apparentTemperatureC: 9,
        weatherCode: 3,
        isDay: true,
        precipitationMm: 0,
        rainMm: 0,
        showersMm: 0,
        cloudCover: 48,
        windSpeedKph: 16,
        windGustKph: 24,
        visibilityMeters: 12000,
      ),
      minutely: const <MinuteForecast>[],
      hourly: List<HourlyForecast>.generate(12, (index) {
        return HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperatureC: 10 + index * 0.2,
          apparentTemperatureC: 9 + index * 0.2,
          precipitationProbability: 20,
          precipitationMm: 0,
          weatherCode: 3,
          windSpeedKph: 16,
          windGustKph: 24,
          visibilityMeters: 12000,
          cloudCover: 48,
          uvIndex: 2.1,
          isDay: true,
        );
      }),
      today: DailyForecast(
        date: now,
        weatherCode: 3,
        maxTempC: 13,
        minTempC: 7,
        precipitationMm: 0.4,
        precipitationProbabilityMax: 20,
        maxWindKph: 18,
        uvIndexMax: 2.5,
        sunrise: DateTime(2026, 3, 19, 6, 18),
        sunset: DateTime(2026, 3, 19, 18, 9),
      ),
      daily: <DailyForecast>[
        DailyForecast(
          date: DateTime(2026, 3, 19),
          weatherCode: 3,
          maxTempC: 13,
          minTempC: 7,
          precipitationMm: 0.4,
          precipitationProbabilityMax: 20,
          maxWindKph: 18,
          uvIndexMax: 2.5,
          sunrise: DateTime(2026, 3, 19, 6, 18),
          sunset: DateTime(2026, 3, 19, 18, 9),
        ),
        DailyForecast(
          date: DateTime(2026, 3, 20),
          weatherCode: 3,
          maxTempC: 14,
          minTempC: 8,
          precipitationMm: 0.5,
          precipitationProbabilityMax: 25,
          maxWindKph: 20,
          uvIndexMax: 2.8,
          sunrise: DateTime(2026, 3, 20, 6, 16),
          sunset: DateTime(2026, 3, 20, 18, 10),
        ),
        DailyForecast(
          date: DateTime(2026, 3, 21),
          weatherCode: 1,
          maxTempC: 17,
          minTempC: 9,
          precipitationMm: 0.1,
          precipitationProbabilityMax: 15,
          maxWindKph: 16,
          uvIndexMax: 3.8,
          sunrise: DateTime(2026, 3, 21, 6, 14),
          sunset: DateTime(2026, 3, 21, 18, 12),
        ),
        DailyForecast(
          date: DateTime(2026, 3, 22),
          weatherCode: 61,
          maxTempC: 12,
          minTempC: 7,
          precipitationMm: 5.2,
          precipitationProbabilityMax: 78,
          maxWindKph: 32,
          uvIndexMax: 1.6,
          sunrise: DateTime(2026, 3, 22, 6, 12),
          sunset: DateTime(2026, 3, 22, 18, 14),
        ),
      ],
    );

    final guidance = advisor.build(
      report,
      commuteWindows: savedWindows,
      explanationMode: ExplanationMode.simple,
    );

    expect(guidance.weekendPlanner, isNotNull);
    expect(guidance.weekendPlanner!.days, hasLength(2));
    expect(guidance.weekendPlanner!.title, contains('Saturday'));
    expect(guidance.weekendPlanner!.days.first.label, 'Saturday');
    expect(guidance.weekendPlanner!.days.last.label, 'Sunday');
  });
}
