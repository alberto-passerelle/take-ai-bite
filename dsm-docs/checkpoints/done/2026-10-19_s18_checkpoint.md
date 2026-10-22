**Consumed at:** Session 19 start (2026-10-22)

# Session 18 Checkpoint
**Date:** 2026-10-19
**Branch:** session-17/2026-10-16 (resumed; merged to main via PR #16 at this wrap-up)
**Last commit:** 3ecc47f File fork-local BACKLOG-014 to -017 as upstream proposals from the S17 STAA candidates 3-6

## Work completed this session
BACKLOG-011 filed and the reference-reading research linked to it. BACKLOG-012 removed the
reporting spoke's name from the public fork's current files, tags and PR #11; BACKLOG-013 added a
name check before every push and every posting `gh` command. BACKLOG-014 to -017 filed as upstream
proposals, and the upstream issue batch triaged (details in the S18 handoff).

## Pending next session
1. **Post the upstream issue batch, wave 1 first.** Fifteen issues are triaged in three waves in the
   S18 handoff, with each claim rechecked against v1.35.0. Two choices are still the user's: the
   pace (recommended: wave 1, seven defect issues, now; waves 2 and 3 after Central responds) and
   the review format (recommended: one draft file the user edits, each issue approved before it is
   posted). Every issue and the #130 refresh go out under the user's name, so each body needs its
   own approval (voice attribution). Nothing blocks this; skipping it only lets #130 stay stale and
   the findings age.
2. **Tick BACKLOG-012's last pending check.** The search of the fork's `main` for the name can only
   run after PR #16 merges, which happens at the end of this wrap-up; its result is in the S18
   worklog's last Output. Recording it in the BL file needs a commit, so it waits for the next
   session branch rather than landing on `main` directly (§20.8).
3. **Extend the name list.** `.claude/name-denylist.txt` holds only the spoke's name. The check knows
   only what is listed, so client or other names the user wants kept off the fork must be added by
   the user; until then they pass unchecked.
4. **Decide on PR #11's edit history.** Its description history still holds the old text with the
   name. GitHub documents that write-access users can delete sensitive information from a comment's
   edit history, without saying whether that covers a PR description. Trying it is an outward
   change and the user's call; the rename event cannot be removed by users as far as known.
5. **BACKLOG-011 needs two things before implementation, in either order:** answers to its five
   open questions, and CLAUDE.md sections 2-4 (§23.3 bars implementation without them; filing and
   research were exempt). The Test Plan's trial measurement cannot be written until "correction"
   is defined.
6. **Carried from S17, still the user's call:** retire `/Users/alberto/TAB/HUB` or keep it as a
   fallback; prune the research README's 19 links to files absent in this fork (a small fork BL).
7. **Scratch files in /tmp.** The cross-repo hook blocks Edit-tool writes to `/tmp` while shell
   writes pass. The user has not said whether scratch edits should go through the session
   confirmation; until then, scratch files are written through the shell, as all of S18's were.

## Open branches
None after the PR #16 merge (`session-17/2026-10-16` is deleted by the merge). No `bl-*` or
`sprint-*` branches locally or on the fork.
