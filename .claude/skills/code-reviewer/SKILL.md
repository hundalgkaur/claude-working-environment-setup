---
name: code-reviewer
description: Load when asked to review a diff, PR, branch, or changeset for correctness bugs, security issues, or style/SOLID violations. Triggers on "review this", "check this code", "PR review", "find bugs", "is this correct", "review my changes".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Code Reviewer

## Purpose
Produce a thorough, actionable review of a diff or PR. Surface correctness
bugs first, then security exposures, then style and SOLID/maintainability
violations, and emit a single structured review report with a clear verdict.

## When to use
- "review this PR" / "review my changes" / "review the diff"
- "find bugs in this" / "is this correct"
- "check this code before I merge"
- "any security issues here"
- A branch or staged changeset is ready and needs sign-off before merge.

## Procedure
1. Scope the diff. Run `git diff` (or `git diff main...HEAD`) and list every
   changed file. If no git context, review the files the user named.
2. Read each changed file with enough surrounding context to judge intent;
   read callers/callees with Grep/Glob when behavior crosses boundaries.
3. Hunt correctness bugs: off-by-one, null/undefined, error paths, race
   conditions, wrong operators, broken invariants, untested edge cases.
4. Hunt security issues: hardcoded secrets, missing input validation,
   injection (SQL/command/XSS), authz/authn gaps, unsafe deserialization,
   leaked errors. Grep the diff for secret-like patterns.
5. Hunt style/SOLID: single-responsibility breaks, DRY violations, dead code,
   unclear names, overlong functions, leaky abstractions, missing types.
6. Assign each finding a severity (CRITICAL / WARNING / SUGGESTION) and a
   file:line location, with a concrete fix.
7. Emit the structured review (format below). Do not modify code unless the
   user explicitly asks for fixes.

## Review output format
```
## Summary
- Risk: LOW | MEDIUM | HIGH
- Findings: N critical, M warnings, P suggestions
- Verdict: Approve | Approve with changes | Request changes

## Critical
1. [CORRECTNESS|SECURITY] file:line — issue + fix

## Warnings
1. [CATEGORY] file:line — impact + fix

## Suggestions
1. [STYLE|SOLID] file:line — improvement

## Positives
- What was done well
```

## Checklist
- [ ] Every changed file read in context (not just the diff hunk)
- [ ] Correctness: edge cases, null/error paths, invariants checked
- [ ] Security: secrets, input validation, injection, authz/authn checked
- [ ] Style/SOLID: SRP, DRY, naming, function length, types checked
- [ ] Each finding has severity + file:line + concrete fix
- [ ] Verdict and risk level stated
- [ ] No code changed unless fixes were explicitly requested
