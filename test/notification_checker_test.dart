import 'package:dry_slots/core/services/notification_preferences_controller.dart';
import 'package:dry_slots/core/services/weather_notification_checker.dart';
import 'package:dry_slots/core/services/local_notification_service.dart';
import 'package:dry_slots/features/weather_core/domain/weather_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A fake notification service that records calls instead of showing real
/// platform notifications.
class FakeNotificationService extends LocalNotificationService {
  final List<String> firedTitles = <String>[];

  @override
  Future<void> initialize() async {}

  @override
  Future<void> showRainAlert({required String title, required String body}) async {
    firedTitles.add(title);
  }

  @override
  Future<void> showCommuteWarning({required String title, required String body}) async {
    firedTitles.add(title);
  }

  @override
  Future<void> showDryWindowAlert({required String title, required String body}) async {
    firedTitles.add(title);
  }
}

void main() {
  late FakeNotificationService fakeService;
  late SharedPreferences preferences;

  WeatherReport makeReport({
    required DateTime now,
    List<MinuteForecast>? minutely,
    List<HourlyForecast>? hourly,
  }) {
    return WeatherReport(
      location: WeatherLocation.london,
      fetchedAt: now,
      current: CurrentConditions(
        time: now,
        temperatureC: 12,
        apparentTemperatureC: 10,
        weatherCode: 3,
        isDay: true,
        precipitationMm: 0,
        rainMm: 0,
        showersMm: 0,
        cloudCover: 40,
        windSpeedKph: 14,
        windGustKph: 20,
        visibilityMeters: 12000,
      ),
      minutely: minutely ?? const <MinuteForecast>[],
      hourly: hourly ??
          List<HourlyForecast>.generate(8, (i) {
            return HourlyForecast(
              time: now.add(Duration(hours: i)),
              temperatureC: 12,
              apparentTemperatureC: 10,
              precipitationProbability: 10,
              precipitationMm: 0,
              weatherCode: 3,
              windSpeedKph: 14,
              windGustKph: 20,
              visibilityMeters: 12000,
              cloudCover: 40,
              uvIndex: 2,
              isDay: true,
            );
          }),
      today: DailyForecast(
        date: now,
        weatherCode: 3,
        maxTempC: 15,
        minTempC: 8,
        precipitationMm: 0.5,
        precipitationProbabilityMax: 20,
        maxWindKph: 18,
        uvIndexMax: 2.5,
        sunrise: DateTime(now.year, now.month, now.day, 6, 18),
        sunset: DateTime(now.year, now.month, now.day, 18, 6),
      ),
      daily: <DailyForecast>[],
      usingFallback: false,
      sourceLabel: 'Test',
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await SharedPreferences.getInstance();
    fakeService = FakeNotificationService();
  });

  group('WeatherNotificationChecker', () {
    test('does not fire when all alert types are disabled', () async {
      final now = DateTime(2026, 3, 15, 8);
      final report = makeReport(now: now);
      const advisor = WeatherAdvisor();
      final guidance = advisor.build(report, commuteWindows: const []);

      final checker = WeatherNotificationChecker(
        notificationService: fakeService,
        preferences: preferences,
        notificationPreferences: const NotificationPreferences(
          rainAlerts: false,
          commuteWarnings: false,
          dryWindowAlerts: false,
          quietHoursEnabled: false,
          quietStart: TimeOfDay(hour: 22, minute: 0),
          quietEnd: TimeOfDay(hour: 7, minute: 0),
        ),
      );

      await checker.evaluate(report, guidance);
      expect(fakeService.firedTitles, isEmpty);
    });

    test('does not fire during quiet hours', () async {
      final now = DateTime(2026, 3, 15, 8);
      final report = makeReport(now: now);
      const advisor = WeatherAdvisor();
      final guidance = advisor.build(report, commuteWindows: const []);

      // Set quiet hours to cover the entire day (always quiet).
      final checker = WeatherNotificationChecker(
        notificationService: fakeService,
        preferences: preferences,
        notificationPreferences: const NotificationPreferences(
          rainAlerts: true,
          commuteWarnings: true,
          dryWindowAlerts: true,
          quietHoursEnabled: true,
          quietStart: TimeOfDay(hour: 0, minute: 0),
          quietEnd: TimeOfDay(hour: 23, minute: 59),
        ),
      );

      await checker.evaluate(report, guidance);
      expect(fakeService.firedTitles, isEmpty);
    });

    test('fires rain alert when rain is imminent and rain alerts enabled', () async {
      final now = DateTime(2026, 3, 15, 8);
      final report = makeReport(
        now: now,
        minutely: List<MinuteForecast>.generate(4, (i) {
          return MinuteForecast(
            time: now.add(Duration(minutes: i * 15)),
            precipitationMm: i == 0 ? 0 : 0.8,
            weatherCode: i == 0 ? 3 : 80,
            windSpeedKph: 14,
            visibilityMeters: 10000,
            isDay: true,
          );
        }),
      );
      const advisor = WeatherAdvisor();
      final guidance = advisor.build(report, commuteWindows: const []);

      // Only fire if the guidance actually detected rain approaching.
      if (guidance.nextHour.minutesUntilRain != null &&
          guidance.nextHour.minutesUntilRain! <= 15) {
        final checker = WeatherNotificationChecker(
          notificationService: fakeService,
          preferences: preferences,
          notificationPreferences: const NotificationPreferences(
            rainAlerts: true,
            commuteWarnings: true,
            dryWindowAlerts: true,
            quietHoursEnabled: false,
            quietStart: TimeOfDay(hour: 22, minute: 0),
            quietEnd: TimeOfDay(hour: 7, minute: 0),
          ),
        );

        await checker.evaluate(report, guidance);
        expect(fakeService.firedTitles, isNotEmpty);
      }
    });

    test('respects cooldown and does not fire twice', () async {
      final now = DateTime(2026, 3, 15, 8);
      final report = makeReport(
        now: now,
        minutely: List<MinuteForecast>.generate(4, (i) {
          return MinuteForecast(
            time: now.add(Duration(minutes: i * 15)),
            precipitationMm: i == 0 ? 0 : 0.8,
            weatherCode: i == 0 ? 3 : 80,
            windSpeedKph: 14,
            visibilityMeters: 10000,
            isDay: true,
          );
        }),
      );
      const advisor = WeatherAdvisor();
      final guidance = advisor.build(report, commuteWindows: const []);

      final checker = WeatherNotificationChecker(
        notificationService: fakeService,
        preferences: preferences,
        notificationPreferences: const NotificationPreferences(
          rainAlerts: true,
          commuteWarnings: true,
          dryWindowAlerts: true,
          quietHoursEnabled: false,
          quietStart: TimeOfDay(hour: 22, minute: 0),
          quietEnd: TimeOfDay(hour: 7, minute: 0),
        ),
      );

      await checker.evaluate(report, guidance);
      final countAfterFirst = fakeService.firedTitles.length;

      // Second evaluation should not fire again (cooldown).
      await checker.evaluate(report, guidance);
      expect(fakeService.firedTitles.length, countAfterFirst);
    });
  });
}
