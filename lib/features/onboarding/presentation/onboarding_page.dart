import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_theme.dart';
import '../../weather/data/weather_repository.dart';
import '../../weather/domain/weather_models.dart';
import '../../weather/presentation/weather_dashboard_controller.dart';
import '../../weather/presentation/weather_dashboard_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  bool _notificationsEnabled = false;
  bool _routineSupportEnabled = true;
  WeatherLocation? _pickedLocation;

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
            ? 'Pick your first location.'
            : '${_pickedLocation!.name} is set for now.',
        detail:
            'Search for your town or city to get straight into useful advice. Device location can be layered in next.',
        primaryLabel: _pickedLocation == null
            ? 'Search for a location'
            : 'Use this location',
        secondaryLabel: 'Skip for now',
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
                _SetupCard(
                  title: _pickedLocation?.name ?? 'No location chosen yet',
                  detail: _pickedLocation == null
                      ? 'Pick somewhere to get going quickly.'
                      : '${_pickedLocation!.subtitle}. You can change this any time.',
                  icon: Icons.location_on_outlined,
                ),
              if (_step == 2) ...<Widget>[
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Optional weather notifications'),
                  subtitle: const Text(
                    'Morning briefings, routine reminders, and severe-weather prompts later on.',
                  ),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
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
                  onPressed: () {
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
                        _pickLocation();
                      }
                      return;
                    }
                    _finish();
                  },
                  child: Text(stepData.primaryLabel),
                ),
              ),
              if (stepData.secondaryLabel != null) ...<Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      if (_step == 1) {
                        setState(() {
                          _step = 2;
                        });
                      }
                    },
                    child: Text(stepData.secondaryLabel!),
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
