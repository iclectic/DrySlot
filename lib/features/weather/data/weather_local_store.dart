import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../domain/weather_models.dart';
import 'weather_provider_config.dart';

class WeatherLocalStore {
  WeatherLocalStore(this._box);

  static const boxName = 'dry_slots.weather';
  static const selectedLocationKey = 'selected_location.v2';
  static const comparisonLocationKey = 'comparison_location.v2';
  static const commuteWindowsKey = 'commute_windows.v2';

  final Box<String> _box;

  WeatherLocation? getSelectedLocation() {
    return _readObject(
      selectedLocationKey,
      (json) => WeatherLocation.fromJson(json),
    );
  }

  Future<void> saveSelectedLocation(WeatherLocation location) {
    return _box.put(selectedLocationKey, jsonEncode(location.toJson()));
  }

  WeatherLocation? getComparisonLocation() {
    return _readObject(
      comparisonLocationKey,
      (json) => WeatherLocation.fromJson(json),
    );
  }

  Future<void> saveComparisonLocation(WeatherLocation? location) async {
    if (location == null) {
      await _box.delete(comparisonLocationKey);
      return;
    }
    await _box.put(comparisonLocationKey, jsonEncode(location.toJson()));
  }

  List<SavedCommuteWindow> getCommuteWindows() {
    final raw = _box.get(commuteWindowsKey);
    if (raw == null || raw.isEmpty) {
      return SavedCommuteWindow.defaults;
    }

    try {
      final json = jsonDecode(raw) as List<dynamic>;
      final windows = json
          .whereType<Map<String, dynamic>>()
          .map(SavedCommuteWindow.fromJson)
          .toList(growable: false);
      return windows.isEmpty ? SavedCommuteWindow.defaults : windows;
    } catch (_) {
      return SavedCommuteWindow.defaults;
    }
  }

  Future<void> saveCommuteWindows(List<SavedCommuteWindow> windows) {
    final sanitized = windows.isEmpty ? SavedCommuteWindow.defaults : windows;
    return _box.put(
      commuteWindowsKey,
      jsonEncode(
        sanitized.map((window) => window.toJson()).toList(growable: false),
      ),
    );
  }

  WeatherReport? getCachedReport(
    WeatherLocation location, {
    WeatherDataProvider provider = WeatherDataProvider.openMeteo,
  }) {
    return _readObject(
      _reportKey(location, provider),
      (json) => WeatherReport.fromJson(json),
    );
  }

  Future<void> cacheReport(
    WeatherReport report, {
    required WeatherDataProvider provider,
  }) {
    return _box.put(
      _reportKey(report.location, provider),
      jsonEncode(report.toJson()),
    );
  }

  T? _readObject<T>(String key, T Function(Map<String, dynamic>) builder) {
    final raw = _box.get(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return builder(json);
    } catch (_) {
      return null;
    }
  }

  String _reportKey(WeatherLocation location, WeatherDataProvider provider) {
    final latitude = location.latitude.toStringAsFixed(3);
    final longitude = location.longitude.toStringAsFixed(3);
    return 'report.${provider.cacheKey}.$latitude.$longitude';
  }
}
