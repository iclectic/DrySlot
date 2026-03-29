import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../../core/widgets/weather_state_guard.dart';
import '../../weather_core/domain/weather_models.dart';

class WidgetPreviewPage extends StatelessWidget {
  const WidgetPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AtmosphericScaffold(
      title: 'Widget preview',
      subtitle:
          'This is how your home-screen widgets will look. Add them from your device\u2019s widget picker.',
      showBack: true,
      body: WeatherStateGuard(
        builder: (context, ref, state, report, guidance) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: <Widget>[
              Text(
                'Small widgets',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _SmallWidget(
                    icon: Icons.umbrella_rounded,
                    label: 'Umbrella',
                    value: guidance.nextHour.tone == AdviceTone.wait ||
                            (guidance.nextHour.minutesUntilRain != null &&
                                guidance.nextHour.minutesUntilRain! <= 60)
                        ? 'Take one'
                        : 'Leave it',
                    tone: guidance.nextHour.tone,
                  ),
                  _SmallWidget(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Dry window',
                    value: guidance.dryWindow.isAvailable
                        ? formatDurationShort(guidance.dryWindow.duration)
                        : 'None',
                    tone: guidance.dryWindow.tone,
                  ),
                  if (guidance.commute.windows.isNotEmpty)
                    _SmallWidget(
                      icon: Icons.commute_rounded,
                      label: 'Commute',
                      value: '${guidance.commute.windows.first.score}/100',
                      tone: guidance.commute.windows.first.tone,
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Medium widget',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _MediumWidget(report: report, guidance: guidance),
              const SizedBox(height: 28),
              Text(
                'Large widget',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _LargeWidget(report: report, guidance: guidance),
              const SizedBox(height: 28),
              Text(
                'All glance cards',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...guidance.homeCards.map(
                (card) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GlanceCard(card: card),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small square widget preview
// ---------------------------------------------------------------------------

class _SmallWidget extends StatelessWidget {
  const _SmallWidget({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final AdviceTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _toneColor(tone).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _toneColor(tone).withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22, color: _toneColor(tone)),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Medium rectangular widget preview
// ---------------------------------------------------------------------------

class _MediumWidget extends StatelessWidget {
  const _MediumWidget({required this.report, required this.guidance});

  final WeatherReport report;
  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.10)
              : AppPalette.ink.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  report.location.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${report.current.temperatureC.round()}°',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  guidance.headline.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _ToneDot(tone: guidance.nextHour.tone),
              const SizedBox(height: 8),
              Text(
                guidance.nextHour.departureAdvice,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(
                guidance.dryWindow.isAvailable
                    ? 'Dry: ${formatDurationShort(guidance.dryWindow.duration)}'
                    : 'No dry window',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Large widget preview (full-width, shows more detail)
// ---------------------------------------------------------------------------

class _LargeWidget extends StatelessWidget {
  const _LargeWidget({required this.report, required this.guidance});

  final WeatherReport report;
  final WeatherGuidance guidance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.10)
              : AppPalette.ink.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                report.location.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '${report.current.temperatureC.round()}°',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            guidance.headline.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            guidance.headline.detail,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 24),
          Row(
            children: <Widget>[
              _WidgetStat(
                label: 'Next hour',
                value: guidance.nextHour.departureAdvice,
                tone: guidance.nextHour.tone,
              ),
              const SizedBox(width: 20),
              _WidgetStat(
                label: 'Dry window',
                value: guidance.dryWindow.isAvailable
                    ? formatDurationShort(guidance.dryWindow.duration)
                    : 'None',
                tone: guidance.dryWindow.tone,
              ),
              if (guidance.commute.windows.isNotEmpty) ...<Widget>[
                const SizedBox(width: 20),
                _WidgetStat(
                  label: 'Commute',
                  value: '${guidance.commute.windows.first.score}/100',
                  tone: guidance.commute.windows.first.tone,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glance card (individual home card)
// ---------------------------------------------------------------------------

class _GlanceCard extends StatelessWidget {
  const _GlanceCard({required this.card});

  final HomeSummaryCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.10)
              : AppPalette.ink.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppPalette.sky.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(card.icon, color: AppPalette.sky),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(card.title, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  card.value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (card.detail.isNotEmpty)
                  Text(
                    card.detail,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _ToneDot extends StatelessWidget {
  const _ToneDot({required this.tone});
  final AdviceTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _toneColor(tone),
      ),
    );
  }
}

class _WidgetStat extends StatelessWidget {
  const _WidgetStat({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final AdviceTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ToneDot(tone: tone),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

Color _toneColor(AdviceTone tone) {
  return switch (tone) {
    AdviceTone.go => AppPalette.teal,
    AdviceTone.watch => AppPalette.amber,
    AdviceTone.wait => AppPalette.coral,
  };
}
