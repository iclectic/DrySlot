import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/connectivity_service.dart';
import '../theme/app_theme.dart';

/// A slim banner that appears at the top of the dashboard when the device
/// has no internet connection, letting the user know they are seeing cached
/// (potentially stale) data.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);

    return connectivity.when(
      data: (isOnline) {
        if (isOnline) return const SizedBox.shrink();
        return _BannerBody();
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => _BannerBody(),
    );
  }
}

class _BannerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppPalette.amber.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.amber.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.cloud_off_rounded, size: 18, color: AppPalette.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You\u2019re offline \u2014 showing cached weather data.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
