import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../weather_core/domain/weather_models.dart';

/// A self-contained branded card designed for screenshot / share rendering.
///
/// Wrapped in a [RepaintBoundary] keyed by [boundaryKey] so the parent can
/// capture it as an image with [ShareCardService].
class ShareableCard extends StatelessWidget {
  const ShareableCard({
    super.key,
    required this.boundaryKey,
    required this.variant,
  });

  final GlobalKey boundaryKey;
  final ShareableCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: boundaryKey,
      child: _CardShell(child: variant.build(context)),
    );
  }
}

/// A card shell that provides the branded background, padding, and logo
/// footer so every share variant looks consistent.
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppPalette.midnight,
            Color(0xFF0D2231),
            AppPalette.deepSea,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          child,
          const SizedBox(height: 24),
          const _BrandFooter(),
        ],
      ),
    );
  }
}

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: AppPalette.sky.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.wb_sunny_rounded,
            size: 16,
            color: AppPalette.sky,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Dry Slots',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppPalette.sky,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        Text(
          'dryslots.app',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppPalette.muted,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shareable card variants
// ---------------------------------------------------------------------------

sealed class ShareableCardVariant {
  const ShareableCardVariant();

  Widget build(BuildContext context);

  /// Plain-text description for the share sheet message.
  String get shareText;
}

/// Shares the best dry window insight.
class DryWindowShareVariant extends ShareableCardVariant {
  const DryWindowShareVariant({
    required this.dryWindow,
    required this.locationName,
  });

  final DryWindowInsight dryWindow;
  final String locationName;

  @override
  String get shareText =>
      'Dry Slots – $locationName: ${dryWindow.headline}. ${dryWindow.note}';

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(dryWindow.tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Eyebrow(text: 'BEST DRY WINDOW', icon: Icons.wb_sunny_outlined),
        const SizedBox(height: 6),
        _Location(name: locationName),
        const SizedBox(height: 16),
        Text(
          dryWindow.headline,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.6,
          ),
        ),
        if (dryWindow.isAvailable &&
            dryWindow.start != null &&
            dryWindow.end != null) ...<Widget>[
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              _Pill(
                color: toneColor,
                label: formatDurationShort(dryWindow.duration),
              ),
              const SizedBox(width: 10),
              _Pill(
                color: AppPalette.sky,
                label: dryWindow.confidenceLabel,
              ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Text(
          dryWindow.note,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppPalette.muted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Shares the next-hour rain insight.
class NextHourShareVariant extends ShareableCardVariant {
  const NextHourShareVariant({
    required this.nextHour,
    required this.locationName,
  });

  final NextHourInsight nextHour;
  final String locationName;

  @override
  String get shareText =>
      'Dry Slots – $locationName: ${nextHour.title}. ${nextHour.detail}';

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(nextHour.tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Eyebrow(text: 'NEXT HOUR RAIN', icon: Icons.timeline_rounded),
        const SizedBox(height: 6),
        _Location(name: locationName),
        const SizedBox(height: 16),
        Text(
          nextHour.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 12),
        _Pill(color: toneColor, label: nextHour.departureAdvice),
        const SizedBox(height: 14),
        Text(
          nextHour.detail,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppPalette.muted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Shares the commute overview.
class CommuteShareVariant extends ShareableCardVariant {
  const CommuteShareVariant({
    required this.commute,
    required this.locationName,
  });

  final CommuteOverview commute;
  final String locationName;

  @override
  String get shareText =>
      'Dry Slots – $locationName commute: ${commute.summary}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Eyebrow(text: 'COMMUTE', icon: Icons.commute_rounded),
        const SizedBox(height: 6),
        _Location(name: locationName),
        const SizedBox(height: 16),
        Text(
          commute.summary,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        ...commute.windows.take(4).map((leg) {
          final toneColor = _toneColor(leg.tone);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                _Pill(color: toneColor, label: '${leg.score}/100'),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${leg.label} • ${leg.summary}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppPalette.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/// Shares the weekend planner.
class WeekendShareVariant extends ShareableCardVariant {
  const WeekendShareVariant({
    required this.planner,
    required this.locationName,
  });

  final WeekendPlanner planner;
  final String locationName;

  @override
  String get shareText =>
      'Dry Slots – $locationName weekend: ${planner.summary}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Eyebrow(
          text: 'WEEKEND PLANNER',
          icon: Icons.calendar_view_week_rounded,
        ),
        const SizedBox(height: 6),
        _Location(name: locationName),
        const SizedBox(height: 16),
        Text(
          planner.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          planner.summary,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppPalette.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        ...planner.days.map((day) {
          final toneColor = _toneColor(day.tone);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(day.icon, color: toneColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          day.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day.headline,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Pill(color: toneColor, label: '${day.maxTempC.round()}°'),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared internal widgets
// ---------------------------------------------------------------------------

Color _toneColor(AdviceTone tone) => switch (tone) {
  AdviceTone.go => AppPalette.teal,
  AdviceTone.watch => AppPalette.amber,
  AdviceTone.wait => AppPalette.coral,
};

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: AppPalette.sky),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppPalette.sky,
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.place_rounded, size: 14, color: AppPalette.muted),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppPalette.muted,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
