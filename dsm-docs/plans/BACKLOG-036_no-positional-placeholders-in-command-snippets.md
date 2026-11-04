# BACKLOG-036: Keep $1-$9 Out of Command-File Snippets, Because the Harness Substitutes Skill Arguments Into Them

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** the runnable snippets in `scripts/commands/*.md`; DSM_0.2.B §8.2 (review requirements for
infrastructure edits).
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. `/dsm-go` was invoked with an
argument, and the rendered Step 6 lockfile snippet carried the argument in place of `$1`. This hub
met the same substitution in S24 (a lesson in the Skills category); it was never filed.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-036).

---

## Problem Statement

When a skill is invoked with arguments, the harness replaces `$1` to `$9` inside the skill text.
The source file stays correct; the rendered copy the agent reads does not. `scripts/commands/dsm-go.md`
L1116:

> `ANCHOR=$(md5sum .claude/worklog.md | awk '{print $1}')`

With an argument, the agent copies an `awk` program that prints the argument, and the lockfile gets a
wrong anchor with no error. In S29 the command files hold 20 occurrences of `$1`-`$9` on 13 lines in
4 files (`dsm-go.md` 8 lines, `dsm-staa.md` 2, `dsm-wrap-up.md` 2, `dsm-align.md` 1).

## Proposed Solution (sketch for Gate 1)

- Rewrite each occurrence in a form the harness leaves alone, for example `awk '{print $(1)}'` or
  `cut -d' ' -f1` for fields, and named variables for shell function arguments.
- Add one line to the DSM_0.2.B §8.2 review: a `grep -nE '\$[1-9]' scripts/commands/*.md` check
  before a command-file commit.

Open for Gate 1: which forms survive delivery (tested first, see T-1); whether the check also goes
into a commit hook.

## Success Criteria (draft)

- [ ] No bare `$1`-`$9` remains in `scripts/commands/*.md`, or each remaining one is shown to be
  outside any substitution.
- [ ] Every rewritten snippet gives the same result as before on real input.
- [ ] The §8.2 review names the check.
- [ ] Runtime copies deployed (`scripts/sync-commands.sh --deploy`), `diff -q` clean.

## Test Plan (draft)

- [ ] T-1: a scratch command holding each candidate form, run by the user with and without
  arguments (the S24 method); record which forms arrive unchanged.
- [ ] T-2: `grep -cE '\$[1-9]'` over `scripts/commands/*.md`: 0, or the listed exceptions.
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

Offer to Central as an issue plus a PR on the four command files and DSM_0.2.B §8.2 (DSM_0.2 §21.5),
when a PR slot is free.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
