import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

const _onboardingCompletedKey = 'dry_slots.onboarding.completed.v1';
const _notificationsEnabledKey = 'dry_slots.notifications.enabled.v1';
const _routineSupportKey = 'dry_slots.routines.enabled.v1';

final appPreferencesControllerProvider =
    NotifierProvider<AppPreferencesController, AppPreferencesState>(
      AppPreferencesController.new,
    );

class AppPreferencesState {
  const AppPreferencesState({
    required this.onboardingCompleted,
    required this.notificationsEnabled,
    required this.routineSupportEnabled,
  });

  final bool onboardingCompleted;
  final bool notificationsEnabled;
  final bool routineSupportEnabled;

  AppPreferencesState copyWith({
    bool? onboardingCompleted,
    bool? notificationsEnabled,
    bool? routineSupportEnabled,
  }) {
    return AppPreferencesState(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      routineSupportEnabled:
          routineSupportEnabled ?? this.routineSupportEnabled,
    );
  }
}

class AppPreferencesController extends Notifier<AppPreferencesState> {
  @override
  AppPreferencesState build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    return AppPreferencesState(
      onboardingCompleted:
          preferences.getBool(_onboardingCompletedKey) ?? false,
      notificationsEnabled:
          preferences.getBool(_notificationsEnabledKey) ?? false,
      routineSupportEnabled: preferences.getBool(_routineSupportKey) ?? true,
    );
  }

  Future<void> completeOnboarding({
    required bool notificationsEnabled,
    required bool routineSupportEnabled,
  }) async {
    state = state.copyWith(
      onboardingCompleted: true,
      notificationsEnabled: notificationsEnabled,
      routineSupportEnabled: routineSupportEnabled,
    );
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setBool(_onboardingCompletedKey, true);
    await preferences.setBool(_notificationsEnabledKey, notificationsEnabled);
    await preferences.setBool(_routineSupportKey, routineSupportEnabled);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_notificationsEnabledKey, value);
  }

  Future<void> setRoutineSupportEnabled(bool value) async {
    state = state.copyWith(routineSupportEnabled: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_routineSupportKey, value);
  }
}
