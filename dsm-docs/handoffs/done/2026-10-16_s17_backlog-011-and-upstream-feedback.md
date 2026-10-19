# Session 17 Handoff: file BACKLOG-011, then the upstream feedback set

**Date:** 2026-10-16
**Date Completed:** 2026-10-19
**Outcome Reference:** Consumed at session 18 start
**Branches:** `bl-011/reference-reading` (open, research signed off) and `session-17/2026-10-16`
(open, pushed). Both are on the fork `alberto-passerelle/take-ai-bite`.
**Read first:** the S17 checkpoint, then `dsm-docs/research/2026-10-15_reference-reading.md`
sections 3.4 and 5.

## Filing BACKLOG-011 (DSM_0.2 §21.5 workflow, v1.35.0)

1. Next number: the highest fork-local `BACKLOG-###` in `dsm-docs/plans/README.md` or
   `dsm-docs/plans/done/fork-INDEX.md` is 010, so 011 is free.
2. Write a name-free body on the **session branch**: Risks (§21.2), a Test Plan, and one
   `**Extends:**` line naming the upstream sections it extends (DSM_0.2.B for C, DSM_6.0 §1.3 for B,
   DSM_0.2 §10/§10.1 for E). Point at research section 3.4 for the exchange, trigger and
   exemptions and at section 5 for the recommendation; do not copy them.
3. Add the README row and commit both on the session branch.
4. Update the research header ("Linked BL: BACKLOG-011", Status) and move its research README row
   from "Findings ready for promotion" to "Tied to an active backlog item".
5. Merge `bl-011` into the session branch, then open the PR to the fork's main with
   `--repo alberto-passerelle/take-ai-bite --base main` (without `--repo`, `gh` targets upstream TAB).
6. The open questions of research section 5 stay open in the BL; the Test Plan needs a definition
   of "correction" before implementation.

## Upstream feedback candidates (agent drafts, user posts; none sent yet)

Each is a candidate for a name-free issue on `albertodiazdurana/take-ai-bite`. Check
`gh issue list --repo albertodiazdurana/take-ai-bite` for an existing issue before drafting.

From S16:
1. DSM_0.1 §8 places a research document's Sources section at the end; the `/dsm-research-add`
   stub places it second.
2. `/dsm-go` Step 0c checks out an open Level 3 branch before Step 3 reads handoffs and
   checkpoints, so artifacts committed only on the session branch are missed. Workaround used in
   S16 and S17: merge the session branch into the open task branch at wrap-up.
3. `/dsm-go` reports inbox files as "entries", but a per-source file can hold several entries,
   including processed ones.
4. DSM_0.2.F numbers Gates 0-3, while §8.10 and the CLAUDE.md template number the prose gates 1-4.
5. DSM_0.2 §7 asks for a prompt summary in User blocks, which lets the agent's reading of a terse
   prompt be logged as the prompt itself; keeping the literal words and marking the reading
   separately would close that.
6. Whether DSM_0.2 §10's exemption for internal file reads also applies to §10.1 is not stated.
   This one is recommendation E of the research and travels with BACKLOG-011, not as a separate
   issue.

From S17:
7. `/dsm-go` Step 0.7a computes the transcript age with GNU `stat -c %Y`; on macOS it fails and the
   age silently prints 0. The same snippet is copied into `/dsm-staa` Step 0.
8. The `/dsm-go` Step 6 pid walk compares `comm` exactly to `claude`; macOS `ps` reports the full
   binary path, so the walk never matches. Only the fallback path is affected (`CLAUDE_PID` was set).
9. `/dsm-align` Step 11b compares `done/` only with the inherited `INDEX.md`. On a fork using
   §21.5's `done/fork-INDEX.md` it flags fork BLs whose numbers Central does not use and silently
   passes those whose numbers collide with Central's.
10. `/dsm-wrap-up` Step 10 merges the session branch to main without restating §20.2's condition
    that every Level 3 branch is merged back first.
11. `/dsm-wrap-up` Step 0.5's snippet assigns a variable named `path`; in zsh, the harness shell,
    `path` is tied to `PATH`, so the loop wipes PATH after its first iteration.
12. DSM_0.2 core carries the line "Confirm that you understand what I need. Be concise in your
    work." between the Contents list and §1 (present since v1.3.61). It reads like a stray prompt
    in an always-loaded file.
13. The tracked project-level copies in `.claude/commands/` of `dsm-go`, `dsm-light-go`,
    `dsm-refresh-all`, `dsm-refresh-memory` and `dsm-staa` lag `scripts/commands/` in v1.35.0. They
    are inert wherever a user-level deploy exists.

## Settled this session (do not reopen without the user)
- HUB-central is the hub; `/TAB/HUB` is an unused fallback.
- The local history keeps both the S14 consolidation commit and the fork's original commits
  (joined with `merge -s ours`); no force-push.
- Held `bl-*` branches are deleted on the fork; their heads survive as `archive/bl-*` tags.
- BACKLOG-008 stays open at Low priority, narrowed to the four items §21.5 leaves out.
