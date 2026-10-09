# BACKLOG-006: Fork Non-Contradiction and Free-Contribution Principle

**Status:** Implemented (fork-local, S7); methodology on `bl-005-006/fork-governance-cluster` (commit `6110aee`), upstream PR deferred until #125 reconciles
**Priority:** Medium
**Date Created:** 2026-10-09
**Origin:** User directive (S6, 2026-10-09): "fork additions must never contradict main TAB; forks are allowed to contribute without building restrictions — analyze this rule and make it a BL." Generalizes BL-002's "Central stays canonical" clause into a full governing principle.
**Author:** Alberto (with AI assistance)

---

## 1. Problem

The fork↔upstream relationship is governed only piecemeal: BL-002 (§21.5) says the
fork-local numbering line "never overrides Central's numbering or decisions," but there
is no stated **general principle** covering fork-local additions beyond numbering. As the
fork accumulates independent work (BL-001..005, methodology proposals), two failure modes
open up without a principle:

- **Silent divergence:** a fork-local addition could contradict an upstream rule and sit
  on the fork's `main`, so the fork and upstream drift into incompatible methodology —
  caught only at the next fork-sync, as a conflict, long after the fact.
- **Over-restriction:** an over-cautious reading of "don't diverge" could discourage the
  fork from developing or contributing at all, defeating the point of the independent
  fork-local backlog (BL-002).

Both are live tensions in this very session.

## 2. Proposed Principle

**(a) Non-contradiction.** A fork-local addition MUST NEVER contradict upstream TAB
methodology. It may **add** (a new section, a new rule, a template) or **propose a
change** (via a contribution), but it may not place on the fork's `main` a rule that
conflicts with an existing upstream rule. Upstream is canonical; on conflict the fork
reconciles toward upstream.

**(b) Free contribution.** Forks are free to draft, track, implement, and contribute
without building restrictions. No gate blocks a fork from developing a BL or opening a
contribution. The independent fork-local backlog (BL-002) is the sanctioned vehicle; its
use is encouraged, not rationed.

**(c) Reconciliation on conflict.** Where a fork-local addition and a later upstream
change collide, upstream wins the base and the fork re-expresses its addition on top (or
drops it). Fork-sync (`git merge upstream/main`, additive) is the mechanism; BL-005's
visibility rule keeps the fork's additions auditable.

## 3. Analysis (what "contradiction" means — the rule's edges)

The user asked to *analyze* this rule, not just state it. The load-bearing distinction:

| Fork change | Non-contradicting? | Why |
|-------------|--------------------|-----|
| **Additive** — new §, new template, new BL body | Yes | Adds surface; removes/overrides nothing upstream |
| **Proposed change** — a cross-fork PR altering an upstream rule | Yes | Changes upstream *by consent* (merge), not by fork-only divergence |
| **Fork-only override** — fork's `main` carries a rule that negates an upstream rule, un-contributed | **No** | This is the prohibited case: the fork silently behaves differently from upstream |
| **Divergent interpretation** — same rule, fork reads it incompatibly | **Grey** | Resolve by surfacing to the methodology owner; do not encode a private reading |

So "never contradict" is **not** "never change upstream" — a fork changing upstream
through a PR is contribution, which (b) explicitly protects. It is "never carry a
fork-only rule that conflicts with upstream and is not on a path to reconciliation."

**Free contribution vs non-contradiction are not in tension once (a) is read correctly:**
(a) bounds the fork's **private divergence**; (b) protects the fork's **contribution
throughput**. A fork may propose anything upstream (b); it may not unilaterally diverge
(a).

## 4. Enforcement (lightweight, not a blocker)

- **Drafting-time check.** Every fork-local BL carries a **Non-Contradiction Check**
  section (already applied to BL-003/004/005 this session): name what upstream rule the
  change touches and assert additive / proposed-change / reconciling, never fork-only
  override. Same shape as §21.2 Risks — a forcing prompt, not a gate.
- **No new hard gate.** Per (b), enforcement is a review discipline, not a build
  restriction. Reuse §21.4 (resolver sweep) at implementation to catch an accidental
  contradiction.
- **Reconciliation at sync.** The fork-sync merge surfaces real conflicts; (c) says
  upstream wins the base.

## 5. Non-Contradiction Check (self-applied)

This BL **is** the non-contradiction rule; it is self-consistent and generalizes BL-002's
existing "Central canonical" clause (an extension, not a conflict). It adds no restriction
on contribution — it protects it (clause b). Contributed upstream as a §21.5 / fork-governance
addition.

## 6. Success Criteria

- A stated principle in shared methodology covering (a) non-contradiction, (b) free
  contribution, (c) reconciliation on conflict.
- The drafting-time Non-Contradiction Check is defined as a required fork-local BL section.
- The principle is explicit that contributing a change upstream is NOT a contradiction.
- No new hard gate on fork development/contribution is introduced.

## 7. Test Plan

- **T-1 (structural):** the principle (a/b/c) is written in §21.5 (or a referenced
  fork-governance location); `grep` all three clauses.
- **T-2 (structural):** the Non-Contradiction Check is named as a required fork-local BL
  section (cross-ref from BL-005's workflow); `grep`.
- **T-3 (worked example):** BL-003/004/005 each carry a Non-Contradiction Check — the
  session is the acceptance instance.

## 8. Risks (per DSM_0.2 §21.2)

- **Principle too abstract to apply.** A bare "don't contradict" invites the grey-case
  confusion. *Mitigation:* §3's table makes the additive / proposed-change / override /
  interpretation distinction concrete.
- **Check becomes ritual.** A Non-Contradiction Check that always says "additive, no
  conflict" satisfies the form without engagement (same anti-pattern as §21.2 "Risks: none
  known"). *Mitigation:* require naming the specific upstream rule touched, not a blanket
  assertion.
- **Perceived as a restriction despite clause (b).** *Mitigation:* (b) and §4 state
  explicitly that enforcement is review discipline, never a build gate.

## 9. Test Execution Log (per DSM_0.2 §21.3)

Implemented S7 (2026-10-09) on `bl-005-006/fork-governance-cluster` (commit `6110aee`);
§21.6 added to DSM_0.2 core (between §21.5 and §22).

- **T-1 (clauses a/b/c in §21.6)** — PASS. (a) Non-contradiction, (b) Free contribution,
  and (c) Reconciliation on conflict are all written as labeled clauses in §21.6 (DSM_0.2
  lines 1742 / 1750 / 1756).
- **T-2 (Non-Contradiction Check named as required section)** — PASS. §21.6 defines the
  Check; §21.5's workflow step 2 and its Cross-references both require it.
- **T-3 (worked example)** — PASS. BL-003/004/005 each carry a Non-Contradiction Check
  block (1 / 1 / 3 occurrences).

### Pending verification

- None. All Test Plan items satisfied in-session.
