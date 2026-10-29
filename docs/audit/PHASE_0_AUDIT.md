# Dry Slots: Phase 0 production-readiness audit

Audit date: 29 October 2026. Scope: Phase 0 only. Review status: awaiting owner review.

Audited revision: [`3baf32cc909c3fdffd44a72f917701941faeb832`](https://github.com/iclectic/DrySlot/commit/3baf32cc909c3fdffd44a72f917701941faeb832). Branch: `audit/phase-0-production-readiness`. The initial working tree was clean. The audit made no application changes or dependency upgrades. At the initial handoff, no commit or push had been made; the owner subsequently authorised committing and pushing the Phase 0 documentation. No store uploads or application releases were made.

## Assessment

The existing application is worth retaining. It already expresses a clear product purpose, has modular feature directories, three provider implementations, immutable Freezed models, Riverpod composition, GoRouter navigation, local persistence, eight activity scoring policies, routine editing, and notification infrastructure.

It is **not ready for commercial beta or production distribution**. The existing analyzer and 29 unit tests pass on this machine after dependency resolution, but all three mobile build attempts fail. More seriously, the app can manufacture forecast inputs during failures, accept arbitrarily old cached forecasts, recommend elapsed or unsupported time windows, and send notifications despite the master preference being disabled. Commercial data-use rights are unresolved. These issues affect the product's central promise of trustworthy weather decisions.

The recommended direction is incremental repair and extraction within the current Flutter application. A full rewrite has no supporting evidence. See the [architecture assessment](ARCHITECTURE_ASSESSMENT.md) and [proposed ADR](../adr/0001-preserve-and-harden-existing-application.md).

## Review pack

| Deliverable | Contents |
| --- | --- |
| [Baseline verification](BASELINE_VERIFICATION.md) | Actual commands, outcomes, environment, dependency caveats, coverage limits, diagnostic observations |
| [Architecture assessment](ARCHITECTURE_ASSESSMENT.md) | Current dependency flow, boundaries, reusable code, proposed changes and alternatives |
| [Risk register](RISK_REGISTER.md) | Priorities, evidence, consequences, mitigation ownership and acceptance gates |
| [Implementation backlog](IMPLEMENTATION_BACKLOG.md) | Numbered tasks, dependencies, proposed files, tests and completion criteria |
| [Provider and release gates](PROVIDER_AND_RELEASE_GATES.md) | Dated primary-source checks, licensing gaps and store prerequisites |
| [Roadmap](../ROADMAP.md) | Phases 0–14, outcomes and gates |
| [Implementation status](../IMPLEMENTATION_STATUS.md) | What exists, what was actually verified and what remains blocked |
| [Engineering record](../ENGINEERING_RECORD.md) | Work-package report, learning questions and suggested PR |
| [Repository inventory](evidence/repository-inventory.tsv) | Every tracked baseline file, size, line count, SHA-256 and inspection scope |

## Repository scope and method

The baseline has 278 tracked files: 203 text files and 75 PNG/ICO assets. `lib/` has 92 Dart files and 22,012 physical lines: 87 handwritten files / 15,021 lines, and five generated files / 6,991 lines. Thirteen handwritten files are one-line compatibility exports. Seven Dart test files contain 29 tests. These are inventory measurements, not complexity or performance benchmarks.

The audit read the application source and tests, followed imports and active routes, examined Android/iOS build and permission configuration, provider parsing, storage, background execution, notifications, privacy text and existing documentation. Generated model code was inspected for structure and serialization; other platform runners and resource manifests received static inspection. Binary assets were inventoried, not visually certified. Desktop and web shells exist but were not built or exercised. No tracked `AGENTS.md` was found; the session-provided repository instructions were followed, including doing agent work sequentially in the main thread.

Verification used the installed stable Flutter SDK. Tool-generated migrations and dependency changes were captured and restored; builds are explicitly qualified by these temporary migrations. An isolated diagnostic probe ran outside the application/test directories. Public provider and store documentation was checked for current licensing and submission requirements. No private weather keys, developer account credentials, user locations, provider account plans, remote CI history, or store-console state were assumed available.

## Existing product capability

| Area | Existing implementation | Assessment |
| --- | --- | --- |
| Onboarding and navigation | Splash, optional device location or manual UK search, notification choice, routine choice; Home / Planner / Routines / Settings | Useful structure. Splash waits for network-backed initialization; onboarding layout needs small-screen/text-scale testing. |
| Current forecast and guidance | Three adapters, current/hourly/daily data, next rain, clothing, warnings, simple/detailed explanation | Preserve; harden input validation, temporal scope and unavailable states. |
| Dry windows | Longest qualifying run in the domain; separate ranked runs in the dry-slots page | No requested-duration input, continuity validation or evaluation clock. Two algorithms can disagree. |
| Activities | Walking, running, cycling, picnic, laundry, dog walk, football, outdoor coffee | Real heuristics exist. They score broad daily context, not the user's requested interval or preferences. No observed calibration evidence. |
| Routines | Editable named start/end times stored locally; overnight window support | No weekdays, selected activity, recurrence exceptions or per-routine location. Deleting all routines restores examples. |
| Provider/cache | Dio, retry interceptor, Hive JSON storage keyed by provider/rounded coordinates | Good seams. Failure handling conflates cache and demo; no retention/expiry or typed capability model. |
| Notifications | Local channels, alert types, quiet hours, cooldowns, periodic worker | Master preference not enforced; stale/sample data can trigger alerts; native delivery unverified. |
| Accessibility | Material 3 themes, system scaling, high contrast, reduced animation, semantic labels in some components | Preserve. No widget/assistive-technology acceptance evidence; colorblind setting exists in a sheet stranded in the legacy dashboard. |
| Native widgets | Dart data writer and in-app previews | No Dry Slots Android widget receiver/provider or iOS WidgetKit extension/App Group. Preview tells users to use the widget picker prematurely. |
| Observability | Optional Sentry DSN, disabled-by-default analytics abstraction with debug-only sink | Sentry native compilation fails. No deployed analytics pipeline or feedback collection evidence. |

## Findings that change the implementation order

1. **Remove invented production weather before polishing recommendations.** `BaseNetworkWeatherRepository.fetchWeather` returns `DemoWeatherRepository` on cold failure. Each provider also creates default daily data when daily payloads are absent; numeric/date helpers turn unknown values into zero or now. An empty Open-Meteo payload produced a report labelled live with 12°C daily maximum and 0% rain chance in the probe. See R01/R02.
2. **Treat time and interval coverage as core domain contracts.** Open-Meteo's live response returned 168 hourly entries starting at midnight. The calculator selects the first 14, can merge gaps, and has no evaluation time or activity duration. Offset-free provider times are parsed in the device timezone; OpenWeather timestamps are explicitly converted to device local time. Cached guidance uses the original fetch time. See R04–R07.
3. **Separate precipitation probability from confidence.** The dry-window confidence string is derived from mean precipitation probability. Next-rain confidence is based on slot count/provider name. Neither has calibration evidence. Preserve probability as probability and describe coverage/freshness separately. See R06.
4. **Repair native builds and release signing in small packages.** Android debug fails on missing desugaring; release fails compiling Sentry Kotlin; iOS fails compiling Sentry Swift. Android release signing still uses debug keys despite README keystore instructions. See R09–R11.
5. **Recover useful features deliberately.** The 2,612-line `WeatherDashboardPage` is not routed. Radar, sharing, weekend and comparison result cards, pull-to-refresh, offline banner and most analytics hooks are concentrated there. Compatibility exports are not duplicate implementations. Preserve these components before retiring legacy code. See R12/R13.
6. **Gate alerts on consent, fresh data and native support.** A diagnostic with the persisted master preference false still called the rain notification service. The worker is registered at every startup and hardcodes Open-Meteo, independently of the foreground provider. See R08/R14.
7. **Resolve commercial rights before selecting a release provider.** Current default code uses Open-Meteo's public endpoint; commercial access, attribution, cache retention, distribution and mobile key constraints need an explicit recorded decision. Radar needs its own decision. See R03 and the [release gate register](PROVIDER_AND_RELEASE_GATES.md).

## Security, privacy and operations

There is no account/authentication flow or custom backend in the repository. Location access is requested on user action at medium accuracy; manual search is available. Android does not declare background location permission. The worker uses a saved location rather than requesting continuous device updates. These are useful privacy properties to preserve.

Selected/comparison coordinates, reports and routine labels persist in Hive without an application retention/deletion policy. OS backup and uninstall semantics have not been validated. Weather provider requests contain coordinates; search requests contain user-entered queries; OS reverse geocoding may involve a platform service. The privacy policy names only Open-Meteo and Sentry, omitting other selectable providers and radar. `sendDefaultPii=false` and screenshots disabled do not prove all exception text, URLs or breadcrumbs are free of location or key data. Sentry activation is controlled by the build DSN, independently of the analytics preference.

A targeted scan of tracked baseline contents for private-key headers, AWS access-key patterns and GitHub token patterns found no matches; no tracked keystore, key.properties, P12 or provisioning profile was found. This was not an exhaustive secret-history, dependency-vulnerability or third-party SDK audit. Android signing files are gitignored. App-level Apple privacy manifests, release automation, a repository license and a dependency-license inventory were not found. Whether SDK privacy manifests satisfy a final archive requires inspecting a successful archive later.

No tracked GitHub Actions workflow, integration-test directory or functional widget test exists. The native iOS test is an empty template. There are no measured launch/frame/memory/battery baselines, field forecast calibration, adoption figures, testimonials, user studies or production incident records in the reviewed files. None are inferred from source code or the passing unit suite.

## Phase 0 exit and review boundary

Phase 0 deliverables are prepared; approval is pending. Review the factual findings, proposed preservation boundaries, P0 task order and licensing gates. Platform/account ownership, provider budget/rights, supported OS versions and any prior published application identifiers still need owner confirmation before dependent release work.

Phase 1 has not started. Review acceptance of this pack does not authorize application publication, store submission, provider purchases or credential creation. Future code packages should each use a dedicated branch and report changed files, rationale, tests actually run, limits, learning questions and a suggested PR. Backlog completion must be based on acceptance evidence, never simply on adding code.
