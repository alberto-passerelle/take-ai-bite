# Session 28 Checkpoint
**Date:** 2026-10-31
**Branch:** session-28/2026-10-31 (merged into `main` at this wrap-up)
**Last commit:** the wrap-up commit on top of the BACKLOG-031 and 032 filing

## Work completed this session
BACKLOG-028 is implemented and closed: DSM_0.2.C §5 now says it governs storage, not reading,
§5.1 has a `Restricted, protected` row, and §5.9 asks about all three protected kinds. A
downstream spoke's inbox entry added one storage sentence to the row before implementation. The
inbox is empty: two spoke files processed, BACKLOG-031 and BACKLOG-032 filed, one idea recorded
only. The tool-use report wrote its second history row (S28).

## Pending next session
1. **BACKLOG-030 can start.** `.claude/tool-use/history.md` now holds S27 and S28, which is its
   start condition. Begin with the dated copies its Rollback section names (`settings.json`,
   `CLAUDE.md`, `reasoning-lessons.md`), then run T-1 (the generator on S26's log), and switch
   off the per-turn writes last: the switch changes the hooks every later session runs under,
   and the copies are the only way back.
2. **BACKLOG-031 Gate 1 before any upstream offer of BACKLOG-028.** 031 lets a project move
   `MEMORY.md` out of the §5.8 egress zone, and the new `Restricted, protected` row relies on that
   zone to keep protected data out of `MEMORY.md`. So 031 has to change 028's row. Offering 028
   upstream first would send the same row twice.
3. **Upstream offers for BACKLOG-028 and 032 are not made yet.** Read Central with `gh`, never
   fetch in the Central clone.
4. **The spokes were not told what happened to their entries.** The protected tier already
   applies to them through the `@` chain. A note to their inboxes is a cross-repo write and needs
   the user's go.
5. **The reference-read guide §5 still sends counts to BACKLOG-025's log, which is closed.** S28
   had 4 exchanges, all confirmed, 1 self-corrected before showing; they are in the local log
   only. Decide where counts go after the trial, or drop the line.
6. **Scratch folders** under `.claude/scratch/` (ignored, now including `s28/`) wait for the
   user's go to delete (`rm -rf`).
7. **Next Central release:** merge `upstream/main`, run `scripts/sync-commands.sh --deploy` and
   `diff -q`, close BACKLOG-022 and 023 if the release carries them.

## Open branches
none
