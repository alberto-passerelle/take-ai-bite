# Skill argument substitution in command files: what is replaced, and whether escaping protects snippets

**Date:** 2026-10-27
**Linked BL:** (none, candidate for promotion; sent upstream as an issue in S24)
**Author:** Alberto (with AI assistance)
**Status:** Active
**Validation depth:** Multi-pass (per DSM_0.2 §10.1): a source pass and a behavioral pass

---

## Purpose / Question

DSM command files (`scripts/commands/*.md`) use `$0`-`$N` as awk fields and shell positionals
inside fenced snippets. Claude Code substitutes skill arguments into the file text before the
agent reads it. A downstream spoke reported that invoking `/dsm-go` with arguments rewrote its
snippets, and this hub reproduced it with `/dsm-wrap-up` in S22. This file records which forms are
replaced, whether fenced code is exempt, and whether a backslash escape protects a snippet with and
without arguments, so the upstream report can state tested behaviour rather than inference.

## Sources

- Claude Code documentation, "Skills": https://code.claude.com/docs/en/skills, fetched 2026-10-26
  (WebFetch; the first 100,000 of 118,114 characters were read). Search route: a claude-code-guide
  subagent pointed to the page; the quotes below were then taken from the page itself.
- Behavioral pass: a scratch command `.claude/commands/s24-argtest.md` (deleted after the test),
  invoked by the user in Claude Code (VS Code extension, model claude-opus-5-5) on 2026-10-27, once
  as `/s24-argtest alpha beta` and once as `/s24-argtest` with no arguments.
- Local checks on macOS (BSD awk version 20200816, /bin/bash 3.2), 2026-10-27.
- Counts: `grep -cE '\$[0-9]'` over this fork's `scripts/commands/*.md` (v1.37.1), 2026-10-27.

## Findings

### Pass 1: source (documentation), scope = the six quotes below

- "`$ARGUMENTS[N]` | Access a specific argument by 0-based index, such as `$ARGUMENTS[0]` for the first argument."
- "`$N` | Shorthand for `$ARGUMENTS[N]`, such as `$0` for the first argument or `$1` for the second."
- "An indexed placeholder with no corresponding argument, such as `$2` when only one argument was passed, stays in the content unchanged."
- "To include a literal `$` before a digit, `ARGUMENTS`, or a declared argument name, such as `$1.00` in prose, escape it with a backslash: `\$1.00`. A backslash before any other `$` is left unchanged. Only a single backslash directly before the token escapes it. A doubled backslash such as `\\$1` leaves both backslashes in place, and `$1` still expands to the argument value."
- "`${CLAUDE_SKILL_DIR}` | The directory containing the skill's `SKILL.md` file. [...] Use this in bash injection commands to reference scripts or files bundled with the skill, regardless of the current working directory."
- "Custom commands have been merged into skills. A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way."

Not stated in the part read: whether fenced code blocks are exempt, and whether the escaping
backslash is removed from the delivered text.

### Pass 2: behavioral, scope = 14 cases (P1-P7 prose, F1-F7 fenced) plus the `$ARGUMENTS` header, two runs

| Case | Source | Run 1, `alpha beta` | Run 2, no arguments |
|---|---|---|---|
| header | `$ARGUMENTS` | `alpha beta` | empty |
| P1 prose | `$0` | `alpha` | unchanged |
| P2 prose | `$1` | `beta` | unchanged |
| P3 prose | `$3` | unchanged | unchanged |
| P4 prose | `\$1` | `$1` | `$1` |
| P5 prose | `\\$1` | `\\beta` | unchanged |
| P6 prose | `$ARGUMENTS[1]` | `beta` | unchanged |
| P7 prose | `${1}` | unchanged | unchanged |
| F1 fenced | `awk '{print $1}'` | `awk '{print beta}'` | unchanged |
| F2 fenced | `awk '{print \$1}'` | `awk '{print $1}'` | `awk '{print $1}'` |
| F3 fenced | `local p="$1"` | `local p="beta"` | unchanged |
| F4 fenced | `local p="\$1"` | `local p="$1"` | `local p="$1"` |
| F5 fenced | `$0 ~ /x/` | `alpha ~ /x/` | unchanged |
| F6 fenced | `\$0 ~ /x/` | `$0 ~ /x/` | `$0 ~ /x/` |
| F7 fenced | `{print $2}` | unchanged | unchanged |

Results: fenced code is not exempt; indices are 0-based and an index without an argument stays;
`\$N` arrives as `$N` with the backslash removed, with and without arguments, in prose and in
fences; `${N}` is not replaced.

### Local checks (what an escaped snippet does when run straight from the file)

- `echo 'a b' | awk '{print \$1}'`: BSD awk reports a syntax error, exit 2.
- `local p="\$1"` in bash gives the literal text `$1`.
- `awk '{print $(2)}'` prints field 2 and `$(0)` the record; bash `${1}` is the first positional.
  `$(N)` in awk was not part of the behavioral pass.

### Scale

Lines matching `\$[0-9]` in this fork's `scripts/commands/*.md`: 14 in 4 files (`dsm-go.md` 9,
`dsm-wrap-up.md` 2, `dsm-staa.md` 2, `dsm-align.md` 1). Not every match is a snippet.

## Conclusion

Escaping (`\$N`) protects a snippet when the command is invoked, with or without arguments, but
the file then no longer shows what runs: a snippet copied from the source breaks (awk syntax
error, literal `$1` in bash). Forms the substitution leaves alone (`${N}` in shell, `$(N)` in
awk) keep the file runnable as written; `$(N)` still needs a behavioral check. Moving snippets
into scripts removes the class at a larger cost. The three options and the test table went
upstream as an issue in S24; the choice is upstream's.
