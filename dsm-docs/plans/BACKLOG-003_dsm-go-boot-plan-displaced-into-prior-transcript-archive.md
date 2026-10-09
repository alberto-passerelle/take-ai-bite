# BACKLOG-003: /dsm-go boot plan displaced into prior session's transcript archive

**Status:** Proposed
**Priority:** Low
**Date Created:** 2026-10-09
**Origin:** Surfaced by a concurrent STAA session (S5-STAA analysis, 2026-10-09, Finding 3) while analyzing `.claude/transcripts/2026-10-07T10:31-ST.md`. Originally filed by that session as provisional Central-style `BACKLOG-580`; renumbered into the fork-local line (BL-003) per DSM_0.2 §21.5.
**Author:** Alberto (with AI assistance)
**Renumbered from:** BACKLOG-580 (provisional Central number; the authoring session could not see the fork-local line because its artifacts were on unmerged branches — see BL-005).

---

## Problem Statement

§7 (Session Transcript Protocol) mandates that the plan append be the **first tool
call** of a turn, enforced by the `UserPromptSubmit` per-turn reminder hook and the
`validate-transcript-edit.sh` occurrence check. `/dsm-go` Step 5.5 archives the live
`.claude/session-transcript.md` to `.claude/transcripts/{start-ts}-ST.md`, and Step 6
resets the live file with a fresh session header.

When `/dsm-go` runs, these two rules collide on ordering. The §7 hook fires at the
start of the boot turn, so the agent appends the boot plan block to the **live**
transcript before Steps 5.5/6 execute. The archive (Step 5.5) then captures a file
that already contains the next session's boot plan, and the reset (Step 6) overwrites
the live file — so the boot plan is **absent** from the fresh current-session
transcript and **present** at the tail of the **previous** session's archive.

**Evidence:** `.claude/transcripts/2026-10-07T10:31-ST.md` is the Session 5 archive.
After its final `Session 5 closed.` output block, it carries an `<------------Start
Plan / 10:47------------>` block that is unmistakably the **Session 6** `/dsm-go` boot
plan ("GIT_AVAILABLE=true. Running the session-start sequence..."). This reproduced
again in Session 6 itself (its own boot plan is in the Session 5 archive).

**Effect:**
1. Each session's boot reasoning is systematically filed under the **previous**
   session's archive (archive-boundary bleed).
2. The current session's fresh transcript lacks its own boot-plan reasoning.
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
  transcript as part of the reset, so the plan lands in the correct file by
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
- [ ] If unintended: a `/dsm-go` boot's plan block lands in the **current** session's fresh transcript
- [ ] If unintended: the just-archived prior transcript contains no next-session boot-plan bleed
- [ ] The §7 occurrence hook raises no false violation from the chosen fix (the plan append still occurs within the boot turn)
- [ ] STAA subject-selection and parsing remain correct under the chosen resolution

## Test Plan

Conditions that must pass before the implementing branch merges:

- [ ] Run `/dsm-go`; confirm the fresh `.claude/session-transcript.md` contains the boot-plan block (grep the boot-plan signature in the live file)
- [ ] Confirm the just-archived prior transcript (`.claude/transcripts/{prev}-ST.md`) does **not** contain the new boot-plan block
- [ ] Confirm `validate-transcript-edit.sh` and the `UserPromptSubmit` occurrence check pass on the boot turn with no violation (behavioral run, capture output — §19.1)
- [ ] Confirm an STAA run on the new session sees that session's boot reasoning in its own archive

## Risks (per DSM_0.2 §21.2)

- **Hook false-violation from reordering:** moving archive/reset ahead of the plan append may trip the §7 "plan must be the first tool call" occurrence check. *Mitigation:* the fix must carve a boot-turn hook exception or fold the plan into Step 6's reset (direction B); this design dependency is exactly why this is a BL, not an inline fix.
- **High blast radius, low benefit:** the change touches the boot hot-path (§7 hook + `/dsm-go` Steps 5.5/6), shared by every session across every DSM project via the `@`/mirror chain. A regression silently breaks transcript occurrence for all projects. *Acceptance:* keep Priority Low; schedule only with a §19.1 behavioral test on the hook and the branch-testing minimum (§19).
- **Behavior may be intended:** the boot plan may be a deliberate bridge entry. *Mitigation:* Success Criteria gates implementation on confirming intent first.
- **Implementation touches untracked deployed copies:** a fix to `scripts/commands/dsm-go.md` requires `scripts/sync-commands.sh --deploy` to refresh the untracked global copy in `~/.claude/commands/`. *Mitigation:* implementer follows the Revert Safeguards Protocol and the command-file sync step.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items above (deferred: this BL is Proposed, not implemented)
