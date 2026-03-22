import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/weather_core/domain/weather_models.dart';
import 'analytics_settings_controller.dart';

final analyticsSinkProvider = Provider<AnalyticsSink>((ref) {
  return const DebugAnalyticsSink();
});

final appAnalyticsProvider = Provider<AppAnalytics>((ref) {
  final enabled = ref.watch(analyticsSettingsControllerProvider).enabled;
  final sink = ref.watch(analyticsSinkProvider);
  return AppAnalytics(enabled: enabled, sink: sink);
});

enum NotificationEngagementType { opened, dismissed, actionTapped }

class AnalyticsEvent {
  const AnalyticsEvent({required this.name, required this.parameters});

  final String name;
  final Map<String, Object> parameters;
}

abstract interface class AnalyticsSink {
  Future<void> record(AnalyticsEvent event);
}

class DebugAnalyticsSink implements AnalyticsSink {
  const DebugAnalyticsSink();

  @override
  Future<void> record(AnalyticsEvent event) async {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[Analytics] ${event.name} ${jsonEncode(event.parameters)}');
  }
}

class AppAnalytics {
  const AppAnalytics({required this.enabled, required this.sink});

  final bool enabled;
  final AnalyticsSink sink;

  Future<void> trackBestDrySlotViewed({required DryWindowInsight window}) {
    return _track('best_dry_slot_viewed', <String, Object?>{
      'slot_available': window.isAvailable,
      'duration_minutes': window.duration.inMinutes,
      'tone': window.tone,
    });
  }

  Future<void> trackRoutineCreated({
    required int createdCount,
    required int totalCount,
  }) {
    return _track('routine_created', <String, Object?>{
      'created_count': createdCount,
      'total_count': totalCount,
    });
  }

  Future<void> trackCommuteChecked({required int routineCount}) {
    return _track('commute_checked', <String, Object?>{
      'routine_count': routineCount,
    });
  }

  Future<void> trackActivityCardTapped({
    required ActivityRecommendation activity,
  }) {
    return _track('activity_card_tapped', <String, Object?>{
      'activity_name': activity.name,
      'score': activity.score,
      'suitability': activity.suitability,
    });
  }

  Future<void> trackNotificationEngagement({
    required NotificationEngagementType type,
    required String surface,
  }) {
    return _track('notification_engagement', <String, Object?>{
      'type': type,
      'surface': surface,
    });
  }

  Future<void> _track(String name, Map<String, Object?> parameters) async {
    if (!enabled) {
      return;
    }

    await sink.record(
      AnalyticsEvent(name: name, parameters: _sanitizeParameters(parameters)),
    );
  }

  Map<String, Object> _sanitizeParameters(Map<String, Object?> input) {
    final sanitized = <String, Object>{};
    for (final entry in input.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }

      sanitized[entry.key] = switch (value) {
        bool() || int() || double() || String() => value,
        Enum() => value.name,
        Duration() => value.inMinutes,
        _ => value.toString(),
      };
    }
    return sanitized;
  }
}
