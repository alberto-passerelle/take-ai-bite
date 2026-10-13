# BACKLOG-003: /dsm-go boot plan displaced into prior session's transcript archive

**Status:** Implemented (fork-local, S11); methodology on `bl-003/boot-plan-transcript-displacement`; upstream issue #142 filed (2026-10-13); PR pending (window 3/3)
**Priority:** Low
**Date Created:** 2026-10-09
**Origin:** Surfaced by a concurrent STAA session (S5-STAA analysis, 2026-10-09, Finding 3) while analyzing `.claude/transcripts/2026-10-07T10:31-ST.md`. Originally filed by that session as provisional Central-style `BACKLOG-580`; renumbered into the fork-local line (BL-003) per DSM_0.2 §21.5.
**Author:** Alberto (with AI assistance)
**Renumbered from:** BACKLOG-580 (provisional Central number; the authoring session could not see the fork-local line because its artifacts were on unmerged branches — see BL-005).

---

## Problem Statement

§7 (Worklog Protocol) mandates that the plan append be the **first tool
call** of a turn, enforced by the `UserPromptSubmit` per-turn reminder hook and the
`validate-transcript-edit.sh` occurrence check. `/dsm-go` Step 5.5 archives the live
`.claude/worklog.md` to `.claude/transcripts/{start-ts}-ST.md`, and Step 6
resets the live file with a fresh session header.

When `/dsm-go` runs, these two rules collide on ordering. The §7 hook fires at the
start of the boot turn, so the agent appends the boot plan block to the **live**
worklog before Steps 5.5/6 execute. The archive (Step 5.5) then captures a file
that already contains the next session's boot plan, and the reset (Step 6) overwrites
the live file — so the boot plan is **absent** from the fresh current-session
worklog and **present** at the tail of the **previous** session's archive.

**Evidence:** `.claude/transcripts/2026-10-07T10:31-ST.md` is the Session 5 archive.
After its final `Session 5 closed.` output block, it carries an `<------------Start
Plan / 10:47------------>` block that is unmistakably the **Session 6** `/dsm-go` boot
plan ("GIT_AVAILABLE=true. Running the session-start sequence..."). This reproduced
again in Session 6 itself (its own boot plan is in the Session 5 archive).

**Effect:**
1. Each session's boot reasoning is systematically filed under the **previous**
   session's archive (archive-boundary bleed).
2. The current session's fresh worklog lacks its own boot-plan reasoning.
3. STAA selects subjects by archive and parses the `# Session N` header; boot reasoning
   for session N therefore appears inside session N-1's archived file and is
   effectively mis-attributed or missed. This is the STAA-facing cost and the reason
   the observation was surfaced during an STAA run.

## Proposed Solution

First **confirm the behavior is unintended** with the methodology owner (it may be a
deliberate "bridge entry"). If unintended, candidate directions (design to be settled
in the BL, not pre-committed here):

- **A — Reorder + hook carve-out:** run Step 5.5 (archive) + Step 6 (reset) *before*
  the first boot-plan append, and add a `/dsm-go`-boot exception to the §7
  `UserPromptSubmit`/occurrence hook so the archive/reset Bash calls are not flagged as
  "work before the plan append."
- **B — Reset writes the plan:** have Step 6 emit the boot-plan block into the fresh
  worklog as part of the reset, so the plan lands in the correct file by
  construction and the hook sees the append within the turn.
- **C — Document as intended:** if the bridge-entry behavior is wanted, codify it as a
  convention and make STAA subject-selection account for next-session boot bleed at the
  archive tail.

This is cross-referenced to §23 (Skill/Hook Collaboration), which explicitly tracks the
hook/skill collision surface; this is a concrete instance.

## Non-Contradiction Check (per BL-006)

This BL proposes a *candidate fix* to an existing §7/§25 ordering collision; it does not
contradict any upstream TAB rule. Success Criteria gates implementation on confirming
intent with the methodology owner first, so a wanted behavior is never silently removed.
The fix, if adopted, is contributed upstream like any fork-local BL — it changes shared
methodology by proposal, not by fork-only divergence.

## Success Criteria

- [ ] The behavior is confirmed intended or unintended with the methodology owner before any code change
- [ ] If unintended: a `/dsm-go` boot's plan block lands in the **current** session's fresh worklog
- [ ] If unintended: the just-archived prior worklog contains no next-session boot-plan bleed
- [ ] The §7 occurrence hook raises no false violation from the chosen fix (the plan append still occurs within the boot turn)
- [ ] STAA subject-selection and parsing remain correct under the chosen resolution

## Test Plan

Conditions that must pass before the implementing branch merges:

- [ ] Run `/dsm-go`; confirm the fresh `.claude/worklog.md` contains the boot-plan block (grep the boot-plan signature in the live file)
- [ ] Confirm the just-archived prior worklog (`.claude/transcripts/{prev}-ST.md`) does **not** contain the new boot-plan block
- [ ] Confirm `validate-transcript-edit.sh` and the `UserPromptSubmit` occurrence check pass on the boot turn with no violation (behavioral run, capture output — §19.1)
- [ ] Confirm an STAA run on the new session sees that session's boot reasoning in its own archive

## Risks (per DSM_0.2 §21.2)

- **Hook false-violation from reordering:** moving archive/reset ahead of the plan append may trip the §7 "plan must be the first tool call" occurrence check. *Mitigation:* the fix must carve a boot-turn hook exception or fold the plan into Step 6's reset (direction B); this design dependency is exactly why this is a BL, not an inline fix.
- **High blast radius, low benefit:** the change touches the boot hot-path (§7 hook + `/dsm-go` Steps 5.5/6), shared by every session across every DSM project via the `@`/mirror chain. A regression silently breaks worklog occurrence for all projects. *Acceptance:* keep Priority Low; schedule only with a §19.1 behavioral test on the hook and the branch-testing minimum (§19).
- **Behavior may be intended:** the boot plan may be a deliberate bridge entry. *Mitigation:* Success Criteria gates implementation on confirming intent first.
- **Implementation touches untracked deployed copies:** a fix to `scripts/commands/dsm-go.md` requires `scripts/sync-commands.sh --deploy` to refresh the untracked global copy in `~/.claude/commands/`. *Mitigation:* implementer follows the Revert Safeguards Protocol and the command-file sync step.

## Test Execution Log (per DSM_0.2 §21.3)

**Implemented S11** on `bl-003/boot-plan-transcript-displacement`. Methodology owner confirmed
the displacement is **unintended** and chose **direction B** (Step 6 owns the boot-plan append;
no §7 hook change). Three additive insertions: a new "Boot-Turn Transcript Guard" at the top of
`scripts/commands/dsm-go.md`, a one-sentence reinforcement in its Step 6, and a "Boot-turn
exception" paragraph in DSM_0.2 §7. Purely additive (32 insertions, 0 deletions).

Structural / mechanism tests (run this session, evidence captured):

- **S-1 (guard present) — PASS.** `grep -c '^## Boot-Turn Transcript Guard'` = 1 in the source,
  = 1 in the user-level runtime (`~/.claude/commands/dsm-go.md`, refreshed by
  `sync-commands.sh --deploy`), = 1 in the tracked project-level bootstrap copy
  (`.claude/commands/dsm-go.md`, synced from source; `diff` source↔copy IDENTICAL).
- **S-2 (Step-6 reinforcement) — PASS.** `grep -c 'deferred boot-plan block named by the Boot-Turn'` = 1.
- **S-3 (§7 exception) — PASS.** `grep -c 'Boot-turn exception'` on DSM_0.2 core = 1.
- **X-ref — PASS.** dsm-go.md guard → "DSM_0.2 §7 boot-turn exception" resolves; §7 exception →
  "`/dsm-go` Step 6" / "Step 5.5" resolve.
- **§21.4 resolver sweep — EMPTY (recorded).** Change renamed/removed no string, so the
  removed-string sweep has nothing to run; `git diff` shows insertions only.
- **§19.1 (would a wrong result look different) — PASS.** Each structural grep returns 1 when the
  text is present and would return 0 if absent; the patterns are literal strings just written, so
  a broken pattern and a missing insertion are distinguishable.

Behavioral Test Plan items:

- **T-2 (prior archive carries no next-session boot plan) — PASS this boot.** The S10 archive
  `.claude/transcripts/2026-10-12T08:12-ST.md` contains **0** S11 markers (last header line
  `# Session 10 Transcript`). No bleed occurred on the S11 boot.
- **T-1 (fresh transcript carries the boot plan) — PASS this boot (partial).** The live S11
  transcript contains the boot-plan block (1 occurrence).
- **T-3 (no §7 occurrence false-violation) — PASS this boot.** Occurrence was satisfied by the
  Step-6 append within the boot turn; the §7 hook was not modified (direction B), so no new
  false-violation surface was introduced.

**Honesty note (Earn Your Assertions).** The S11 boot that produced T-1/T-2/T-3 evidence ran
under the **pre-fix** skill — the correct outcome came from the agent already following the
direction-B discipline manually, not from the new guard text being active. So this session proves
that *direction B produces the right outcome*, and that the mechanism is structurally in place; it
does **not** yet prove the new guard text causes a less-disciplined boot to defer. That end-to-end
test requires a boot under the updated skill.

### Pending verification

- [ ] **T-1 / T-3 (end-to-end behavioral):** next `/dsm-go` boot runs under the updated skill —
  confirm the fresh transcript holds the boot plan and `validate-transcript-edit.sh` +
  `UserPromptSubmit` raise no violation. §21.3 untestable-by-design this session (cannot re-run a
  boot mid-session).
- [ ] **T-4 (STAA attribution):** an STAA run on a post-fix session sees that session's boot
  reasoning in its own archive, not the prior one. Deferred (needs a next session + `/dsm-staa`).
- [ ] **Upstream contribution:** deferred until the open-PR window (≤2-3) frees; then cut a
  `feature/*` off `upstream/main` carrying only the `scripts/commands/dsm-go.md` +
  `DSM_0.2_Custom_Instructions_v1.1.md` diff (de-forked), open issue + no-merge PR + name-free
  comment, and add BL-003 to tracking issue #130's Queued list.
