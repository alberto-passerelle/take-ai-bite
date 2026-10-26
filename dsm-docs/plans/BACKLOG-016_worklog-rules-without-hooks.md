# BACKLOG-016: Worklog Rules for Harnesses Where the Hooks Do Not Run

**Status:** Proposed (sent to Central as an issue, S20; accepted into Central's backlog 2026-10-24, not shipped)
**Priority:** Low
**Extends:** DSM_0.2.G (worklog enforcement) and DSM_0.2 §6 (delimiter time stamps)
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 5 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`, section 5).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-016).

---

## Problem Statement

The S17 boot first ran in a harness where no hooks fire. Its first Plan block was stamped in UTC
(the VM clock), listed steps that were already done, and carried no `[RETROACTIVE]` marker; the
matching Output was stamped in local time. The worklog shows a two-hour gap that did not happen,
and an after-the-fact summary labelled as a plan (STAA handoff, section 5). §6 asks for local time
and §7 defines `[RETROACTIVE]`, but DSM_0.2.G does not say what changes when the hooks that
normally enforce them are absent.

## Proposed Solution

A proposal for Central; this fork does not edit the methodology files (§21.5). Guidance in
DSM_0.2.G for harnesses without the worklog hooks:

1. Stamp in local time; where only another clock is available, say so in the first line of the
   block body, never in the delimiter, so the validator's shape check still passes.
2. Label any entry written after the work `[RETROACTIVE]`, as §7 already defines.
3. A session that adopts such a boot (instead of re-running `/dsm-go` Steps 5.5 and 6) notes the
   clock offset in its first Output.

## Success Criteria

- [ ] Upstream text in DSM_0.2.G covers points 1 to 3, or Central declines with a reason recorded
      here.

## Test Plan

For whoever implements it upstream:

- [ ] T-1: the three points are present; `grep`.
- [ ] T-2 (§19.1): a sample append in the recommended form passes `validate-transcript-edit.sh`
      (which already checks delimiter shape and HH:MM drift where hooks run), and the validator's
      result for a sample with the clock note inside the delimiter is recorded, so the guidance
      matches what the validator accepts.

## Risks (per DSM_0.2 §21.2)

- **Format drift.** Guidance that changes the delimiter would break the validator. *Mitigation:*
  the clock note goes in the block body; T-2 checks it.
- **Rare case.** Hook-less boots are uncommon. *Accepted:* Low priority.
- **Overlap with BACKLOG-003's upstream fix** (boot-turn ordering, DSM_0.2.G, v1.35.0), which
  covers where the boot's first entry lands, not how a hook-less boot stamps it. *Mitigation:*
  point to that section rather than restating it.

## Upstream Contribution

Route: one issue on TAB with this body attached, listed in tracking issue #130. Drafted with the
S17 feedback batch; posted only after the user approves its text.

**Sent (S20, 2026-10-22):** as an issue on Central after a recheck against v1.37.1, with the
user-approved text. The TAB-issue route above predates this fork's Central access (S19).

**Central disposition (S23 check, 2026-10-26):** the issue was closed into Central's backlog on
2026-10-24 (Proposed, not shipped). At the release, check the shipped text against points 1 to 3
of this BL, one by one.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, upstream proposal)
- [ ] At the release that ships the change: the shipped text covers points 1, 2 and 3, checked
      one by one.
