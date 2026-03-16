import '../../../core/utils/formatters.dart';
import 'weather_models.dart';

class WeatherInterpreter {
  const WeatherInterpreter(this.mode);

  final ExplanationMode mode;

  bool get isDetailed => mode == ExplanationMode.detailed;

  String explain(
    String simple, {
    Iterable<String> details = const <String>[],
  }) {
    if (!isDetailed) {
      return simple;
    }

    final supporting = details
        .map((detail) => detail.trim())
        .where((detail) => detail.isNotEmpty)
        .join(' ');
    if (supporting.isEmpty) {
      return simple;
    }
    return '$simple $supporting';
  }

  String apparent(double temperatureC) => 'Feels like ${formatTemperature(temperatureC)}.';

  String temperatureRange(double minC, double maxC) {
    return 'Temperatures range from ${formatTemperature(minC)} to ${formatTemperature(maxC)}.';
  }

  String rainChance(int percent) => 'Rain chance peaks near ${formatPercent(percent)}.';

  String rainAmount(double millimetres, {String prefix = 'Rainfall'}) {
    return '$prefix reaches about ${formatRain(millimetres)}.';
  }

  String wind(double kph) => 'Wind sits around ${formatWind(kph)}.';

  String gust(double kph) => 'Gusts could reach ${formatWind(kph)}.';

  String visibility(double meters) => 'Visibility is around ${formatVisibility(meters)}.';

  String dryWindow(DateTime start, DateTime end, {String prefix = 'Dry window'}) {
    return '$prefix runs ${formatTimeRange(start, end)}.';
  }

  String score(String label, int value, {int outOf = 10}) {
    return '$label scores $value/$outOf.';
  }

  String count(String label, int value) {
    return '$value $label${value == 1 ? '' : 's'}.';
  }
}
