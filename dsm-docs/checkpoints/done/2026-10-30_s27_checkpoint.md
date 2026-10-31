**Consumed at:** Session 28 start (2026-10-31)

# Session 27 Checkpoint
**Date:** 2026-10-30
**Branch:** session-27/2026-10-30 (merged into `main` at this wrap-up)
**Last commit:** the wrap-up commit on top of the BACKLOG-029 index move

## Work completed this session
The session measured what the per-turn worklog costs and built a tool-use report from the Claude
Code session log (BACKLOG-029, done, run at every wrap-up through the local CLAUDE.md). It filed
BACKLOG-030 to build the worklog from that log instead, closed the reference-read trial
(BACKLOG-025: narrowed), and added commit hooks for the egress sweep. Details: the S27 handoff.

## Pending next session
1. **BACKLOG-028, starting with one inbox entry.** A downstream spoke sent "Protected data: two
   conditions, not one", which may change what BACKLOG-028 writes into DSM_0.2.C §5, so read it
   before Gate 2. Then implement on `bl-028/*` from a clean index and run T-1 to T-7.
2. **S28's wrap-up must run the tool-use report.** BACKLOG-030 starts only when
   `.claude/tool-use/history.md` holds two sessions, so a skipped report delays it by a session.
   Prefix every Bash description from the first call: S27's worklog figures are partly guessed,
   S28's should be exact.
3. **BACKLOG-030 at S29 at the earliest.** Start with the dated copies its Rollback section asks
   for and the test on S26's log (T-1) before switching anything.
4. **Central:** nothing new since S26, and all three PR slots are in use, so BACKLOG-028's upstream
   offer and the queued fixes still wait. Read with `gh`, never fetch in the Central clone.
5. **Inbox:** 2 files, 5 entries, not read yet (item 1 is one of them).
6. **Scratch folders** under `.claude/scratch/` (ignored); one holds a full copy of the S27 session
   log. Delete them on the user's explicit go (`rm -rf`).

## Open branches
none
