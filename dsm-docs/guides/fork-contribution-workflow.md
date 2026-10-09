# Fork-to-Central Contribution Workflow

**Audience:** any session operating this fork (`alberto-passerelle/take-ai-bite`, a kicked-off
local hub cloned from the public DSM mirror).
**Purpose:** a repeatable, clutter-free process for contributing methodology improvements back to
upstream TAB / DSM Central, so the maintainer can review them as an organized set.
**Status:** operational guide (the "how"). The normative rule (the "what/why") is tracked as the
fork-local backlog item for fork-to-Central contribution mechanics; this guide follows that rule
and is updated when it changes.

---

## 1. The Contribution Model: Proposals, Not Merge Requests

Upstream TAB is the public mirror of a private DSM Central. The maintainer **absorbs** accepted
proposals into private Central and releases them as version bumps; a public PR is frequently
**closed unmerged** once absorbed (the portable-date fix, issue #121 / PR #122, resolved this
way). The maintainer also uses explicit "no-merge, for review only" PRs.

The consequence shapes everything below: **our PRs are proposals the maintainer reads and adapts,
not diffs they merge.** "Clean" therefore means *each PR is a self-contained, readable proposal*,
not that it is mergeable. State this expectation in the PR body so there is no back-and-forth about
merge mechanics.

## 2. Packaging a Single Contribution

One PR carries **one methodology concern** and nothing else.

- **Branch off `upstream/main`**, not fork `main`. Name it `feature/<concern>` (upstream
  CONTRIBUTING uses `feature/`, `fix/`, `docs/`, `example/`).
- **Carry only the methodology-file diff** — the two or three `DSM_*` / `scripts/commands/*`
  files the concern touches. Never include fork-local artifacts: no `dsm-docs/plans/` bodies, no
  `BACKLOG-*` files, no fork `CHANGELOG` entries, no `.claude/` session artifacts.
- **Attach the name-free proposal body as a PR comment**, not a committed file — "for Central's
  backlog pipeline; Central assigns the canonical number on absorption." This is the established
  pattern on PRs #125 and #128.
- **Keep fork `main` free of un-reconciled methodology.** Methodology edits live on the held
  `feature/*` (or `bl-NNN/*`) branch until Central absorbs them and they return via the next
  fork-sync. Only the fork-local `plans/` bodies and index live on fork `main`. (See handoff §4.)

A `bl-NNN/*` implementation branch may bundle methodology plus the fork-local body for local work,
but it is **not** the PR branch. Cut a dedicated `feature/*` off `upstream/main` carrying only the
methodology files for the PR.

## 3. Issue First for Non-Trivial Changes

Per upstream CONTRIBUTING, open an issue before a non-trivial PR and link the two (the
#124 -> #125 and #127 -> #128 pattern). The issue states the problem and proposal in the house
style: `**Problem.** ... **Proposed.** ...`, concise, name-free, professional, no decorative
symbols. Trivial fixes (a typo, a portability one-liner) may skip straight to a PR.

## 4. Dependency Ordering and the Open-PR Cadence

Clutter comes from opening PRs faster than Central absorbs them, and from opening a dependent PR
before its base is absorbed.

- **Hold a small open-PR window (<=2-3).** Implemented-but-unsubmitted work waits on held
  branches — the queue — until an open PR resolves.
- **Respect the dependency graph.** Where one concern extends another's section (for example, the
  fork-local workflow extends the fork-local numbering rule), do not submit the dependent PR until
  its base has resolved, or bundle genuinely-coupled concerns into one PR.
- **Atomic for independent concerns; bundle only what is truly one feature.** One self-reviewing
  diff per independent concern; a single PR when two items only make sense together.

## 5. The Tracking Issue Is the Index

Maintain **one** upstream tracking issue listing every open and queued contribution, its section
target, its dependencies, and the cadence rule. It is the anti-clutter keystone: the maintainer
checks one place instead of reconstructing the set from scattered PRs, and each PR body links back
to it. Keep it current as items are submitted, absorbed, or reordered.

- Current tracking issue: **#130** on `albertodiazdurana/take-ai-bite`.

## 6. Branch and Repository Hygiene

- Delete a `feature/*` PR branch (local and remote) once its PR resolves — merged or
  closed-after-absorption.
- Keep remote branches only for currently-open PRs.
- After a fork-sync that brings an absorbed change back into the methodology, delete the held
  `bl-NNN/*` branch whose work it carried; the fork-local `plans/` status moves to reflect it.

## 7. Pre-Submit Checklist

Before opening a PR:

- [ ] Branch is off `upstream/main`; diff is methodology files only (no fork-local artifacts).
- [ ] An upstream issue exists for a non-trivial change, and the PR links it.
- [ ] The name-free proposal body is ready to post as a PR comment.
- [ ] CONTRIBUTING style: no decorative symbols; `WARNING`/`OK`/`ERROR` as text; clear headers.
- [ ] The open-PR window is within cadence (<=2-3); dependencies are resolved or the PR is bundled.
- [ ] The tracking issue (#130) is updated with the new PR.
- [ ] Read-Before-Draft done (CONTRIBUTING + a recent similar PR), per DSM_0.2.D §9.
