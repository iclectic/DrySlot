# Baseline verification

Executed: 29 October 2026, on local branch `audit/phase-0-production-readiness`, source revision `3baf32cc909c3fdffd44a72f917701941faeb832`.

## Environment

| Component | Observed value |
| --- | --- |
| Host | macOS 26.3, Apple silicon, locale en-GB |
| Flutter | 3.47.8 stable; framework `737ba8f885`; engine `cf636b1dfb` |
| Dart | 3.13.7; project constraint `^3.11.0` |
| Xcode / CocoaPods | Xcode 16.4 (16F6), CocoaPods 1.16.2 |
| Android | SDK/build-tools 36.0.0; Flutter uses Android Studio JDK 21.0.6; shell `java -version` reports Temurin 21.0.10 |
| Gradle / AGP / Kotlin | Committed 8.14 / 8.11.1 / 2.2.20 |
| Devices | Doctor listed macOS and Chrome; no attached mobile device in this check |
| Doctor | Exit 0 with Android warning: some SDK licenses not accepted. No licenses were accepted by this audit. |

The initial sandboxed `flutter --version` failed writing SDK-cache stamps. It was rerun with approved SDK-cache access and succeeded. Dependency, analyzer/test and native build commands used approved access to SDK/package/build caches. No release credentials were provided.

## Results and exact principal commands

All shell redirections below captured stdout and stderr. Evidence logs replace machine-specific home/repository paths with `<user>` / `<repo>` and trim trailing whitespace; success/failure text is preserved. The migration diff is stored losslessly as the JSON `patch` field to preserve its original indentation and context lines.

| Command executed | Exit / result | Evidence |
| --- | --- | --- |
| `flutter --version` | 0 on approved retry; values above | Version output recorded above |
| `flutter pub get > /private/tmp/dryslot-phase0-pub-get.log 2>&1` | 0; changed six resolved dependencies; auto-added analyzer exclusions | [Output](evidence/pub-get.txt), [migration diff](evidence/tool-migrations.patch.json) |
| `flutter analyze --no-pub > /private/tmp/dryslot-phase0-analyze.log 2>&1` | **0; no issues**, reported 1.5s | [Output](evidence/analyze.txt) |
| `flutter test --no-pub --coverage --reporter expanded > /private/tmp/dryslot-phase0-tests.log 2>&1` | **0; 29 tests passed**, reporter elapsed about 2s | [Output](evidence/tests.txt), [LCOV](evidence/lcov.info.txt) |
| `flutter doctor -v > /private/tmp/dryslot-phase0-doctor.log 2>&1` | 0; Android license warning | [Output](evidence/doctor.txt) |
| `xcodebuild -version` / `java -version` | 0; versions above | Recorded above |
| `flutter build apk --debug --no-pub > /private/tmp/dryslot-phase0-android-debug.log 2>&1` | **1; failed**, `:app:checkDebugAarMetadata`: local notifications requires core library desugaring; Gradle task 71.9s | [Output](evidence/android-debug.txt) |
| `flutter build appbundle --release --no-pub > /private/tmp/dryslot-phase0-android-release.log 2>&1` | **1; failed**, `:sentry_flutter:compileReleaseKotlin`: language version 1.6 unsupported; Gradle task 11.4s | [Output](evidence/android-release.txt) |
| `flutter build ios --release --no-codesign --no-pub > /private/tmp/dryslot-phase0-ios-release.log 2>&1` | **1; failed**, Swift error: `SentryBinaryImageCache` has no `image`; Xcode build 16.9s after 124.7s SPM setup | [Output](evidence/ios-release.txt) |
| `./gradlew :app:processReleaseMainManifest > /private/tmp/dryslot-phase0-android-manifest.log 2>&1` (cwd `android/`) | **0; manifest task only**; 14s. Does not prove compilation or packaging | [Output](evidence/android-manifest-task.txt), [manifest](evidence/android-release-manifest.xml.txt), [blame](evidence/android-manifest-blame.txt) |
| `flutter pub get --enforce-lockfile > /private/tmp/dryslot-phase0-enforce-lockfile.log 2>&1` | **65; failed**, unable to satisfy pubspec using committed lockfile | [Output](evidence/enforce-lockfile.txt) |
| `flutter test --no-pub --reporter expanded /private/tmp/dryslot_phase0_probe_test.dart > /private/tmp/dryslot-phase0-probe.log 2>&1` | 0; diagnostic executed and printed existing failures; **not correctness acceptance** | [Output](evidence/probe.txt), [probe source](evidence/diagnostic-probe.dart.txt) |

The build times are one local run each, including different cache/setup states. They are not comparable performance benchmarks or before/after improvements. No APK/AAB/IPA was successfully produced by these attempts. Signed archive/export, installation, launch, background delivery and physical-device verification were not executed. Native test templates, desktop/web builds, full code-generation reproducibility, security history scan and automated vulnerability audit were not executed.

## Dependency and migration qualification

This is an **unchanged application-source baseline on locally resolved dependencies**, not a claim that the exact committed lockfile builds reproducibly. The installed SDK's `pub get` resolved the following version changes:

| Package | Committed | Resolved |
| --- | --- | --- |
| geolocator_linux | 0.2.4 | 0.2.3 |
| matcher | 0.12.18 | 0.12.20 |
| meta | 1.17.0 | 1.19.0 |
| package_info_plus | 9.0.0, transitive | 8.3.1, direct |
| test_api | 0.7.9 | 0.7.12 |
| vector_math | 2.2.0 | 2.4.4 |

`package_info_plus` is declared directly as `^8.3.0` in pubspec, inconsistent with the committed 9.0.0 lock entry. The original lock and analyzer settings were restored before analyzer/test execution; `.dart_tool/package_config.json` still pointed at resolved versions. `--no-pub` prevented implicit resolution during those checks. The full [resolved lock snapshot](evidence/resolved-pubspec.lock.txt) is retained as text evidence.

Native builds automatically added Gradle properties and migrated iOS project/Podfile deployment to iOS 15, integrated Swift Package Manager, and regenerated Podfile.lock. The baseline source project specifies iOS 13; the Podfile platform was commented out. The iOS result therefore includes tool migrations and native dependency re-resolution; it is not an untouched-project build result. See [tool migration diff](evidence/tool-migrations.patch.json) and [resolved Podfile lock](evidence/resolved-Podfile.lock.txt). All tracked tool changes were restored after commands completed; generated untracked SPM workspace metadata was moved outside the repository. No skip-dependency-validation flags, lint suppressions, test removals or package-cache edits were used.

## Tests and coverage interpretation

| Existing test file | Tests | Scope |
| --- | --- | --- |
| `test/weather_advisor_test.dart` | 8 | High-level heuristic output, labels, activity score range, official-warning ordering, explanation mode, weekend |
| `test/weather_models_test.dart` | 1 | Selected JSON round-trip fields |
| `test/weather_provider_config_test.dart` | 4 | Provider selection and missing-key fallback |
| `test/notification_checker_test.dart` | 4 | Alert-type off, quiet hours, rain trigger, cooldown using fake service |
| `test/notification_preferences_test.dart` | 6 | Quiet preference access and copy behavior |
| `test/display_settings_test.dart` | 3 | Constructed values and copy behavior |
| `test/app_analytics_test.dart` | 3 | Disabled events and selected sanitized payloads |

LCOV reports 1,110 hit / 1,404 recorded executable lines = **79.06% across 21 recorded source files**, including generated JSON code. That is not whole-repository coverage: adapters, Hive store, dashboard controller and all UI pages are absent from this LCOV. It measures line execution, not assertion strength. The quiet-hour test checking `isA<bool>()` does not establish boundary correctness; one rain-trigger test conditionally skips its assertion; cooldown can pass after zero deliveries. No `testWidgets` or integration suite was found. Native `RunnerTests.testExample` is empty.

## Isolated diagnostic observations

The external probe uses synthetic fixtures only for diagnosis and does not alter production code. Its successful execution means these observations were printed, not that the observed behavior is desirable. Convert scenarios into proper failing-then-fixed regression tests during implementation; do not install assertions that preserve the defects.

| Input | Observed current behavior |
| --- | --- |
| One wet hourly entry, 90% probability / 2mm | Available “Short dry slot: 08:00 to 09:00” |
| Dry entries at 08:00 and 12:00 only | Five-hour duration despite three missing hourly intervals |
| Elapsed 08:00 forecast entry | Accepted without an evaluation-time check |
| Dry entry with 5% precipitation probability | “High confidence” |
| Fake offline transport and empty cache | `Demo forecast`, `usingFallback=true` |
| Fake offline transport with 1 January 2020 cache | `Saved forecast` returned with original 2020 fetch time |
| HTTP 200 with empty Open-Meteo map | `Live weather by Open-Meteo`, fallback false, default 12°C daily max and 0% rain |
| Persisted master notification false, rain-alert type true | One call to fake rain notification service |

Reproduce with the installed dependency setup by copying `docs/audit/evidence/diagnostic-probe.dart.txt` to `/private/tmp/dryslot_phase0_probe_test.dart` and executing the command above from the repository root. Probe temporary Hive data remains outside the repository. The probe has no assertions and is retained as an investigation artifact, not added to the unit suite.

## Public API smoke check

One request with preset London coordinates, no user location and no key returned HTTP 200. The exact request matched the adapter's parameter sets:

```sh
curl -s --max-time 25 -G 'https://api.open-meteo.com/v1/forecast' \
  --data-urlencode 'latitude=51.5072' --data-urlencode 'longitude=-0.1276' \
  --data-urlencode 'timezone=Europe/London' --data-urlencode 'forecast_days=7' \
  --data-urlencode 'forecast_minutely_15=8' \
  --data-urlencode 'current=temperature_2m,apparent_temperature,is_day,precipitation,rain,showers,weather_code,cloud_cover,wind_speed_10m,wind_gusts_10m,visibility' \
  --data-urlencode 'minutely_15=precipitation,weather_code,wind_speed_10m,visibility' \
  --data-urlencode 'hourly=temperature_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,wind_speed_10m,wind_gusts_10m,visibility,cloud_cover,uv_index,is_day' \
  --data-urlencode 'daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,uv_index_max,sunrise,sunset' \
  -w '\nHTTP_STATUS=%{http_code}\n' -o /private/tmp/dryslot-phase0-openmeteo-response.json
```

[Recorded response summary](evidence/openmeteo-smoke.json): current time 13:15 on 29 October, hourly count 168 starting at 00:00, short-range count eight starting at 13:15, daily count seven. This supports the elapsed-hour finding; it does not establish provider accuracy, uptime or performance. Keyed adapters, warning-feed correctness and native HTTP execution were not live-tested.
