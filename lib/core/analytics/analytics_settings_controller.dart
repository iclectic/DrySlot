import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

part 'analytics_settings_controller.freezed.dart';

const _analyticsEnabledKey = 'dry_slots.analytics.enabled.v1';

final analyticsSettingsControllerProvider =
    NotifierProvider<AnalyticsSettingsController, AnalyticsSettingsState>(
      AnalyticsSettingsController.new,
    );

@freezed
abstract class AnalyticsSettingsState with _$AnalyticsSettingsState {
  const factory AnalyticsSettingsState({required bool enabled}) =
      _AnalyticsSettingsState;
}

class AnalyticsSettingsController extends Notifier<AnalyticsSettingsState> {
  @override
  AnalyticsSettingsState build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final enabled = preferences.getBool(_analyticsEnabledKey) ?? false;
    return AnalyticsSettingsState(enabled: enabled);
  }

  Future<void> setEnabled(bool value) async {
    if (state.enabled == value) {
      return;
    }

    state = state.copyWith(enabled: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_analyticsEnabledKey, value);
  }
}
