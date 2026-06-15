---
name: test-writer
description: Load when asked to write or expand tests, add test cases, reproduce a bug with a test, or improve coverage. Triggers on "write test", "test this", "increase coverage", "unit test", "integration test", "test suite", "TDD", "repro test", "cover edge cases".
allowed-tools: [Read, Edit, Bash, Grep, Glob]
---

# Test Writer Skill

## Purpose
Write and expand tests that pin behavior down: find untested paths, reproduce
bugs with a failing test first, cover edge and error cases, and keep the suite
fast and deterministic. Match the project's existing framework and conventions.

## When to use
- "Write tests for X" / "test this function or module"
- "Increase coverage" / a coverage report shows gaps
- A bug is reported and needs a regression test before the fix
- "Add edge cases" / "the suite is flaky or slow" and needs hardening
- TDD: write the failing test before implementing a feature

## Procedure
1. Discover conventions: Glob/Grep for existing tests; identify the framework,
   runner command, assertion lib, and test helpers/fixtures. Reuse them.
2. Read the code under test. List its paths: happy path, branches, boundaries,
   error/exception cases. Note external deps to mock or fake.
3. Find the gaps: run the existing suite with coverage if available; target
   uncovered lines and branches, not just function entry.
4. For a bug: write the failing test that reproduces it FIRST. Confirm it fails
   for the right reason before any fix touches production code.
5. Write tests using AAA (Arrange, Act, Assert). One behavior per test.
   Name them should_<behavior>_when_<condition>. Cover happy, edge, and error.
6. Keep tests isolated: no shared mutable state, no real network/clock/random.
   Inject or freeze time, seed randomness, mock I/O. Each test runs standalone.
7. Run the suite. Confirm new tests pass (and bug-repro now passes post-fix) and
   nothing else broke. Re-run to check determinism.

## Checklist
- [ ] Matches existing framework, runner, and helper conventions
- [ ] Each previously untested path now has a test
- [ ] Bug fixes have a regression test that failed before the fix
- [ ] Edge + error cases covered, not only the happy path
- [ ] Tests are isolated, deterministic, and order-independent
- [ ] No real network, filesystem, clock, or RNG without control
- [ ] Each test asserts one clear behavior with a descriptive name
- [ ] Full suite passes and reruns identically
