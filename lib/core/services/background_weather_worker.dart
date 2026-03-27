import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../features/weather_core/data/open_meteo_weather_data_provider.dart';
import '../../features/weather_core/data/weather_local_store.dart';
import '../../features/weather_core/data/weather_provider_config.dart';
import '../../features/weather_core/domain/weather_advisor.dart';
import '../../features/weather_core/domain/weather_models.dart';
import 'local_notification_service.dart';
import 'weather_notification_checker.dart';

/// Unique task name used to register and identify the periodic background job.
const backgroundWeatherTaskName = 'dry_slots_background_weather_check';

/// Top-level callback invoked by Workmanager in a background isolate.
///
/// Because this runs in an isolate, it cannot access the Riverpod container.
/// It manually sets up the minimum dependencies needed to fetch weather,
/// evaluate notification triggers, and fire local notifications.
@pragma('vm:entry-point')
void backgroundWeatherCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != backgroundWeatherTaskName) {
      return true;
    }

    try {
      // Bootstrap minimal dependencies.
      final preferences = await SharedPreferences.getInstance();
      await Hive.initFlutter();
      final box =
          await Hive.openBox<String>(WeatherLocalStore.boxName);
      final store = WeatherLocalStore(box);

      final savedLocation = store.getSelectedLocation();
      if (savedLocation == null) {
        return true; // No location saved yet; nothing to check.
      }

      // Fetch fresh weather data from Open-Meteo (no key required).
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      final provider = OpenMeteoWeatherDataProvider(dio: dio);
      final report = await provider.fetchWeather(savedLocation);

      // Build guidance.
      final commuteWindows = store.getCommuteWindows();
      const advisor = WeatherAdvisor();
      final guidance = advisor.build(
        report,
        commuteWindows: commuteWindows,
      );

      // Evaluate notification triggers.
      final notificationService = LocalNotificationService();
      await notificationService.initialize();
      final checker = WeatherNotificationChecker(
        notificationService: notificationService,
        preferences: preferences,
      );
      await checker.evaluate(report, guidance);

      // Cache the fresh report so the UI has it when opened.
      await store.cacheReport(report, provider: WeatherDataProvider.openMeteo);

      dio.close();
    } catch (_) {
      // Swallow errors in background — notifications are best-effort.
    }

    return true;
  });
}

/// Registers the periodic background weather check with Workmanager.
///
/// Call once at app startup (e.g. in `main()`).
Future<void> registerBackgroundWeatherWorker() async {
  await Workmanager().initialize(
    backgroundWeatherCallbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    backgroundWeatherTaskName,
    backgroundWeatherTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingWorkPolicy.keep,
  );
}
