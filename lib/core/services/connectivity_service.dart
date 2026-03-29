import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight connectivity check that pings a known reliable host.
/// No extra packages needed — just a raw socket attempt.
class ConnectivityService {
  const ConnectivityService();

  /// Returns `true` if the device can reach the internet.
  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return const ConnectivityService();
});

/// A [StreamProvider] that emits connectivity status every 30 seconds and on
/// initial load. Widgets can watch this to show/hide offline banners.
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return Stream<bool>.periodic(
    const Duration(seconds: 30),
    (_) => true,
  ).asyncMap((_) => service.hasConnection()).asBroadcastStream()
    ..first; // ensure we get an immediate check
});
