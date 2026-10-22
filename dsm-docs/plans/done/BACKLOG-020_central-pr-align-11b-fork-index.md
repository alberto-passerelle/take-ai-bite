# BACKLOG-020: Send Central a Fix So /dsm-align Step 11b Checks a Fork Against fork-INDEX.md

**Status:** Implemented (absorbed upstream, shipped in v1.37.1)
**Date Implemented:** 2026-10-22
**Central BL:** BACKLOG-610 (v1.37.1)
**Priority:** Medium
**Extends:** Central's `/dsm-align` Step 11b (done-index currency); DSM_0.2 §21.5 ("Done and archive": fork-local BLs are indexed in `done/fork-INDEX.md`, never in the inherited `INDEX.md`)
**Date Created:** 2026-10-22
**Origin:** S17 feedback item 9 (seen at that session's `/dsm-align` run); S18 triage claim C; S19 recheck against v1.37.0.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-020).

---

## Problem Statement

Step 11b builds its row set from `dsm-docs/plans/done/INDEX.md` only. On a fork that file carries
Central's numbering, while the fork's closed BLs are fork-local and indexed in `done/fork-INDEX.md`
(§21.5); the mirror ships `done/` with `INDEX.md` and no bodies, so every body in a fork's `done/`
is fork-local. The step runs on a fork because the fork carries `scripts/commands/`. Measured on
this fork in S19 (11 bodies, 479 Central rows): it reports 002 to 005 as missing and passes the
other 7 only because their numbers collide with Central rows; `fork-INDEX.md` is never read.

## Proposed Solution

One pull request to Central, branch `fix/align-11b-fork-index` off Central `main`:

- If `dsm-docs/plans/done/fork-INDEX.md` exists, compare against it; otherwise against `INDEX.md`
  (Central unchanged). The output lines name the index used.
- Read row IDs from the first table column only: `fork-INDEX.md`'s Outcome column names Central BL
  numbers. On Central's `INDEX.md` this gives the same result as today (measured: 480 closed BLs,
  480 first-column rows, 0 missing either way).
- One paragraph explaining the fork case; the warning text points a fork to §21.5's row format
  instead of CHANGELOG-derived rows.

No Central BL file, no CHANGELOG version (S19 decision). The owner merges.

## Success Criteria

- [x] On this fork the step reports OK against `fork-INDEX.md`, and a missing fork-INDEX row is
      reported even when its number collides with a Central row.
- [x] On Central the step's output is unchanged apart from naming the index.
- [x] The empty guard still prints `UNRESOLVED` when the chosen index has no rows.
- [x] The pull request is opened on Central with a body the user approved; nothing pushed to `main`.

## Test Plan

Old = the snippet from Central `origin/main`, new = the edited snippet; each run under bash and zsh.

- [x] T-1: the diff touches only Step 11b (`git diff --stat`, hunk list).
- [x] T-2: this fork's real tree: old reports 002-005 missing; new reports OK naming
      `fork-INDEX.md`.
- [x] T-3: scratch copy of this fork's tree with the 001 row removed from `fork-INDEX.md` (001
      collides with a Central row): old does not report 001; new reports exactly 001.
- [x] T-4: the Central clone's own tree: old and new give the same verdict and count.
- [x] T-5: scratch tree with an empty `fork-INDEX.md` (header only): new prints `UNRESOLVED`.

## Risks (per DSM_0.2 §21.2)

- **A fork that never created `fork-INDEX.md`** keeps today's behaviour (compared against
  `INDEX.md`). *Accepted:* §21.5 creates the file at the first close; the step cannot tell a fork
  from Central without it.
- **First-column matching changes Central's reading of `INDEX.md`.** *Mitigation:* T-4, and the
  measured equality is stated in the PR body.
- **Overlap with work the owner has in flight on `dsm-align.md`.** *Mitigation:* small diff, branch
  from the latest `main`.

## Upstream Contribution

This BL is the contribution: a pull request on Central.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S19) on macOS. Central clone, branch `fix/align-11b-fork-index`, one local
commit on Central `main` at v1.37.0. Runner `/tmp/s19-fix/run11b.sh` extracts Step 11b's bash block
from `origin/main` (old) and the working tree (new) and runs both under bash and zsh; the two shells
gave identical lines in every case.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | 1 file, 6 hunks at L401-426, all inside Step 11b (L399-430), +10/-6 |
| T-2 | PASS | This fork's tree (12 bodies): old `MISSING 4 row(s): BACKLOG-002 ... -005`; new `OK: fork-INDEX.md covers all 12 closed BLs` |
| T-3 | PASS | 001 row removed in a copy: old still the same 4 (001 masked); new `MISSING 1 row(s) in fork-INDEX.md: BACKLOG-001` |
| T-4 | PASS | Central's tree: old and new `OK: INDEX.md covers all 480 closed BLs`; separately measured 481 any-column vs 480 first-column IDs in Central's INDEX.md, 0 missing either way |
| T-5 | PASS | Header-only fork-INDEX.md: new `UNRESOLVED: collected 1 BL entries and 0 rows in fork-INDEX.md` |

**§22 note:** the first version of the runner reset its fixtures with `rm -rf` on two scratch
paths, which the Destructive Command Protocol forbids without the user's request. Nothing was
deleted (both paths were created by that run). The runner now uses fresh `mktemp -d` dirs; the
rerun gave the same 16 lines.

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, head = local HEAD, base `main` unchanged, open and mergeable, live body = approved file.
- [x] Owner's merge and the release that ships it: merged by the owner, shipped as Central BACKLOG-610 in v1.37.1 and merged into this fork in S20 (2026-10-22). The release also accepts bare `NNN` row IDs. S20's `/dsm-align` Step 11b printed `OK: fork-INDEX.md covers all 12 closed BLs` on this fork.
