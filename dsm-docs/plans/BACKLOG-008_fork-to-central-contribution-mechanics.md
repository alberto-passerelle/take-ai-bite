# BACKLOG-008: Fork-to-Central Contribution Mechanics

**Status:** Proposed
**Priority:** Medium
**Date Created:** 2026-10-09
**Origin:** S7. The fork has been contributing methodology upstream (PRs #125, #128; the portable-date fix #122 before them) using a consistent packaging-and-cadence process, but that process is captured nowhere in the methodology — it is tribal knowledge carried in handoffs and session memory. A gap check this session confirmed it: `§21.5` (the fork-local backlog line) does not yet exist in core methodology (it is proposed, as PR #125), and a search for any fork-to-Central contribution-routing protocol returned nothing. The existing external-contribution docs (DSM_3.0.C/D/E, DSM_0.2.D) govern contributing to *other* repos, not a DSM fork contributing methodology *back* to Central.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-008).

---

## 1. Problem

A DSM fork (a clone of the public mirror, including one promoted to a local hub by the
Cloned-Mirror Kick-off) that develops a methodology improvement has no formalized way to
contribute it back to Central. The practice exists and works, but it is unwritten:

- **The contribution shape is undocumented.** One concern per PR, branched off `upstream/main`,
  carrying only the methodology-file diff, with the name-free proposal body attached as a PR
  comment for Central's pipeline. This is what PRs #125/#128 do, learned by imitation.
- **The review model is implicit.** Central absorbs accepted proposals into a private repository
  and releases them as version bumps; a public PR is frequently closed unmerged once absorbed
  (issue #121 / PR #122). A contributor who does not know this reads a closed-unmerged PR as a
  rejection.
- **Nothing governs cadence or ordering.** Without a stated open-PR window and a dependency rule,
  a fork can stack interdependent PRs faster than Central absorbs them, producing exactly the
  clutter the maintainer must then untangle.
- **Related fork-governance pieces are partial.** `§21.5` (BL-002) covers fork-local *numbering*;
  BL-005 covers the fork-local BL *workflow*; BL-006 covers the non-contradiction *principle*.
  None covers the *contribution mechanics* — how a finished fork-local item becomes a clean,
  reviewable upstream proposal.

## 2. Proposed Behavior

Add a methodology subsection — proposed home **`§21.6` "Fork-to-Central Contribution Mechanics"**
in DSM_0.2 core, continuing the fork-governance cluster begun by the proposed `§21.5` — codifying:

- **Proposals, not merge requests.** A fork PR is a proposal Central absorbs and may close
  unmerged; the PR body states this so a closed-unmerged outcome is not read as rejection.
- **One concern per PR**, branched off `upstream/main`, carrying only the methodology-file diff —
  never fork-local artifacts (`plans/` bodies, `BACKLOG-*` files, fork `CHANGELOG` entries,
  `.claude/` session artifacts). The name-free proposal body is attached as a **PR comment**.
- **Issue-first** for non-trivial changes, per upstream CONTRIBUTING, with the PR linking the issue.
- **Cadence and ordering.** A small open-PR window (default <=2-3) matched to Central's absorption
  rate; dependent PRs wait on their base, or genuinely-coupled concerns are bundled into one PR.
- **One tracking issue as the index** of open and queued contributions, their section targets,
  dependencies, and status — the single place the maintainer reviews the set.
- **Branch and fork-main hygiene.** Delete a PR branch when its PR resolves; keep fork `main` free
  of un-reconciled methodology (methodology arrives back via fork-sync after Central absorbs).

**Division of labor.** The operational "how" already lives in the fork-local guide
`dsm-docs/guides/fork-contribution-workflow.md` (S7). This BL makes the rule normative (the
"what/why") so it is discoverable to any fork, not only this one, and can be absorbed into Central.

**Placement is a design decision to settle at implementation.** Primary candidate is `§21.6`
(clusters with `§21.5`, single absorbable PR). Alternative: a "Fork Contributor" participation
pattern in `DSM_3.0.E` (DSM_3.0.E currently has no fork pattern; "fork" appears there once in
passing). If `§21.6` is chosen, add a one-line cross-reference from the DSM_3.0.E pattern list.

## 3. Non-Contradiction Check (per BL-006)

**Additive.** It introduces no rule that conflicts with upstream methodology. It does not alter
`§21.1`-`§21.4`, and it does not touch the external-contribution protocols (DSM_3.0.C/D/E,
DSM_0.2.D §9), which govern contributing to *other* maintained repos — a different direction from
a DSM fork contributing *back* to Central. It complements the proposed `§21.5` (numbering),
BL-005 (workflow), and BL-006 (principle) rather than overlapping them. It is itself contributed
upstream via the very process it documents.

## 4. Success Criteria

- A methodology subsection states the contribution shape, the proposals-not-merges model, the
  cadence/ordering rule, the tracking-issue requirement, and the branch/fork-main hygiene.
- The rule is discoverable to any fork (not dependent on this fork's handoffs/guide).
- The fork-local guide is named as the operational companion and stays consistent with the rule.
- The rule names its direction explicitly (DSM fork -> Central), distinguishing it from the
  external-contribution protocols.

## 5. Test Plan

- **T-1 (structural):** the new subsection exists at the chosen location and contains the five
  codified elements (shape, model, cadence, tracking issue, hygiene); `grep`.
- **T-2 (structural):** `§21.1`-`§21.4` and DSM_3.0.C/D/E/DSM_0.2.D §9 are unchanged by the
  addition; `git diff` scoped to the intended files only.
- **T-3 (consistency):** the fork-local guide's section list and the new subsection do not
  contradict each other (same shape, model, cadence, hygiene).
- **T-4 (cross-reference, if `§21.6` chosen):** the DSM_3.0.E participation-pattern list gains the
  one-line fork-contributor cross-reference.

## 6. Risks (per DSM_0.2 §21.2)

- **Placement churn.** Choosing `§21.6` then later preferring a DSM_3.0.E pattern would move the
  rule and break cross-references. *Mitigation:* the placement decision is made explicitly at
  implementation, with the alternative recorded here; the guide (operational) is placement-stable
  regardless.
- **Duplication with BL-005/006.** The workflow (005), principle (006), and mechanics (008) could
  blur. *Mitigation:* §2 states the division of labor (numbering / workflow / principle /
  contribution mechanics); if they prove inseparable at implementation, apply the §21 scope test
  and consider bundling the upstream PRs rather than merging the BLs.
- **Guide/rule drift.** The operational guide and the normative rule could diverge over time.
  *Mitigation:* the guide names the rule as its source and is updated when the rule changes; T-3
  checks consistency at implementation.
- **Over-specification.** Hard-coding "<=2-3 open PRs" could be wrong for a different fork or a
  different maintainer tempo. *Mitigation:* state it as a default window, not a fixed limit, and
  tie it to "Central's absorption rate" rather than an absolute number.

## 7. Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, not implemented)
