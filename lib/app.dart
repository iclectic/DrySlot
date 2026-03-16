import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/display_settings_controller.dart';
import 'features/weather/presentation/weather_dashboard_page.dart';

class DrySlotsApp extends StatefulWidget {
  const DrySlotsApp({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  State<DrySlotsApp> createState() => _DrySlotsAppState();
}

class _DrySlotsAppState extends State<DrySlotsApp> {
  late final DisplaySettingsController _displaySettings;

  @override
  void initState() {
    super.initState();
    _displaySettings = DisplaySettingsController(preferences: widget.preferences);
  }

  @override
  void dispose() {
    _displaySettings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _displaySettings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Dry Slots',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildLight(),
          darkTheme: AppTheme.buildDark(),
          themeMode: _displaySettings.themeMode,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(_displaySettings.textScaleFactor),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: WeatherDashboardPage(
            preferences: widget.preferences,
            displaySettings: _displaySettings,
          ),
        );
      },
    );
  }
}
