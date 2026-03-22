import 'package:dry_slots/core/analytics/app_analytics.dart';
import 'package:dry_slots/features/weather_core/domain/weather_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not record analytics events when disabled', () async {
    final sink = _FakeAnalyticsSink();
    final analytics = AppAnalytics(enabled: false, sink: sink);

    await analytics.trackCommuteChecked(routineCount: 3);

    expect(sink.events, isEmpty);
  });

  test('records sanitized activity tap payloads when enabled', () async {
    final sink = _FakeAnalyticsSink();
    final analytics = AppAnalytics(enabled: true, sink: sink);

    await analytics.trackActivityCardTapped(
      activity: const ActivityRecommendation(
        name: 'Dog walk',
        score: 8,
        detail: 'A dry, comfortable hour for a longer walk.',
        suitability: ActivitySuitability.great,
        icon: Icons.pets_rounded,
      ),
    );

    expect(sink.events, hasLength(1));
    expect(sink.events.single.name, 'activity_card_tapped');
    expect(sink.events.single.parameters, <String, Object>{
      'activity_name': 'Dog walk',
      'score': 8,
      'suitability': 'great',
    });
  });

  test(
    'keeps notification engagement hooks available for future alerts',
    () async {
      final sink = _FakeAnalyticsSink();
      final analytics = AppAnalytics(enabled: true, sink: sink);

      await analytics.trackNotificationEngagement(
        type: NotificationEngagementType.opened,
        surface: 'routine_alert',
      );

      expect(sink.events.single.name, 'notification_engagement');
      expect(sink.events.single.parameters['type'], 'opened');
      expect(sink.events.single.parameters['surface'], 'routine_alert');
    },
  );
}

class _FakeAnalyticsSink implements AnalyticsSink {
  final List<AnalyticsEvent> events = <AnalyticsEvent>[];

  @override
  Future<void> record(AnalyticsEvent event) async {
    events.add(event);
  }
}
