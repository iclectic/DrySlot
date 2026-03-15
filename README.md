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

## Verify

```bash
flutter analyze
flutter test
flutter build apk --debug
```

The debug APK is generated at `build/app/outputs/flutter-apk/app-debug.apk`.
