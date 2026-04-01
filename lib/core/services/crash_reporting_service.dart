import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// DSN injected at build time via `--dart-define=SENTRY_DSN=https://…`.
///
/// When empty or unset the SDK silently no-ops, so debug builds just work.
const String _sentryDsn = String.fromEnvironment('SENTRY_DSN');

/// Whether Sentry is available (a DSN was provided at compile time).
bool get sentryEnabled => _sentryDsn.isNotEmpty;

/// Initialises Sentry and installs global Flutter error handlers.
///
/// Call this **instead of** `runApp()` — it wraps the app in an error zone
/// and hooks into [FlutterError.onError] automatically.
///
/// Usage in `main()`:
/// ```dart
/// await initCrashReporting(
///   appRunner: () => runApp(const MyApp()),
/// );
/// ```
Future<void> initCrashReporting({
  required FutureOr<void> Function() appRunner,
}) async {
  if (!sentryEnabled) {
    // No DSN → run the app normally without Sentry overhead.
    await appRunner();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      options.tracesSampleRate = kDebugMode ? 1.0 : 0.2;
      options.environment = kDebugMode ? 'debug' : 'production';
      options.sendDefaultPii = false;
      options.attachScreenshot = false;
    },
    appRunner: appRunner,
  );
}

/// Capture a non-fatal exception manually (e.g. in a catch block).
Future<void> reportError(
  dynamic exception, {
  dynamic stackTrace,
  String? hint,
}) async {
  if (!sentryEnabled) return;
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
    hint: hint != null ? Hint.withMap({'message': hint}) : null,
  );
}

/// Add a breadcrumb for contextual debugging (e.g. navigation, user action).
void addBreadcrumb(String message, {String? category}) {
  if (!sentryEnabled) return;
  Sentry.addBreadcrumb(
    Breadcrumb(
      message: message,
      category: category ?? 'app',
      timestamp: DateTime.now(),
    ),
  );
}
