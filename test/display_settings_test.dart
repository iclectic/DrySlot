import 'package:dry_slots/core/theme/display_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisplaySettingsState', () {
    test('defaults to system theme, no large text, no high contrast, no colorblind', () {
      const state = DisplaySettingsState(
        themeMode: ThemeMode.system,
        largeText: false,
        highContrast: false,
        colorblindSafe: false,
      );

      expect(state.themeMode, ThemeMode.system);
      expect(state.largeText, isFalse);
      expect(state.highContrast, isFalse);
      expect(state.colorblindSafe, isFalse);
    });

    test('copyWith overrides specified fields only', () {
      const state = DisplaySettingsState(
        themeMode: ThemeMode.system,
        largeText: false,
        highContrast: false,
        colorblindSafe: false,
      );

      final updated = state.copyWith(
        themeMode: ThemeMode.dark,
        colorblindSafe: true,
      );

      expect(updated.themeMode, ThemeMode.dark);
      expect(updated.largeText, isFalse);
      expect(updated.highContrast, isFalse);
      expect(updated.colorblindSafe, isTrue);
    });

    test('copyWith preserves all fields when none specified', () {
      const state = DisplaySettingsState(
        themeMode: ThemeMode.light,
        largeText: true,
        highContrast: true,
        colorblindSafe: true,
      );

      final updated = state.copyWith();

      expect(updated.themeMode, ThemeMode.light);
      expect(updated.largeText, isTrue);
      expect(updated.highContrast, isTrue);
      expect(updated.colorblindSafe, isTrue);
    });
  });
}
