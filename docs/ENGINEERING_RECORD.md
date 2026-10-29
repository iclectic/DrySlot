# Engineering record

Maintain factual records of significant contributions. Record proposed decisions separately from implemented decisions, and observations separately from hypotheses. Never fill missing user, performance or release outcomes with estimates presented as fact.

## WP-000: Phase 0 audit

Date: 29 October 2026. Status: deliverables prepared; owner review pending. Baseline: [`3baf32cc909c3fdffd44a72f917701941faeb832`](https://github.com/iclectic/DrySlot/commit/3baf32cc909c3fdffd44a72f917701941faeb832). Branch: `audit/phase-0-production-readiness`. Contribution commits: see the [audit branch history](https://github.com/iclectic/DrySlot/commits/audit/phase-0-production-readiness). No PR created. The baseline link identifies inspected code, not the audit contribution.

Publication authorisation: following the initial uncommitted audit handoff, the owner requested “push phase 0”. This authorises committing and pushing the documentation branch only; Phase 1 review remains pending.

### 1. Summary of changes

Added a repository audit and inventory, actual verification evidence, architecture assessment, risk register, provider/store gate review, 31-item backlog, phased roadmap, implementation status and proposed ADR. Application source, platform configuration, dependencies and existing tests are unchanged from the baseline after restoring tool migrations. Phase 1 has not begun.

### 2. Files modified

Only new documentation and evidence under `docs/` remain as deliverable changes:

- `docs/ROADMAP.md`
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/ENGINEERING_RECORD.md`
- `docs/adr/0001-preserve-and-harden-existing-application.md`
- `docs/audit/PHASE_0_AUDIT.md`
- `docs/audit/ARCHITECTURE_ASSESSMENT.md`
- `docs/audit/RISK_REGISTER.md`
- `docs/audit/BASELINE_VERIFICATION.md`
- `docs/audit/PROVIDER_AND_RELEASE_GATES.md`
- `docs/audit/IMPLEMENTATION_BACKLOG.md`
- `docs/audit/evidence/`: path-sanitized command logs, diagnostic source/output, resolved lock snapshots, tool-migration diff, Android merged manifest/blame, partial LCOV, public API response summary and baseline file inventory/hashes. See `docs/audit/evidence/deliverables.txt` for every deliverable path.

Native tooling temporarily changed Gradle properties, iOS Podfile/lock/project/scheme and dependency/analyzer files. Those diffs were retained as evidence and the tracked files restored. Ignored local SDK/build/dependency artifacts can remain on disk; they are not deliverables.

### 3. Architectural rationale

The problem is lack of reliable evidence and unsafe boundaries in existing behavior, rather than absence of an application architecture. The audit follows active routes, repository interfaces, interval math and side effects before proposing changes. It recommends retaining existing integrations and extracting a pure-Dart engine incrementally. A full rewrite, broad package migration, immediate backend and ML-first model were considered and deferred for lack of a demonstrated need. See [architecture assessment](audit/ARCHITECTURE_ASSESSMENT.md) and [proposed ADR](adr/0001-preserve-and-harden-existing-application.md).

### 4. Tests written

No production regression tests were added in this documentation-only package. An isolated external diagnostic with eight printed observations was written/executed; its source is preserved as `diagnostic-probe.dart.txt`, outside the test suite. It reproduces defects and has no correctness assertions. Future fixes must add meaningful regression tests, not assertions preserving these observed failures. Existing 29 tests were run unchanged.

### 5. Commands executed and results

Full command/evidence ledger: [baseline verification](audit/BASELINE_VERIFICATION.md).

- Analyzer: exit 0, no issues; unit tests: exit 0, 29 passed.
- Locked dependency enforcement: exit 65; initial ordinary resolution succeeded with six changes.
- Debug APK, release AAB and unsigned iOS release builds: each exit 1, with distinct desugaring/Sentry native compilation failures.
- Android release manifest merge: exit 0; confirmed dependency-supplied INTERNET permission.
- External diagnostic: exit 0, eight defect observations. Preset London public API smoke: HTTP 200.
- Repository inspection used `rg`, shell reads, `git status/log/ls-files/show/diff`, and Python inventory/targeted credential-pattern scans. No matching targeted credential patterns or tracked release-credential files were found; full history/vulnerability audits remain open.
- Final document verification: `git diff --check` and `python3 /private/tmp/dryslot_phase0_verify_docs.py` both exited 0. Source/output are retained in evidence. The Python check also covers untracked document whitespace, local Markdown targets, baseline inventory hashes, backlog IDs and unchanged tracked files, not runtime correctness.

### 6. Known risks and limitations

The passing analyzer/tests used installed stable SDK dependencies resolved locally, because the committed lock cannot be enforced. Native build attempts included automatic tool migrations. Coverage is partial (1,110/1,404 recorded lines across 21 files), and some assertions are weak/time-dependent. No physical device, signed artifact, production provider entitlement, remote CI run or store state was verified. Binary assets were inventoried but not visually accepted. All [risks](audit/RISK_REGISTER.md) remain open.

### 7. Incomplete work

Phase 0 owner review and all Phase 1–14 implementation. No production defects were repaired. No release credentials were created/used, PR created, or application release published. Committing and pushing this documentation branch was subsequently authorised by the owner. Provider purchases, release uploads and submissions need separate explicit approval when a concrete candidate exists.

### 8. Suggested pull request

Title: **docs: audit Dry Slots production readiness and prioritise implementation**

Description:

> Establish a Phase 0 baseline for the existing Flutter application before production hardening. Document the current architecture, reusable features, reproduced weather/cache/notification defects, native build blockers, licensing gates and a prioritised 31-task roadmap.
>
> Validation: analyzer and 29 existing tests passed on locally resolved dependencies; enforced lockfile resolution failed; Android debug/release and unsigned iOS release builds failed with captured logs. Preserve diagnostic and manifest evidence, and leave application code unchanged. Phase 1 awaits review.

## Learning record: WP-000

**Technical problem solved:** replace assumptions about production readiness with a traceable account of code paths, actual build/test outcomes and reproduced failures. This is an audit contribution, not a performance or release achievement.

**Why this approach:** reading active routes revealed that many attractive features were unrouted, while isolated probes exposed dangerous behavior that the passing tests did not assert against. Native build and merged-manifest checks distinguished real blockers from plausible static suspicions.

**Alternatives and trade-offs:** read-only analysis alone would miss build/toolchain failures; fixing during audit would blur the requested review boundary. Local verification creates generated artifacts and may migrate configuration, so the audit captures those changes and restores tracked inputs. Preserving the code avoids unnecessary replacement, but leaves remediation work explicitly outstanding.

**How to test/debug:** reproduce baseline commands with the stated SDK and dependency caveat; inspect linked logs before changing configuration. For decision defects, run the external diagnostic and then design regression tests around desired behavior. Trace provider measurement intervals, UTC/location zone, cache age and active UI before adjusting thresholds. For release permissions, inspect the merged manifest and blame report rather than only the app manifest.

Three questions to demonstrate understanding:

1. Why can 29 passing unit tests and 79.06% recorded-line coverage coexist with invented production forecasts and three failed mobile builds?
2. Why must the decision engine distinguish a timestamp, its represented precipitation interval, the device timezone and the selected location timezone before evaluating a requested duration?
3. What makes a cached forecast eligible for a recommendation or notification, and why are precipitation probability, data freshness and measured forecast accuracy different concepts?

## Measurements and portfolio evidence ledger

| Evidence category | Current factual record | Next evidence needed |
| --- | --- | --- |
| Significant contribution | Phase 0 audit and reproduced risk evidence; owner-authorised documentation push tracked in branch history above | PR link if one is subsequently requested/created |
| Architectural decisions | ADR 0001 proposed | Review/acceptance and implementation references |
| Tests | 29 existing tests passed; diagnostic observations captured | Regression/contract/widget/integration outcomes for each fix |
| Releases | Three local native build failures; no successful release artifact | Successful signed candidate, hashes, device results and approved distribution record |
| Performance | One-run build/setup durations only; no comparable before/after measurements | Device/OS/build-mode workload, repeated baseline and after-change measurements |
| Forecast quality | No observed-outcome calibration dataset | Consented/appropriately licensed observations and defined calibration scoring |
| Product outcomes | No verified research, feedback, adoption or revenue data | Dated real feedback and measurable outcome records |

For each later major package, append the same eight report fields and learning record, link actual commits/PRs, and retain measurement conditions and release results. Avoid recording private credentials, exact user locations or personal feedback identifiers in public engineering evidence.
# DS-001 work in progress: native compatibility

The Android debug build previously stopped before compilation because notifications require core-library desugaring; after enabling it, Workmanager 0.5.2 failed against removed Flutter embedding APIs. The dependency was moved to 0.6.0, which removes the v1 APIs. Sentry was upgraded to 9.30.1 to address native SDK compatibility. Flutter generated an iOS 15 and Swift Package Manager migration during the build. The trade-off is a higher minimum iOS version and dependency changes that require device and clean-checkout validation; keeping old packages would retain known build failures. The Sentry major upgrade and background scheduling behavior require further runtime verification.

Evidence: locked pub resolution, analyzer and 29 tests succeeded; Android debug, Android release bundle and unsigned iOS release compiled. The Android release build originally failed because a blanket Flutter engine keep rule retained unused deferred-delivery classes referencing absent Play Core APIs. Removing that rule allowed R8 to shrink the release; debug signing is still configured. An isolated source snapshot also built Android release and unsigned iOS release using the same machine and caches. See `IMPLEMENTATION_STATUS.md` for commands and caveats. No new tests were added for configuration-only changes; actual builds are the relevant integration check, while background execution requires device tests. The owner authorised committing and pushing this partial package on `fix/ds-001-native-builds`; its [branch history](https://github.com/iclectic/DrySlot/commits/fix/ds-001-native-builds) records the contribution. No PR has been created; DS-001 remains incomplete pending its outstanding acceptance checks.

To debug, reproduce the release bundle with `flutter build appbundle --release` and inspect R8 output and `build/app/outputs/mapping/release/missing_rules.txt`; do not suppress missing classes without establishing why they are safe. Suggested eventual PR: `fix: restore reproducible Android and iOS builds` — resolve native dependency and toolchain compatibility, retain strict release checks, and document supported platforms and verified build results.

Questions: Why does Android desugaring need both a Gradle flag and a library? How does an unsigned iOS build differ from a distributable archive? Why must a missing R8 class be investigated before suppressing its warning?
