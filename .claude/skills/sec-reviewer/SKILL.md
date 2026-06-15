---
name: sec-reviewer
description: Load when asked to security-review a diff, PR, or changeset for injection, authz/authn gaps, secret leaks, and crypto misuse. Triggers on "security review", "is this secure", "any vulnerabilities in this change", "check for injection", "review auth", "did I leak a secret".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Security Reviewer

## Purpose
Review a diff or changeset purely through a security lens: find injection,
broken authorization/authentication, leaked secrets, and cryptographic misuse,
then emit a severity-ranked report with concrete, minimal fixes.

## When to use
- "security review this PR/diff" / "is this change secure"
- "check for injection / XSS / SQLi" / "review the auth logic"
- "did I commit a secret" / "is this crypto right"
- Hardening a change before merge when correctness review already passed.

## Procedure
1. Scope the diff. Run `git diff` (or `git diff main...HEAD`); list changed
   files. With no git context, review the files the user named.
2. Read each change with surrounding context; trace tainted input from entry
   points to sinks using Grep/Glob across callers and callees.
3. Injection: untrusted data reaching SQL/NoSQL, shell/exec, HTML/DOM (XSS),
   templates (SSTI), LDAP, path/file ops, or deserialization. Require
   parameterization/encoding/allowlists, not string concatenation.
4. Authz/authn: missing or post-action permission checks, IDOR/object-level
   access, broken session/token handling, privilege escalation, default-allow.
5. Secrets: hardcoded keys, tokens, passwords, connection strings; secrets in
   logs or error messages. Grep the diff for secret-like patterns and entropy.
6. Crypto misuse: weak/legacy algorithms (MD5/SHA1/DES/ECB), static IVs/keys,
   home-rolled crypto, missing auth on encryption, unsalted/fast hashes for
   passwords, bad randomness, disabled TLS/cert verification.
7. Assign each finding severity (CRITICAL/HIGH/MEDIUM/LOW) + file:line + a
   concrete fix and (where useful) an exploit sketch. Note false-positive risk.
8. Emit the structured review (format below). Change code only if asked.

## Output format
```
## Summary
- Risk: LOW | MEDIUM | HIGH | CRITICAL
- Findings: N critical, M high, ...
- Verdict: Approve | Approve with changes | Request changes

## Findings
1. [INJECTION|AUTHZ|SECRET|CRYPTO] severity — file:line
   - Issue + how it's exploited
   - Fix

## Positives
- Controls done correctly
```

## Checklist
- [ ] Every changed file read in context; taint traced entry -> sink
- [ ] Injection sinks checked (SQL, shell, XSS, template, path, deserialize)
- [ ] Authz/authn checks present, correct, and before the action
- [ ] No hardcoded secrets; nothing sensitive logged (diff grepped)
- [ ] Crypto: strong algorithms, proper keys/IVs/randomness, TLS verified
- [ ] Each finding has severity + file:line + concrete fix
- [ ] Verdict and overall risk stated; no code changed unless requested
