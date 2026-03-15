import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/weather/presentation/weather_dashboard_page.dart';

class DrySlotsApp extends StatelessWidget {
  const DrySlotsApp({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dry Slots',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: WeatherDashboardPage(preferences: preferences),
    );
  }
}
