# BACKLOG-026: Approve Every Spoke-Hub Message, Let Only Methodology Concepts Cross, and Replace /dsm-align's Inbox Notice

**Status:** Proposed (to be addressed later; the user asked for it to be filed, not implemented)
**Priority:** High
**Extends:** DSM_0.2.C §2.3 (Voice-Attribution) and §5 (Sensitive Data Protection); DSM_0.2.A §1 (Session-End Inbox Push); `/dsm-wrap-up` Steps 0.5, 1 and 6; `/dsm-align` Steps 6 and 12b; `/dsm-go` Steps 1.8 and 2b
**Date Created:** 2026-10-23
**Origin:** User request, S21: human approval before spokes and hub exchange files, with the strictest data protection, and messages limited to methodology concepts that improve the methodology. The user's source states that wrap-up still sends methodology feedback and notifications to the hub without per-message approval, and that the approval step is planned but not implemented. Part B added by the user at filing: the `/dsm-align` inbox notice is over-engineered.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-026).

---

## Problem Statement

**A. Messages between projects leave without review, and nothing limits what they carry.**
Checked against the commands this hub deploys (S21): `/dsm-wrap-up` writes into other projects'
`_inbox/` in Step 1 (README, FEATURES and downstream notices) and Step 6 (feedback push), and Step
0.5 pre-confirms those inbox directories so the cross-repo write hook never asks. `/dsm-align` Step 6
pushes feedback as well. None of these waits for the human to read the text. DSM_0.2.C §2.3 already
treats inbox notifications and feedback files as the user's words, but `/dsm-wrap-up` is specified
to "Run all steps without pausing for approval".

Central has a backlog item, created 2026-10-21, for human review of every inbox message between
projects, in both directions (one review block per run, no pre-confirmed inboxes, no
self-confirmation through the hook's message, non-suppressible in auto mode). Its text has no rule
on what a message may contain: confidentiality, personal or client data, and a limit to methodology
content are not mentioned (read-only check, S21).

A spoke can be a client project. A message that carries its content moves Restricted or
Confidential material (DSM_0.2.C §5.1) into another repository, where it is read by another session
and can be quoted onward.

**B. `/dsm-align` writes a notice into the project's own inbox (Step 12b).** After a post-change
run, or a check-only run with warnings, Step 12b writes `_inbox/{date}_dsm-align-update.md`. The
session that ran the skill already has the result three times: the Step 12 report in conversation,
`.claude/last-align-report.md` (12a) and `.claude/last-align.txt` (13). The inbox entry then sits in
the next boot's inbox list beside real messages from other projects and has to be archived by hand
(one such entry from 2026-10-16 was still in this hub's inbox at S21).

## Proposed Solution

**A1. Approval.** Adopt the shape of Central's item: every message into another project's inbox,
in either direction, is shown with its target and full text in one review block per skill run; the
user approves, edits or drops each; only approved messages are written; dropped ones are recorded as
dropped. Step 0.5 stops pre-confirming inbox directories.

**A2. Content rule (the part Central's item lacks).** A message between projects carries
methodology concepts only: what a protocol or skill does, where it failed or helped, and a proposed
change. It carries no client, mandate, person or project names, no project content or data
excerpts, and no file paths or identifiers from the sending project. The sending project's material
is handled at its highest classification (DSM_0.2.C §5.1): none of it crosses. A situation that
explains a methodology failure is described in abstract, name-free terms; the reviewer decides
whether the abstraction holds. Before the review block, the skill runs the name-list check this
fork already uses for public egress and reports it with its coverage.

**A3. Route.** Offer A2 to Central as input to its item (described by topic, never by number, in
tracked fork files). Because this hub deploys the commands its spokes run, decide at implementation
whether to adopt A1 and A2 fork-locally before Central ships them.

**B. Replace Step 12b.** Drop the own-inbox notice. The result stays where it already is (Step 12
report, 12a, 13). `/dsm-go` adds one boot-report line read from `.claude/last-align.txt`: version
change, result and warning count, with a pointer to `.claude/last-align-report.md` when the result
is not `pass`. On a version match the line appears only when the stored result is not `pass`, so
unresolved warnings stay visible in later sessions. Update the two texts that cite the Step 12b
notice (the enumerate-each-entry rule in `/dsm-go` Step 2b and DSM_0.2.A). Exact wording decided at
implementation.

**Scope note (DSM_0.2 §21).** A and B have independent success criteria. They are filed together
at the user's request because both cut unreviewed inbox traffic; split them when they are worked
separately.

## Success Criteria

- [ ] A1: no skill writes into another project's `_inbox/` before the user approved that message's
      full text in the same session; approved, edited and dropped outcomes are recorded.
- [ ] A2: the content rule is stated once and every sending step points to it; the name-list check
      runs before the review block and reports its coverage.
- [ ] A3: A2 offered to Central as input to its item; fork-local adoption decided and recorded.
- [ ] B: `/dsm-align` no longer writes to `_inbox/`; `/dsm-go` reports the alignment result from
      `.claude/last-align.txt`; no text still cites the Step 12b notice.

## Test Plan

- [ ] T-1 (A1): in a scratch spoke with one ripe feedback file, run `/dsm-wrap-up`: no inbox write
      before approval (checksum of the target `_inbox/` before and after the review block); a
      dropped message is recorded as dropped.
- [ ] T-2 (A1): recount the inbox-writing steps across `scripts/commands/*.md` by grep at
      implementation time and show each one routes through the review block.
- [ ] T-3 (A2): a scratch message containing a listed name is flagged before the review block; the
      report states the list size and never echoes the value (DSM_0.2.C §5.8).
- [ ] T-4 (B): run `/dsm-align` with a forced warning in a scratch project: `_inbox/` checksum
      unchanged; the next `/dsm-go` boot report shows the alignment line with the warning count.
- [ ] T-5 (resolver, DSM_0.2 §21.4): sweep for `12b` and `dsm-align-update` across `DSM_*.md` and
      `scripts/commands/*.md`, recorded even when empty.

## Risks (per DSM_0.2 §21.2)

- **Approval fatigue.** A review block at every wrap-up can be waved through, and a reflex-approved
  gate still reads as protection (DSM_0.2.F §8.9.2). *Mitigation:* one block per run; skills send
  nothing when nothing is ripe, so the block appears only when a message exists.
- **Content rule strips the context a finding needs.** Some methodology failures make sense only
  with the project situation. *Mitigation:* abstract, name-free descriptions are allowed; the human
  judges them in the review block.
- **A name list gives false assurance.** The list holds what the user put in it; client terms not
  on it pass the check. *Mitigation:* the check reports its coverage, and the human review is the
  control, not the list.
- **Upstream-merge conflicts.** Fork-local edits to `/dsm-wrap-up`, `/dsm-align` and `/dsm-go`
  collide with upstream releases that touch the same steps; Central's text wins (§21.5).
  *Mitigation:* prefer the upstream route; any fork-local change is an additive block re-applied
  mechanically after a merge.
- **B hides warnings.** Without the inbox entry, an unresolved alignment warning could go unnoticed
  in later sessions. *Mitigation:* the `/dsm-go` line persists while the stored result is not
  `pass`.

## Upstream Contribution

A2 goes to Central as input to its item on human review of inbox messages; B as an issue or PR on
`/dsm-align` and `/dsm-go`. Route chosen at implementation, within the fork's limit of three open
PRs on Central.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, not implemented)
