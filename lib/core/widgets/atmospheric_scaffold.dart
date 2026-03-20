import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AtmosphericScaffold extends StatelessWidget {
  const AtmosphericScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const <Widget>[],
    this.child,
    this.body,
    this.showBack = false,
  }) : assert(child != null || body != null);

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? child;
  final Widget? body;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        children: <Widget>[
          const _AtmosphericGlow(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (showBack)
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      if (showBack) const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            if (subtitle != null) ...<Widget>[
                              const SizedBox(height: 6),
                              Text(
                                subtitle!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                      ...actions,
                    ],
                  ),
                ),
                Expanded(
                  child:
                      body ??
                      ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                        children: <Widget>[child!],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStatePanel extends StatelessWidget {
  const EmptyStatePanel({
    super.key,
    required this.title,
    required this.detail,
    this.action,
  });

  final String title;
  final String detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (action != null) ...<Widget>[
                const SizedBox(height: 18),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AtmosphericGlow extends StatelessWidget {
  const _AtmosphericGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            left: -80,
            child: _GlowOrb(
              color: AppPalette.sky.withValues(alpha: 0.16),
              size: 260,
            ),
          ),
          Positioned(
            top: 180,
            right: -100,
            child: _GlowOrb(
              color: AppPalette.teal.withValues(alpha: 0.12),
              size: 260,
            ),
          ),
          Positioned(
            bottom: -120,
            left: 20,
            child: _GlowOrb(
              color: AppPalette.amber.withValues(alpha: 0.08),
              size: 260,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
