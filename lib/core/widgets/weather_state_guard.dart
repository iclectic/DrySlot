import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/weather/domain/weather_models.dart';
import '../../features/weather/presentation/weather_dashboard_controller.dart';
import 'atmospheric_scaffold.dart';

typedef WeatherStateBuilder =
    Widget Function(
      BuildContext context,
      WidgetRef ref,
      WeatherDashboardState state,
      WeatherReport report,
      WeatherGuidance guidance,
    );

class WeatherStateGuard extends ConsumerStatefulWidget {
  const WeatherStateGuard({
    super.key,
    required this.builder,
    this.loadingTitle = 'Checking today’s forecast',
    this.loadingDetail = 'Building your dry windows and practical guidance.',
  });

  final WeatherStateBuilder builder;
  final String loadingTitle;
  final String loadingDetail;

  @override
  ConsumerState<WeatherStateGuard> createState() => _WeatherStateGuardState();
}

class _WeatherStateGuardState extends ConsumerState<WeatherStateGuard> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(weatherDashboardControllerProvider.notifier).initialize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherDashboardControllerProvider);
    if (state.isLoading && !state.hasData) {
      return EmptyStatePanel(
        title: widget.loadingTitle,
        detail: widget.loadingDetail,
        action: const CircularProgressIndicator.adaptive(),
      );
    }

    if (!state.hasData) {
      return EmptyStatePanel(
        title: 'Weather is unavailable',
        detail:
            state.errorMessage ??
            'Dry Slots could not load a forecast just now.',
        action: FilledButton(
          onPressed: () =>
              ref.read(weatherDashboardControllerProvider.notifier).refresh(),
          child: const Text('Try again'),
        ),
      );
    }

    return widget.builder(context, ref, state, state.report!, state.guidance!);
  }
}
