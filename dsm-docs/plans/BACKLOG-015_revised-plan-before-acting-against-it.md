# BACKLOG-015: Append a Revised Plan Before Acting Against the Current Plan

**Status:** Proposed
**Priority:** Low
**Extends:** DSM_0.2 §7 Worklog Protocol (per-turn flow) and DSM_0.2.G
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 4 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`, section 4).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-015).

---

## Problem Statement

§7 requires a plan entry before the turn acts, but says nothing about a turn that then does
something its plan ruled out. In S17 a turn planned as a read-only investigation deleted files and
attempted a memory write; the user's words may have authorized it, but the worklog does not record
that reading (STAA handoff, section 4). The plan block then documents an intent the turn did not
follow, which is the record a later reviewer trusts.

## Proposed Solution

A proposal for Central; this fork does not edit the methodology files (§21.5):

- When a turn is about to do something its plan block ruled out, it appends a revised Plan block
  first, stating what changed and why, or its Output quotes the user's words that authorized it.
- **Scope:** writes, deletions and outward-facing actions only, so the rule does not fire on every
  small change of approach (DSM_0.2.F §8.9.2 over-firing guard).

## Success Criteria

- [ ] Upstream text in §7 or DSM_0.2.G states the rule and its scope, or Central declines with a
      reason recorded here.

## Test Plan

For whoever implements it upstream:

- [ ] T-1: the rule and its scope are present; `grep`.
- [ ] T-2: DSM_0.2.G carries one worked example (plan, deviation, revised plan or quoted
      authorization), and the example passes the transcript validator's shape check.

## Risks (per DSM_0.2 §21.2)

- **Over-firing.** Without a scope, every adjustment would need a revised plan. *Mitigation:* the
  scope is limited to writes, deletions and outward-facing actions.
- **Ritual revisions.** A revised plan that only says "plan changed" keeps the form and drops the
  reason. *Mitigation:* the revised plan names what changed and why.
- **Low recurrence evidence.** One recorded case. *Accepted:* Low priority; the S17 reasoning lesson
  carries the practice until Central decides.

## Upstream Contribution

Route: one issue on TAB with this body attached, listed in tracking issue #130. Drafted with the
S17 feedback batch; posted only after the user approves its text.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, upstream proposal)
