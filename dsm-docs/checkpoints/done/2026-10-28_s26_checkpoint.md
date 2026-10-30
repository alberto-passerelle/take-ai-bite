**Consumed at:** Session 27 start (2026-10-30)

# Session 26 Checkpoint
**Date:** 2026-10-28
**Branch:** session-26/2026-10-28 (merged into `main` at this wrap-up)
**Last commit:** the wrap-up commit on top of the BACKLOG-028 filing

## Work completed this session
An organization changed the data-protection rule in its agent instructions; the session adapted
the hub and the spokes to it. BACKLOG-028 is filed (Gate 1 approved, not implemented), and each of
the four spokes has an inbox note with its own points. S26 closed the reference-read trial window;
its counts are in BACKLOG-025 and the decision moved to S27. Details: the S26 handoff.

## Pending next session
1. **Read Central's answers first.** Unchanged from S25: the S24 batch, the two S25 issues and the
   consequential-drafting update are open, and all three PR slots are used. Every other item that
   goes upstream (BACKLOG-028's offer, the queued fixes) waits for a free slot, so this check
   decides what can move.
2. **Trial decision (BACKLOG-025).** The window S22-S26 is closed. Ask the user to confirm the one
   classification that decides the rule (S25's human correction: a question that changed the
   claim, not its wording), then apply guide §5's rule. Both "keep" (rule 1) and "narrow" (rule 3,
   about 17 exchanges per session) match on the counts, so the confirmation decides between them;
   the reference-read rule stays active until then.
3. **Implement BACKLOG-028** on a `bl-028/*` branch from a clean index, with its seven tests. It
   edits DSM_0.2.C, which every spoke reads through the hub's `@` chain, so the protected tier
   reaches all spokes at merge; the spoke notes already announce it as coming.
4. **Spokes apply their notes themselves.** Nothing for the hub unless a spoke reports back.
5. **Carried from S25:** the lessons prune at the next STAA run (an S18 lesson against a spoke
   lesson), the name list (still one entry), the upstream-release merge, and the user's own
   team-skill rollout steps.

## Open branches
none
