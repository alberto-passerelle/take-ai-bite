# BACKLOG-024: Send Central a Fix So Worklog User Blocks Keep the User's Words

**Status:** In Progress (Central PR open, awaiting the owner)
**Priority:** Medium
**Extends:** Central's DSM_0.2 §6 (Worklog Delimiter Format, User row) and §7 (per-turn flow, step 1)
**Date Created:** 2026-10-22
**Origin:** S16 feedback item 5; S18 triage claim K; S20 recheck against v1.37.1.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-024).

---

## Problem Statement

§6 defines the User block as "Summary of the user's prompt" and §7 step 1 says "append the
user-prompt summary". For a terse prompt ("ok all", "approve") a summary is the agent's
interpretation, so the worklog records an interpretation as the user's words. A later check of a
turn against its prompt, by a reviewer or `/dsm-staa`, then checks it against the agent's own
reading.

## Proposed Solution

The User block carries the prompt in the user's own words, abridged with `[...]` when long; any
expansion is marked as the agent's reading ("read as: ..."); no secrets or personal data. Two lines
change (§6 row, §7 step 1); delimiters do not, so the shape validator is unaffected. No Central BL
file, no CHANGELOG version (S19 decision).

## Success Criteria

- [x] No "summary of the user's prompt" wording remains in DSM_0.2 core.
- [x] No other corpus text describes the User block's content differently.
- [x] The pull request is opened on Central with a body the user approved; nothing pushed to `main`.

## Test Plan

- [x] T-1: the diff touches only the §6 row and §7 step 1 (`git diff --numstat`: +2/-2).
- [x] T-2: sweep DSM_0.2 core for the old wording after the change.
- [x] T-3: corpus sweep for other descriptions of User block content.

## Risks (per DSM_0.2 §21.2)

- **Verbatim prompts can carry sensitive content into the worklog.** *Mitigation:* the new wording
  excludes secrets and personal data and allows abridging.
- **Longer User blocks.** *Accepted:* `[...]` abridging bounds them.
- **The owner prefers summaries for brevity.** *Accepted:* the PR states the trade-off; the owner
  decides.

## Upstream Contribution

This BL is the contribution: a pull request on Central.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S20) on macOS. Scratch copy of the fork's DSM_0.2 core at v1.37.1 (= Central
`main`); the PR branch was cut from Central `origin/main` in a temporary worktree, where the file
was byte-identical to the reviewed base before the change.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | `git diff --numstat`: `2 2 DSM_0.2_Custom_Instructions_v1.1.md`, asserted before commit |
| T-2 | PASS | 0 occurrences of "Summary of the user's prompt" or "user-prompt summary" |
| T-3 | PASS | DSM_0.2.T, DSM_3.0.E and `/dsm-staa` name only the delimiter; no other content description |

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, PR head = local HEAD, live body = approved file.
- [ ] Owner's merge and the release that ships it; then Status Implemented and move to `done/`.
