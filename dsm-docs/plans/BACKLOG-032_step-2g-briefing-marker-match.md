# BACKLOG-032: Let /dsm-go Step 2g Find a Data-Protection Briefing by a Marker Line, Not Only by Its English Title

**Status:** Proposed (Gate 1 open)
**Priority:** Low
**Extends:** `scripts/commands/dsm-go.md` Step 2g and the DSM_0.2.C §5.9 briefing template.
**Date Created:** 2026-10-31
**Origin:** Inbox entry from a downstream spoke, processed in S28. Its briefing follows the §5.9
sections but has a non-English title, and Step 2g warned that no briefing exists. The spoke
worked around it with an English subtitle line.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-032).

---

## Problem Statement

`scripts/commands/dsm-go.md` L800:

> `if grep -rliE 'Data-Protection and Compliance Briefing' dsm-docs/decisions/ 2>/dev/null | grep -q .; then`

Step 2g finds a briefing only by the English title phrase. A project that writes its briefing in
its working language gets a false warning at every boot, which teaches the user to dismiss the
warning.

## Proposed Solution (sketch for Gate 1)

- §5.9 template: one marker line under the title, for example `**DSM briefing:** §5.9`.
- Step 2g: a file counts as a briefing if it contains the title phrase or the marker line,
  anchored at line start. The change is additive: every briefing found today is still found.

Open for Gate 1: the marker's exact form.

## Success Criteria (draft)

- [ ] Step 2g finds a briefing by its title or by the marker line; the warning still fires when
  neither is present.
- [ ] The §5.9 template carries the marker line; no heading changes.
- [ ] The runtime copy is deployed (`scripts/sync-commands.sh --deploy`) and `diff -q` against
  `~/.claude/commands/dsm-go.md` reports no difference.

## Test Plan (draft)

- [ ] T-1: scratch projects with the trigger set, run in a Claude Code Bash session (DSM_0.2
  §19.1): English title, silent; non-English title with the marker, silent; neither, warning;
  marker only inside a prose sentence, warning.
- [ ] T-2: trigger absent, silent.
- [ ] T-3: the title phrase count in DSM_0.2.C is unchanged; the marker line occurs once in the
  template.
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` reports no conflict on
  `dsm-go.md` or DSM_0.2.C.
- [ ] T-5: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **The fork's skill file drifts from upstream:** a local change to `dsm-go.md` conflicts at the
  next upstream merge. Mitigation: send the change upstream instead of patching the fork's copy;
  the spoke keeps its English subtitle until then.
- **A marker inside prose counts as a briefing:** mitigation: the match is anchored at line start,
  and T-1 case 4 checks it.
- **Stale runtime copy:** the boot reads `~/.claude/commands/`. Mitigation: success criterion 3.

## Upstream Contribution

Offer to Central as a fix: an issue plus a PR carrying the `dsm-go.md` and DSM_0.2.C change
(DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
