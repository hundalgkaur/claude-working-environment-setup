---
name: dep-auditor
description: Load when asked to audit project dependencies for known vulnerabilities (CVEs) and propose safe, minimal upgrades. Triggers on "audit dependencies", "check for vulnerable packages", "npm audit", "pip audit", "any CVEs", "are my deps safe", "supply chain risk".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Dependency Auditor

## Purpose
Audit a project's dependency tree for known vulnerabilities, separate direct
from transitive risk, and propose the smallest safe upgrade path that clears
the highest-severity issues without breaking the build.

## When to use
- "audit my dependencies" / "check for vulnerable packages"
- "any known CVEs in this project" / "are these deps safe"
- "run npm/pip/cargo audit" / "supply chain review"
- Before a release, or after a published advisory affecting the stack.

## Procedure
1. Detect ecosystems. Find manifests and lockfiles (package.json/lock,
   requirements/poetry/uv, go.mod, Cargo.toml, pom.xml, Gemfile) with Glob.
2. Run the native auditor per ecosystem: `npm audit --json` / `pnpm audit`,
   `pip-audit`, `osv-scanner`, `cargo audit`, `govulncheck`, `mvn` checks.
   Prefer a lockfile-aware tool; fall back to OSV if none is installed.
3. Parse results into findings: package, installed version, advisory/CVE,
   severity, fixed version, and whether the dep is direct or transitive.
4. Triage: drop findings with no reachable call path or no fix when noted;
   flag the rest. Prioritize CRITICAL/HIGH and internet-reachable code.
5. Plan upgrades: prefer minimal semver bumps; group fixes; flag any major
   bump as a breaking change needing review. For transitive issues, pin or
   use overrides/resolutions rather than blind top-level bumps.
6. Verify nothing obviously breaks: re-run install + the audit; run tests/lint
   if cheap. Note any upgrade with no available fix as accepted risk.
7. Emit the structured audit (format below). Apply upgrades only if asked.

## Output format
```
## Summary
- Ecosystems scanned, total findings: N critical, M high, ...
- Verdict: Clean | Action needed | Blocked (no fix available)

## Findings
| Package | Installed | Severity | CVE/Advisory | Fixed in | Direct? |

## Upgrade plan
1. pkg X.Y -> X.Z (minor, safe) — clears CVE-...
2. pkg A -> B (MAJOR, review) — breaking, clears CVE-...

## Accepted risk / no fix
- pkg + reason
```

## Checklist
- [ ] All manifests and lockfiles in the repo discovered
- [ ] Native auditor run per ecosystem (lockfile-aware where possible)
- [ ] Findings split direct vs transitive, with CVE + fixed version
- [ ] CRITICAL/HIGH prioritized; unreachable/no-fix items called out
- [ ] Upgrades are minimal semver; major bumps flagged as breaking
- [ ] Re-audit/install (and tests if cheap) confirm the plan
- [ ] No manifests changed unless upgrades were explicitly requested
