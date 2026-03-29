import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

const _rainAlertsKey = 'dry_slots.notif_pref.rain_alerts.v1';
const _commuteWarningsKey = 'dry_slots.notif_pref.commute_warnings.v1';
const _dryWindowAlertsKey = 'dry_slots.notif_pref.dry_window_alerts.v1';
const _quietStartKey = 'dry_slots.notif_pref.quiet_start.v1';
const _quietEndKey = 'dry_slots.notif_pref.quiet_end.v1';
const _quietEnabledKey = 'dry_slots.notif_pref.quiet_enabled.v1';

final notificationPreferencesProvider =
    NotifierProvider<NotificationPreferencesController, NotificationPreferences>(
      NotificationPreferencesController.new,
    );

class NotificationPreferences {
  const NotificationPreferences({
    required this.rainAlerts,
    required this.commuteWarnings,
    required this.dryWindowAlerts,
    required this.quietHoursEnabled,
    required this.quietStart,
    required this.quietEnd,
  });

  final bool rainAlerts;
  final bool commuteWarnings;
  final bool dryWindowAlerts;
  final bool quietHoursEnabled;
  final TimeOfDay quietStart;
  final TimeOfDay quietEnd;

  /// Returns true if the current time falls within the quiet window.
  bool get isInQuietHours {
    if (!quietHoursEnabled) return false;

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = quietStart.hour * 60 + quietStart.minute;
    final endMinutes = quietEnd.hour * 60 + quietEnd.minute;

    if (startMinutes <= endMinutes) {
      // e.g. 22:00 – 23:00
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    } else {
      // Wraps midnight, e.g. 22:00 – 07:00
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    }
  }

  NotificationPreferences copyWith({
    bool? rainAlerts,
    bool? commuteWarnings,
    bool? dryWindowAlerts,
    bool? quietHoursEnabled,
    TimeOfDay? quietStart,
    TimeOfDay? quietEnd,
  }) {
    return NotificationPreferences(
      rainAlerts: rainAlerts ?? this.rainAlerts,
      commuteWarnings: commuteWarnings ?? this.commuteWarnings,
      dryWindowAlerts: dryWindowAlerts ?? this.dryWindowAlerts,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
    );
  }
}

class NotificationPreferencesController
    extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return NotificationPreferences(
      rainAlerts: prefs.getBool(_rainAlertsKey) ?? true,
      commuteWarnings: prefs.getBool(_commuteWarningsKey) ?? true,
      dryWindowAlerts: prefs.getBool(_dryWindowAlertsKey) ?? true,
      quietHoursEnabled: prefs.getBool(_quietEnabledKey) ?? false,
      quietStart: _readTime(prefs.getString(_quietStartKey), fallback: const TimeOfDay(hour: 22, minute: 0)),
      quietEnd: _readTime(prefs.getString(_quietEndKey), fallback: const TimeOfDay(hour: 7, minute: 0)),
    );
  }

  Future<void> setRainAlerts(bool value) async {
    state = state.copyWith(rainAlerts: value);
    await ref.read(sharedPreferencesProvider).setBool(_rainAlertsKey, value);
  }

  Future<void> setCommuteWarnings(bool value) async {
    state = state.copyWith(commuteWarnings: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_commuteWarningsKey, value);
  }

  Future<void> setDryWindowAlerts(bool value) async {
    state = state.copyWith(dryWindowAlerts: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_dryWindowAlertsKey, value);
  }

  Future<void> setQuietHoursEnabled(bool value) async {
    state = state.copyWith(quietHoursEnabled: value);
    await ref.read(sharedPreferencesProvider).setBool(_quietEnabledKey, value);
  }

  Future<void> setQuietStart(TimeOfDay time) async {
    state = state.copyWith(quietStart: time);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_quietStartKey, _writeTime(time));
  }

  Future<void> setQuietEnd(TimeOfDay time) async {
    state = state.copyWith(quietEnd: time);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_quietEndKey, _writeTime(time));
  }

  static TimeOfDay _readTime(String? raw, {required TimeOfDay fallback}) {
    if (raw == null) return fallback;
    final parts = raw.split(':');
    if (parts.length != 2) return fallback;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? fallback.hour,
      minute: int.tryParse(parts[1]) ?? fallback.minute,
    );
  }

  static String _writeTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
