import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../weather_core/domain/weather_models.dart';

/// Syncs weather guidance data to the native home-screen widget via
/// [HomeWidget]. The native side reads shared key/value pairs and renders
/// them in the platform widget (iOS WidgetKit / Android Glance).
///
/// Keys are prefixed with `ds_` to avoid collisions.
class HomeWidgetService {
  const HomeWidgetService();

  static const _androidWidgetName = 'DrySlotsWidgetProvider';
  static const _iOSWidgetName = 'DrySlotsWidget';

  /// Pushes the latest weather guidance into the widget data store and
  /// triggers a native widget refresh.
  Future<void> update({
    required WeatherReport report,
    required WeatherGuidance guidance,
  }) async {
    // Dry window
    await HomeWidget.saveWidgetData<String>(
      'ds_dry_headline',
      guidance.dryWindow.headline,
    );
    await HomeWidget.saveWidgetData<String>(
      'ds_dry_note',
      guidance.dryWindow.note,
    );
    await HomeWidget.saveWidgetData<bool>(
      'ds_dry_available',
      guidance.dryWindow.isAvailable,
    );
    await HomeWidget.saveWidgetData<String>(
      'ds_dry_tone',
      guidance.dryWindow.tone.name,
    );
    await HomeWidget.saveWidgetData<int>(
      'ds_dry_duration_min',
      guidance.dryWindow.duration.inMinutes,
    );

    // Next hour
    await HomeWidget.saveWidgetData<String>(
      'ds_next_title',
      guidance.nextHour.title,
    );
    await HomeWidget.saveWidgetData<String>(
      'ds_next_advice',
      guidance.nextHour.departureAdvice,
    );
    await HomeWidget.saveWidgetData<String>(
      'ds_next_tone',
      guidance.nextHour.tone.name,
    );

    // Commute score (first window)
    if (guidance.commute.windows.isNotEmpty) {
      final first = guidance.commute.windows.first;
      await HomeWidget.saveWidgetData<String>(
        'ds_commute_label',
        first.label,
      );
      await HomeWidget.saveWidgetData<int>(
        'ds_commute_score',
        first.score,
      );
      await HomeWidget.saveWidgetData<String>(
        'ds_commute_summary',
        first.summary,
      );
      await HomeWidget.saveWidgetData<String>(
        'ds_commute_tone',
        first.tone.name,
      );
    }

    // Umbrella indicator
    final needsUmbrella = guidance.nextHour.tone == AdviceTone.wait ||
        (guidance.nextHour.minutesUntilRain != null &&
            guidance.nextHour.minutesUntilRain! <= 60);
    await HomeWidget.saveWidgetData<bool>(
      'ds_needs_umbrella',
      needsUmbrella,
    );

    // Temperature
    await HomeWidget.saveWidgetData<String>(
      'ds_temperature',
      '${report.current.temperatureC.round()}°',
    );

    // Location
    await HomeWidget.saveWidgetData<String>(
      'ds_location',
      report.location.name,
    );

    // Headline
    await HomeWidget.saveWidgetData<String>(
      'ds_headline',
      guidance.headline.title,
    );

    // Timestamp
    await HomeWidget.saveWidgetData<String>(
      'ds_updated_at',
      DateTime.now().toIso8601String(),
    );

    // Trigger native widget refresh.
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iOSWidgetName,
      qualifiedAndroidName: 'app.dryslots.$_androidWidgetName',
    );
  }
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return const HomeWidgetService();
});
