import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

part 'display_settings_controller.freezed.dart';

const _themeModeKey = 'dry_slots.display.theme_mode.v2';
const _largeTextKey = 'dry_slots.display.large_text.v2';
const _highContrastKey = 'dry_slots.display.high_contrast.v1';
const _colorblindSafeKey = 'dry_slots.display.colorblind_safe.v1';

final displaySettingsControllerProvider =
    NotifierProvider<DisplaySettingsController, DisplaySettingsState>(
      DisplaySettingsController.new,
    );

@freezed
abstract class DisplaySettingsState with _$DisplaySettingsState {
  const DisplaySettingsState._();

  const factory DisplaySettingsState({
    required ThemeMode themeMode,
    required bool largeText,
    required bool highContrast,
    required bool colorblindSafe,
  }) = _DisplaySettingsState;

  double get textScaleFactor => largeText ? 1.16 : 1.0;
}

class DisplaySettingsController extends Notifier<DisplaySettingsState> {
  @override
  DisplaySettingsState build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final rawThemeMode = preferences.getString(_themeModeKey);
    final themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == rawThemeMode,
      orElse: () => ThemeMode.system,
    );
    final largeText = preferences.getBool(_largeTextKey) ?? false;
    final highContrast = preferences.getBool(_highContrastKey) ?? false;
    final colorblindSafe = preferences.getBool(_colorblindSafeKey) ?? false;
    return DisplaySettingsState(
      themeMode: themeMode,
      largeText: largeText,
      highContrast: highContrast,
      colorblindSafe: colorblindSafe,
    );
  }

  Future<void> setThemeMode(ThemeMode value) async {
    if (state.themeMode == value) {
      return;
    }

    state = state.copyWith(themeMode: value);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_themeModeKey, value.name);
  }

  Future<void> setLargeText(bool value) async {
    if (state.largeText == value) {
      return;
    }

    state = state.copyWith(largeText: value);
    await ref.read(sharedPreferencesProvider).setBool(_largeTextKey, value);
  }

  Future<void> setHighContrast(bool value) async {
    if (state.highContrast == value) {
      return;
    }

    state = state.copyWith(highContrast: value);
    await ref.read(sharedPreferencesProvider).setBool(_highContrastKey, value);
  }

  Future<void> setColorblindSafe(bool value) async {
    if (state.colorblindSafe == value) {
      return;
    }

    state = state.copyWith(colorblindSafe: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_colorblindSafeKey, value);
  }
}
