import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../data/weather_local_store.dart';
import '../data/weather_repository.dart';
import '../domain/weather_advisor.dart';
import '../domain/weather_models.dart';
import '../domain/weather_repository.dart';

const _explanationModeKey = 'dry_slots.explanation_mode.v1';
const _unset = Object();

final weatherAdvisorProvider = Provider<WeatherAdvisor>((ref) {
  return const WeatherAdvisor();
});

final weatherDashboardControllerProvider =
    NotifierProvider<WeatherDashboardController, WeatherDashboardState>(
      WeatherDashboardController.new,
    );

class WeatherDashboardState {
  const WeatherDashboardState({
    required this.selectedLocation,
    required this.commuteWindows,
    required this.explanationMode,
    required this.comparisonLocation,
    required this.report,
    required this.guidance,
    required this.comparisonReport,
    required this.comparisonGuidance,
    required this.errorMessage,
    required this.isLoading,
    required this.isRefreshing,
  });

  final WeatherLocation selectedLocation;
  final List<SavedCommuteWindow> commuteWindows;
  final ExplanationMode explanationMode;
  final WeatherLocation? comparisonLocation;
  final WeatherReport? report;
  final WeatherGuidance? guidance;
  final WeatherReport? comparisonReport;
  final WeatherGuidance? comparisonGuidance;
  final String? errorMessage;
  final bool isLoading;
  final bool isRefreshing;

  bool get hasData => report != null && guidance != null;

  WeatherDashboardState copyWith({
    WeatherLocation? selectedLocation,
    List<SavedCommuteWindow>? commuteWindows,
    ExplanationMode? explanationMode,
    Object? comparisonLocation = _unset,
    Object? report = _unset,
    Object? guidance = _unset,
    Object? comparisonReport = _unset,
    Object? comparisonGuidance = _unset,
    Object? errorMessage = _unset,
    bool? isLoading,
    bool? isRefreshing,
  }) {
    return WeatherDashboardState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      commuteWindows: commuteWindows ?? this.commuteWindows,
      explanationMode: explanationMode ?? this.explanationMode,
      comparisonLocation: comparisonLocation == _unset
          ? this.comparisonLocation
          : comparisonLocation as WeatherLocation?,
      report: report == _unset ? this.report : report as WeatherReport?,
      guidance: guidance == _unset
          ? this.guidance
          : guidance as WeatherGuidance?,
      comparisonReport: comparisonReport == _unset
          ? this.comparisonReport
          : comparisonReport as WeatherReport?,
      comparisonGuidance: comparisonGuidance == _unset
          ? this.comparisonGuidance
          : comparisonGuidance as WeatherGuidance?,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class WeatherDashboardController extends Notifier<WeatherDashboardState> {
  int _requestSerial = 0;
  bool _didInitialize = false;

  WeatherRepository get _repository => ref.read(weatherRepositoryProvider);
  WeatherLocalStore get _localStore => ref.read(weatherLocalStoreProvider);
  WeatherAdvisor get _advisor => ref.read(weatherAdvisorProvider);

  @override
  WeatherDashboardState build() {
    final localStore = ref.watch(weatherLocalStoreProvider);
    final preferences = ref.watch(sharedPreferencesProvider);

    final selectedLocation =
        localStore.getSelectedLocation() ?? WeatherLocation.london;
    final commuteWindows = localStore.getCommuteWindows();
    final explanationMode = ExplanationMode.values.firstWhere(
      (mode) => mode.name == preferences.getString(_explanationModeKey),
      orElse: () => ExplanationMode.simple,
    );

    final rawComparisonLocation = localStore.getComparisonLocation();
    final comparisonLocation =
        rawComparisonLocation != null &&
            _sameLocation(rawComparisonLocation, selectedLocation)
        ? null
        : rawComparisonLocation;
    final report = localStore.getCachedReport(selectedLocation);
    final comparisonReport = comparisonLocation == null
        ? null
        : localStore.getCachedReport(comparisonLocation);

    final guidance = report == null
        ? null
        : _advisor.build(
            report,
            commuteWindows: commuteWindows,
            explanationMode: explanationMode,
          );
    final comparisonGuidance = comparisonReport == null
        ? null
        : _advisor.build(
            comparisonReport,
            commuteWindows: commuteWindows,
            explanationMode: explanationMode,
          );

    return WeatherDashboardState(
      selectedLocation: selectedLocation,
      commuteWindows: commuteWindows,
      explanationMode: explanationMode,
      comparisonLocation: comparisonLocation,
      report: report,
      guidance: guidance,
      comparisonReport: comparisonReport,
      comparisonGuidance: comparisonGuidance,
      errorMessage: null,
      isLoading: report == null,
      isRefreshing: false,
    );
  }

  Future<void> initialize() async {
    if (_didInitialize) {
      return;
    }
    _didInitialize = true;
    await refresh();
  }

  Future<void> saveCommuteWindows(List<SavedCommuteWindow> windows) async {
    final sanitized = windows.isEmpty ? SavedCommuteWindow.defaults : windows;
    state = state.copyWith(commuteWindows: sanitized);
    await _localStore.saveCommuteWindows(sanitized);
    _rebuildGuidance();
  }

  Future<void> setExplanationMode(ExplanationMode mode) async {
    if (state.explanationMode == mode) {
      return;
    }

    state = state.copyWith(explanationMode: mode);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_explanationModeKey, mode.name);
    _rebuildGuidance();
  }

  Future<void> setComparisonLocation(WeatherLocation? location) async {
    final sanitized =
        location == null || _sameLocation(location, state.selectedLocation)
        ? null
        : location;
    state = state.copyWith(
      comparisonLocation: sanitized,
      comparisonReport: sanitized == null ? null : state.comparisonReport,
      comparisonGuidance: sanitized == null ? null : state.comparisonGuidance,
    );
    await _localStore.saveComparisonLocation(sanitized);
    if (sanitized == null) {
      return;
    }

    final cached = _localStore.getCachedReport(sanitized);
    state = state.copyWith(
      comparisonReport: cached,
      comparisonGuidance: cached == null
          ? null
          : _advisor.build(
              cached,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            ),
    );
    await refresh();
  }

  Future<void> clearComparisonLocation() => setComparisonLocation(null);

  Future<void> refresh({WeatherLocation? location}) async {
    final nextLocation = location ?? state.selectedLocation;
    final locationChanged =
        location != null && !_sameLocation(location, state.selectedLocation);
    final sanitizedComparison =
        state.comparisonLocation != null &&
            _sameLocation(state.comparisonLocation!, nextLocation)
        ? null
        : state.comparisonLocation;

    final cachedReport = _localStore.getCachedReport(nextLocation);
    final cachedComparison = sanitizedComparison == null
        ? null
        : _localStore.getCachedReport(sanitizedComparison);

    state = state.copyWith(
      selectedLocation: nextLocation,
      comparisonLocation: sanitizedComparison,
      report: cachedReport ?? (locationChanged ? null : state.report),
      guidance: cachedReport == null
          ? (locationChanged ? null : state.guidance)
          : _advisor.build(
              cachedReport,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            ),
      comparisonReport:
          cachedComparison ??
          (sanitizedComparison == null ? null : state.comparisonReport),
      comparisonGuidance: cachedComparison == null
          ? (sanitizedComparison == null ? null : state.comparisonGuidance)
          : _advisor.build(
              cachedComparison,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            ),
      errorMessage: null,
      isLoading: !(cachedReport != null || state.hasData),
      isRefreshing: cachedReport != null || state.hasData,
    );

    final requestId = ++_requestSerial;
    try {
      final comparisonLocation = sanitizedComparison;
      final weatherFuture = _repository.fetchWeather(nextLocation);
      final comparisonFuture = comparisonLocation == null
          ? Future<WeatherReport?>.value(null)
          : _repository.fetchWeather(comparisonLocation);
      final weather = await weatherFuture;
      final comparisonWeather = await comparisonFuture;
      if (requestId != _requestSerial) {
        return;
      }

      final guidance = _advisor.build(
        weather,
        commuteWindows: state.commuteWindows,
        explanationMode: state.explanationMode,
      );
      final comparisonGuidance = comparisonWeather == null
          ? null
          : _advisor.build(
              comparisonWeather,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            );

      await _localStore.saveSelectedLocation(nextLocation);
      if (comparisonLocation == null) {
        await _localStore.saveComparisonLocation(null);
      }

      state = state.copyWith(
        selectedLocation: nextLocation,
        comparisonLocation: comparisonLocation,
        report: weather,
        guidance: guidance,
        comparisonReport: comparisonWeather,
        comparisonGuidance: comparisonGuidance,
        errorMessage: null,
        isLoading: false,
        isRefreshing: false,
      );
    } catch (_) {
      if (requestId != _requestSerial) {
        return;
      }

      state = state.copyWith(
        errorMessage: 'Unable to load weather right now.',
        isLoading: false,
        isRefreshing: false,
      );
    }
  }

  void _rebuildGuidance() {
    state = state.copyWith(
      guidance: state.report == null
          ? null
          : _advisor.build(
              state.report!,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            ),
      comparisonGuidance: state.comparisonReport == null
          ? null
          : _advisor.build(
              state.comparisonReport!,
              commuteWindows: state.commuteWindows,
              explanationMode: state.explanationMode,
            ),
    );
  }

  bool _sameLocation(WeatherLocation a, WeatherLocation b) {
    return (a.latitude - b.latitude).abs() < 0.001 &&
        (a.longitude - b.longitude).abs() < 0.001;
  }
}
