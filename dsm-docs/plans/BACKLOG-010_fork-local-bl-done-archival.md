# BACKLOG-010: Fork-Local BL Done-Criterion and Archival Step (§21.5)

**Status:** Implemented (fork-local, S11); methodology on `bl-010/fork-local-bl-done-archival`; upstream PR queued (open-PR window 3/3)
**Priority:** Medium
**Date Created:** 2026-10-13
**Origin:** S11. Organizing `dsm-docs/plans/` surfaced that absorbed fork-local BLs (BL-001, BL-002 — upstream PRs #128/#125 closed) sat in `plans/` with stale "upstream contribution pending" status and were never archived. §21.5 defined the fork-local active line and the Central-number mapping on absorption, but never wired the archival step: no done-criterion, no archival destination, and no handling for the inherited `plans/done/INDEX.md` being Central's namespace (its `BACKLOG-001` ≠ the fork's). The generic `/dsm-backlog-done` skill assumes a single namespace and would collide fork `BACKLOG-NNN` with Central `BACKLOG-NNN`.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-010).

---

## 1. Problem

A fork-local BL has a two-stage lifecycle the standard DSM backlog protocol does not model:
fork-implementation, then upstream contribution. The standard "Implemented → `done/`" rule
(CLAUDE.md Backlog System + `/dsm-backlog-done`) assumes implementation == completion. For a
fork BL these diverge, and §21.5 never stated which stage is "done" or how to archive, so:

- **No done-criterion.** Sessions set `Implemented (fork-local)` in place and never archive,
  because "when is a fork BL done" is undefined.
- **No archival destination that avoids a namespace collision.** `plans/done/INDEX.md` is
  Central's inherited namespace; a fork row would collide with a Central row of the same number.
- **Absorbed BLs go stale.** BL-001/002 were absorbed (PRs #128/#125 closed; back on `main` via
  fork-sync as Central BL-582/583 and BL-581) yet kept "upstream contribution pending".

## 2. Proposed Behavior

Add a **"Done and archival"** bullet to DSM_0.2 §21.5 and a self-contained reconciliation step
to `dsm-docs/guides/fork-contribution-workflow.md` §6:

- **Done-criterion:** a fork-local BL is done when its upstream contribution resolves (reference
  PR closed/absorbed, change back via fork-sync, held `bl-NNN` branch retired per §20.4) — or
  when the fork deliberately keeps it local-only and its local work is complete.
  Fork-*implementation* alone is not done; in-flight BLs stay in `plans/`.
- **Archival destination:** status → `Done (fork-local) — absorbed as Central BL-NNN (§X, vY.Z)`,
  record a `**Central BL:**` mapping, mark the `plans/README.md` row Done, move the name-free
  body to `dsm-docs/plans/done/`.
- **INDEX-collision rule:** do **not** add the fork BL to `plans/done/INDEX.md` (Central's
  namespace); the absorbed change already appears there under its Central number via the sync.
  The fork README row + the `Central BL:` field are the fork-side done record.

## 3. Non-Contradiction Check (per BL-006)

Additive. It extends the fork-local line's own lifecycle (§21.5) and introduces no rule that
conflicts with upstream methodology. It references the proposed §21.6 (BL-008, contribution
mechanics / branch hygiene) for the held-branch retirement half without duplicating it (§21
scope): BL-010 governs the fork-local BL *record's* archival; BL-008 governs the *contribution
mechanics*. It is itself contributed upstream via the process it documents.

## 4. Success Criteria

- §21.5 states the done-criterion, the archival destination (status + Central-BL mapping + README
  row + body to `done/`), and the do-not-add-to-Central-`INDEX.md` rule.
- The fork guide §6 carries a self-contained reconciliation step (no dangling dependency on a
  §21.5 bullet not yet on `main`).
- The two absorbed BLs (BL-001/002) are archived per the rule, demonstrating it.

## 5. Test Plan

- **T-1 (structural):** §21.5 contains the "Done and archival" bullet with the four elements
  (done-criterion, destination, Central-BL mapping, INDEX rule); `grep`.
- **T-2 (structural):** guide §6 contains the reconciliation step and is self-contained; `grep`.
- **T-3 (demonstration):** BL-001/002 bodies are in `plans/done/`, status Done with `Central BL:`
  mapping, README rows marked Done, and absent from `plans/done/INDEX.md`.
- **T-4 (§21.4 sweep):** the §21.5 and guide edits are additive (no string removed/renamed).

## 6. Risks (per DSM_0.2 §21.2)

- **Overlap with BL-008 (§21.6 branch hygiene).** *Mitigation:* BL-010 is scoped to the
  fork-local BL record's archival and references BL-008 for branch retirement; distinct topics.
- **README bloat from retained Done rows.** *Mitigation:* Done rows carry the Central mapping and
  serve as the fork-side done index; split into Active/Done tables later if it grows.
- **Relaxes §21.5's "INDEX-only done/".** The fork `done/` now carries name-free fork bodies.
  *Acceptance:* the bodies are name-free (public-safe); the bullet makes body-to-`done/` explicit.
- **Done-criterion leaves in-flight BLs in `plans/`.** *Acceptance:* intended — an open
  contribution should stay visible as active, not be marked done at implementation.

## 7. Test Execution Log (per DSM_0.2 §21.3)

**Implemented S11.** §21.5 "Done and archival" bullet on `bl-010/fork-local-bl-done-archival`;
guide §6 reconciliation + BL-001/002 archival on the session branch.

- **T-1 (structural) — PASS.** `grep -c '^- \*\*Done and archival\.\*\*'` on DSM_0.2 §21.5 = 1;
  the done-criterion clause ("implementation ... alone is **not** done", line 1698), the
  destination clause, and the "Do **not** add the fork BL to `plans/done/INDEX.md`" clause all
  present. (§19.1 note: an initial `grep` of the done-criterion clause returned 0 from a
  markdown-asterisk escaping artifact, not an absent string — verified present with a loose
  `grep 'alone is'`.)
- **T-2 (structural) — PASS.** `fork-contribution-workflow.md` §6 carries the expanded
  reconciliation bullet (status → Done, Central-BL mapping, README row, body to `done/`, do-not-
  add-to-INDEX), self-contained with a parenthetical pointer to §21.5 as the normative rule.
- **T-3 (demonstration) — PASS.** `plans/done/` holds `BACKLOG-001_*.md` + `BACKLOG-002_*.md`
  (bodies), each status `Done (fork-local) — absorbed...` with a `**Central BL:**` field (582/583,
  581); README rows marked Done; neither added to `plans/done/INDEX.md` (which still carries only
  Central 581/582/583 via sync). Commit `e47c5fe`.
- **T-4 (§21.4 sweep) — PASS / EMPTY.** The §21.5 edit is additive (`git diff --stat`: 17
  insertions, 0 deletions); the guide edit replaces one vague bullet with an expanded one (no
  identifier removed/renamed). No removed-or-renamed string to sweep.

### Pending verification

- [ ] **Behavioral reconciliation at next fork-sync:** when a currently in-flight fork BL
  (003/004/005/006/007/009) is absorbed, the §21.5 + guide §6 rule archives it correctly.
  §21.3 untestable-by-design this session (no absorption pending). The BL-001/002 archival is the
  demonstration proxy.
- [ ] **Upstream contribution:** deferred until the open-PR window (≤2-3) frees; then cut a
  `feature/*` off `upstream/main` carrying only the `DSM_0.2_Custom_Instructions_v1.1.md` §21.5
  diff (de-forked), open issue + no-merge PR + name-free comment, add to tracking issue #130.
