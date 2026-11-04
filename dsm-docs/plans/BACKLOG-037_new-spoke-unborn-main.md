# BACKLOG-037: Give a New Spoke's main a First Commit, So the First Wrap-Up Merge Does Not Stop on an Unborn Branch

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** `scripts/commands/dsm-new-spoke.md` step 9; the merge block of
`scripts/commands/dsm-wrap-up.md`.
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. A spoke created in a repository that
existed but had no commit reached its first wrap-up with an unborn `main`, and the merge failed.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-037).

---

## Problem Statement

`scripts/commands/dsm-new-spoke.md` L55-56:

> 9. **Make the initial commit (only if this skill ran `git init` in step 3).**
> ... If the repository already existed, leave committing to the user and the first `/dsm-go` session branch.

A repository that exists but has no commit gets no commit. `/dsm-go` Step 0 then creates the session
branch from an unborn `main`, so `main` never gets a commit. At wrap-up, `dsm-wrap-up.md` L360 runs
`git checkout -q main || OUT="STOP: could not switch to main; nothing was merged"`, and the merge
stops.

## Proposed Solution (sketch for Gate 1)

Two options, not exclusive:
- a) Step 9: when `git rev-parse --verify HEAD` fails, propose the scaffold commit on `main` and make
  it after the user confirms.
- b) Wrap-up merge: when `main` is unborn, create it at the session branch head before the checkout.

Open for Gate 1: a, b or both.

## Success Criteria (draft)

- [ ] A spoke created in a repository without commits has a `main` with a commit before its first
  session, or its first wrap-up creates one.
- [ ] Repositories with commits behave as before.
- [ ] Runtime copies deployed, `diff -q` clean.

## Test Plan (draft)

- [ ] T-1: scratch repository after `git init`, no commit: run the step 9 logic; `main` has one
  commit and the scaffold files are in it.
- [ ] T-2: scratch repository with an unborn `main` and a session branch with one commit: the wrap-up
  merge snippet stops before the fix and merges after it (if option b).
- [ ] T-3: a repository with commits: unchanged output.
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` on both files.
- [ ] T-5: egress sweep of the diff and the commit message, counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **The scaffold commit picks up files the user did not mean to commit** (`git add .` in an existing
  folder): mitigation: show the file list and run the secret-pattern check before the commit; the
  user confirms.
- **Option b merges everything on the session branch into a new `main`:** acceptable for a first
  session, which is what the branch holds.
- **Upstream drift on two files:** mitigation: send the change upstream.

## Upstream Contribution

Offer to Central as an issue plus a PR (DSM_0.2 §21.5), when a PR slot is free.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
