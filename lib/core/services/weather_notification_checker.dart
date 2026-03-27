import 'package:shared_preferences/shared_preferences.dart';

import '../../features/weather_core/domain/weather_models.dart';
import 'local_notification_service.dart';

/// Evaluates a [WeatherReport] and [WeatherGuidance] and fires local
/// notifications when conditions warrant a proactive alert.
///
/// Each alert type has a cooldown period so we avoid spamming the user.
class WeatherNotificationChecker {
  const WeatherNotificationChecker({
    required this.notificationService,
    required this.preferences,
  });

  final LocalNotificationService notificationService;
  final SharedPreferences preferences;

  static const _rainCooldownKey = 'dry_slots.notif.rain_cooldown';
  static const _commuteCooldownKey = 'dry_slots.notif.commute_cooldown';
  static const _dryCooldownKey = 'dry_slots.notif.dry_cooldown';
  static const _cooldownMinutes = 90;

  /// Run all checks against the latest report and guidance. Call this after
  /// every weather refresh (both foreground and background).
  Future<void> evaluate(
    WeatherReport report,
    WeatherGuidance guidance,
  ) async {
    await _checkRainApproaching(report, guidance);
    await _checkCommuteWarning(guidance);
    await _checkDryWindowOpening(guidance);
  }

  // ---------------------------------------------------------------------------
  // Rain approaching in the next 15 minutes
  // ---------------------------------------------------------------------------

  Future<void> _checkRainApproaching(
    WeatherReport report,
    WeatherGuidance guidance,
  ) async {
    if (_isOnCooldown(_rainCooldownKey)) return;

    final nextHour = guidance.nextHour;
    // Only fire if rain is imminent (within 15 min) and meaningful.
    if (nextHour.minutesUntilRain == null ||
        nextHour.minutesUntilRain! > 15 ||
        nextHour.maxPrecipitationMm < 0.15) {
      return;
    }

    final minutes = nextHour.minutesUntilRain!;
    final title = minutes <= 3
        ? 'Rain starting now'
        : 'Rain in about $minutes minutes';
    final body = nextHour.detail.isNotEmpty
        ? nextHour.detail
        : 'You might want to grab an umbrella.';

    await notificationService.showRainAlert(title: title, body: body);
    _setCooldown(_rainCooldownKey);
  }

  // ---------------------------------------------------------------------------
  // Commute window has a poor forecast
  // ---------------------------------------------------------------------------

  Future<void> _checkCommuteWarning(WeatherGuidance guidance) async {
    if (_isOnCooldown(_commuteCooldownKey)) return;

    // Find the next commute window with a poor score (< 40/100).
    final poorLeg = guidance.commute.windows
        .where((leg) => leg.score < 40 && leg.tone == AdviceTone.wait)
        .toList(growable: false);

    if (poorLeg.isEmpty) return;

    final worst = poorLeg.first;
    final title = '${worst.label} looks rough';
    final body =
        '${worst.summary}. Consider leaving earlier or adjusting plans.';

    await notificationService.showCommuteWarning(title: title, body: body);
    _setCooldown(_commuteCooldownKey);
  }

  // ---------------------------------------------------------------------------
  // A good dry window is opening soon
  // ---------------------------------------------------------------------------

  Future<void> _checkDryWindowOpening(WeatherGuidance guidance) async {
    if (_isOnCooldown(_dryCooldownKey)) return;

    final window = guidance.dryWindow;
    if (!window.isAvailable || window.start == null) return;

    final now = DateTime.now();
    final minutesUntilStart = window.start!.difference(now).inMinutes;

    // Only notify when the dry window starts within 30 minutes and lasts
    // a worthwhile amount of time.
    if (minutesUntilStart < 0 ||
        minutesUntilStart > 30 ||
        window.duration.inMinutes < 45) {
      return;
    }

    final durationLabel = window.duration.inMinutes >= 60
        ? '${window.duration.inHours}h ${window.duration.inMinutes.remainder(60)}m'
        : '${window.duration.inMinutes}m';

    final title = 'Dry window opening soon';
    final body =
        'A $durationLabel clear stretch starts in about $minutesUntilStart minutes. ${window.note}';

    await notificationService.showDryWindowAlert(title: title, body: body);
    _setCooldown(_dryCooldownKey);
  }

  // ---------------------------------------------------------------------------
  // Cooldown helpers
  // ---------------------------------------------------------------------------

  bool _isOnCooldown(String key) {
    final lastFired = preferences.getInt(key);
    if (lastFired == null) return false;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastFired;
    return elapsed < _cooldownMinutes * 60 * 1000;
  }

  void _setCooldown(String key) {
    preferences.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }
}
