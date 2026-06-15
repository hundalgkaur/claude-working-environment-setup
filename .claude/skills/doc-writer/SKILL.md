---
name: doc-writer
description: Load when asked to write or update documentation from code — README, API reference, or inline comments — or to keep existing docs in sync with the implementation. Triggers on "document this", "write README", "API docs", "add comments", "explain how this works", "docs are stale", "update the docs".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Documentation Writer Skill

## Purpose
Write and update README, API documentation, and inline docs directly from the
code, and keep them in sync with the implementation. Documentation must reflect
what the code actually does, not what it once did. Start with WHY, then WHAT,
then HOW. Active voice, sentences under 25 words.

## When to use
- "Document this module / function / package."
- "Write a README" or "the README is out of date."
- "Generate / update API docs."
- "Add (or improve) inline comments."
- "Explain how this works" for a user guide.
- After a code change that altered a public signature, flag, env var, or behavior.

## Procedure
1. Locate sources. Use Glob/Grep to find code, existing docs, and config
   (README*, docs/**, package manifests, OpenAPI/JSON schemas).
2. Read the implementation before writing. Confirm signatures, params, return
   types, errors, defaults, and side effects from the actual code — never guess.
3. Detect drift. Compare current docs against code; list every mismatch
   (renamed params, removed flags, changed defaults, new/removed endpoints).
4. Choose scope: README (Quick Start, Install, Usage, API Reference, Config,
   Contributing), API reference (per-symbol), or inline comments.
5. Write/edit with Edit. Preserve surrounding structure and heading style.
   For each API symbol: purpose, parameters (name/type/desc), returns, throws,
   and one runnable example. Comments explain WHY, not the obvious WHAT.
6. Add Mermaid diagrams only for non-trivial flows.
7. Verify examples and commands compile/run where cheap (Bash); fix or mark any
   that cannot be validated.
8. Report what changed and any drift you could not resolve.

## Checklist
- [ ] Every documented signature matches the current code exactly.
- [ ] Each public API has params, returns, throws, and a working example.
- [ ] No stale flags, defaults, paths, or endpoints remain.
- [ ] Code samples and CLI commands were run or explicitly marked unverified.
- [ ] WHY-before-WHAT ordering; active voice; sentences under 25 words.
- [ ] Existing doc formatting and heading hierarchy preserved.
- [ ] Comments justify intent, not restate the line.
- [ ] Unresolved drift is reported, not silently left.
