# BACKLOG-039: Let /dsm-new-spoke Copy a Hub's "Portfolio Not Applicable" Record Instead of Writing a Placeholder Row

**Status:** Proposed (Gate 1 open)
**Priority:** Low
**Extends:** `scripts/commands/dsm-new-spoke.md` step 5; DSM_0.2 §18 (Ecosystem Path Registry).
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. Its hub had recorded that a
portfolio does not apply; the new spoke still got a `portfolio` placeholder row.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-039).

---

## Problem Statement

`scripts/commands/dsm-new-spoke.md` L37:

> If `{HUB}/.claude/dsm-ecosystem.md` has a `portfolio` row, copy its path; otherwise write a `portfolio` placeholder row for the user to fill.

The step knows two cases. A hub that has decided a portfolio does not apply has no way to say so
that the step reads, so every new spoke gets a placeholder the user has to remove or explain. DSM_0.2
§18 makes `portfolio` a required entry for every project ("Required for all project types", L688),
so there is no sanctioned "not applicable" form today.

## Proposed Solution (sketch for Gate 1)

- DSM_0.2 §18: a sanctioned way to record "portfolio not applicable" (for example a `portfolio` row
  whose Path is `n/a` with a reason), which `/dsm-go` Step 2a.5 does not validate as a path.
- Step 5: when the hub's row carries that record, copy it instead of writing a placeholder.

Open for Gate 1: the record's form; whether §18's "required" wording changes or the record counts as
the required entry.

## Success Criteria (draft)

- [ ] A hub with the record produces a spoke with the same record; a hub with a path or no row
  behaves as before.
- [ ] `/dsm-go` Step 2a.5 does not warn about the record.
- [ ] §18 states the record.

## Test Plan (draft)

- [ ] T-1: scratch hub registries (path, record, no row): step 5 output for each.
- [ ] T-2: Step 2a.5 run against a registry with the record: no warning.
- [ ] T-3: §21.4 sweep for other readers of the `portfolio` row (wrap-up notifications, DSM_0.2.A).
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` on the changed files.
- [ ] T-5: egress sweep of the diff and the commit message, counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **Other readers of the `portfolio` row treat the record as a path:** mitigation: T-3 finds them;
  each skips the record.
- **Changing a core-file rule (§18) for a low-priority case:** mitigation: keep the change to one
  sentence; Gate 1 may choose a skill-only fix.
- **Upstream drift:** mitigation: send the change upstream.

## Upstream Contribution

Offer to Central as an issue plus a PR (DSM_0.2 §21.5), when a PR slot is free.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
