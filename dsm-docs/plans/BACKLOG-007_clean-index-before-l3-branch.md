# BACKLOG-007: Clean Index Before Creating a Level 3 Task Branch

**Status:** Implemented (fork-local, S7); methodology on `bl-007/clean-index-before-l3-branch` (commit `8167a0b`), upstream PR deferred until #125 reconciles
**Priority:** Medium
**Date Created:** 2026-10-09
**Origin:** S7 §22 incident (2026-10-09). The `/dsm-go` boot (Steps 3/3.5) staged the consumed handoff + checkpoint moves on the session branch. A BL implementation then created a Level 3 `bl-004` branch off that session branch **while the index still held those staged moves**, and the first `git commit` on the task branch — which commits the whole index, not only freshly `git add`ed paths — absorbed the two unrelated session-artifact renames into the methodology commit. The methodology branch (destined for an upstream PR) was polluted with session artifacts, and the session branch lost the consumption.
**Author:** Alberto (with AI assistance)

---

## 1. Problem

`/dsm-go` stages session-artifact moves during boot:

- Step 3 annotates + `git mv`s a consumed handoff into `done/`.
- Step 3.5 annotates + `git mv`s a consumed checkpoint into `done/` and restages it.

Both land in the **index** on the session branch. If the next action is a BL implementation,
`CLAUDE.md` directs the agent to create a Level 3 branch (`bl-NNN/*`) as its first action.
`git checkout -b` carries the staged index onto the new branch. The implementer then stages the
BL's own files and commits — but `git commit` commits the **entire** index, so the pre-staged
boot moves ride along into the task commit.

Two bad outcomes, both silent (every command exits 0):

1. The task branch (often a held, upstream-destined methodology branch) carries unrelated
   session artifacts, polluting the eventual PR.
2. The session branch — the correct home for the moves — no longer carries them; switching back
   reverts the consumed files to their loose, un-consumed state.

The `git add <specific files>` the implementer runs does **not** scope the commit; it adds to an
already-dirty index. The gap is that nothing guarantees a clean index before the L3 branch is cut.

## 2. Proposed Behavior

- **Before creating a Level 3 task branch, the session-branch index must be clean of unrelated
  staged changes.** The agent either commits the pending session-artifact moves to the session
  branch first, or confirms the index holds nothing it does not intend to carry onto the task branch.
- Concretely, add to the branching workflow (DSM_0.2 §20.3 / the `/dsm-go`→BL-implementation
  hand-off in `CLAUDE.md`): "The first action on a BL implementation is to create the L3 branch —
  **after** committing or stashing any staged session-artifact moves from boot, so the L3 branch
  starts from a clean index."
- **Candidate enforcement (design to settle in the BL):** a lightweight pre-commit or pre-checkout
  guard that warns when `git checkout -b bl-*` is run with a non-empty, unrelated staged index.
  Scope carefully against false positives (an implementer may legitimately carry staged work).

## 3. Non-Contradiction Check (per BL-006)

This **adds** a precondition to the existing Three-Level Branching Strategy (§20); it does not
change the strategy's levels, naming, or merge conditions. It does not touch the parallel-session
commit-booking model (§26.5 / §7). No upstream rule is contradicted; contributed upstream as a
§20 clarification like any fork-local BL.

## 4. Success Criteria

- The branching workflow states the clean-index precondition before an L3 branch is created.
- A worked example (the S7 incident) is referenced so the failure mode is recognizable.
- If an enforcement guard is added, it warns on the dirty-index-at-`checkout -b` case without
  firing on legitimately-carried staged work.

## 5. Test Plan

- **T-1 (structural):** the §20.3 / `CLAUDE.md` branching text contains the clean-index
  precondition; `grep`.
- **T-2 (behavioral, if a guard is built):** stage an unrelated change, run `git checkout -b
  bl-test`, confirm the guard warns. Deferred until a guard is designed (§21.3 carve-out).
- **T-3 (structural):** §20 levels/naming/merge-conditions unchanged by the addition.

## 6. Risks (per DSM_0.2 §21.2)

- **Over-firing (if a guard is built):** an implementer may intend to carry staged work onto the
  task branch; a hard block would obstruct that. *Mitigation:* warn, do not block; the precondition
  is primarily a prose discipline, not a gate.
- **Ritual compliance:** "index is clean" checked by habit rather than actually, missing the case.
  *Mitigation:* the prose names the specific boot steps (3/3.5) that stage moves, so the check has a
  concrete target rather than a vague "is it clean?".
- **Scope ambiguity with parallel sessions:** parallel sessions share the branch via commit booking
  and do not cut L3 branches (§26.5). *Mitigation:* the precondition is scoped to L3-branch creation,
  which parallel sessions do not perform.

## 7. Test Execution Log (per DSM_0.2 §21.3)

Implemented S7 (2026-10-09) on `bl-007/clean-index-before-l3-branch` (commit `8167a0b`);
BL body + index on `main` (session-7).

- **T-1 (structural, precondition in prose)** — PASS. §20.9 ("Clean Index Before Creating a
  Level 3 Task Branch") added to DSM_0.2 core; §20.3 gains a cross-reference; the
  `.claude/CLAUDE.md.template` BL-implementation hand-off reinforces the precondition.
- **T-2 (behavioral, guard warns)** — PASS. `.claude/hooks/validate-l3-branch-index.sh`
  tested 5 ways in a throwaway repo: `checkout -b bl-*` and `switch -c sprint-*` with a
  dirty index emit the JSON warning at exit 0; a `feature/*` branch, a non-branch command,
  and a clean index are all silent at exit 0. Warns, never blocks.
- **T-3 (structural, §20 unchanged)** — PASS. §20.1–§20.8 headings and the §20.3
  levels/naming/merge-conditions table are unchanged; the only §20.3 edit is the added
  cross-reference.

### Pending verification

- None. All Test Plan items satisfied in-session (T-2's guard was built, so it is not
  deferred).
