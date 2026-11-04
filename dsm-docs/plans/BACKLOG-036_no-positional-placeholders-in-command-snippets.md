# BACKLOG-036: Keep $0-$9 Out of Command-File Snippets, Because the Harness Substitutes Skill Arguments Into Them

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** the runnable snippets in `scripts/commands/*.md`; DSM_0.2.B §8.2 (review requirements for
infrastructure edits).
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. `/dsm-go` was invoked with an
argument, and the rendered Step 6 lockfile snippet carried an argument word in place of `$1`. This
hub measured the substitution in S24 (`dsm-docs/research/2026-10-27_skill-argument-substitution.md`:
14 cases, two runs) and sent the finding upstream as an issue then; no fork BL was filed.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-036).

---

## Problem Statement

When a skill is invoked with arguments, the harness replaces `$0`, `$1`, ... inside the skill text
with the argument words, counting from 0 (`$0` is the first word); a number without a matching word
stays. Fenced code is not exempt (S24 research file, Pass 2). The source file stays correct; the
rendered copy the agent reads does not. `scripts/commands/dsm-go.md` L1116:

> `ANCHOR=$(md5sum .claude/worklog.md | awk '{print $1}')`

With two or more argument words, the agent copies an `awk` program that prints the second word, and
the lockfile gets a wrong anchor with no error. In S29 the command files hold 22 occurrences of
`$0`-`$9` on 14 lines in 4 files (`dsm-go.md` 9 lines, `dsm-staa.md` 2, `dsm-wrap-up.md` 2,
`dsm-align.md` 1).

## Proposed Solution (sketch for Gate 1)

- Rewrite each occurrence in a form the harness leaves alone, for example `awk '{print $(1)}'` or
  `cut -d' ' -f1` for fields, and named variables for shell function arguments.
- Not a backslash escape: S24 found that `\$1` survives delivery but breaks the snippet when it runs
  straight from the file (BSD awk reports a syntax error).
- Add one line to the DSM_0.2.B §8.2 review: a `grep -nE '\$[0-9]' scripts/commands/*.md` check
  before a command-file commit.

Open for Gate 1: the rewrite form (`$(N)` in awk is the one candidate S24 did not run, see T-1);
whether the check also goes into a commit hook.

## Success Criteria (draft)

- [ ] No bare `$0`-`$9` remains in `scripts/commands/*.md`, or each remaining one is shown to be
  outside any substitution.
- [ ] Every rewritten snippet gives the same result as before on real input.
- [ ] The §8.2 review names the check.
- [ ] Runtime copies deployed (`scripts/sync-commands.sh --deploy`), `diff -q` clean.

## Test Plan (draft)

- [ ] T-1: the S24 measurement covers 14 forms; run the S24 method (a scratch command the user runs
  with and without arguments) for the forms it did not cover, at least awk `$(N)`.
- [ ] T-2: `grep -cE '\$[0-9]'` over `scripts/commands/*.md`: 0, or the listed exceptions.
- [ ] T-3: each rewritten snippet run against its real input in a Claude Code Bash session, before
  and after, same output (DSM_0.2 §19.1).
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` on the four files.
- [ ] T-5: egress sweep of the diff and the commit message, counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **A rewrite changes what a snippet does:** mitigation: T-3 runs each one on real input.
- **The harness's substitution rules are not documented here:** a form that survives today may not
  later. Mitigation: T-1 measures; the review check catches new bare forms.
- **Upstream drift on four files:** mitigation: send the change upstream instead of keeping a fork
  copy.

## Upstream Contribution

The finding went upstream as an issue in S24. Offer the fix as a PR on the four command files and
DSM_0.2.B §8.2 when a PR slot is free (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
