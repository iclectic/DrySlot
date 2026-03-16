import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/app_providers.dart';
import 'features/weather/data/weather_local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  final weatherBox = await Hive.openBox<String>(WeatherLocalStore.boxName);

  runApp(
    ProviderScope(
      overrides: <Override>[
        sharedPreferencesProvider.overrideWithValue(preferences),
        weatherStorageBoxProvider.overrideWithValue(weatherBox),
      ],
      child: const DrySlotsApp(),
    ),
  );
}
