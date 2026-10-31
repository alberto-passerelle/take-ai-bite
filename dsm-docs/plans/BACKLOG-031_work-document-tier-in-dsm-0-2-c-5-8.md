# BACKLOG-031: Let a Project Declare That Its Work Documents May Hold the Names the Work Needs (Egress-Zone Tiers in DSM_0.2.C §5.8)

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** DSM_0.2.C §5.8 (the egress-zone paragraph) and the §5.1 `Restricted, protected` row
added by BACKLOG-028.
**Date Created:** 2026-10-31
**Origin:** Inbox entry from a downstream spoke, processed in S28. The spoke tracks work across
projects and needs colleagues' names in plans, checkpoints, handoffs, backlog items and
`MEMORY.md` to assign owners and keep track of agreements. Its organization's rule allows personal
data as far as the task needs it. §5.8 keeps `MEMORY.md` free of all personal data, so the spoke
had to deviate from the core.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-031).
**Related:** BACKLOG-026 (what may cross between spoke and hub; the strict zone below holds those
messages).

---

## Problem Statement

DSM_0.2.C §5.8 L780-783:

> Projects that handle sensitive data treat the worklog, `MEMORY.md`, and the
> reasoning-lessons files as an **egress zone**: local content that can later cross an
> air-gap to the hub (...) and must stay free of personal data.

The rule puts `MEMORY.md` in one zone with the worklog and the reasoning lessons. A project whose
work is tracking people's tasks needs names in its own records: who owns a step, who agreed to
what. Today it can either deviate from §5.8 or keep owners and agreements out of its records.

## Proposed Solution (sketch for Gate 1)

A project-level declaration in `.claude/CLAUDE.md`, off by default, that splits the egress zone
in three:

| Zone | Artifacts | Personal data |
|---|---|---|
| Strict | worklog, reasoning-lessons files, feedback and inbox notes to the hub or Central, text pasted outside a task | none (today's §5.8 rule) |
| Work documents | `MEMORY.md` and memory files, checkpoints, handoffs, decisions, backlog items, plans | the names the work needs, within limits the project states (for example: colleagues only in `MEMORY.md`, because it loads in every session) |
| Task output | output a task sends to an external service | what the task needs |

Fixed limits, whatever a project declares:

- Protected data (§5.1 `Restricted, protected`) stays out of the strict zone and out of the work
  documents. The `Restricted, protected` row then names `MEMORY.md` explicitly, so BACKLOG-028's
  storage sentence keeps its effect when `MEMORY.md` leaves the strict zone.
- The declaration is not available in a repository that is public or synced to a public mirror:
  its tracked work documents ship (DSM_0.2 §21.5 name-free rule, DSM_0.2.C §5.7).
- The project states the limit for `MEMORY.md` in the declaration itself.

Open for Gate 1: the declaration's form, whether §5.8's leak-scan then covers only the strict
zone, and whether `/dsm-go` reports the declaration at boot.

## Success Criteria (draft)

- [ ] §5.8 defines the three zones and the declaration; without the declaration, today's rule
  applies unchanged.
- [ ] §5.8 states the protected-data limit and the public-repository exclusion.
- [ ] The `Restricted, protected` row keeps protected data out of `MEMORY.md` when the declaration
  is set.
- [ ] No section is added, removed or renumbered.

## Test Plan (draft)

- [ ] T-1: `git diff upstream/main -- DSM_0.2.C_Security_Safety.md` shows additions in §5.8 and
  one changed sentence in the §5.1 row.
- [ ] T-2: anchored grep finds the zone table, the declaration and each fixed limit (one hit
  each).
- [ ] T-3: the heading list (`grep -nE '^#{2,4} '`) is identical before and after.
- [ ] T-4: §21.4 sweep for the egress-zone wording across `DSM_*.md`, `scripts/commands/*.md` and
  `dsm-docs/`, including the steps §5.8 cites (`/dsm-staa` Step 8b, `/dsm-go` Step 1.5); each hit
  classified as deliberate or stale.
- [ ] T-5: `git merge-tree --write-tree --name-only HEAD upstream/main` reports no conflict on
  DSM_0.2.C.
- [ ] T-6: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **Declaration used to justify names in a public repository:** mitigation: the exclusion is part
  of the rule, and T-2 checks it.
- **`MEMORY.md` spans mandates:** names from one mandate reach every later session. Mitigation:
  the declaration must state the `MEMORY.md` limit; without it the strict rule applies.
- **BACKLOG-028's storage sentence loses its effect for `MEMORY.md`:** mitigation: success
  criterion 3.
- **Leak-scan flags allowed names:** a scan over the work documents would report every declared
  name. Open question for Gate 1; until it is answered, the scan covers the strict zone only.
- **Fork-sync conflict with §5.8:** Central's text wins and the fork re-applies (DSM_0.2 §21.5).

## Upstream Contribution

Offer to Central as an issue plus a PR carrying the DSM_0.2.C change (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
