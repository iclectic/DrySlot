import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Installs a friendly error widget that replaces Flutter's default red/grey
/// error screen in release builds.
///
/// Call once in `main()` before `runApp()`.
void installErrorBoundary() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // In debug mode keep the standard red error screen for diagnostics.
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }

    return const _FriendlyErrorCard();
  };
}

class _FriendlyErrorCard extends StatelessWidget {
  const _FriendlyErrorCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppPalette.deepSea : AppPalette.pearl,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: AppPalette.coral,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This part of the screen couldn\'t load.\nTry going back or refreshing.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.slate,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
