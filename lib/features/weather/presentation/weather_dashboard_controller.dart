import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/weather_repository.dart';
import '../domain/weather_advisor.dart';
import '../domain/weather_models.dart';

const _selectedLocationKey = 'dry_slots.selected_location.v1';

class WeatherDashboardController extends ChangeNotifier {
  WeatherDashboardController({
    required WeatherRepository repository,
    required SharedPreferences preferences,
    WeatherAdvisor advisor = const WeatherAdvisor(),
  })  : _repository = repository,
        _preferences = preferences,
        _advisor = advisor;

  final WeatherRepository _repository;
  final SharedPreferences _preferences;
  final WeatherAdvisor _advisor;

  WeatherLocation _selectedLocation = WeatherLocation.london;
  WeatherReport? _report;
  WeatherGuidance? _guidance;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isRefreshing = false;
  int _requestSerial = 0;

  WeatherLocation get selectedLocation => _selectedLocation;

  WeatherReport? get report => _report;

  WeatherGuidance? get guidance => _guidance;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get hasData => _report != null && _guidance != null;

  Future<void> initialize() async {
    _restoreLocation();
    await refresh();
  }

  Future<void> refresh({WeatherLocation? location}) async {
    if (location != null) {
      _selectedLocation = location;
    }

    _errorMessage = null;
    final requestId = ++_requestSerial;
    if (_report == null) {
      _isLoading = true;
    } else {
      _isRefreshing = true;
    }
    notifyListeners();

    try {
      final weather = await _repository.fetchWeather(_selectedLocation);
      final guidance = _advisor.build(weather);
      if (requestId != _requestSerial) {
        return;
      }
      _report = weather;
      _guidance = guidance;
      _errorMessage = null;
      await _preferences.setString(
        _selectedLocationKey,
        jsonEncode(_selectedLocation.toJson()),
      );
    } catch (_) {
      if (requestId != _requestSerial) {
        return;
      }
      _errorMessage = 'Unable to load weather right now.';
    } finally {
      if (requestId == _requestSerial) {
        _isLoading = false;
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  void _restoreLocation() {
    final raw = _preferences.getString(_selectedLocationKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _selectedLocation = WeatherLocation.fromJson(json);
    } catch (_) {
      _selectedLocation = WeatherLocation.london;
    }
  }
}
