import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routing/route_paths.dart';
import '../core/theme/app_theme.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  final int currentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.deepSea.withValues(alpha: 0.94)
            : Colors.white.withValues(alpha: 0.96),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_rounded),
            selectedIcon: Icon(Icons.repeat_on_rounded),
            label: 'Routines',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (index) {
          final path = switch (index) {
            0 => RoutePaths.home,
            1 => RoutePaths.planner,
            2 => RoutePaths.routines,
            _ => RoutePaths.settings,
          };
          context.go(path);
        },
      ),
    );
  }
}
