import 'package:flutter/material.dart';

import '../../../core/widgets/atmospheric_scaffold.dart';

/// In-app privacy policy screen.
///
/// Also available as a hosted HTML page at `privacy_policy.html` in the
/// project root — use that URL for store submissions.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _lastUpdated = '1 April 2026';

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;
    final bold = body?.copyWith(fontWeight: FontWeight.w700);

    return AtmosphericScaffold(
      title: 'Privacy Policy',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: <Widget>[
          Text('Privacy Policy', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Last updated: $_lastUpdated', style: body),
          const SizedBox(height: 20),

          Text('1. What Dry Slots Collects', style: bold),
          const SizedBox(height: 6),
          Text(
            'Dry Slots requests your device location solely to provide '
            'weather forecasts for your area. Your coordinates are sent '
            'directly to the weather data provider (Open-Meteo by default) '
            'and are never stored on any server we operate.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('2. Data Stored on Your Device', style: bold),
          const SizedBox(height: 6),
          Text(
            '• Selected location and commute windows (SharedPreferences & Hive)\n'
            '• Display preferences (theme, text size, colorblind mode)\n'
            '• Notification preferences (alert types, quiet hours)\n'
            '• Cached weather data for offline use\n\n'
            'All of this data stays on your device. We do not operate a '
            'backend server and have no way to access it.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('3. Third-Party Services', style: bold),
          const SizedBox(height: 6),
          Text(
            '• Open-Meteo (weather data) — open-meteo.com/en/terms\n'
            '• Sentry (crash reporting, optional) — sentry.io/privacy\n\n'
            'When crash reporting is enabled, anonymous error traces may be '
            'sent to Sentry. No personal data or location is included.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('4. Notifications', style: bold),
          const SizedBox(height: 6),
          Text(
            'Dry Slots can send local notifications about rain, commute '
            'weather, and dry windows. These are generated entirely on your '
            'device — no push notification server is involved. You can '
            'disable any alert type or set quiet hours in Settings.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('5. Analytics', style: bold),
          const SizedBox(height: 6),
          Text(
            'Dry Slots includes a local analytics log that records '
            'anonymised interaction events (e.g. which cards you tap). '
            'This data never leaves your device and can be disabled in '
            'Settings → Privacy & analytics.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('6. Children\'s Privacy', style: bold),
          const SizedBox(height: 6),
          Text(
            'Dry Slots does not knowingly collect personal information '
            'from children under 13. The app does not require an account '
            'or any personal details to function.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('7. Changes to This Policy', style: bold),
          const SizedBox(height: 6),
          Text(
            'We may update this policy from time to time. The "Last updated" '
            'date at the top will always reflect the latest revision.',
            style: body,
          ),
          const SizedBox(height: 16),

          Text('8. Contact', style: bold),
          const SizedBox(height: 6),
          Text(
            'If you have questions about this policy, please open an issue '
            'on the project repository or contact the developer directly.',
            style: body,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
