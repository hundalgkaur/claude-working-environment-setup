---
name: ci-builder
description: Load when the user wants to create, fix, or harden a CI pipeline for a repo — generating or maintaining a GitHub Actions workflow that gates PRs on install, lint, typecheck, test, and build. Triggers include "set up CI", "add a CI workflow", "my CI is failing/missing gates", or requests for a .github/workflows/ci.yml.
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

## Purpose
Generate or maintain a GitHub Actions CI workflow that runs install, lint, typecheck, test, and build as required gates. Any failed gate fails the PR. Add a build matrix where it adds value and cache dependencies for speed.

## When to use
- User asks to set up, add, or scaffold CI for a repository.
- An existing `.github/workflows/ci.yml` is missing gates, has no caching, or lets failures pass.
- User wants PRs blocked until lint/typecheck/test/build pass.
- A new language/runtime version must be covered via a matrix.

## Procedure
1. Detect the stack: Glob/Read for `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, lockfiles, and any existing `.github/workflows/*`.
2. Identify the real commands from the manifest scripts (e.g. `lint`, `typecheck`/`tsc`, `test`, `build`). Do not invent script names — Grep the manifest to confirm each exists; skip a gate only if no command exists and note it.
3. Choose triggers: `on: pull_request` (target branches) and `push` to the default branch. Set `permissions:` to least privilege (`contents: read`).
4. Add a matrix only where useful (multiple runtime versions or OSes). Keep it minimal; pin the primary version explicitly.
5. Enable dependency caching via the setup action's built-in cache (e.g. `actions/setup-node` `cache:`, `setup-python` `cache:`) keyed on the lockfile.
6. Order gates: checkout, setup+cache, install (frozen/locked), lint, typecheck, test, build. Each is a separate step so failures are attributable.
7. Ensure failures propagate: no `continue-on-error`, no `|| true`. A non-zero step must fail the job and thus the PR check.
8. Write the result to `.github/workflows/ci.yml`. If one exists, Edit to add missing gates/caching rather than overwriting unrelated jobs.
9. Validate YAML syntax (`Bash`: a YAML lint/parse if available) and confirm referenced scripts resolve.

## Checklist
- [ ] All five gates present (install, lint, typecheck, test, build) or absence explained.
- [ ] Every gate command exists in the project manifest — none invented.
- [ ] Triggers cover `pull_request` and default-branch `push`.
- [ ] Dependency cache configured and keyed on the lockfile.
- [ ] Matrix used only where it adds value; primary version pinned.
- [ ] No `continue-on-error`/`|| true` — any gate failure fails the PR.
- [ ] `permissions:` set to least privilege.
- [ ] Output is valid YAML at `.github/workflows/ci.yml`.
