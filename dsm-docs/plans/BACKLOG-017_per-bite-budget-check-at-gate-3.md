# BACKLOG-017: Check Each Draft Bite Against Its Section Budget at Gate 3

**Status:** Proposed (sent to Central as an issue, S20; accepted into Central's backlog 2026-10-24, not shipped)
**Priority:** Medium
**Extends:** DSM_0.2.F §8.10 (Chunked Drafting Protocol, Gates 2 and 3)
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 6 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`, section 6).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-017).

---

## Problem Statement

§8.10 sets a length budget per section at Gate 2, but Gate 3 reviews each bite without comparing it
to that budget. In the reference-reading research, eight of nine sections drafted in S16 ran over
budget; at Gate 4 in S17, trims took the note from 1,949 to 1,829 words, and closing the remaining
gap would have meant cutting prose already approved bite by bite. The budget's measure was not
stated either: the measure used in S17 gave 1,949 words where `wc -w` gave 2,128 (STAA handoff,
section 6).

## Proposed Solution

A proposal for Central; this fork does not edit the methodology files (§21.5):

- **Gate 3:** each bite is delivered with its word count against its section budget; an overrun is
  accepted or cut at that bite, not at Gate 4.
- **Gate 2:** the budget names its measure (for example `wc -w` over the section, or a stated rule
  for headings, tables and quotes).

## Success Criteria

- [ ] Upstream text in §8.10 states the per-bite check and the named measure, or Central declines
      with a reason recorded here.

## Test Plan

For whoever implements it upstream:

- [ ] T-1: Gate 3 names the per-bite count; Gate 2 names the measure; `grep`.
- [ ] T-2 (§19.1): the stated measure, run as a command on a real section, reproduces the count a
      bite report shows.

## Risks (per DSM_0.2 §21.2)

- **Counting over quality.** A hard cap would push cuts that hurt the text. *Mitigation:* an
  overrun can be accepted explicitly at the bite; the check makes the decision visible, it does
  not make it.
- **Measure ambiguity.** Two measures gave counts 179 words apart in S17. *Mitigation:* Gate 2
  names one measure.
- **Ritual counts.** A count typed from memory defeats the check. *Mitigation:* the count comes
  from a command (S16 reasoning lesson on counts).

## Upstream Contribution

Route: one issue on TAB with this body attached, listed in tracking issue #130. Drafted with the
S17 feedback batch; posted only after the user approves its text.

**Sent (S20, 2026-10-22):** as an issue on Central after a recheck against v1.37.1, with the
user-approved text. The TAB-issue route above predates this fork's Central access (S19).

**Central disposition (S23 check, 2026-10-26):** the issue was closed into Central's backlog on
2026-10-24 (Proposed, not shipped). The success criterion is checked at the release that ships
the change.

**Related (S22):** BACKLOG-027 also adds to what each Gate 3 bite carries (a source map and a
validator run, opt-in at Gate 1). If both land, coordinate the bite-delivery wording.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, upstream proposal)
