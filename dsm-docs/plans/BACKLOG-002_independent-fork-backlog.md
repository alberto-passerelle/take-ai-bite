# BACKLOG-002: Independent Fork-Local Backlog for TAB Forks

**Status:** Implemented (fork-local); upstream contribution pending
**Priority:** Medium
**Date Created:** 2026-10-08
**Origin:** Fork-governance gap surfaced in this session (S6) while routing a downstream spoke proposal (BL-001): a de-identified public fork has no sanctioned backlog of its own.
**Author:** Alberto
**Backlog line:** Fork-local independent numbering (BL-002). This BL defines that line.

---

## 1. Problem

A TAB fork — a clone of the public DSM mirror, including one kicked off as its own
local hub — cannot develop methodology enhancements independently today:

- **BL numbering is Central-owned.** Backlog items and their numbers are assigned in
  the private, off-machine DSM Central. A fork cannot mint a BL without colliding with
  or guessing at Central's line (currently ~579+), which it cannot see.
- **De-identified forks carry no active BL bodies.** On the public mirror,
  `dsm-docs/plans/` is `README` + `done/`, and `done/` is `INDEX`-only. There is no
  place for a fork to author a proposal it wants to develop before (or instead of)
  contributing upstream.

Net effect: a fork that spots a useful enhancement must either push it straight to
Central (not always possible — Central may be off-machine or access-gated) or hold it
informally with no tracking. Independent development is blocked by construction.

This gap is live in this very session: BL-001 (a downstream DP/compliance-briefing
proposal) had nowhere sanctioned to live on the fork until we decided, ad hoc, to open
an independent local line. This BL formalizes that decision as a rule.

## 2. Proposed Rule

**A TAB fork MAY maintain an independent local backlog**, enabling independent
development without waiting on DSM Central:

- **Independent line from BL-001.** The fork authors BLs in its own
  `dsm-docs/plans/` using the standard `BACKLOG-###` format, numbered from **001** in
  the fork's own line. This line is explicitly **fork-local** and distinct from
  Central's; the two are not expected to agree.
- **Fork-local backlogs are first-class.** They use the same template, required fields,
  §21.2 Risks, and Test Plan discipline as Central BLs. `dsm-docs/plans/README.md`
  indexes the fork-local line.
- **Name-free, always.** Because a public fork's `plans/` is public, every fork-local
  BL body MUST be name-free (egress discipline, DSM_0.2.C): no client/mandate/person
  names, no confidential content. Worked instances stay in the (private/gitignored)
  originating project.
- **Upstream contribution is OPTIONAL but RECOMMENDED.** A developed fork-local BL
  SHOULD be offered upstream — a GitHub issue on the public repo plus a cross-fork PR
  carrying the methodology-document changes with the BL attached — so **DSM Central**
  can absorb the change, assign its own canonical number, and reconcile
  de-identification. A fork is free to keep a BL purely local (independence is the
  point); the recommendation is a nudge, not a gate.

## 3. Numbering & Reconciliation

- The fork-local number (`BACKLOG-001`, `-002`, …) is a **local identity**, not a claim
  on Central's namespace.
- On upstream absorption, **Central assigns the canonical number.** The fork-local BL
  records the mapping (e.g. a `**Central BL:**` field added when known), so provenance
  survives the renumber.
- Forks do not coordinate numbering with each other; each fork's line is its own.

## 4. Scope Note (§21 single-topic check)

One topic: the fork-local backlog convention. It is completable as a unit (a rule +
its documentation). It does **not** bundle the DP/compliance-briefing work (BL-001),
which is a separate capability that merely happened to surface the gap.

## 5. Candidate DSM Hook Points (for maintainer evaluation)

Candidate anchors only; final placement is an implementation-design decision confirmed
before editing any methodology file:

- **DSM_7.0 (AI Platform / Fork Collaboration)** — already covers mirror repos, the
  Cloned-Mirror Kick-off, and fork mechanics; natural home for a fork-backlog rule.
- **DSM_0.2 §20 (Branching) or §21 (Backlog Scope/Naming)** — backlog-system rules live
  near here.
- **DSM_0.1 / scaffold** — `plans/` is canonical scaffold; the "fork-local line allowed"
  note could attach to the scaffold definition.
- **Cloned-Mirror Kick-off (DSM_0.2.A §25)** — Kick-off could seed an empty fork-local
  `plans/README.md` and state the convention.
- **Mirror-sync manifest** — ensure a fork's local `plans/BACKLOG-###_*.md` are treated
  as fork-owned (not "orphaned/delete" from Central's POV), the same category-6 logic
  that protects mirror command copies.

## 6. Success Criteria

- The rule is documented in shared methodology, so all forks inherit it.
- A fork can author `dsm-docs/plans/BACKLOG-001+` without violating de-identification
  (name-free requirement stated and enforced by convention).
- Numbering reconciliation on upstream contribution is specified (Central assigns
  canonical number; fork records the mapping).
- The optional-but-recommended contribution path (issue + cross-fork PR + BL attachment)
  is documented.
- Mirror-sync does not flag or delete fork-local BL bodies.

## 7. Test Plan

- **T-1 (structural):** the fork-backlog rule section exists at its chosen hook point;
  `grep` the rule text.
- **T-2 (structural):** all new cross-references resolve (§19 minimum).
- **T-3 (worked example):** this fork's own `dsm-docs/plans/` carries BL-001 and BL-002
  under the new convention and `README.md` indexes them — the session is its own
  acceptance instance.
- **T-4 (behavioral, deferred):** a mirror-sync run does not label fork-local
  `BACKLOG-###_*.md` as orphaned/delete. Untestable without a sync cycle →
  **deferred to the next mirror-sync**; verification plan: run
  `scripts/sync-commands.sh --check` (or the mirror-sync content scanner) and confirm
  fork-local BL bodies are not flagged for deletion.

## 8. Risks (§21.2)

- **Cross-line number collision** — fork-local `BACKLOG-001` and Central's own
  `BACKLOG-001` are different items. *Mitigation:* the number is explicitly fork-local;
  Central reassigns on absorption and the fork records the mapping. Confusion is bounded
  because each line is scoped by repo.
- **Fragmentation** — forks accumulate local BLs that never reach Central, so the
  ecosystem's methodology diverges. *Accepted:* independent development is the feature;
  the "recommended" contribution nudge is the counterweight, not a lock.
- **De-identification leak** — a fork-local BL on a public repo carries mandate/PII
  content. *Mitigation:* name-free requirement is part of the rule; same egress
  discipline already applied to BL-001.
- **Authority confusion** — unclear which backlog is canonical. *Mitigation:* the rule
  states Central remains canonical; fork-local lines are explicitly local and never
  override Central numbering or decisions.
- **Mirror-sync deletion** — a sync treats fork-local BL bodies as orphaned and removes
  them. *Mitigation:* §5 mirror-sync hook point classifies them as fork-owned
  (category-6 analogue); T-4 verifies.

## 9. Open Questions (for maintainer / DSM Central)

- Final hook-point placement (DSM_7.0 vs DSM_0.2 §20/§21 vs scaffold).
- Whether a fork-local BL should carry a visible namespace marker (e.g.
  `BACKLOG-F001`) to make cross-line identity unmistakable, or stay plain `BACKLOG-001`
  with the "fork-local" field as the only signal. (This BL proposes plain numbering;
  the marker is an alternative for the maintainer to weigh.)
- Whether Central wants a registry of fork lines, or treats each contribution ad hoc.

## 10. Contribution Routing

Fork-local BL-002 is implemented on this fork on branch
`bl-002/independent-fork-backlog`. On completion: update `dsm-docs/plans/README.md`,
open a **GitHub issue** on the upstream public repo (`albertodiazdurana/take-ai-bite`)
describing the rule, and open a **cross-fork PR** carrying the methodology-document
change with this BL attached, so **DSM Central** manages final numbering and
integration. Per its own rule (§2), this contribution is recommended — and, because the
rule benefits every fork, worth sending.

## 11. Test Execution Log (S6, 2026-10-08)

Implemented on branch `bl-002/independent-fork-backlog`. Per-item results:

- **T-1 (structural) — PASS.** `### 21.5. Independent Fork-Local Backlog Line` present
  in `DSM_0.2_Custom_Instructions_v1.1.md:1654`; `## 22.` intact at 1703 (addition did
  not clobber the following section).
- **T-2 (structural) — PASS.** Cross-refs resolve: DSM_7.0 §2.1 → §21.5; CHANGELOG →
  §21.5 + DSM_7.0 §2.1; §21.5 → §21.1/§21.2/§21.4, DSM_0.2.A §25, DSM_7.0 §2.1 (all
  targets exist). §21.4 resolver sweep: "Fork-Local Backlog Line" appears only in the
  §21.5 heading and the README row — no dangling reference; edit is additive, no
  renumbering of §22+.
- **T-3 (worked example) — PASS.** `dsm-docs/plans/README.md` indexes BACKLOG-001 and
  BACKLOG-002 under the fork-local line; this session is the acceptance instance.
- **T-4 (behavioral) — DEFERRED + reasoned.** "mirror-sync must not delete fork-local
  BLs." Reasoned-resolved: a fork updates via `git merge upstream/main` (additive), which
  preserved this fork's checkpoints and `.gitignore` guard during the S6 1.27.1 sync, so
  fork-local BL bodies survive the same way. Formal deferral: verify at the next
  fork-sync that `BACKLOG-00{1,2}_*.md` remain after the merge.

Egress (DSM_0.2.C §5.8): §21.5, the CHANGELOG entry, and this log are name-free; no
matched sensitive value echoed. Not yet moved to `done/`: "done" for a fork-local BL is
upstream absorption by Central, which the contribution PR initiates.
