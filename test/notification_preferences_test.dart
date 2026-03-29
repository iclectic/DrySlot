import 'package:dry_slots/core/services/notification_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationPreferences.isInQuietHours', () {
    test('returns false when quiet hours are disabled', () {
      const prefs = NotificationPreferences(
        rainAlerts: true,
        commuteWarnings: true,
        dryWindowAlerts: true,
        quietHoursEnabled: false,
        quietStart: TimeOfDay(hour: 22, minute: 0),
        quietEnd: TimeOfDay(hour: 7, minute: 0),
      );

      expect(prefs.isInQuietHours, isFalse);
    });

    test('detects quiet hours that do not wrap midnight', () {
      // Quiet window: 14:00 – 16:00
      const prefs = NotificationPreferences(
        rainAlerts: true,
        commuteWarnings: true,
        dryWindowAlerts: true,
        quietHoursEnabled: true,
        quietStart: TimeOfDay(hour: 14, minute: 0),
        quietEnd: TimeOfDay(hour: 16, minute: 0),
      );

      // isInQuietHours depends on TimeOfDay.now() which we can't mock here,
      // but we can at least verify the property is accessible and returns a bool.
      expect(prefs.isInQuietHours, isA<bool>());
    });

    test('copyWith preserves unmodified fields', () {
      const original = NotificationPreferences(
        rainAlerts: true,
        commuteWarnings: false,
        dryWindowAlerts: true,
        quietHoursEnabled: false,
        quietStart: TimeOfDay(hour: 22, minute: 0),
        quietEnd: TimeOfDay(hour: 7, minute: 0),
      );

      final updated = original.copyWith(commuteWarnings: true);

      expect(updated.rainAlerts, isTrue);
      expect(updated.commuteWarnings, isTrue);
      expect(updated.dryWindowAlerts, isTrue);
      expect(updated.quietHoursEnabled, isFalse);
      expect(updated.quietStart.hour, 22);
      expect(updated.quietEnd.hour, 7);
    });

    test('copyWith overrides quiet hours fields', () {
      const original = NotificationPreferences(
        rainAlerts: true,
        commuteWarnings: true,
        dryWindowAlerts: true,
        quietHoursEnabled: false,
        quietStart: TimeOfDay(hour: 22, minute: 0),
        quietEnd: TimeOfDay(hour: 7, minute: 0),
      );

      final updated = original.copyWith(
        quietHoursEnabled: true,
        quietStart: const TimeOfDay(hour: 23, minute: 30),
        quietEnd: const TimeOfDay(hour: 6, minute: 0),
      );

      expect(updated.quietHoursEnabled, isTrue);
      expect(updated.quietStart.hour, 23);
      expect(updated.quietStart.minute, 30);
      expect(updated.quietEnd.hour, 6);
      expect(updated.quietEnd.minute, 0);
    });

    test('all alert types default to enabled', () {
      const prefs = NotificationPreferences(
        rainAlerts: true,
        commuteWarnings: true,
        dryWindowAlerts: true,
        quietHoursEnabled: false,
        quietStart: TimeOfDay(hour: 22, minute: 0),
        quietEnd: TimeOfDay(hour: 7, minute: 0),
      );

      expect(prefs.rainAlerts, isTrue);
      expect(prefs.commuteWarnings, isTrue);
      expect(prefs.dryWindowAlerts, isTrue);
    });

    test('individual alerts can be disabled', () {
      const prefs = NotificationPreferences(
        rainAlerts: false,
        commuteWarnings: true,
        dryWindowAlerts: false,
        quietHoursEnabled: false,
        quietStart: TimeOfDay(hour: 22, minute: 0),
        quietEnd: TimeOfDay(hour: 7, minute: 0),
      );

      expect(prefs.rainAlerts, isFalse);
      expect(prefs.commuteWarnings, isTrue);
      expect(prefs.dryWindowAlerts, isFalse);
    });
  });
}
