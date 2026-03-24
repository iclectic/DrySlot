enum WeatherDataProvider { openMeteo, weatherApi, openWeather }

const drySlotsWeatherProviderEnv = 'DRY_SLOTS_WEATHER_PROVIDER';
const drySlotsWeatherApiKeyEnv = 'DRY_SLOTS_WEATHERAPI_KEY';
const drySlotsOpenWeatherKeyEnv = 'DRY_SLOTS_OPENWEATHER_KEY';

extension WeatherDataProviderX on WeatherDataProvider {
  String get envName => switch (this) {
    WeatherDataProvider.openMeteo => 'openMeteo',
    WeatherDataProvider.weatherApi => 'weatherApi',
    WeatherDataProvider.openWeather => 'openWeather',
  };

  String get label => switch (this) {
    WeatherDataProvider.openMeteo => 'Open-Meteo',
    WeatherDataProvider.weatherApi => 'WeatherAPI.com',
    WeatherDataProvider.openWeather => 'OpenWeather',
  };

  String get cacheKey => switch (this) {
    WeatherDataProvider.openMeteo => 'open_meteo',
    WeatherDataProvider.weatherApi => 'weather_api',
    WeatherDataProvider.openWeather => 'open_weather',
  };

  static WeatherDataProvider parse(String? raw) {
    final normalized = raw?.trim().toLowerCase();
    return switch (normalized) {
      'weatherapi' ||
      'weather_api' ||
      'weatherapi.com' => WeatherDataProvider.weatherApi,
      'openweather' || 'open_weather' => WeatherDataProvider.openWeather,
      _ => WeatherDataProvider.openMeteo,
    };
  }
}

class WeatherProviderConfig {
  const WeatherProviderConfig({
    required this.requestedProvider,
    this.weatherApiKey,
    this.openWeatherApiKey,
  });

  factory WeatherProviderConfig.fromEnvironment() {
    return WeatherProviderConfig.fromValues(
      providerName: const String.fromEnvironment(drySlotsWeatherProviderEnv),
      weatherApiKey: const String.fromEnvironment(drySlotsWeatherApiKeyEnv),
      openWeatherApiKey: const String.fromEnvironment(
        drySlotsOpenWeatherKeyEnv,
      ),
    );
  }

  factory WeatherProviderConfig.fromValues({
    String? providerName,
    String? weatherApiKey,
    String? openWeatherApiKey,
  }) {
    return WeatherProviderConfig(
      requestedProvider: WeatherDataProviderX.parse(providerName),
      weatherApiKey: _clean(weatherApiKey),
      openWeatherApiKey: _clean(openWeatherApiKey),
    );
  }

  final WeatherDataProvider requestedProvider;
  final String? weatherApiKey;
  final String? openWeatherApiKey;

  WeatherDataProvider get activeProvider => switch (requestedProvider) {
    WeatherDataProvider.weatherApi =>
      isConfigured(WeatherDataProvider.weatherApi)
          ? WeatherDataProvider.weatherApi
          : WeatherDataProvider.openMeteo,
    WeatherDataProvider.openWeather =>
      isConfigured(WeatherDataProvider.openWeather)
          ? WeatherDataProvider.openWeather
          : WeatherDataProvider.openMeteo,
    WeatherDataProvider.openMeteo => WeatherDataProvider.openMeteo,
  };

  bool get isFallingBackToDefault => activeProvider != requestedProvider;

  bool isConfigured(WeatherDataProvider provider) {
    return switch (provider) {
      WeatherDataProvider.openMeteo => true,
      WeatherDataProvider.weatherApi => weatherApiKey != null,
      WeatherDataProvider.openWeather => openWeatherApiKey != null,
    };
  }

  String? apiKeyFor(WeatherDataProvider provider) {
    return switch (provider) {
      WeatherDataProvider.openMeteo => null,
      WeatherDataProvider.weatherApi => weatherApiKey,
      WeatherDataProvider.openWeather => openWeatherApiKey,
    };
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
