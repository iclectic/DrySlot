import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/services/device_location_service.dart';
import '../../../core/services/notification_permission_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../locations/presentation/location_search_sheet.dart';
import '../../weather_core/data/weather_repository.dart';
import '../../weather_core/domain/weather_models.dart';
import '../../weather_core/presentation/weather_dashboard_controller.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  bool _notificationsEnabled = false;
  bool _routineSupportEnabled = true;
  bool _locationBusy = false;
  bool _notificationBusy = false;
  WeatherLocation? _pickedLocation;
  String? _locationStatusMessage;
  String? _notificationStatusMessage;
  bool _locationCanOpenSettings = false;
  bool _notificationsCanOpenSettings = false;

  Future<void> _pickLocation() async {
    final state = ref.read(weatherDashboardControllerProvider);
    final picked = await showModalBottomSheet<WeatherLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LocationSearchSheet(
          repository: ref.read(weatherRepositoryProvider),
          selectedLocation: state.selectedLocation,
        );
      },
    );

    if (picked == null) {
      return;
    }

    await ref
        .read(weatherDashboardControllerProvider.notifier)
        .refresh(location: picked);
    if (!mounted) {
      return;
    }
    setState(() {
      _pickedLocation = picked;
      _step = 2;
      _locationStatusMessage = 'Using ${picked.name} for local guidance.';
      _locationCanOpenSettings = false;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locationBusy = true;
      _locationStatusMessage = null;
    });

    final result = await ref
        .read(deviceLocationServiceProvider)
        .fetchCurrentLocation();

    if (result.location != null) {
      await ref
          .read(weatherDashboardControllerProvider.notifier)
          .refresh(location: result.location);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _locationBusy = false;
      _locationStatusMessage = result.message;
      _locationCanOpenSettings = result.canOpenSettings;
      if (result.location != null) {
        _pickedLocation = result.location;
        _step = 2;
      }
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (!value) {
      setState(() {
        _notificationsEnabled = false;
        _notificationStatusMessage = 'Notifications are off for now.';
        _notificationsCanOpenSettings = false;
      });
      return;
    }

    setState(() {
      _notificationBusy = true;
      _notificationStatusMessage = null;
    });

    final result = await ref
        .read(notificationPermissionServiceProvider)
        .requestPermission();

    if (!mounted) {
      return;
    }

    setState(() {
      _notificationBusy = false;
      _notificationsEnabled = result.isGranted;
      _notificationStatusMessage = result.message;
      _notificationsCanOpenSettings = result.canOpenSettings;
    });
  }

  Future<void> _finish() async {
    await ref
        .read(appPreferencesControllerProvider.notifier)
        .completeOnboarding(
          notificationsEnabled: _notificationsEnabled,
          routineSupportEnabled: _routineSupportEnabled,
        );
    if (!mounted) {
      return;
    }
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final steps = <_OnboardingStepData>[
      const _OnboardingStepData(
        eyebrow: 'Dry Slots',
        title: 'Weather that helps you decide what to do today.',
        detail:
            'Dry Slots focuses on timing, dry gaps, routines, and practical guidance instead of noisy forecast screens.',
        primaryLabel: 'Continue',
      ),
      _OnboardingStepData(
        eyebrow: 'Start with a place',
        title: _pickedLocation == null
            ? 'Use your current location or search instead.'
            : '${_pickedLocation!.name} is set for now.',
        detail:
            'Dry Slots can ask for your current location so next rain and dry slots feel instantly local. You can still search manually if you prefer.',
        primaryLabel: _pickedLocation == null
            ? 'Use current location'
            : 'Continue',
        secondaryLabel: 'Search instead',
      ),
      const _OnboardingStepData(
        eyebrow: 'Stay ahead of the weather',
        title: 'Choose how proactive Dry Slots should feel.',
        detail:
            'Notifications are optional. Routine support helps with commutes, school runs, and everyday timing windows.',
        primaryLabel: 'Finish setup',
      ),
    ];

    final stepData = steps[_step];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? const <Color>[AppPalette.midnight, AppPalette.deepSea]
              : const <Color>[AppPalette.dawn, AppPalette.pearl],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stepData.eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: List<Widget>.generate(steps.length, (index) {
                  final active = index == _step;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == steps.length - 1 ? 0 : 8,
                      ),
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? AppPalette.sky
                            : AppPalette.sky.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Text(
                stepData.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                stepData.detail,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              if (_step == 0)
                _OnboardingFeatureList(
                  items: const <String>[
                    'Next-hour rain in plain English',
                    'Best dry slots for the day',
                    'Routine-aware commute and outing guidance',
                  ],
                ),
              if (_step == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SetupCard(
                      title: _pickedLocation?.name ?? 'No location chosen yet',
                      detail: _pickedLocation == null
                          ? 'Use your device location for faster setup, or search for a place manually.'
                          : '${_pickedLocation!.subtitle}. You can change this any time.',
                      icon: Icons.location_on_outlined,
                    ),
                    if (_locationStatusMessage != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        _locationStatusMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (_locationCanOpenSettings) ...<Widget>[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: () => ref
                                .read(deviceLocationServiceProvider)
                                .openAppSettings(),
                            child: const Text('Open app settings'),
                          ),
                          OutlinedButton(
                            onPressed: () => ref
                                .read(deviceLocationServiceProvider)
                                .openLocationSettings(),
                            child: const Text('Open location settings'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              if (_step == 2) ...<Widget>[
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Optional weather notifications'),
                  subtitle: const Text(
                    'Morning briefings, routine reminders, and severe-weather prompts later on.',
                  ),
                  value: _notificationsEnabled,
                  onChanged: _notificationBusy ? null : _toggleNotifications,
                ),
                if (_notificationStatusMessage != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    _notificationStatusMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (_notificationsCanOpenSettings) ...<Widget>[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(notificationPermissionServiceProvider)
                        .openSettings(),
                    child: const Text('Open notification settings'),
                  ),
                ],
                if (_notificationBusy) ...<Widget>[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Commute and routine support'),
                  subtitle: const Text(
                    'Show school runs, gym walks, and daily timing windows on the home screen.',
                  ),
                  value: _routineSupportEnabled,
                  onChanged: (value) {
                    setState(() {
                      _routineSupportEnabled = value;
                    });
                  },
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _locationBusy || _notificationBusy
                      ? null
                      : () {
                          if (_step == 0) {
                            setState(() {
                              _step = 1;
                            });
                            return;
                          }
                          if (_step == 1) {
                            if (_pickedLocation != null) {
                              setState(() {
                                _step = 2;
                              });
                            } else {
                              _useCurrentLocation();
                            }
                            return;
                          }
                          _finish();
                        },
                  child: Text(
                    _step == 1 && _locationBusy
                        ? 'Finding your location…'
                        : _step == 2 && _notificationBusy
                        ? 'Checking notification access…'
                        : stepData.primaryLabel,
                  ),
                ),
              ),
              if (stepData.secondaryLabel != null) ...<Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _locationBusy || _notificationBusy
                        ? null
                        : () {
                            if (_step == 1) {
                              _pickLocation();
                              return;
                            }
                          },
                    child: Text(stepData.secondaryLabel!),
                  ),
                ),
              ],
              if (_step == 1 && _locationBusy) ...<Widget>[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
              if (_step == 1) ...<Widget>[
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _locationBusy
                        ? null
                        : () {
                            setState(() {
                              _step = 2;
                              _locationStatusMessage =
                                  'You can set your location later from the locations screen.';
                            });
                          },
                    child: _locationBusy
                        ? const Text('Finding your location…')
                        : const Text('Skip for now'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStepData {
  const _OnboardingStepData({
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.primaryLabel,
    this.secondaryLabel,
  });

  final String eyebrow;
  final String title;
  final String detail;
  final String primaryLabel;
  final String? secondaryLabel;
}

class _OnboardingFeatureList extends StatelessWidget {
  const _OnboardingFeatureList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SetupCard(
                title: item,
                detail: '',
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppPalette.sky.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppPalette.sky),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (detail.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(detail, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
