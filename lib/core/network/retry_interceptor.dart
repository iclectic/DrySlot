import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// A Dio [Interceptor] that retries failed requests with exponential backoff.
///
/// Retries on:
/// - HTTP 429 (Too Many Requests)
/// - HTTP 5xx (Server errors)
/// - [DioExceptionType.connectionTimeout]
/// - [DioExceptionType.receiveTimeout]
/// - [DioExceptionType.connectionError]
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = _attemptFromExtra(err.requestOptions);

    if (attempt >= maxRetries || !_shouldRetry(err)) {
      return handler.next(err);
    }

    // Exponential backoff with jitter.
    final delay = baseDelay * pow(2, attempt);
    final jitter = Duration(
      milliseconds: Random().nextInt(delay.inMilliseconds ~/ 2 + 1),
    );
    await Future<void>.delayed(delay + jitter);

    // Clone the request with an incremented attempt counter.
    final options = err.requestOptions;
    options.extra['_retryAttempt'] = attempt + 1;

    try {
      final response = await dio.fetch<Object?>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  int _attemptFromExtra(RequestOptions options) {
    return (options.extra['_retryAttempt'] as int?) ?? 0;
  }

  bool _shouldRetry(DioException err) {
    // Retry on timeout errors.
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on 429 or 5xx.
    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      return statusCode == 429 || (statusCode >= 500 && statusCode < 600);
    }

    return false;
  }
}
