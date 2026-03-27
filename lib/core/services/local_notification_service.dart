import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin wrapper around [FlutterLocalNotificationsPlugin] that handles platform
/// initialisation and exposes simple show/cancel helpers.
class LocalNotificationService {
  LocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialized = false;

  // Channel IDs
  static const rainAlertChannel = 'dry_slots_rain_alert';
  static const commuteChannel = 'dry_slots_commute';
  static const dryWindowChannel = 'dry_slots_dry_window';

  // Notification IDs (stable so we can replace rather than stack).
  static const rainAlertId = 1001;
  static const commuteWarningId = 1002;
  static const dryWindowAlertId = 1003;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings);

    // Create Android notification channels.
    if (Platform.isAndroid) {
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            rainAlertChannel,
            'Rain Alerts',
            description: 'Heads-up when rain is approaching.',
            importance: Importance.high,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            commuteChannel,
            'Commute Weather',
            description: 'Weather warnings for your saved routines.',
            importance: Importance.high,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            dryWindowChannel,
            'Dry Windows',
            description: 'Alerts when a good dry window opens up.',
            importance: Importance.defaultImportance,
          ),
        );
      }
    }

    _initialized = true;
  }

  /// Show a "rain starting soon" notification.
  Future<void> showRainAlert({
    required String title,
    required String body,
  }) {
    return _show(
      id: rainAlertId,
      channelId: rainAlertChannel,
      channelName: 'Rain Alerts',
      title: title,
      body: body,
    );
  }

  /// Show a commute weather warning.
  Future<void> showCommuteWarning({
    required String title,
    required String body,
  }) {
    return _show(
      id: commuteWarningId,
      channelId: commuteChannel,
      channelName: 'Commute Weather',
      title: title,
      body: body,
    );
  }

  /// Show a "dry window opening" notification.
  Future<void> showDryWindowAlert({
    required String title,
    required String body,
  }) {
    return _show(
      id: dryWindowAlertId,
      channelId: dryWindowChannel,
      channelName: 'Dry Windows',
      title: title,
      body: body,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> _show({
    required int id,
    required String channelId,
    required String channelName,
    required String title,
    required String body,
  }) async {
    await initialize();
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});
