# Dry Slots roadmap

Updated 29 October 2026. Mission: build a trustworthy, explainable, activity-aware weather decision assistant while preserving valuable existing Flutter code. This is a proposed sequence, not a claim that later phases are implemented or authorised.

Canonical evidence: [Phase 0 audit](audit/PHASE_0_AUDIT.md). Execution state: [implementation status](IMPLEMENTATION_STATUS.md). Task-level dependencies and acceptance tests: [numbered backlog](audit/IMPLEMENTATION_BACKLOG.md).

## Phase gates

| Phase | Intended outcome | Principal backlog tasks | Exit gate / current status |
| --- | --- | --- | --- |
| 0: audit | Repository inventory, actual baseline, architecture assessment, risks and prioritised backlog | Audit work package; DS-031 record established | Deliverables prepared; **owner review pending**. No Phase 1 implementation started. |
| 1: production blockers | Buildable native baseline; valid signing configuration; honest failure/cache states; temporal corrections; consent enforcement | DS-001–010 | Executed Android/iOS compile checks, regression tests for invented/stale data, interval/DST and notifications; reviewed licensing/configuration gates. Proposed only. |
| 2: architecture | Preserve modules and integrations; pure decision facts; isolated repository/platform effects | DS-011 | Characterized existing behavior, migration tests, explicit domain/platform boundaries and no accidental feature loss. Proposed only. |
| 3: Dry Window Engine | Requested-duration and activity-aware deterministic recommendations with reasons | DS-012–013 | Coverage/gap/timezone/activity/hazard tests; one engine feeds all consumers; probability never labelled accuracy/confidence. Proposed only. |
| 4: provider standardisation | Typed capabilities, provenance, warning status, cache schema and commercial rights | DS-002,009,014–015 | Provider fixture contracts, retention/migration tests, approved commercial provider configuration and attribution. Proposed only. |
| 5: design/onboarding | Clear active dashboard, recoverable startup, accessible navigation, useful existing features | DS-016–017 | Tested onboarding/denial/offline flows, source/age visible, responsive layouts and feature-preservation review. Proposed only. |
| 6: personalisation | Valid recurring routines, activity preferences and evaluated alternatives where prioritised | DS-018–019 | Schema migration, recurrence/DST/duration tests, useful empty state and user validation. Alternatives remain P2. Proposed only. |
| 7: platform hardening | Reliable local notification lifecycle, honest background support and deep links | DS-020–022 | Real-device lifecycle/delivery checks. Native widgets remain P2 and need prioritisation; remove unsupported promises meanwhile. Proposed only. |
| 8: security/privacy | Minimal location/data retention, truthful privacy controls and SDK/licensing review | DS-023–024 | Data-flow review, redaction and deletion tests, scanner/license findings, platform disclosures. Proposed only. |
| 9: comprehensive verification | Unit/widget/integration/contract/release checks and protected CI/CD | DS-010,025 | Observed strict CI runs plus device and release evidence. CI/CD prepares artifacts; uploads still require approval. Proposed only. |
| 10: performance/accessibility | Measured improvements to launch/render/network/memory/battery and assistive use | DS-017,026 | Comparable before/after measurements with devices/build modes and accessibility acceptance results. No measurements yet. |
| 11: observability/feedback | Privacy-conscious events, crash evidence and real user feedback | DS-027 | Reviewed consent/redaction, useful event questions and actual feedback records. No production usage claims. Proposed only. |
| 12: beta preparation | Reproducible signed Android/iOS candidates and tested device matrix | DS-028 | Artifact hashes, valid signing/identifiers, commercial rights and beta review. Distribution requires explicit approval. Proposed only. |
| 13: production preparation | Versioned store-ready builds, assets, metadata, policy/support and submission pack | DS-029 | Exact candidate/metadata approved before submission/publication; store acceptance recorded only when observed. Proposed only. |
| 14: post-launch | Monitoring, incident response, measured growth experiments, technical case studies | DS-030–031 | Actual launch evidence and observed signals; optional calendar, calibration and backend alerts scoped separately. Not started. |

## Sequencing rules

Phase 0 review is a hard boundary. Afterwards, production data safety, native build repair and provider-rights discovery can proceed in independent small branches. A trustworthy beta requires completion of all applicable P0 gates, even when a P0 deliverable belongs to a later phase.

Tests accompany every behavior change; they are not deferred to Phase 9. A minimum strict CI workflow is intentionally proposed in Phase 1, with Phase 9 completing device/contract/release coverage. Likewise, provider rights are investigated before commercial feature commitments, even though provider standardisation is Phase 4. These dependency adjustments do not start later-phase implementation during this audit.

Retain Riverpod, Freezed, Dio, GoRouter, working feature boundaries and stored user data. Do not perform a broad rewrite or dependency migration without new evidence. Pure-Dart decision logic should remain local; add packages or backends only for a concrete approved requirement.

No calendar dates or effort estimates are committed. Provider contracts, account/signing access, supported devices and the selected feature scope affect delivery. Every package needs actual verification, residual-risk notes, a learning record and a suggested PR. External publication/release always requires explicit approval.
