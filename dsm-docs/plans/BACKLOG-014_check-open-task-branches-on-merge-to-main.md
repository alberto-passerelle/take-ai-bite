# BACKLOG-014: Check Open Task Branches Whenever a Plan Merges Into Main

**Status:** Proposed
**Priority:** Medium
**Extends:** DSM_0.2 §20.2 ("Merge to Level 1") and `/dsm-wrap-up` Step 10
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 3 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`, section 3), together with the S17 handoff's feedback item 10 (`dsm-docs/handoffs/done/2026-10-16_s17_backlog-011-and-upstream-feedback.md`).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-014).

---

## Problem Statement

§20.2 lets a session branch reach `main` only at wrap-up, and only once every Level 3 branch is
merged back. Two gaps leave that condition unchecked:

1. **Mid-session merges.** A plan step that merges into `main` before wrap-up is not checked at
   all. In S17 a fork-sync PR merged the session branch into `main` while a task branch held
   unmerged work, and the plan did not name an exception (STAA handoff, section 3).
2. **Wrap-up Step 10.** The step merges the session branch via PR without restating the condition,
   so the skip that S17 applied correctly rested on the agent remembering §20.2 (S17 handoff,
   feedback item 10).

On a fork, the usual reason for a mid-session merge is an upstream sync, which §20.2 neither
allows nor routes.

## Proposed Solution

A proposal for Central; this fork does not edit the methodology files (§21.5):

- **(a)** Any plan step that merges into `main` lists the open Level 3 branches that hold commits
  not in the session branch, and names the §20.2 exception it relies on.
- **(b)** `/dsm-wrap-up` Step 10 restates the condition and checks it with a command before it opens
  or merges the PR.
- **(c)** §20.2 either names an upstream sync as an allowed mid-session merge into `main`, or routes
  it through a dedicated sync branch. Which of the two is open; it is Central's decision.

## Success Criteria

- [ ] Upstream text covers (a), (b) and (c), or Central declines with a reason recorded here.

## Test Plan

For whoever implements it upstream:

- [ ] T-1: Step 10 restates the Level 3 condition; `grep`.
- [ ] T-2 (§19.1): the check command, run against a repo with an open `bl-*` branch holding a commit
      not in the session branch, reports that branch; run against a repo without one, it reports
      none; the two outputs differ.
- [ ] T-3: §20.2 names the chosen route for upstream syncs.

## Risks (per DSM_0.2 §21.2)

- **Over-firing on held branches.** A wrap-up that keeps a task branch open on purpose (S17's case)
  would meet the check every time. *Mitigation:* the check reports and the wrap-up keeps the
  session branch open, as it already does; it never blocks.
- **Fork-only framing.** Written around forks, the rule would miss other repos that sync from an
  upstream. *Mitigation:* phrase (c) for any upstream sync.
- **Overlap with `/dsm-go` Step 0c**, which already counts unmerged commits on a leftover branch.
  *Mitigation:* reuse the same `git log main..branch` measure rather than adding a second one.

## Upstream Contribution

Route: one issue on TAB carrying (a) to (c), with this body attached, listed in tracking issue
#130. Drafted with the S17 feedback batch; posted only after the user approves its text.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, upstream proposal)
