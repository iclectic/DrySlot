import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'dry_slots.display.theme_mode.v2';
const _largeTextKey = 'dry_slots.display.large_text.v2';

class DisplaySettingsController extends ChangeNotifier {
  DisplaySettingsController({required SharedPreferences preferences})
      : _preferences = preferences {
    _restore();
  }

  final SharedPreferences _preferences;

  ThemeMode _themeMode = ThemeMode.system;
  bool _largeText = false;

  ThemeMode get themeMode => _themeMode;

  bool get largeText => _largeText;

  double get textScaleFactor => _largeText ? 1.16 : 1.0;

  Future<void> setThemeMode(ThemeMode value) async {
    if (_themeMode == value) {
      return;
    }

    _themeMode = value;
    await _preferences.setString(_themeModeKey, value.name);
    notifyListeners();
  }

  Future<void> setLargeText(bool value) async {
    if (_largeText == value) {
      return;
    }

    _largeText = value;
    await _preferences.setBool(_largeTextKey, value);
    notifyListeners();
  }

  void _restore() {
    final rawThemeMode = _preferences.getString(_themeModeKey);
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == rawThemeMode,
      orElse: () => ThemeMode.system,
    );
    _largeText = _preferences.getBool(_largeTextKey) ?? false;
  }
}
