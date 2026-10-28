# Session 25 Checkpoint
**Date:** 2026-10-28
**Branch:** session-25/2026-10-28 (merged into `main` at this wrap-up)
**Last commit:** the wrap-up commit on top of the BACKLOG-027 merge

## Work completed this session
BACKLOG-027 was amended and implemented as a fork-local feature: `dsm-docs/guides/consequential-drafting.md`
and an optional Gate 1 item 6 in DSM_0.2.F §8.10, which every spoke reads through the hub's DSM_0.2.
Two spoke inbox files of reviewed lessons were processed and archived; a lessons-reload line and a
`.gitignore` entry went to the hub and two idle spokes, and an inbox note asks all four spokes to
apply them. Two new issues went to Central; the trial counts are in BACKLOG-025.

## Pending next session
1. **Read Central's answers before anything else that touches Central.** The S24 batch (eight
   items), this session's two issues and the consequential-drafting update are all open with no
   reply. Check each answer one success criterion at a time and record status only in tracked
   files (`.claude/CLAUDE.md` §2). All three PR slots stay in use until one resolves, so the queued
   mechanical fixes in the drafts candidates file wait; a PR for consequential drafting, offered in
   the update, also needs a free slot.
2. **Trial session S26, the last one.** Log exchanges as before, except claims inside drafted bites,
   which the validator checks since S25. At S26 close, run the four commands of guide §5 and apply
   the rule. S25 logged the trial's first human correction, so rule 1 ("keep") now matches. That
   one classification decides the outcome, so ask the user to confirm it (a question that changed
   the claim, not its wording) before applying the rule. Then weigh the narrowing evidence: the
   user stopped the per-claim question rounds while drafting, and the trigger fired about 20 times
   per session.
3. **Spokes apply the lessons fixes themselves.** The inbox note in all four spokes asks for the
   CLAUDE.md line and the `.gitignore` entry; two spokes already hold the edits uncommitted, made by
   the hub when no session ran there, and their next session commits them. Nothing for the hub
   unless a spoke reports a problem.
4. **Lessons prune (next STAA run):** revisit the S18 Infrastructure lesson that suggests a Bash
   write to pass the cross-repo gate. A spoke lesson aggregated in S25 says the opposite, and this
   session hit that bypass itself; the aggregation entry carries a conflict note.
5. **Name list.** `.claude/name-denylist.txt` still holds one entry; name sweeps keep reporting
   "against a 1-entry list" until the user adds the missing names.
6. **When Central's next release ships:** merge `upstream/main` (then `sync-commands.sh --deploy`
   and `diff -q`), take up the release-dependent follow-ups in the drafts, and reconcile the
   fork's §8.10 item 6 and guide with Central's text if the release carries its own version.
7. **The user's own steps** for the team-skill rollout (S21 parallel handoff in the drafts, §5);
   nothing for the agent until the user reports back.

## Open branches
none
