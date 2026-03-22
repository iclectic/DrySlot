import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../features/weather_core/domain/weather_models.dart';

final deviceLocationServiceProvider = Provider<DeviceLocationService>((ref) {
  return const DeviceLocationService();
});

enum DeviceLocationStatus {
  granted,
  denied,
  deniedForever,
  servicesDisabled,
  unavailable,
}

class DeviceLocationResult {
  const DeviceLocationResult({
    required this.status,
    required this.message,
    this.location,
  });

  final DeviceLocationStatus status;
  final String message;
  final WeatherLocation? location;

  bool get isSuccess => location != null;

  bool get canOpenSettings =>
      status == DeviceLocationStatus.deniedForever ||
      status == DeviceLocationStatus.servicesDisabled;
}

class DeviceLocationService {
  const DeviceLocationService();

  Future<DeviceLocationResult> fetchCurrentLocation() async {
    final servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return const DeviceLocationResult(
        status: DeviceLocationStatus.servicesDisabled,
        message: 'Location services are turned off on this device.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return const DeviceLocationResult(
        status: DeviceLocationStatus.denied,
        message:
            'Location permission was not granted, so Dry Slots cannot use your current place yet.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      return const DeviceLocationResult(
        status: DeviceLocationStatus.deniedForever,
        message:
            'Location permission is blocked. Open app settings to allow current-location weather.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );

      Placemark? placemark;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          placemark = placemarks.first;
        }
      } catch (_) {
        placemark = null;
      }

      final location = WeatherLocation(
        name: _firstNonEmpty(<String?>[
          placemark?.locality,
          placemark?.subAdministrativeArea,
          placemark?.administrativeArea,
          'Current location',
        ], fallback: 'Current location'),
        region: _firstNonEmpty(<String?>[
          placemark?.administrativeArea,
          placemark?.subAdministrativeArea,
          '',
        ], fallback: ''),
        country: _firstNonEmpty(<String?>[
          placemark?.country,
          'United Kingdom',
        ], fallback: 'United Kingdom'),
        latitude: position.latitude,
        longitude: position.longitude,
        timezone: 'auto',
      );

      return DeviceLocationResult(
        status: DeviceLocationStatus.granted,
        message: 'Using ${location.name} for local weather guidance.',
        location: location,
      );
    } catch (_) {
      return const DeviceLocationResult(
        status: DeviceLocationStatus.unavailable,
        message:
            'Dry Slots could not resolve your current location just now. You can still search manually.',
      );
    }
  }

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  String _firstNonEmpty(List<String?> values, {required String fallback}) {
    return values
        .map((value) => value?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty, orElse: () => fallback);
  }
}
