import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>((ref) {
      return const NotificationPermissionService();
    });

enum NotificationPermissionState {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}

class NotificationPermissionResult {
  const NotificationPermissionResult({
    required this.state,
    required this.message,
  });

  final NotificationPermissionState state;
  final String message;

  bool get isGranted => state == NotificationPermissionState.granted;

  bool get canOpenSettings =>
      state == NotificationPermissionState.permanentlyDenied ||
      state == NotificationPermissionState.restricted;
}

class NotificationPermissionService {
  const NotificationPermissionService();

  Future<NotificationPermissionResult> requestPermission() async {
    final status = await Permission.notification.request();
    return _map(status);
  }

  Future<NotificationPermissionResult> currentStatus() async {
    final status = await Permission.notification.status;
    return _map(status);
  }

  Future<void> openSettings() => openAppSettings();

  NotificationPermissionResult _map(PermissionStatus status) {
    if (status.isGranted) {
      return const NotificationPermissionResult(
        state: NotificationPermissionState.granted,
        message:
            'Notifications are allowed for weather prompts and routine nudges.',
      );
    }
    if (status.isPermanentlyDenied) {
      return const NotificationPermissionResult(
        state: NotificationPermissionState.permanentlyDenied,
        message:
            'Notification access is blocked. Open app settings if you want Dry Slots to alert you later.',
      );
    }
    if (status.isRestricted) {
      return const NotificationPermissionResult(
        state: NotificationPermissionState.restricted,
        message: 'Notification access is restricted on this device right now.',
      );
    }
    if (status.isLimited || status.isProvisional) {
      return const NotificationPermissionResult(
        state: NotificationPermissionState.limited,
        message: 'Notifications are only partly available on this device.',
      );
    }
    return const NotificationPermissionResult(
      state: NotificationPermissionState.denied,
      message:
          'Notifications are off for now. You can still use Dry Slots without them.',
    );
  }
}
