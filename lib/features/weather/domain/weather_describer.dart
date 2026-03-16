import 'package:flutter/material.dart';

class WeatherDescriptor {
  const WeatherDescriptor({
    required this.label,
    required this.summary,
    required this.icon,
  });

  final String label;
  final String summary;
  final IconData icon;
}

WeatherDescriptor describeWeatherCode(int code, {required bool isDay}) {
  switch (code) {
    case 0:
      return WeatherDescriptor(
        label: isDay ? 'Clear' : 'Clear night',
        summary: isDay ? 'Bright and settled' : 'Clear and calm',
        icon: isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
      );
    case 1:
    case 2:
      return WeatherDescriptor(
        label: 'Bright spells',
        summary: 'Mostly dry with broken cloud',
        icon: isDay ? Icons.cloud_queue_rounded : Icons.cloud_rounded,
      );
    case 3:
      return const WeatherDescriptor(
        label: 'Overcast',
        summary: 'Grey but generally steady',
        icon: Icons.cloud_rounded,
      );
    case 45:
    case 48:
      return const WeatherDescriptor(
        label: 'Fog',
        summary: 'Visibility may be patchy',
        icon: Icons.dehaze_rounded,
      );
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return const WeatherDescriptor(
        label: 'Drizzle',
        summary: 'Light wet spells around',
        icon: Icons.grain_rounded,
      );
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
      return const WeatherDescriptor(
        label: 'Rain',
        summary: 'Wet periods likely',
        icon: Icons.water_drop_rounded,
      );
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return const WeatherDescriptor(
        label: 'Snow',
        summary: 'Wintry conditions around',
        icon: Icons.ac_unit_rounded,
      );
    case 80:
    case 81:
    case 82:
      return const WeatherDescriptor(
        label: 'Showers',
        summary: 'Passing bursts of rain',
        icon: Icons.umbrella_rounded,
      );
    case 95:
    case 96:
    case 99:
      return const WeatherDescriptor(
        label: 'Thunder',
        summary: 'Stormy weather risk',
        icon: Icons.thunderstorm_rounded,
      );
    default:
      return WeatherDescriptor(
        label: 'Mixed',
        summary: 'Typical UK changeable weather',
        icon: isDay ? Icons.cloud_queue_rounded : Icons.cloud_rounded,
      );
  }
}

String rainIntensityLabel(double mmPerQuarterHour) {
  if (mmPerQuarterHour < 0.08) {
    return 'barely any rain';
  }
  if (mmPerQuarterHour < 0.35) {
    return 'light rain';
  }
  if (mmPerQuarterHour < 0.8) {
    return 'steady rain';
  }
  return 'heavy rain';
}
