# Session 22 Handoff: one spoke's inbox file checked, its priority entry at Gate 1, all decisions open

**Date:** 2026-10-25
**Session:** 22 (light wrap-up; work continues)
**Branch:** session-22/2026-10-25 (pushed, not merged; a light wrap-up does not merge)
**Author:** Alberto (with AI assistance)
**Consumer:** the next session (Step 3 of `/dsm-go`; `/dsm-light-go` does not read handoffs, so read this file by hand there)

This file ships with the public fork. It names no Central PR, issue, commit or active-backlog
numbers and no spoke, client or person names. The spoke's evidence counts and lesson texts are
left out on purpose (decision B3 below is whether any of them may appear in a public file).

---

## 1. Where Things Stand at the S22 Light Wrap-Up

| Area | State | Evidence |
|---|---|---|
| Fork version | TAB 1.37.1; `/dsm-align` skipped (version unchanged) | `.claude/last-align.txt` |
| Central, since S21 | Two of the three open fix PRs merged (inbox-entry count, research-add Sources order); the worklog User-block PR is still open. All eight issues closed as completed, 2026-10-24. Upstream TAB still 1.37.1, so none of it is released yet | read-only `gh` lists, S22 boot |
| Fork BLs touched by those closures | 022, 023 (PRs merged); 008, 014, 015, 016, 017 (issues closed); 024 still open. Not yet checked per success criterion, so none is closed | title match only |
| PR limit on Central | 1 of 3 in use | same lists |
| Inbox | Three downstream-spoke files, 8 entries. One file (5 entries) read and checked in S22, not archived; the other two (3 entries) still unread | `grep -c '^### \['` |
| Reference-read trial | S22 logged as `unanswered` (11 claims shown, 0 answered); counts in BACKLOG-025 | `.claude/reference-read-log.md` |

## 2. Inbox: the Priority Entry and Its Gate 1 Decisions

The user named one entry the only priority: a spoke's proposal, dated 2026-10-24, to add an
optional "consequential drafting" mode to chunked drafting (DSM_0.2.F §8.10). With the option on,
every drafted bite is followed by a source map, and a validator agent with a fresh context checks
the bite against the originals while the user reviews it. The proposal also adds project-guide
fields (DSM_3.0.E §6.7.3) and a validator template. Its evidence is interim (one spoke, one
document), and the spoke's own adopt / adjust / drop decision was pending when it was sent.

Planned as fork-local **BACKLOG-027** (next free number; shape of BACKLOG-026). Proposed title:
"Offer Source Maps and an Independent Validator for Each Drafted Bite as a Gate 1 Option in
Chunked Drafting". Nothing is written yet. Decisions, with the S22 recommendation first:

- **B1 Scope:** one BL for the whole mechanism; split out the validator template if Central
  accepts, because `scripts/sync-commands.sh` has no path for agent files (0 references).
- **B2 Route:** a Central issue now, stating that the evidence is interim and carrying the three
  open questions; or wait for the spoke's decision.
- **B3 Evidence in the public fork:** include the spoke's method counts (no document content),
  or keep them only in the Central issue.
- **B4 Relation:** separate from the reference-read trial (BACKLOG-025), with a cross-reference;
  both check a statement against the passage instead of the memory of a read.

Checked at the source in S22 (fork 1.37.1 and Central's main, identical for DSM_0.2.F): §8.10's
bite review has no source step (F lines 1019-1022); §10.1 covers quoted claims but runs "before
synthesis" (core lines 258-263, 275), so it is adjacent, not absent; §6.7.3 has the project guide
but no source fields (lines 109-110); BL files are outside the §8.10 trigger (F line 983). A
10-term search of DSM_*.md found no per-bite source mechanism.

## 3. Inbox: Recommendation for Everything Else, Awaiting One Approval (Package A)

The user rated the rest low priority and asked for one recommendation to approve. Not yet approved:

1. The spoke's inbox notice: acknowledge only.
2. Unreviewed lessons (7): add five to the gitignored aggregation file; skip one duplicate and one
   already covered by a hub lesson. DSM_0.2.A §8.3 requires the user's approval for these.
3. Reviewed lessons (3): add all three. Their two hub ideas: a lessons read in `/dsm-light-go`
   (later candidate); a timestamp-drift check on the Bash path (no action: the hook keeps drift
   Edit-only by design, `validate-transcript-edit.sh` lines 62-64).
4. Three defects, carried as candidates for the next Central batch, all present on Central's main:
   skill arguments overwrite `$N` field references in skill snippets (14 lines matching `\$[0-9]`
   in 4 command files, not each one a snippet; silent wrong values); DSM_3.0.E §6.7 stale in three spots (lines 41, 42 and 51-53, 139 vs 45);
   `/dsm-new-spoke` Step 5 writes a placeholder `portfolio` row that triggers a boot warning
   (line 37).
5. Archive the file to `_inbox/done/2026-10-25_{source}.md` once BACKLOG-027 exists.
6. Delete two scratch files holding Central's private text: `/tmp/s22-central-plans-readme.md`,
   `/tmp/s22-central-F.md`.

## 4. Reference-Read Answers Owed

Eleven claims are waiting for the user's confirm or correct, by location:

- S22 block 1 (12:22): DSM_0.2.A §8.3 lines 1282-1284; inbox entry 3 lines 42-43; DSM_3.0.E §6.7
  lines 41, 51-53, 139 and 45; `dsm-new-spoke.md` line 37; inbox entry 4 line 148;
  `validate-transcript-edit.sh` lines 62-64; `dsm-light-go.md` line 146. Approving Package A
  confirms all of these except entry 4 line 148.
- S22 block 2 (12:30): DSM_0.2.F lines 1019-1022; core §10.1 lines 258-263 and 275; DSM_3.0.E
  lines 109-110; DSM_0.2.F line 983; plus entry 4 line 148 again.

**Correction owed to the user:** the 12:30 block quoted entry 4 line 148 with one word wrong (the
second of the three decision words was repeated from the first). The source reads "adopt / adjust
/ drop". Show the corrected passage when asking again.

## 5. Still Open From Earlier Sessions

- How the trial counts STAA runs and parallel sessions:
  `dsm-docs/handoffs/done/2026-10-24_staa-s21_trial-session-scope.md` §2. S22 adds a third
  question: what an unanswered exchange counts as (BACKLOG-025 Test Execution Log).
- S21 review items (wave-4 candidates, S18 carry-overs, the parallel session's handoff in
  `.claude/drafts/`): `dsm-docs/handoffs/done/2026-10-23_s21_trial-start-and-review-items.md` §3.
- Per-criterion check of the fork BLs touched by Central's closures, then the public ledger
  update (take-ai-bite #130; its text is a separate approval).

## 6. Next Steps, in Dependency Order

1. Get the user's answers to Package A, B1-B4 and the owed claims; log each answer in the trial
   log, then file BACKLOG-027 and execute Package A.
2. Draft the Central issue for BACKLOG-027 (if B2 is "now"); its body is its own approval gate.
3. Check the closures per criterion and update #130.
4. Close today's branch with a full `/dsm-wrap-up` if the next session runs on a later day (a light
   wrap-up is same-day only).
