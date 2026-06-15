# Working with Claude Code

This repo ships with Claude Code defaults and best practices so you inherit good
conventions on day one. This guide is accurate to the current Claude Code; where behavior
varies by version it says so. Provider is Anthropic/Claude.

## 1. CLAUDE.md — project context

`CLAUDE.md` is auto-loaded into context at the start of every session.

- **Where it lives:** project root (and/or `.claude/CLAUDE.md`), nested subdirectories in a
  monorepo (loaded from the working directory upward), and `~/.claude/CLAUDE.md` for your
  personal cross-project rules.
- **What belongs in it:** architecture overview, conventions, constraints, key paths, build
  and test commands. Use `## ` headings.
- **Keep it lean.** It loads every session — prioritize signal. Put long procedures in a
  skill (loaded on demand) instead.
- Edits are picked up on the next session (prompt caching means mid-session edits may not apply).

## 2. Settings & permissions

- `.claude/settings.json` — project settings (committed).
- `.claude/settings.local.json` — your personal overrides (gitignored).
- `~/.claude/settings.json` — global defaults.

Permissions use `allow` / `ask` / `deny` lists with tool-scoped patterns. `deny` wins over
`allow`; `ask` always prompts.

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Read(./**)", "Edit(./src/**)"],
    "deny":  ["Read(./.env*)", "Read(./secrets/**)", "Bash(git push *)"]
  }
}
```

Patterns: `Bash(npm run *)` matches any `npm run ...`; `Read(./.env*)` blocks env files;
`Edit(./src/**)` scopes edits. Safe default for a new repo: deny reads of `.env*`/secrets and
deny direct `git push` to protected branches; allow your test/lint/build commands.

## 3. Hooks

Hooks run a command at a lifecycle event. Register them in `.claude/settings.json` with a
`matcher` (tool name regex) and a `hooks` array. A `PreToolUse` hook that exits non-zero
(code 2) blocks the tool call.

```json
{
  "hooks": {
    "PreToolUse":  [ { "matcher": "Write|Edit", "hooks": [ { "type": "command", "command": ".claude/hooks/block-secrets.sh" } ] } ],
    "PostToolUse": [ { "matcher": "Write|Edit", "hooks": [ { "type": "command", "command": ".claude/hooks/capture-usage.sh" } ] } ]
  }
}
```

Common events: `PreToolUse` (validate/block before a tool), `PostToolUse` (side effects like
format/test after an edit), `Stop`, `SessionStart`. This repo already ships a `block-secrets`
PreToolUse hook (denies writes that look like keys) and a `capture-usage` PostToolUse hook.
A hook reads the tool payload as JSON on stdin; a PreToolUse hook denies by printing a
`hookSpecificOutput` decision and exiting 2.

## 4. Skills

A skill is a folder with a `SKILL.md`. Claude auto-selects it when the request matches its
`description`, or you invoke it as `/<name>`.

```markdown
---
name: deploy
description: >
  Use when the user asks to deploy or release. Runs tests, builds, tags, and pushes.
user-invocable: true
allowed-tools: [Read, Bash, Edit]
---
# Deploy
1. `npm test` 2. `npm run build` 3. tag + push ...
```

- **Location:** `.claude/skills/<name>/SKILL.md`.
- **`description` is load-bearing** — it's how the skill gets auto-selected, so be specific
  about *when* to use it.
- `user-invocable: true` makes it callable as `/deploy`. `allowed-tools` scopes what it may do.
- Put multi-step procedures here, not in CLAUDE.md, so they load only when needed.

## 5. Slash commands

Built-ins worth knowing (availability can vary by version): `/code-review` (review the diff;
`--fix` applies findings), `/model` (switch session model), `/effort` (reasoning budget),
`/compact` (compress history), `/memory` (view/edit memory), `/loop` (run a prompt/command on
an interval). Any `user-invocable` skill is itself a slash command.

## 6. Plan mode

Plan mode is a read-only exploration mode: Claude reads files and runs read-only commands but
makes no edits until you approve a plan. Use it before large or risky changes. Toggle it with
Shift+Tab (or your client's plan-mode control); approve to exit into execution.

## 7. Subagents / the Agent tool

Claude can delegate work to subagents — useful for broad searches (so the main context stays
clean) and for running independent work in parallel. For parallel work that edits files, use
git **worktree isolation** so agents don't conflict; review and merge each branch. Delegate
when the work is genuinely independent; stay in one context when steps depend on each other.

## 8. MCP servers

MCP (Model Context Protocol) exposes external tools (GitHub, Postgres, web, custom) to Claude.

```json
{
  "mcpServers": {
    "github": { "command": "npx", "args": ["@modelcontextprotocol/server-github"], "transport": "stdio" }
  }
}
```

- Config in `.claude/mcp.json` (this repo) or the `mcpServers` key of settings.
- Transports: `stdio` (local subprocess) or `http` (remote; authenticate first).
- **Don't overload context** — each server adds tool schemas. Start with 1–2 you actually use.

## 9. Memory

Claude Code carries context across sessions via `CLAUDE.md` (always loaded) and auto-memory
(`/memory` to view/edit). When the conversation grows, it auto-compacts older history; you can
also `/compact` manually. For long tasks, prefer "document & clear" — write decisions into a
file or CLAUDE.md, then start fresh — over relying on a giant context window.

## 10. Model selection & effort

Route the model to the task weight (real current Anthropic models):

| Task | Model | Why |
|------|-------|-----|
| mechanical (format, rename) | Claude Haiku 4.5 | fast and cheap |
| steady-state coding, review | Claude Sonnet 4.6 | balanced |
| architecture, security, hard reasoning | Claude Opus 4.8 (max effort) | deepest reasoning |

Switch with `/model`; raise reasoning with `/effort`. Use a strong model + high effort for
planning and security; drop to a cheap model for rote work.

## 11. Day-1 checklist

- [ ] Read `CLAUDE.md` (architecture, conventions, constraints).
- [ ] Skim `.claude/settings.json` (permissions + hooks) and `.claude/mcp.json` (tools).
- [ ] List skills: `ls .claude/skills`.
- [ ] Authenticate any auth-required MCP servers.
- [ ] Use plan mode for the first non-trivial change.
- [ ] Keep CLAUDE.md lean; move long procedures into skills.

## See also
- Claude Code docs: https://docs.anthropic.com/en/docs/claude-code
- Agent Skills: https://docs.anthropic.com/en/docs/claude-code/skills
