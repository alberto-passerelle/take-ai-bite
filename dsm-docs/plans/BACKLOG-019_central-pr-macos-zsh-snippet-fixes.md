# BACKLOG-019: Send Central a Fix for Boot and Wrap-Up Snippets That Fail on macOS and zsh

**Status:** In Progress (Central PR open, awaiting the owner)
**Priority:** Medium
**Extends:** Central's `/dsm-go` Steps 0.7a and 6, `/dsm-staa` Step 0, `/dsm-parallel-session-go`, `/dsm-wrap-up` Step 0.5, DSM_0.2.A §26 (lockfile `pid` snippet) and `.claude/hooks/transcript-reminder.sh`; DSM_0.2 §19.1 (published snippets are run before they ship)
**Date Created:** 2026-10-22
**Origin:** S17 feedback items 7, 8 and 11; S18 triage claims A and B; S19 recheck against v1.37.0 and a sweep of Central's corpus, which found three more sites of the same `comm` defect.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-019).

---

## Problem Statement

Three snippet defects give a plausible but wrong result on macOS, whose default shell is zsh
(sites counted by a sweep of Central `main` at v1.37.0):

1. **`stat -c %Y`** (2 sites: `/dsm-go` Step 0.7a, `/dsm-staa` Step 0). BSD `stat` has no `-c`, the
   `|| date +%s` fallback fires, and the transcript age prints 0 for any lock.
2. **Exact `[ "$comm" = "claude" ]`** in the parent-chain walk (4 sites: `/dsm-go` Step 6,
   DSM_0.2.A §26, `/dsm-parallel-session-go`, `transcript-reminder.sh`). macOS `ps -o comm=` prints
   the full binary path, so the walk never matches. Measured on this machine: the walk returns
   nothing, while `CLAUDE_PID` and a basename match both give the same PID. `/dsm-go` reads
   `CLAUDE_PID` first, so its lockfile was unaffected here, but `/dsm-parallel-session-go` and the
   reminder hook always walk: on macOS a parallel session cannot record its PID, and the hook cannot
   tell a parallel session from the main one.
3. **`path=$(...)`** (1 site: `/dsm-wrap-up` Step 0.5). In zsh `path` is tied to `PATH`, so the loop
   empties `PATH` and the later commands in the block fail.

## Proposed Solution

One pull request to Central, branch `fix/macos-zsh-shell-portability` off
Central `main`, touching only the 7 sites:

- `stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || date +%s` (GNU first, BSD second,
  the existing fallback last).
- `[ "$(basename "$comm")" = "claude" ]`.
- Rename the loop variable to `target_path`.

No Central BL file and no CHANGELOG version: numbering and releases stay with the owner (user
decision, S19). The owner merges; BACKLOG-018's guard blocks any merge or push to Central's `main`
from this machine.

## Success Criteria

- [x] After the change, the sweep finds no `stat -c %Y` without the BSD form, no exact `comm`
      compare, and no `path=` assignment in the touched files.
- [x] Each changed snippet gives the right result on macOS under bash and zsh, and the old snippet
      gives the wrong one on the same input (§19.1's second question).
- [x] The pull request is opened on Central with a body the user approved, and nothing is pushed to
      Central's `main`.

## Test Plan

- [x] T-1: sweep before and after (`stat -c`, `comm" = "claude"`, `path=`), self-tested on a known
      hit; the diff touches only the 7 sites (`git diff --stat`, hunk count).
- [x] T-2: age snippet on a file with a known mtime at least 2 minutes old, bash and zsh: old prints
      0, new prints the age that `python3 os.stat` gives.
- [x] T-3: parent walk, bash and zsh: old finds nothing, new finds `$CLAUDE_PID`.
- [x] T-4: `transcript-reminder.sh` in a scratch project whose registry records `$CLAUDE_PID`: old
      emits the main reminder, new emits the parallel one.
- [x] T-5: wrap-up Step 0.5 block in a scratch project with a registry row, run under zsh: old empties
      `PATH` ("command not found"), new keeps it and writes the expected confirmation lines.
- [ ] T-6 (deferred): the GNU side on Linux. No GNU tools or containers on this machine. Plan: run
      T-2 to T-5 on any Linux host, or ask the owner to.

## Risks (per DSM_0.2 §21.2)

- **GNU side untested here** (T-6). *Mitigation:* the GNU command still runs first, so GNU behaviour
  changes only where `stat -c` already failed; stated in the PR body.
- **A basename match also matches any other process named `claude`** in the chain. *Accepted:* the
  same holds on Linux today; the walk stops at the first match, which is the nearest ancestor.
- **The change conflicts with work the owner has in flight** on the same files. *Mitigation:* branch
  from the latest `main`, keep the diff to the 7 lines, rebase if `main` moves before the merge.
- **Our hook copies drift** (this fork carries the same files at 1.35.0). *Accepted:* they arrive
  with the next upstream merge into the fork.

## Upstream Contribution

This BL is the contribution: a pull request on Central. Absorption is recorded here with the
merge commit and the release that ships it.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S19) on macOS in the Central clone, branch `fix/macos-zsh-shell-portability`,
one local commit on Central `main` at v1.37.0. Runner `/tmp/s19-fix/run.sh old|new` extracts
each snippet from the file (old = `origin/main` blob, new = working tree) and runs it.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | Before: `stat -c` at 2 sites, exact compare at 4 (self-test on `origin/main`: 4), `path=$(` at 1. After: `stat -c` lines without the BSD form 0 (2 lines carry both), exact compares 0, basename compares 4, `path=$(` 0. Diff: 6 files, 7 hunks, +9/-9, modes unchanged; `bash -n` on the hook exit 0 |
| T-2 | PASS | Worklog fixture 10 min old (python). Old: `TRANSCRIPT_AGE_MIN=0` for dsm-go L95 and dsm-staa L36, bash and zsh. New: `10` in all four |
| T-3 | PASS | `CLAUDE_PID` unset. Old: empty for dsm-go Step 6, DSM_0.2.A §26 and dsm-parallel-session-go, bash and zsh. New: 37516 (= `CLAUDE_PID`) in all six runs |
| T-4 | PASS | Registry recording 37516. Old hook: main reminder. New hook: "parallel mode" reminder |
| T-5 | PASS | Registry with two entries. Old, zsh: `PATH` emptied, 1 of 2 targets confirmed, no error shown. New, zsh: `PATH` intact, 2 of 2. Bash: 2 of 2 before and after |
| T-6 | DEFERRED | GNU side: no Linux host here. Trigger: any Linux host, or the owner's review |

**Found on the way, not changed:** Step 0.5's `realpath -m` fails on macOS (`illegal option -- m`);
the step's own fallback keeps the uncanonicalized path. Named in the PR body as a possible follow-up.

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, head = local HEAD, base `main` unchanged, open and mergeable, live body = approved file.
- [ ] T-6 (GNU side).
- [ ] Owner's merge and the release that ships it; then Status Implemented and move to `done/`.
