# Session 17 Checkpoint
**Date:** 2026-10-16
**Branch:** session-17/2026-10-16
**Last commit:** 3f19fad Narrow BACKLOG-008 to the contribution mechanics DSM_0.2 §21.5 (v1.35.0) leaves out; priority Medium -> Low

## Work completed this session
The fork now pulls from upstream TAB: `origin` is the alberto-passerelle fork, `upstream` is TAB, the
local squashed history is rejoined to fork main, and v1.35.0 is merged on the fork (PR #15). Seven
fork-local BLs closed as absorbed upstream, with `done/fork-INDEX.md` as their archive, and
BACKLOG-008 narrowed. The reference-reading research passed Gate 4 and the user signed it off.

## Pending next session
1. **File BACKLOG-011 on the session branch, then merge in a fixed order.** DSM_0.2 §21.5 (v1.35.0)
   requires a fork-local BL file and its README row on the branch every session starts from, so
   file it on the session branch, not on `bl-011`; a BL that exists only on a task branch is
   invisible to STAA and parallel sessions. Point the BL at research sections 3.4 and 5 instead of
   copying them, set the research header's "Linked BL", and move its research README row to "Tied
   to an active backlog item". Only then merge `bl-011` into the session branch, and the session
   branch into main via a PR on the fork. That order is forced by §20.2: a session branch merges to
   main only after its Level 3 branches are merged back, which is why `session-17` stays open at
   this wrap-up. Details in the S17 handoff.
2. **Decide the three open questions of research section 5 before writing the BL's Test Plan.**
   Who confirms when the source belongs to someone other than the human in the session, where the
   trial runs (this hub, the reporting spoke, or both), and what counts as a correction. The trial
   counts exchanges and corrections, so its Test Plan cannot be written until "correction" is
   defined; filing the BL with these marked open is fine, implementing it is not.
3. **Add CLAUDE.md sections 2-4 before implementing BACKLOG-011, not before filing it.**
   DSM_0.2.A §23.3 bars implementation work while `## 2. Participation Pattern`, `## 3. Project
   Type` and `## 4. Project Specific` are missing; filing and research are exempt. Each section needs
   the user's approval of its text. The upstream hub's CLAUDE.md lacks them too, so drafting them is
   new content, not a copy.
4. **Choose which upstream feedback items to draft as issues.** The S17 handoff lists 13 candidates
   (6 from S16, 7 from S17). The agent drafts name-free issues; the user posts them. They do not
   block BACKLOG-011.
5. **Verify the BACKLOG-003 fix at the next `/dsm-go`.** Central's fix (BACKLOG-590, v1.35.0) moves
   the boot turn's first worklog entry after the reset. Check that the archived S17 worklog ends
   with this wrap-up's last entry and holds no S18 plan block. If it does hold one, reopen the
   finding upstream: BACKLOG-003 was closed on Central's word, and this boot is the first test.
6. **Retire or keep `/Users/alberto/TAB/HUB`.** No spoke or hub config points at it any more, but
   it still holds an uncommitted deletion of the old research file. Deleting the directory is the
   user's call; until then it is an unused fallback.
7. **Research README index (carried from S16).** Its 19 links point to files absent in this fork.
   Pruning them is a small fork-local BL, lower priority than items 1-3.

## Open branches
- `bl-011/reference-reading` (Level 3): research complete and signed off; merges into the session
  branch after BACKLOG-011 is filed (item 1). Carries this checkpoint via a merge of `session-17`,
  so the next `/dsm-go`, which checks it out first, finds it.
- `session-17/2026-10-16` (Level 2): pushed; holds the BL closures, `done/fork-INDEX.md`, the
  BACKLOG-008 narrowing, the guide fix and this checkpoint, none of which is on main yet.
