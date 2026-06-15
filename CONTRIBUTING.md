# Contributing

## Commit conventions

Conventional Commits give every commit a machine-readable, human-friendly shape. Follow them for all commits.

## Format

```
type(scope): subject

[optional body]

[optional footer]
```

- `type` is required and lowercase.
- `scope` is optional and names the area of the codebase affected, e.g. `auth`, `api`, `parser`.
- `subject` is required and follows the colon-space.

Example: `feat(auth): add refresh token rotation`

## Allowed types

| Type | Use for |
|------|---------|
| `feat` | A new feature for the user |
| `fix` | A bug fix |
| `chore` | Maintenance with no src/test behavior change (deps, tooling, config) |
| `docs` | Documentation only |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or correcting tests |
| `perf` | A change that improves performance |
| `build` | Changes to build system or external dependencies |
| `ci` | Changes to CI configuration and scripts |

## Subject rules

- Use the imperative mood: "add", "fix", "remove" — not "added", "fixes", "adding".
- Keep it to 72 characters or fewer.
- Do not capitalize the first letter.
- No trailing period.
- Summarize what the commit does, not how.

Good: `fix(parser): handle empty input without crashing`
Bad: `Fixed the parser so it doesn't crash.`

## Body

Add a body when the subject alone cannot explain the change. Separate it from the subject with one blank line. Use it to explain the *why* and any context a reviewer needs — motivation, trade-offs, and contrast with previous behavior. Wrap lines at around 72 characters.

## Footer

Add a footer for metadata that tools or people consume:

- Reference issues: `Closes #123`, `Refs #456`.
- Note co-authors or reviewers.
- Declare breaking changes (see below).

Separate the footer from the body with one blank line.

## BREAKING CHANGE

Any commit that breaks backward compatibility must signal it. Two equivalent ways:

1. Append `!` after the type/scope: `feat(api)!: drop support for v1 endpoints`
2. Add a `BREAKING CHANGE:` footer describing the break and the migration path.

You may use both. The footer is preferred when the explanation needs more than one line.

```
feat(api)!: remove deprecated /login endpoint

BREAKING CHANGE: /login is removed. Use /auth/session instead.
Existing clients must update before upgrading.
```

Breaking changes drive a major version bump, so always make them explicit.

## Pull requests

## Pull Request Guidance

This document defines how we write and review pull requests. Keep PRs small,
well-described, and easy to review.

## PR Description Template

Copy the block below into every new pull request and fill in each section.

```markdown
## Summary

One or two sentences describing what this PR does and why. State the problem
being solved, not just the code that changed.

## Changes

- Bullet list of the concrete changes in this PR.
- Group related changes; keep each bullet scoped and specific.
- Call out new dependencies, config changes, or migrations.

## Testing

- How the change was verified (unit tests, integration tests, manual steps).
- Commands run and their results.
- Any cases intentionally not covered, with reasoning.

## Risk

- Blast radius if this goes wrong (which users, services, or data are affected).
- Rollback plan and how to detect a regression.
- Feature flags, gradual rollout, or backward-compatibility notes.

## Screenshots

- Before/after images or recordings for any user-facing change.
- Omit this section only when there is no visible or UI-facing impact.

Closes #<issue-number>
```

## Review Rules

- Green CI required. Do not merge until all required checks pass; never merge
  over a red or skipped pipeline.
- One reviewer minimum. Every PR needs at least one approving review from
  someone other than the author before merge.
- Small PRs. Prefer changes that a reviewer can read in one sitting. Split large
  or mixed-concern work into focused, independently reviewable PRs.
- Linked issue. Every PR must reference the issue it addresses (for example
  `Closes #123`). Open a tracking issue first if one does not exist.

## Author Checklist

- Description follows the template above with all sections completed.
- Branch is up to date with the base branch and free of merge conflicts.
- No unrelated changes, debug code, or commented-out blocks.
- Tests added or updated to cover the change.

## Reviewer Checklist

- Confirm the change matches the stated summary and linked issue.
- Verify CI is green and tests are meaningful, not just present.
- Check for correctness, readability, and obvious edge cases.
- Approve only when comfortable owning the change if it breaks.

## Branching

short-lived feature branches off main
