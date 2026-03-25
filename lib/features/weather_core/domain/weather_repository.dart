import 'weather_models.dart';

abstract class WeatherRepository {
  Future<WeatherReport> fetchWeather(WeatherLocation location);

  Future<List<WeatherLocation>> searchLocations(String query);
}
