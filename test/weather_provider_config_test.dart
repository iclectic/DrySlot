import 'package:dry_slots/features/weather/data/weather_provider_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to Open-Meteo when no provider is configured', () {
    final config = WeatherProviderConfig.fromValues();

    expect(config.requestedProvider, WeatherDataProvider.openMeteo);
    expect(config.activeProvider, WeatherDataProvider.openMeteo);
    expect(config.isFallingBackToDefault, isFalse);
  });

  test('resolves WeatherAPI when its key is present', () {
    final config = WeatherProviderConfig.fromValues(
      providerName: 'weatherApi',
      weatherApiKey: 'weather-api-key',
    );

    expect(config.requestedProvider, WeatherDataProvider.weatherApi);
    expect(config.activeProvider, WeatherDataProvider.weatherApi);
    expect(config.apiKeyFor(WeatherDataProvider.weatherApi), 'weather-api-key');
  });

  test(
    'falls back to Open-Meteo when WeatherAPI is selected without a key',
    () {
      final config = WeatherProviderConfig.fromValues(
        providerName: 'weatherApi',
      );

      expect(config.requestedProvider, WeatherDataProvider.weatherApi);
      expect(config.activeProvider, WeatherDataProvider.openMeteo);
      expect(config.isFallingBackToDefault, isTrue);
    },
  );

  test('resolves OpenWeather when its key is present', () {
    final config = WeatherProviderConfig.fromValues(
      providerName: 'openWeather',
      openWeatherApiKey: 'open-weather-key',
    );

    expect(config.requestedProvider, WeatherDataProvider.openWeather);
    expect(config.activeProvider, WeatherDataProvider.openWeather);
    expect(
      config.apiKeyFor(WeatherDataProvider.openWeather),
      'open-weather-key',
    );
  });
}
