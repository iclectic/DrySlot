import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../domain/weather_repository.dart';
import 'open_meteo_weather_repository.dart';
import 'open_weather_weather_repository.dart';
import 'weather_api_weather_repository.dart';
import 'weather_local_store.dart';
import 'weather_provider_config.dart';

final weatherLocalStoreProvider = Provider<WeatherLocalStore>((ref) {
  return WeatherLocalStore(ref.watch(weatherStorageBoxProvider));
});

final weatherProviderConfigProvider = Provider<WeatherProviderConfig>((ref) {
  return WeatherProviderConfig.fromEnvironment();
});

final activeWeatherDataProviderProvider = Provider<WeatherDataProvider>((ref) {
  return ref.watch(weatherProviderConfigProvider).activeProvider;
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final config = ref.watch(weatherProviderConfigProvider);
  final dio = ref.watch(dioProvider);
  final localStore = ref.watch(weatherLocalStoreProvider);

  return switch (config.activeProvider) {
    WeatherDataProvider.weatherApi => WeatherApiWeatherRepository(
      apiKey: config.apiKeyFor(WeatherDataProvider.weatherApi)!,
      dio: dio,
      localStore: localStore,
    ),
    WeatherDataProvider.openWeather => OpenWeatherWeatherRepository(
      apiKey: config.apiKeyFor(WeatherDataProvider.openWeather)!,
      dio: dio,
      localStore: localStore,
    ),
    WeatherDataProvider.openMeteo => OpenMeteoWeatherRepository(
      dio: dio,
      localStore: localStore,
    ),
  };
});
