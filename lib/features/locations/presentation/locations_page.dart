import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/device_location_service.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/atmospheric_scaffold.dart';
import '../../weather/data/weather_repository.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';
import '../../weather/presentation/weather_dashboard_page.dart';

class LocationsPage extends ConsumerWidget {
  const LocationsPage({super.key});

  Future<void> _useCurrentLocation(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(deviceLocationServiceProvider)
        .fetchCurrentLocation();
    if (result.location != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .refresh(location: result.location);
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
  }

  Future<void> _pickMainLocation(BuildContext context, WidgetRef ref) async {
    final state = ref.read(weatherDashboardControllerProvider);
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSearchSheet(
        repository: ref.read(weatherRepositoryProvider),
        selectedLocation: state.selectedLocation,
      ),
    );
    if (picked != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .refresh(location: picked);
    }
  }

  Future<void> _pickComparisonLocation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final state = ref.read(weatherDashboardControllerProvider);
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSearchSheet(
        repository: ref.read(weatherRepositoryProvider),
        selectedLocation: state.comparisonLocation ?? state.selectedLocation,
      ),
    );
    if (picked != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .setComparisonLocation(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weatherDashboardControllerProvider);
    return AtmosphericScaffold(
      title: 'Locations',
      subtitle:
          'Choose your main location and add a second place when you want a quick comparison.',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: <Widget>[
          AppSurfaceCard(
            onTap: () => _useCurrentLocation(context, ref),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Use current location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask the device for your current place and switch the forecast automatically.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            onTap: () => _pickMainLocation(context, ref),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Main location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.selectedLocation.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  state.selectedLocation.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSurfaceCard(
            onTap: () => _pickComparisonLocation(context, ref),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Comparison location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.comparisonLocation?.name ?? 'None set',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  state.comparisonLocation?.subtitle ??
                      'Add another location when you want a side-by-side check.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (state.comparisonLocation != null) ...<Widget>[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => ref
                        .read(weatherDashboardControllerProvider.notifier)
                        .clearComparisonLocation(),
                    child: const Text('Remove comparison'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
