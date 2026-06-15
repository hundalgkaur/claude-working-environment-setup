---
name: store-release
description: Load when asked to prepare and ship an App Store / Play Store release with a staged rollout. Triggers on "ship a release", "submit to App Store / Play Store", "cut a build", "staged/phased rollout", "bump version", "prepare store listing", "TestFlight / internal testing".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Store Release

## Purpose
Prepare and ship a production mobile release to the App Store and/or Play Store
with correct versioning, signed builds, complete store metadata, and a staged
(phased/percentage) rollout with a monitoring and rollback plan.

## When to use
- "ship / cut / submit a release" / "release to the stores"
- "staged rollout" / "phased release" / "release to 10% first"
- "bump the version / build number" / "prepare the store listing"
- "push to TestFlight / Play internal testing" before promoting to production.

## Procedure
1. Pre-flight. Confirm the branch follows the merge flow (feature -> dev -> test
   -> main; release cut from main), the tree is clean, and CHANGELOG/release
   notes exist. Never release off an unmerged feature branch.
2. Version. Bump marketing version + build/version code per platform (iOS
   CFBundleShortVersionString/build, Android versionName/versionCode); ensure
   the build number is strictly higher than the last submitted.
3. Build signed artifacts. Produce release builds with the correct signing
   (iOS distribution cert/provisioning, Android keystore/Play signing) via the
   project's CI/fastlane/EAS pipeline; do not ship debug or ad-hoc keys.
4. Metadata + compliance. Verify listing (name, screenshots, description),
   privacy nutrition labels / Data Safety form, export-compliance, age rating,
   and required permissions justifications are current.
5. Internal testing first. Ship to TestFlight / Play internal or closed track;
   smoke-test critical flows and crash-free startup before promoting.
6. Staged rollout. Submit for review, then release with phased rollout enabled
   (Play percentage stages; iOS phased 7-day). Start small (e.g. 5-10%).
7. Monitor + decide. Watch crash-free rate, ANRs, key funnels, and reviews at
   each stage; halt/roll back (Play halt; iOS pause + expedited fix) on
   regression, otherwise advance to 100%. Tag the release and record notes.

## Output format
```
## Release
- Version / build, platform(s), track, store review status

## Artifacts
- signed build(s) + how produced; signing verified

## Rollout plan
- stages (%), start %, monitoring metrics + thresholds, rollback trigger

## Checks
- metadata/privacy/compliance status; internal test result

## Follow-ups
- post-release tasks / known issues
```

## Checklist
- [ ] Released off main per merge flow; tree clean; release notes ready
- [ ] Version + build number bumped and strictly higher than last submission
- [ ] Signed release build via CI/fastlane/EAS (no debug/ad-hoc keys)
- [ ] Listing, privacy/Data Safety, export, age rating, permissions current
- [ ] Internal/TestFlight smoke test passed before production submit
- [ ] Phased/percentage rollout enabled, starting small
- [ ] Crash-free/ANR/funnel monitoring + rollback trigger defined; release tagged
