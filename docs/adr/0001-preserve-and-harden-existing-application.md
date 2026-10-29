# ADR 0001: Preserve the application and harden its decision boundaries

Date: 29 October 2026. Status: **Proposed; awaiting Phase 0 review**.

## Context

Dry Slots already uses Flutter, Riverpod, Freezed, Dio and GoRouter with useful feature modules and local persistence. The Phase 0 audit found dangerous weather fallbacks, temporal/coverage errors, native build failures and missing release evidence. These problems do not demonstrate that the application needs a rewrite.

## Proposed decision

Retain the current application and integrations. Repair production data handling and native builds in independent branches. Introduce an explicit time/interval contract and extract a pure-Dart, duration-aware decision engine behind existing feature seams. Keep provider normalization, persistence, platform delivery and widget presentation separate. Characterize useful current behavior and migrate compatibility exports only when their callers have moved.

Record a separate provider/licensing ADR before selecting commercial endpoints or a credential gateway. This ADR does not approve a provider, backend, purchase, package migration or external release.

## Alternatives considered

1. Full rewrite: rejected as the audit recommendation because existing modular code has value and replacement increases regression/persistence risk.
2. Broad dependency/framework migration: defer; investigate each demonstrated build incompatibility with a small compatible set first.
3. Backend-first or ML-first recommendations: defer; neither is needed for deterministic local scoring, and there is no calibration dataset. Provider contracts may later require a gateway.

## Consequences

Existing features and stored preferences can be preserved. Temporary adapters and old presentation code remain while migration occurs. Characterization and boundary tests cost time but make changes reviewable. Pure-Dart results will need presenters to supply strings, icons and accessibility descriptions.

## Acceptance evidence required later

Phase 0 owner review; passing typed unavailable/cache/provider tests; interval/DST/activity-duration tests; active-screen consistency checks; successful Android/iOS builds with recorded SDKs and valid signing configuration. Acceptance and implementation dates remain unset. No architectural code was changed by this audit.
