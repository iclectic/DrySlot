import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final weatherStorageBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('weatherStorageBoxProvider must be overridden');
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: const <String, String>{
        'Accept': 'application/json, text/xml, application/rss+xml',
        'User-Agent': 'Dry Slots/1.0 Flutter',
      },
    ),
  );

  ref.onDispose(dio.close);
  return dio;
});
