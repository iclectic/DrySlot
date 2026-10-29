# Implementation status

As of 29 October 2026. Baseline commit: [`3baf32c`](https://github.com/iclectic/DrySlot/commit/3baf32cc909c3fdffd44a72f917701941faeb832). Branch: `audit/phase-0-production-readiness`.

**Phase 0 deliverables are prepared and awaiting review. Phases 1–14 are not started by this work.** Existing code is described below without treating it as verified delivery of the roadmap. The owner subsequently authorised committing and pushing these documents on the audit branch; this does not approve Phase 1. No PR, application release or provider purchase was made.

## Phase 0 checklist

- [x] Inventory all 278 tracked baseline files and record source hashes.
- [x] Read application/test source and assess native configuration, generated boundaries and other platform shells; record visual/runtime exclusions.
- [x] Record installed toolchains, dependency-resolution limitations, analyzer, tests, coverage and mobile build attempts.
- [x] Verify core failure scenarios through an isolated diagnostic probe and a public preset-location API smoke request.
- [x] Document current architecture, valuable code/features, risks and commercial/store release gates.
- [x] Create numbered implementation backlog, roadmap, engineering record and proposed ADR.
- [x] Preserve logs/resolved dependency/migration evidence and restore tool-generated changes to tracked application/configuration files.
- [ ] Owner review of Phase 0 findings and proposed priorities.
- [ ] Approval to begin Phase 1.

## Baseline checks

| Check | Actual status | Important qualification |
| --- | --- | --- |
| Analyzer | Passed, no issues | Installed Flutter 3.47.8; locally resolved dependencies; original analysis settings restored |
| Existing unit suite | Passed, 29 tests | No functional widget/integration coverage; partial LCOV only |
| Committed lock reproducibility | Failed | `flutter pub get --enforce-lockfile`, exit 65 |
| Android debug | Failed | Notification plugin requires core library desugaring |
| Android release bundle | Failed | Sentry Kotlin language version 1.6 unsupported |
| iOS unsigned release | Failed | Sentry Swift `SentryBinaryImageCache.image` error after automatic tool migrations |
| Android release manifest task | Passed | Manifest merge only; internet permission supplied by Sentry; target/minimum SDK 36/24 in this environment |
| Diagnostic probe | Executed, eight observations | Reproduced existing defects; not an acceptance test |
| Mobile install/device use | Not executed | No attached mobile device listed by doctor |
| Signing / beta / store submission | Not executed | Credentials/account readiness not assumed; external actions not authorised |

See [baseline verification](audit/BASELINE_VERIFICATION.md) for exact commands, logs and limitations.

## Existing implementation versus validated capability

| Capability | Existing state | Remaining work |
| --- | --- | --- |
| Weather provider abstraction | Three adapters and config implemented | Typed failures, strict validation, contractual interval/capability semantics and approved commercial access |
| Cached weather | Hive provider/location cache implemented | Expiry, retention, schema migration, truthful age/source and safe unavailable states |
| Dry-window recommendations | Longest-run heuristic and separate UI ranking implemented | Current correctness defects; requested duration/activity/daylight/coverage-aware engine |
| Activity advice | Eight deterministic scoring heuristics implemented | Interval-specific thresholds, hazard/missing-data semantics, personal preferences and explanation evidence |
| Routines | Local labelled start/end templates and editor implemented | True empty state, weekdays, activity/duration/timezone recurrence and migrations |
| Onboarding/navigation | GoRouter feature navigation and optional permissions implemented | Startup independence, flow/layout tests, back/deep-link behavior and active feature preservation |
| Notifications | Channels/checker/quiet hours/cooldowns/worker implemented | Master consent, fresh authentic data, cancellation, native background configuration and device delivery proof |
| Widgets | Dart payload writer/in-app preview implemented | No native Dry Slots widget targets; product copy must reflect this |
| Radar/sharing/weekend/comparison | Useful code exists in unrouted old dashboard | Deliberate extraction/reconnection and licensing decisions; active comparison selection currently has no comparison result surface |
| Accessibility | Theme/scaling/contrast/reduced-motion primitives exist | Active-route layout/semantics, contrast measurements and assistive-technology acceptance |
| Analytics/crash/feedback | Debug-only analytics port, optional Sentry configuration | Native crash SDK build repair, privacy/redaction review, active hooks and approved feedback method |
| CI/release | README instructions and platform projects exist | Workflow, deterministic SDK/locks, valid signing, candidate artifacts and store readiness |

## Decisions and evidence still missing

Commercial provider/plan approval; warning/radar redistribution rights; account/team/identifier ownership and any existing listings; chosen OS support floor; signing credentials and compliant Apple toolchain; hosted privacy/support URLs; device acceptance; a complete SDK/license/security review; user research and measured product outcomes.

No performance improvement, forecast calibration, user adoption or store acceptance has been measured or claimed. The [risk register](audit/RISK_REGISTER.md) remains entirely open. Future task status should link an actual commit/PR and executed acceptance evidence before being marked complete.
