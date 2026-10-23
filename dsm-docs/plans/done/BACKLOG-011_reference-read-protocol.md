# BACKLOG-011: Reference-Read Protocol: Check Claims Against Their Source Passage Before Use

**Status:** Implemented (trial setup; the trial runs as BACKLOG-025)
**Date Implemented:** 2026-10-23
**Priority:** Medium
**Extends:** DSM_0.2.B (new protocol, recommendation C); DSM_6.0 §1.3 Earn Your Assertions (bullet, recommendation B); DSM_0.2 §10 and §10.1 (scope clarification, recommendation E)
**Date Created:** 2026-10-19
**Origin:** Research note `dsm-docs/research/2026-10-15_reference-reading.md` (drafted S16, Gate 4 in S17, signed off by the user), prompted by a downstream spoke's hub inbox report of 2026-10-15.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-011).

---

## Problem Statement

A file read broadly for context later becomes the basis of a specific claim in a plan, a
decision, a brief or a message. The claim travels as the agent's interpretation without the
passage, so the human approving it cannot see a gap between claim and wording, and the
correction comes only from the source side. Cases: research section 3.1. Principle analysis:
section 3.2. No existing rule reaches the point of use with the passage in front of the human:
coverage map, section 3.3.

## Proposed Solution

Implement the research recommendation (section 5) fork-local, as a trial:

- **C.** A reference-read protocol in DSM_0.2.B carrying the trigger, the four-part exchange
  (passage, location, reading, confirmation), the pointer case and the exemptions defined in
  research section 3.4.
- **B.** A bullet in DSM_6.0 §1.3: a claim drawn from a source is checked against the passage,
  not against the memory of a read.
- **E.** A statement in DSM_0.2 §10/§10.1 of whether §10's exemption for internal file reads
  also applies to §10.1, worded consistently with C's exemptions.
- **Dispatch row.** A DSM_0.2.B protocol is read on demand, so C needs a row with its trigger in
  the DSM_0.2 §25.2 module dispatch table; without one the agent has no route to it. Not in the
  research; added at filing.
- **Trial.** Count the exchanges and the corrections they produce (research section 5).

Options not chosen (A, D) and set aside (F-H): research section 3.5.

**Placement inside DSM_0.2.B.** §1 and §2 hold Composition Challenge and Edit Explanation Stop.
Adding C as a section of a methodology document needs explicit user confirmation either way
(Destructive Command Protocol, `.claude/CLAUDE.md`). Placing it directly beside §1 and §2 also
renumbers §3-§8; appending it as a new last section does not. Decided with open question 5:
not needed during the trial (answer 5).

## Open Questions (resolve before implementation)

From research section 5:

1. Who confirms when the source belongs to someone other than the human in the session?
2. Does the trial run in this hub, in the reporting spoke, or both?
3. What counts as a correction? T-6 cannot be written until this is defined.

Added at filing:

4. How long does the trial run, and what result keeps, changes or drops the rule?
5. Where does the trial text live? In-place edits to DSM_0.2.B, DSM_6.0 and DSM_0.2 reach the
   agent the way upstream text does (DSM_0.2 through the `@` chain, DSM_0.2.B through the
   dispatch table), but conflict at every upstream merge that touches those passages. A fork-local guide referenced from the project-specific part of
   `.claude/CLAUDE.md` avoids the conflicts, but loads by a different path than an upstream
   proposal would. This question also settles the placement inside DSM_0.2.B.

### Answers (2026-10-23, S21; the user accepted the recommendations)

1. **Confirmation.** The human in the session confirms. When the claim goes back to the
   source's owner (a PR, an issue, a message), the outgoing text quotes the passage, so the
   owner sees it as well.
2. **Trial location.** This hub only. Its work is largely checking claims against Central's
   text; the reporting spoke's material is confidential, so a trial log there would hold client
   content.
3. **Correction.** Two categories, counted separately: a *human correction* is a confirmation
   that changes what the claim asserts (not only its wording), logged with the human's words
   quoted; a *self-correction* is a change the agent makes to the claim while quoting the
   passage, before showing it (research case 2). Counts are taken from the log by a command.
4. **Window and decision rule.** Five working sessions, S22-S26. Keep the rule if the window
   holds at least one human correction; narrow the trigger if it fires more than 5 times per
   session with no correction; drop it if there are no corrections of either kind. The numbers
   are set without calibration data. *Refined in S21 with the user while drafting the guide:*
   first match wins (keep; drop; narrow if more than 5 per session on average; otherwise the user
   decides), which settles the overlap of "narrow" and "drop" and the case the three rules left
   open (guide §5, BACKLOG-025).
5. **Location.** A fork-local guide, `dsm-docs/guides/reference-read-protocol.md`, with a line in
   the project-specific part of `.claude/CLAUDE.md` naming the trigger. No in-place edits to
   DSM_0.2.B, DSM_6.0 or DSM_0.2 during the trial; text moves into those files only with an
   upstream proposal. The placement inside DSM_0.2.B is therefore not needed for the trial.

## Success Criteria

- [x] Open questions 1-5 are answered and recorded in this BL before implementation starts.
- [x] C: the guide `dsm-docs/guides/reference-read-protocol.md` (§2-§3) holds the trigger, the
      four-part exchange, the pointer case and the exemptions of research section 3.4.
- [x] B: the guide (§4) carries the principle line (answer 5: not DSM_6.0 §1.3 during the trial).
- [x] E: the guide (§4) states this fork's reading of the §10 exemption and §10.1, consistent with
      C's exemptions, and labels it as the fork's reading.
- [x] Routing (replaces the dispatch row): `.claude/CLAUDE.md` §4 names the trigger and the guide
      path; the guide index (`dsm-docs/guides/README.md`) lists the guide.
- [x] The trial log exists at `.claude/reference-read-log.md` with the format of guide §5. Running
      the trial and reporting its counts moved to BACKLOG-025 (split in S21, DSM_0.2 §21).
- [x] Question 5 moved the trial text out of the DSM files; the criteria above and the Test Plan
      below were updated to the guide before implementation (S21).

## Test Plan

Updated to the guide in S21 (answer 5); T-6 moved to BACKLOG-025.

- [x] T-1 (structural): guide §2-§3 name the trigger, passage, location, reading, confirmation,
      pointer case and exemptions; grep each term inside those sections.
- [x] T-2 (structural): guide §4 contains the principle line; grep.
- [x] T-3 (consistency): guide §4's §10/§10.1 statement and §3's exemptions agree; quote both
      passages side by side in the Test Execution Log.
- [x] T-4 (cross-reference, DSM_0.2 §19): the CLAUDE.md line and the guide index resolve to the
      guide; every reference inside the guide resolves; no DSM methodology file changed.
- [x] T-5 (resolver, DSM_0.2 §21.4): removed-or-renamed-string sweep for every string this change
      replaced, recorded even when empty.
- T-6 (trial): moved to BACKLOG-025.

## Risks (per DSM_0.2 §21.2)

The risks of the rule itself (already covered by §1.3 and §1.4, thin evidence, over-firing, cost
and ritual) are in research section 4 with their answers. Risks of implementing it on this fork:

- **Upstream-merge conflicts.** In-place edits to DSM_0.2.B, DSM_6.0 and DSM_0.2 collide with any
  upstream release that touches the same passages; per §21.5 Central's text wins and the fork
  re-applies its change. *Mitigation:* question 5 decides the location before implementation; if
  in place, each edit is a self-contained additive block, so re-applying it is mechanical.
- **Self-measurement bias.** The agent counts its own exchanges and corrections, so the trial can
  flatter the rule. *Mitigation:* each logged correction quotes the human's words that made it,
  and counts are taken from the log by a command, not recalled; both are fixed with question 3.
- **Visibility gap.** §21.5 asks for the BL on the branch sessions start from (`main` by default).
  It is filed on `session-17`, so a session starting from `main` (STAA, parallel) does not see it
  until the session PR merges. *Accepted* for the rest of S18: the PR is opened in S18 and merged
  at wrap-up (§20.2).
- **Trial without an end.** Without question 4 a fork-local trial can stay in force indefinitely
  and drift from upstream. *Mitigation:* question 4 is a precondition for implementation.

## Upstream Contribution

Optional per §21.5. Preconditions from research section 5: a second, comparative pass against work
outside DSM (§10.1), and a name-free account of the reporting spoke's case. Recommendation E
travels upstream with this BL, not as a separate issue.

## Test Execution Log (per DSM_0.2 §21.3)

Executed 2026-10-23 (S21) on `bl-011/reference-read-protocol`, guide drafted section by section
with the user's approval of each section and a full consistency read.

- **T-1 pass.** Matches inside guide §2-§3: trigger 3, `**Passage:**` 2, `**Location:**` 2,
  `**Reading:**` 2, `**Confirmation:**` 1, `**Pointer case.**` 1, `**Exempt,**` 1 (the 2s include
  the example block).
- **T-2 pass.** Guide §4, first content paragraph: "**Principle.** A claim drawn from a source is
  checked against the passage, not against the memory of a read."
- **T-3 pass after one fix.** §3: "values checkable at a glance (a version number, a path, a count
  shown with its output) and claims already confirmed with their passage" are exempt. §4 first
  said a repository-file claim "also gets the section 2 exchange" without naming §3's exemptions;
  it now reads "also gets the section 2 exchange unless section 3 exempts it". Read together, §4
  narrows nothing in §3 and adds the §10.1 passes only for deliverable-critical claims.
- **T-4 pass.** Guide, research file, BACKLOG-011 and BACKLOG-025 exist; `.claude/CLAUDE.md` names
  the guide path once; the guide index links `reference-read-protocol.md`; guide sections 2 and 5
  exist; DSM_6.0 §1.1, §1.3, §1.4, §1.10 and DSM_0.2 §10, §10.1 headings exist; DSM methodology
  files changed by this BL: 0.
- **T-5 pass.** Positive control: `with no correction` found once in this file. Sweep of
  `DSM_*.md`, `scripts/commands/*.md`, `dsm-docs/plans`, `dsm-docs/guides` for the replaced
  strings: `with no correction` 1 hit (answer 4 above, kept deliberately as the record of the
  user's answer, with the S21 refinement beside it); `keep, narrow or drop` 0; `dispatch table
  routes to C` 0; `DSM_6.0 §1.3 carries the bullet` 0.

### Pending verification

- None for this BL. The trial (former T-6) runs under BACKLOG-025 from S22.
