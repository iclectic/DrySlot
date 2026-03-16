import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/weather_repository.dart';
import '../domain/weather_advisor.dart';
import '../domain/weather_models.dart';

const _selectedLocationKey = 'dry_slots.selected_location.v1';
const _commuteWindowsKey = 'dry_slots.commute_windows.v1';
const _explanationModeKey = 'dry_slots.explanation_mode.v1';
const _comparisonLocationKey = 'dry_slots.comparison_location.v1';

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
  List<SavedCommuteWindow> _commuteWindows = SavedCommuteWindow.defaults;
  ExplanationMode _explanationMode = ExplanationMode.simple;
  WeatherLocation? _comparisonLocation;
  WeatherReport? _report;
  WeatherGuidance? _guidance;
  WeatherReport? _comparisonReport;
  WeatherGuidance? _comparisonGuidance;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isRefreshing = false;
  int _requestSerial = 0;

  WeatherLocation get selectedLocation => _selectedLocation;

  List<SavedCommuteWindow> get commuteWindows => List.unmodifiable(_commuteWindows);

  ExplanationMode get explanationMode => _explanationMode;

  WeatherLocation? get comparisonLocation => _comparisonLocation;

  WeatherReport? get report => _report;

  WeatherGuidance? get guidance => _guidance;

  WeatherReport? get comparisonReport => _comparisonReport;

  WeatherGuidance? get comparisonGuidance => _comparisonGuidance;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get hasData => _report != null && _guidance != null;

  Future<void> initialize() async {
    _restoreLocation();
    _restoreCommuteWindows();
    _restoreExplanationMode();
    _restoreComparisonLocation();
    await refresh();
  }

  Future<void> saveCommuteWindows(List<SavedCommuteWindow> windows) async {
    _commuteWindows = windows.isEmpty ? SavedCommuteWindow.defaults : windows;
    await _preferences.setString(
      _commuteWindowsKey,
      jsonEncode(
        _commuteWindows.map((window) => window.toJson()).toList(growable: false),
      ),
    );
    _rebuildGuidance();
    notifyListeners();
  }

  Future<void> setExplanationMode(ExplanationMode mode) async {
    if (_explanationMode == mode) {
      return;
    }

    _explanationMode = mode;
    await _preferences.setString(_explanationModeKey, mode.name);
    _rebuildGuidance();
    notifyListeners();
  }

  Future<void> setComparisonLocation(WeatherLocation? location) async {
    final sanitized = location == null || _sameLocation(location, _selectedLocation)
        ? null
        : location;
    _comparisonLocation = sanitized;
    if (sanitized == null) {
      await _preferences.remove(_comparisonLocationKey);
      _comparisonReport = null;
      _comparisonGuidance = null;
      notifyListeners();
      return;
    }

    await _preferences.setString(
      _comparisonLocationKey,
      jsonEncode(sanitized.toJson()),
    );
    await refresh();
  }

  Future<void> clearComparisonLocation() => setComparisonLocation(null);

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
      final comparisonLocation = _comparisonLocation != null &&
              !_sameLocation(_comparisonLocation!, _selectedLocation)
          ? _comparisonLocation
          : null;
      final weatherFuture = _repository.fetchWeather(_selectedLocation);
      final comparisonFuture = comparisonLocation == null
          ? Future<WeatherReport?>.value(null)
          : _repository.fetchWeather(comparisonLocation);
      final weather = await weatherFuture;
      final comparisonWeather = await comparisonFuture;
      final guidance = _advisor.build(
        weather,
        commuteWindows: _commuteWindows,
        explanationMode: _explanationMode,
      );
      final comparisonGuidance = comparisonWeather == null
          ? null
          : _advisor.build(
              comparisonWeather,
              commuteWindows: _commuteWindows,
              explanationMode: _explanationMode,
            );
      if (requestId != _requestSerial) {
        return;
      }
      _report = weather;
      _guidance = guidance;
      _comparisonReport = comparisonWeather;
      _comparisonGuidance = comparisonGuidance;
      _errorMessage = null;
      await _preferences.setString(
        _selectedLocationKey,
        jsonEncode(_selectedLocation.toJson()),
      );
      if (comparisonLocation == null && _comparisonLocation != null) {
        _comparisonLocation = null;
        await _preferences.remove(_comparisonLocationKey);
      }
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

  void _restoreCommuteWindows() {
    final raw = _preferences.getString(_commuteWindowsKey);
    if (raw == null || raw.isEmpty) {
      _commuteWindows = SavedCommuteWindow.defaults;
      return;
    }

    try {
      final json = jsonDecode(raw) as List<dynamic>;
      final windows = json
          .whereType<Map<String, dynamic>>()
          .map(SavedCommuteWindow.fromJson)
          .toList(growable: false);
      _commuteWindows = windows.isEmpty ? SavedCommuteWindow.defaults : windows;
    } catch (_) {
      _commuteWindows = SavedCommuteWindow.defaults;
    }
  }

  void _restoreExplanationMode() {
    final raw = _preferences.getString(_explanationModeKey);
    _explanationMode = ExplanationMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ExplanationMode.simple,
    );
  }

  void _restoreComparisonLocation() {
    final raw = _preferences.getString(_comparisonLocationKey);
    if (raw == null || raw.isEmpty) {
      _comparisonLocation = null;
      return;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final location = WeatherLocation.fromJson(json);
      _comparisonLocation = _sameLocation(location, _selectedLocation) ? null : location;
    } catch (_) {
      _comparisonLocation = null;
    }
  }

  void _rebuildGuidance() {
    if (_report == null) {
      return;
    }
    _guidance = _advisor.build(
      _report!,
      commuteWindows: _commuteWindows,
      explanationMode: _explanationMode,
    );
    if (_comparisonReport != null) {
      _comparisonGuidance = _advisor.build(
        _comparisonReport!,
        commuteWindows: _commuteWindows,
        explanationMode: _explanationMode,
      );
    }
  }

  bool _sameLocation(WeatherLocation a, WeatherLocation b) {
    return (a.latitude - b.latitude).abs() < 0.001 &&
        (a.longitude - b.longitude).abs() < 0.001;
  }
}
