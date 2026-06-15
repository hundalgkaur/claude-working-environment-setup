# crossplatform-app-starter

> an iOS, Android + web app in one: React Native (Expo) mobile + Next.js web sharing an API, with user accounts

This file is loaded into Claude Code at the start of every session. Keep it current and lean;
move long, situational procedures into `.claude/skills/` so they load only when relevant.

## Project overview

- **What it is:** an iOS, Android + web app in one: React Native (Expo) mobile + Next.js web sharing an API, with user accounts
- **Type:** mobile
- **Status:** new project (scaffolded). Replace placeholders as the codebase grows.

## Architecture

- **Mobile:** React Native (Expo) + TypeScript
- **Web:** Next.js (App Router) + TypeScript
- **API:** Next.js route handlers
- **Database:** Postgres (Drizzle ORM)

Describe how the pieces fit together as they appear (entry points, request flow, data model,
external services). Keep this section accurate — it is the map Claude reads first.

## Tech stack

- Mobile (iOS + Android): React Native (Expo) + TypeScript
- Web: Next.js (App Router) + TypeScript
- API: Next.js route handlers
- Database: Postgres (Drizzle ORM)

## Project structure

```
src/            application code
tests/ (or *.test)   tests, colocated or under tests/
docs/                CLAUDE_CODE_GUIDE.md (how to use Claude Code), SKILLS.md (recommended skills)
.claude/             skills/, settings.json (permissions + hooks), mcp.json
.github/workflows/   ci.yml (lint -> typecheck -> test -> build)
CHECKLISTS.md        per-domain quality checklists (source-stamped)
CONTRIBUTING.md      commit + PR + branch conventions
```

## Commands

| Action | Command |
|--------|---------|
| Install | `npm install` |
| Dev | `npm run dev` |
| Test | `npm test` |
| Lint | `npm run lint` |
| Build | `npm run build` |

Run the full gate (lint, typecheck, test, build) before opening a PR.

## Coding guidelines

These reduce common mistakes. They bias toward caution over speed; for trivial changes, use judgment.

### 1. Think before coding
- State assumptions explicitly; if uncertain, ask rather than guess.
- If multiple interpretations exist, surface them — do not silently pick one.
- If a simpler approach exists, say so. Push back when warranted.

### 2. Simplicity first
- Write the minimum code that solves the problem; nothing speculative.
- No abstractions for single-use code, no unrequested "flexibility", no error handling for impossible states.
- If 200 lines could be 50, rewrite it.

### 3. Surgical changes
- Touch only what the task needs. Do not reformat or "improve" adjacent code.
- Match the existing style even if you would do it differently.
- Remove only the imports/vars your change orphaned; leave unrelated dead code (mention it).

### 4. Goal-driven execution
- Turn each task into a verifiable goal ("write a failing test, then make it pass").
- For multi-step work, state a short plan with a check per step, then loop until green.

### Style
- TypeScript/JS: strict types, small modules, named exports, no `any` without a reason.
- Naming: `camelCase` values, `PascalCase` types/components, `UPPER_SNAKE` constants.
- Comments explain *why* (constraints), never *what* the next line does.

## Testing

- Framework: node:test (or your runner); pattern `src/**/*.test.js`.
- Test behavior, not implementation. Write a failing test first for every bug.
- Keep tests fast and deterministic; cover edge cases and error paths.

## Git workflow

- Branches: short-lived feature branches off main. **Never commit directly to `main`.**
- Conventional Commits: `type(scope): subject` (feat, fix, chore, docs, refactor, test).
- Every PR: green CI, clear description, linked issue, one reviewer.

## Model routing (by task weight)

| Task weight | Model | Effort | When |
|---|---|---|---|
| trivial | `claude-haiku-4-5-20251001` | low | mechanical/simple edits, formatting, renames, single-line fixes |
| steady | `claude-sonnet-4-6` | medium | steady-state coding, code review, bug fixes, quick edits |
| planning | `claude-opus-4-8` | high | architecture, multi-file refactor, domain modeling, dependency reasoning |
| security | `claude-opus-4-8` | high | security audits, threat modeling, auth — conservative and thorough |
| deep | `claude-opus-4-8` | xhigh | hardest reasoning, deep design, novel problems (top available model at max effort) |

Cross-provider (manual trigger):
- **implement** -> `<CODEX_MODEL>` (openai) — fast implementation + test generation (manual trigger; user authenticates Codex)
- **document** -> `<GEMINI_MODEL>` (google) — documentation + large-context exploration (manual trigger; user authenticates Gemini)

Switch with `/model`, raise reasoning with `/effort`. Use a strong model for planning/security; a cheap one for mechanical edits.

## Skills & tools

- Project skills (`.claude/skills/`): `ci-builder`, `code-reviewer`, `doc-writer`, `refactorer`, `test-writer`, `native-bridge`, `screen-builder`, `store-release`, `dep-auditor`, `sec-reviewer`, `threat-modeler`.
- MCP servers (`.claude/mcp.json`): filesystem, git, github, postgres (authenticate the ones that need it).
- Recommended external + knowledge-graph skills: see `docs/SKILLS.md`.
- Checklists for this project: a11y, ci-gates, secret-handling, security-headers, payment-readiness, seo, mobile-a11y, offline-support, permissions, store-readiness, authz, dependency-audit, secrets-rotation, threat-model (see `CHECKLISTS.md`).

## Security & constraints

- NEVER commit secrets, `.env`, credentials, or keys (a PreToolUse hook blocks secret-looking writes).
- ALWAYS validate external input at the boundary; use parameterized queries.
- Pull live figures at use time; do not hard-code confidential data.
- Prefer plan mode for non-trivial changes; keep this file lean (long procedures -> skills).
- Check `CHECKLISTS.md` before shipping anything in a sensitive area (auth, payments, data, deploys).

## Definition of done

A change is done when:
- The task's verifiable goal is met (the failing test you wrote now passes).
- All CI gates are green locally (`npm run lint`, tests, build).
- No secrets, no debug logging, no commented-out code left behind.
- Docs/README updated if behavior or setup changed.
- The diff is minimal and traces directly to the task (no drive-by refactors).
- A relevant `CHECKLISTS.md` item was reviewed for sensitive areas.

## Anti-patterns to avoid

- Editing many files for a one-line need; reformatting code you didn't change.
- Adding configuration/abstraction "for later" that nothing uses yet.
- Catching errors you can't handle, or swallowing them silently.
- Broad `try/catch`, `any`, or `# type: ignore` to make a type checker quiet.
- Committing generated artifacts, large binaries, or `node_modules`/`.venv`.
- Long-lived branches; commits straight to `main`.

## How to ask Claude for help here

- Point at the file/symbol (`path:line`) and state the goal + the constraint.
- For anything non-trivial, ask for a short plan first (plan mode), then approve.
- Prefer the project skills (`.claude/skills/`) for repeatable work (reviews, tests, docs).
- Escalate model/effort for design + security; drop to a cheap model for mechanical edits.

## Working with Claude Code

Full method: `docs/CLAUDE_CODE_GUIDE.md`. In short — CLAUDE.md is durable context, skills are
reusable procedures, hooks are guardrails, CI is the gate, and the model is routed by task weight.
