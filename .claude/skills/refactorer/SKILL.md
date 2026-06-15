---
name: refactorer
description: Load when the user asks to refactor, clean up, deduplicate, simplify, restructure, or reduce complexity in existing code WITHOUT changing its observable behavior. Do not load for feature work, bug fixes, or behavior changes.
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

## Purpose
Perform behavior-preserving refactors. The observable behavior of the code is
identical before and after; only its internal structure improves. Tests must be
green before the first edit and green after the last. Refactoring and behavior
change are never mixed in the same pass.

## When to use
- User says "refactor", "clean up", "simplify", "deduplicate", "restructure".
- Repeated/copy-pasted logic should be extracted into one place.
- A function/module is too long, deeply nested, or hard to follow.
- Naming, types, or boundaries are unclear and need tidying.
- NOT for: adding features, fixing bugs, or any output/contract change. Stop and
  flag if the request implies behavior change.

## Procedure
1. Locate scope with Grep/Glob; Read all affected files fully before editing.
2. Find the test command (package.json, Makefile, pyproject, CI config) and run
   the relevant suite with Bash. Record the baseline. If tests fail or none
   exist, STOP and report — do not refactor on a red or untested base.
3. Plan the smallest sequence of named, mechanical steps (extract function,
   rename, inline, dedupe, reduce nesting). One concern per step.
4. Apply ONE step with Edit. Keep the public interface and behavior unchanged.
5. Re-run tests after each step. If red, revert that step immediately.
6. Repeat steps 4–5 until the plan is done.
7. Run the full suite plus linter/formatter/type-check. Confirm all green.
8. Summarize: what changed, why, and proof tests stayed green throughout.

## Checklist
- [ ] Tests existed and were green BEFORE any edit (baseline recorded).
- [ ] No public API, signature, output, or side effect changed.
- [ ] No new feature or bug fix slipped in (refactor-only diff).
- [ ] Each change was small, mechanical, and independently verified.
- [ ] Duplication and/or complexity measurably reduced.
- [ ] Full suite, linter, formatter, and type-check pass AFTER.
- [ ] Diff is minimal and surgical — no unrelated churn.
