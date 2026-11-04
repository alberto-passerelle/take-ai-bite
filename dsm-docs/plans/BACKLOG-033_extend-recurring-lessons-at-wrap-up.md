# BACKLOG-033: Extend an Existing Reasoning Lesson Instead of Appending a Duplicate at Wrap-Up Step 0

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** `scripts/commands/dsm-wrap-up.md` and `scripts/commands/dsm-quick-wrap-up.md` Step 0
(lesson extraction and the `**Last appended:**` header update); DSM_0.2.A §8.1 (Compact Mirror).
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. Its compact mirror crossed the
§8.1 bound at a wrap-up because recurring lessons were appended as new entries.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-033).

---

## Problem Statement

Step 0 of both wrap-up skills says "For each notable entry, append a 1-2 line summary to
`.claude/reasoning-lessons.md`" (`dsm-wrap-up.md` L16, `dsm-quick-wrap-up.md` L7) and lists
"Patterns that recur across sessions" as notable (L21, L12). Neither step checks the live file for
an existing entry first. A recurrence of a known lesson therefore lands as a new entry, the live
file and the compact mirror grow at every wrap-up, and a later STAA run has to merge the duplicates
back.

The spoke's numbers: after a STAA run its mirror was 27 B under the §8.1 bound. The next wrap-up
appended 6 lessons, at least 4 of which extended an existing entry, and the mirror ended 1,967 B
over the bound. The following STAA run merged 5 of the 6 into older entries.

## Proposed Solution (sketch for Gate 1)

- Step 0, both skills: before appending, search the live file for the pattern. When the pattern
  repeats an existing entry, extend that entry in place with one evidence sentence ending
  "Extended S{N}." Append only lessons without an existing entry.
- The `**Last appended:**` header update counts appended and extended entries separately.
- The §8.1 transform needs no change.

Open for Gate 1: which tag an extended `[STAA]` entry keeps (the spoke proposes the original tag;
the trail names the session); whether an entry's length is capped; how Step 0 decides that two
patterns are the same.

## Success Criteria (draft)

- [ ] Step 0 in both skills checks the live file before appending and extends an existing entry
  when the pattern repeats.
- [ ] The `**Last appended:**` line reports appended and extended counts.
- [ ] The runtime copies are deployed (`scripts/sync-commands.sh --deploy`) and `diff -q` against
  `~/.claude/commands/` reports no difference for both files.

## Test Plan (draft)

- [ ] T-1: scratch lessons file with one existing entry and a worklog whose pattern repeats it;
  follow Step 0: the entry is extended, the entry count is unchanged, the header counts 1 extended.
- [ ] T-2: a worklog with a new pattern: one entry appended, header counts 1 appended.
- [ ] T-3: regenerate the compact mirror from the T-1 file with the §8.1 transform: entry count and
  category headings match the live file.
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` reports no conflict on the
  two skill files.
- [ ] T-5: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **Extended entries grow without limit:** the mirror still crosses its bound, only later.
  Mitigation: one sentence per extension; STAA keeps pruning; Gate 1 decides on a cap.
- **A wrong match merges two different lessons:** a distinct lesson is lost inside an older one.
  Mitigation: when Step 0 is unsure, it appends.
- **The recurrence signal gets quieter:** today a duplicate entry shows that a lesson recurred.
  Mitigation: the "Extended S{N}" trail and the header's extended count keep it visible.
- **The fork's skill files drift from upstream:** a local change conflicts at the next upstream
  merge. Mitigation: send the change upstream instead of patching the fork's copies.

## Upstream Contribution

Offer to Central as an issue plus a PR on both wrap-up skills (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
