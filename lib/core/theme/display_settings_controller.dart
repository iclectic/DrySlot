import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

const _themeModeKey = 'dry_slots.display.theme_mode.v2';
const _largeTextKey = 'dry_slots.display.large_text.v2';

final displaySettingsControllerProvider =
    NotifierProvider<DisplaySettingsController, DisplaySettingsState>(
      DisplaySettingsController.new,
    );

class DisplaySettingsState {
  const DisplaySettingsState({
    required this.themeMode,
    required this.largeText,
  });

  final ThemeMode themeMode;
  final bool largeText;

  double get textScaleFactor => largeText ? 1.16 : 1.0;

  DisplaySettingsState copyWith({ThemeMode? themeMode, bool? largeText}) {
    return DisplaySettingsState(
      themeMode: themeMode ?? this.themeMode,
      largeText: largeText ?? this.largeText,
    );
  }
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
    return DisplaySettingsState(themeMode: themeMode, largeText: largeText);
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
}
