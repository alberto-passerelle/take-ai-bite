# Session 29 Checkpoint
**Date:** 2026-11-04
**Branch:** session-29/2026-11-04 (merged into `main` at this wrap-up)
**Last commit:** the wrap-up commit on top of the BACKLOG-036 Gate 1 record

## Work completed this session
The boot found MEMORY still at S27 because S28's memory write had been blocked; the session took
its number from the wrap-up marker, and memory was repaired with the user's confirmation. BACKLOG-035
(a user-only allowlist of `_inbox` folders for the cross-repo write hook) and BACKLOG-041 (the egress
checker reads fork BL numbers from the fork's indexes) are implemented and closed. Two spoke inbox
files are processed: BACKLOG-033, 034 and 036 to 040 filed, BACKLOG-026 amended. Notes went to five
spoke inboxes. BACKLOG-036 passed Gate 1 after a §22 correction of its origin and scope.

## Pending next session
1. **Implement BACKLOG-036 first.** Gate 1 is approved: awk `$(N)`, shell `${N}`, "field N" in
   prose, plus a line in DSM_0.2.B §8.2 and a count in the fork's pre-commit report. It goes first
   because every skill invoked with words after its name hands the agent altered snippets without an
   error; one word is enough to change `/dsm-go` Step 2e (`$0`). Show one edit per file
   (DSM_0.2.B §8.2), run each rewritten snippet on real input, then deploy and `diff -q`.
2. **BACKLOG-030 in a fresh session.** Make the dated copies (`settings.json`, `CLAUDE.md`,
   `reasoning-lessons.md`) first, then run T-1 on S26's log, and switch off the per-turn writes
   last: the switch changes the hooks every later session runs under, and the copies are the only
   way back.
3. **The allowlist exists only as a mechanism.** The user creates `.claude/cross-repo-allowlist.txt`
   in the editor; the hook blocks the agent from writing it. A spoke honours it only after one
   manual `/dsm-align` (asked for in today's notes); until then its `/dsm-go` may list entries that
   its old hook still blocks. The next `/dsm-go` here runs Step 0f live for the first time
   (BACKLOG-035's pending T-10).
4. **File the fork BL for the Step 0a gap.** It was proposed at the S29 boot as the prevention step
   of the §22 finding and not yet filed: Step 0a should read the wrap-up marker's `session:` as a
   fourth source, and the wrap-up should stop before the merge when its memory write is blocked.
   Without it, a blocked memory write makes the next boot reuse the last session's number.
5. **Upstream offers wait for a free Central PR slot** (3 of 3 in use): 028 (after BACKLOG-031's
   Gate 1, which changes 028's row), 032, 035, and 036 to 040. 041 needs no offer.
6. **Reference-read rule: decide how it applies.** S29 showed passages and locations in drafts and
   BL texts, but asked no reading as its own question; the log records those exchanges as
   unanswered. This joins the S28 item on where the counts go now that BACKLOG-025 is closed.
7. **Carry-overs from S28:** tell the spokes what happened to their S28 entries (a cross-repo note,
   its own approval); delete the scratch folders under `.claude/scratch/` (`rm -rf`, user's go);
   Gate 1 for 031 to 034 and 037 to 040.

## Open branches
none
