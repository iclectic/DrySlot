import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../weather_core/domain/weather_models.dart';
import '../data/rain_viewer_service.dart';
import 'radar_controller.dart';

/// A self-contained radar card that shows precipitation tiles from RainViewer
/// with a scrubber timeline and play/pause controls.
///
/// The card renders the radar as a grid of pre-fetched tile images centered on
/// the user's location. No external map SDK is required.
class RadarMapCard extends ConsumerStatefulWidget {
  const RadarMapCard({super.key, required this.location});

  final WeatherLocation location;

  @override
  ConsumerState<RadarMapCard> createState() => _RadarMapCardState();
}

class _RadarMapCardState extends ConsumerState<RadarMapCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(radarControllerProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radarState = ref.watch(radarControllerProvider);

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Header(isLoading: radarState.isLoading),
          const SizedBox(height: 14),
          if (radarState.isLoading && !radarState.hasData)
            const _LoadingPlaceholder()
          else if (radarState.errorMessage != null)
            _ErrorPanel(
              message: radarState.errorMessage!,
              onRetry: () =>
                  ref.read(radarControllerProvider.notifier).load(),
            )
          else if (radarState.hasData) ...<Widget>[
            _RadarViewport(
              location: widget.location,
              radarState: radarState,
            ),
            const SizedBox(height: 16),
            _TimelineScrubber(
              radarState: radarState,
              onSeek: (index) =>
                  ref.read(radarControllerProvider.notifier).seekTo(index),
              onTogglePlay: () =>
                  ref.read(radarControllerProvider.notifier).togglePlayback(),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _surfaceFill(context, strong: true),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.radar_rounded, color: AppPalette.sky),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'PRECIPITATION RADAR',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppPalette.sky),
              ),
              const SizedBox(height: 4),
              Text(
                'Where is rain moving?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Radar viewport — renders a 3×3 grid of RainViewer tiles
// ---------------------------------------------------------------------------

class _RadarViewport extends StatelessWidget {
  const _RadarViewport({
    required this.location,
    required this.radarState,
  });

  final WeatherLocation location;
  final RadarState radarState;

  /// Converts lat/lng to slippy-map tile coordinates at a given zoom level.
  static (int x, int y) _latLngToTile(
    double lat,
    double lng,
    int zoom,
  ) {
    final n = math.pow(2, zoom).toDouble();
    final x = ((lng + 180) / 360 * n).floor();
    final latRad = lat * math.pi / 180;
    final y = ((1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) / 2 * n).floor();
    return (x, y);
  }

  @override
  Widget build(BuildContext context) {
    final frame = radarState.currentFrame;
    if (frame == null) {
      return const SizedBox.shrink();
    }

    const zoom = 7;
    final (cx, cy) = _latLngToTile(
      location.latitude,
      location.longitude,
      zoom,
    );

    final host = radarState.mapData!.host;
    final tileTemplate = frame.tileUrl(host: host);

    // Build a 3×3 grid of tiles centered on the user's tile.
    const gridSize = 3;
    const tilePixels = 170.0; // display size per tile

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: tilePixels * gridSize,
        child: Stack(
          children: <Widget>[
            // Dark base map layer
            Container(
              decoration: BoxDecoration(
                color: AppPalette.midnight,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            // Radar tiles
            ...List.generate(gridSize * gridSize, (index) {
              final dx = (index % gridSize) - 1;
              final dy = (index ~/ gridSize) - 1;
              final tileX = cx + dx;
              final tileY = cy + dy;

              final url = tileTemplate
                  .replaceFirst('{z}', '$zoom')
                  .replaceFirst('{x}', '$tileX')
                  .replaceFirst('{y}', '$tileY');

              return Positioned(
                left: (dx + 1) * tilePixels,
                top: (dy + 1) * tilePixels,
                width: tilePixels,
                height: tilePixels,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(color: Colors.transparent);
                  },
                ),
              );
            }),
            // Location pin overlay
            Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppPalette.coral,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppPalette.coral.withValues(alpha: 0.5),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            // Nowcast label
            if (radarState.isNowcast)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.amber.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppPalette.amber.withValues(alpha: 0.32),
                    ),
                  ),
                  child: const Text(
                    'Forecast',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.amber,
                    ),
                  ),
                ),
              ),
            // Timestamp badge
            if (radarState.currentFrame != null)
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    formatCompactClock(
                      radarState.currentFrame!.time.toLocal(),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline scrubber
// ---------------------------------------------------------------------------

class _TimelineScrubber extends StatelessWidget {
  const _TimelineScrubber({
    required this.radarState,
    required this.onSeek,
    required this.onTogglePlay,
  });

  final RadarState radarState;
  final ValueChanged<int> onSeek;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final frames = radarState.frames;
    if (frames.isEmpty) return const SizedBox.shrink();

    final nowcastStart = radarState.mapData!.nowcastStartIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Play / pause button
            GestureDetector(
              onTap: onTogglePlay,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _surfaceFill(context, strong: true),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  radarState.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: AppPalette.sky,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Scrubber slider
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppPalette.sky,
                      inactiveTrackColor:
                          AppPalette.sky.withValues(alpha: 0.18),
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      trackHeight: 4,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                    ),
                    child: Slider(
                      value: radarState.currentFrameIndex.toDouble(),
                      min: 0,
                      max: (frames.length - 1).toDouble(),
                      divisions: frames.length - 1,
                      onChanged: (value) => onSeek(value.round()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Time labels
        Row(
          children: <Widget>[
            const SizedBox(width: 54),
            Text(
              _relativeLabel(frames.first.time),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (nowcastStart > 0 && nowcastStart < frames.length) ...<Widget>[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.amber.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Nowcast \u2192',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.amber,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
            const Spacer(),
            Text(
              _relativeLabel(frames.last.time),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  String _relativeLabel(DateTime time) {
    final now = DateTime.now().toUtc();
    final diff = time.difference(now);
    final minutes = diff.inMinutes;
    if (minutes.abs() < 5) return 'Now';
    if (minutes < 0) return '${minutes.abs()}m ago';
    return 'in ${minutes}m';
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: AppPalette.midnight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 14),
            Text(
              'Loading radar data\u2026',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppPalette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppPalette.midnight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, color: AppPalette.coral),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppPalette.muted,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

Color _surfaceFill(BuildContext context, {bool strong = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (isDark) {
    return Colors.white.withValues(alpha: strong ? 0.08 : 0.05);
  }
  return strong ? const Color(0xFFF9FCFF) : const Color(0xF2FFFFFF);
}

// Lightweight glass card matching the dashboard style without importing the
// 2500-line dashboard file.
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppPalette.ink.withValues(alpha: 0.08);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? <Color>[
                    Colors.white.withValues(alpha: 0.09),
                    Colors.white.withValues(alpha: 0.03),
                  ]
                : <Color>[
                    const Color(0xF7FFFFFF),
                    const Color(0xEEF1F7FB),
                  ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor),
        ),
        child: child,
      ),
    );
  }
}
