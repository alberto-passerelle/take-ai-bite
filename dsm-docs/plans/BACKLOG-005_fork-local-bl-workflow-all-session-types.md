# BACKLOG-005: Complete, Discoverable Fork-Local BL Workflow for All Session Types

**Status:** Implemented (fork-local, S7); methodology on `bl-005-006/fork-governance-cluster` (commit `de1b913`), upstream PR deferred until #125 reconciles
**Priority:** High
**Date Created:** 2026-10-09
**Origin:** S6 concurrent-session incident (2026-10-09). A `/dsm-staa` session found a real BL-worthy issue, but could not file it correctly: it guessed a Central-style number (BL-580, "highest observed was 579") and committed ad hoc, because the fork-local line was invisible to it.
**Author:** Alberto (with AI assistance)

---

## 1. Problem

BL-002 (DSM_0.2 §21.5) established the fork-local **numbering rule** — a fork may keep
an independent `BACKLOG-###` line from 001. But it did not specify the complete
**workflow** (how any session type drafts, tracks, and implements a fork-local BL), and
critically it is **not discoverable** to non-main sessions.

The S6 incident is the proof. The STAA session's own BL file admits it: *"PROVISIONAL
NUMBER: assigned on the public mirror, where no active BL bodies live and Central's real
numbering is not reachable. Highest BL observed anywhere in this clone at creation time
was BL-579."* The fork-local line (BL-001, BL-002, and the README index) lived on
**unmerged branches**, so a session operating on `main` saw only the de-identified INDEX
(≤579) and reasonably guessed 580 in Central's namespace — the exact collision BL-002's
rule exists to prevent.

Two root causes:

1. **Invisibility.** Fork-local artifacts were not on `main`, so no session (main, STAA,
   or parallel) could see the line or its next number.
2. **Incomplete, main-centric workflow.** The drafting/tracking/implementing procedure is
   implied by example (BL-001/002) but never written as a procedure a non-main session
   could follow.

## 2. Proposed Behavior

- **Fork-local plans live on `main`.** The fork-local `dsm-docs/plans/` bodies + README
  index are kept on `main` (visible to every session), carrying the next-number and
  status. *(Done for BL-001/002/003 this session; this BL codifies it as the rule.)* The
  methodology-document edits a BL implements stay on their own branches / upstream PRs;
  only the plans bodies + index are the always-visible part.
- **A written fork-local BL workflow**, usable by **any** session type:
  1. find the next number from the `plans/README.md` index on `main` (never guess
     Central's line);
  2. draft a name-free body with the standard required fields + §21.2 Risks + a Test Plan
     + a Non-Contradiction Check (BL-006);
  3. track it in the README index;
  4. implement on a `bl-NNN/*` branch;
  5. offer it upstream (optional but recommended, per §21.5).
- **Discoverability for non-main sessions.** STAA (and other non-`/dsm-go` skills that may
  file) point to this workflow, so a session that finds an issue files it correctly
  instead of improvising. Pairs with BL-004 (which settles whether STAA may file at all).

## 3. Non-Contradiction Check (per BL-006)

This **extends** BL-002 / §21.5 (the numbering rule) with a workflow and a visibility
rule; it does not change Central's canonical status or the numbering reconciliation. It
adds no rule that conflicts with upstream — "fork-local plans on `main`" concerns the
fork's own `main`, not upstream's. Contributed upstream as a §21.5 extension.

## 4. Success Criteria

- The fork-local `plans/` index + bodies are on `main` and carry the next-number.
- A written workflow exists that a non-main session can follow end-to-end.
- Any session type can determine the next fork-local number without reaching Central.
- The workflow names the Non-Contradiction Check (BL-006) as a required drafting step.

## 5. Test Plan

- **T-1 (structural):** `plans/README.md` on `main` indexes the fork-local line with
  next-number + status; `grep`.
- **T-2 (structural):** the workflow is written in §21.5 (or a referenced location) as an
  explicit numbered procedure; `grep` the steps.
- **T-3 (worked example):** this session's own BL-001..006 are filed under the workflow —
  the session is the acceptance instance.
- **T-4 (behavioral, deferred):** a non-main session (e.g. STAA) consulting `main` derives
  the correct next fork-local number. Deferred to a real non-main session run.

## 6. Risks (per DSM_0.2 §21.2)

- **Duplication / drift between the on-`main` index and the per-BL branches.** *Mitigation:*
  the index on `main` is the source of truth for the line; a BL's implementation branch
  does not re-maintain the index.
- **Fork-local `main` divergence from upstream.** Putting fork-local plans on `main` makes
  the fork's `main` differ from upstream's. *Acceptance:* `dsm-docs/plans/` is already a
  fork-owned surface (BL-002); fork-sync (`git merge upstream/main`, additive) preserves
  it. Guarded by BL-006 (non-contradiction) and the mirror-sync manifest's fork-owned
  classification.
- **Non-main sessions still may not read `main`'s index.** Visibility on `main` is
  necessary but a skill must actually consult it. *Mitigation:* BL-004 + the workflow make
  the consult an explicit step for filing sessions.

## 7. Test Execution Log (per DSM_0.2 §21.3)

Implemented S7 (2026-10-09) on `bl-005-006/fork-governance-cluster` (commit `de1b913`);
BL body + index live on `main` (session-7).

- **T-1 (index on `main`)** — PASS. `plans/README.md` on `main` carries the "Fork-local
  line (§21.5)" header, the BL-001..008 table with status, and the next-fork-local-number
  rule.
- **T-2 (workflow written in §21.5)** — PASS. The five-step workflow is written in §21.5
  as an explicit numbered procedure (`grep` of the five step labels at DSM_0.2 lines
  1700–1707).
- **T-3 (worked example)** — PASS. This session's BL-001..008 are filed under the
  workflow; the session is the acceptance instance.
- **T-4 (non-`main` session derives next number)** — DEFERRED to a real non-`main` run.

### Pending verification

- [ ] T-4 (non-`main` session derives next fork-local number) — deferred to a real
  `/dsm-staa` or parallel-session run; the §21.5 discoverability clause is the mechanism
  to verify.
