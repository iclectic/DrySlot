# Dry Slots

Dry Slots is a decision-first weather app for UK users built with Flutter.

Instead of leading with raw forecast data, the app turns forecast inputs into practical guidance:

- Will it rain in the next hour?
- When is the best dry window today?
- What will the commute feel like?
- What should I wear?
- Which everyday outdoor activities suit today?
- Are there any notable weather risks?

## Product Notes

- Premium, calm dashboard UI with responsive card-based layout
- UK location search powered by Open-Meteo geocoding
- Live weather repository with built-in offline/demo fallback
- Decision engine that converts forecast data into actionable guidance
- Shared preferences persistence for the last selected location

## Run

```bash
flutter pub get
flutter run
```

## Provider Selection

Dry Slots keeps weather vendors behind a single repository interface so the
domain layer does not depend on one API shape.

- Default provider: `Open-Meteo`
- WeatherAPI.com: `flutter run --dart-define=DRY_SLOTS_WEATHER_PROVIDER=weatherApi --dart-define=DRY_SLOTS_WEATHERAPI_KEY=your_key`
- OpenWeather: `flutter run --dart-define=DRY_SLOTS_WEATHER_PROVIDER=openWeather --dart-define=DRY_SLOTS_OPENWEATHER_KEY=your_key`

If a keyed provider is selected without a valid API key, the app falls back to
Open-Meteo automatically.

## Crash Reporting (Sentry)

Crash reporting is opt-in via a compile-time flag. Without it the app runs normally:

```bash
flutter run --dart-define=SENTRY_DSN=https://your-key@sentry.io/project-id
```

## Privacy Policy

- In-app: Settings → About → Privacy policy
- Hosted HTML: `privacy_policy.html` (deploy to any static host and provide the URL during store submission)

## Release Build

### Android

1. Create a keystore (one-time):
   ```bash
   keytool -genkey -v -keystore ~/dry-slots-release.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias dry_slots
   ```
2. Create `android/key.properties` (do **not** commit this file):
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=dry_slots
   storeFile=/Users/<you>/dry-slots-release.jks
   ```
3. Build:
   ```bash
   flutter build appbundle --release \
     --dart-define=SENTRY_DSN=https://…
   ```
   The AAB is generated at `build/app/outputs/bundle/release/app-release.aab`.

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set your Team and Bundle Identifier under **Signing & Capabilities**.
3. Build:
   ```bash
   flutter build ipa --release \
     --dart-define=SENTRY_DSN=https://…
   ```
   The archive is generated at `build/ios/archive/Runner.xcarchive`.

## Verify

```bash
flutter analyze
flutter test
flutter build apk --debug
```

The debug APK is generated at `build/app/outputs/flutter-apk/app-debug.apk`.
