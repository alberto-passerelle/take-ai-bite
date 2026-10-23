# Session 20 Handoff: Central waves 2 and 3 sent; ledger, follow-ups and items 3-5 open

**Date:** 2026-10-23 (session 20 ran 2026-10-22 into 2026-10-23)
**Session:** 20
**Branch:** session-20/2026-10-22 (merged into `main` by the wrap-up; if that merge did not complete, `/dsm-go` Step 0c finds the leftover branch)
**Author:** Alberto (with AI assistance)
**Consumer:** the next `/dsm-go` (Step 3 reads this in full and surfaces the pending items)
**Date Completed:** 2026-10-23
**Outcome Reference:** Consumed at session 21 start

This file ships with the public fork. It therefore names no Central PR or issue numbers, no
Central commit IDs, no Central active-backlog numbers and no spoke or client names. The
number map lives in the gitignored `.claude/drafts/` files and in the session worklog; to
list the items from Central itself, run
`gh pr list` / `gh issue list` with `--repo albertodiazdurana/agentic-ai-data-science-methodology --author alberto-passerelle --state all`.

---

## 1. Where things stand

| Area | State at wrap-up | Evidence |
|---|---|---|
| Fork version | TAB 1.37.1 merged into the session branch, 0 conflicts | `git merge-tree` before the merge, CHANGELOG head `## [1.37.1]` after |
| User-level commands | 23 of 23 identical to `scripts/commands/` | `diff -q` per file after `sync-commands.sh --deploy` |
| Fork backlog, active | 008, 011, 014, 015, 016, 017, 022, 023, 024 | `dsm-docs/plans/README.md` |
| Fork backlog, closed this session | 019, 020, 021 (Implemented, absorbed as Central BACKLOG-609/-610/-611 in v1.37.1) | `dsm-docs/plans/done/fork-INDEX.md`, 15 rows = 15 bodies |
| Open on Central from this account | 3 PRs (wave 2) and 8 issues (wave 1: 2, wave 2: 1, wave 3: 5) | `gh pr list` / `gh issue list --state open --json number --jq length` at wrap-up: 3 and 8 |
| Public ledger (take-ai-bite #130) | Stale: still shows wave 1 as open and waves 2-3 as queued | draft update ready, not posted (section 3.1) |
| `/dsm-align` | 1.37.0 check-only pass at boot; marker says 1.37.0 | `.claude/last-align.txt`; the next boot sees 1.37.1 and reruns it |

## 2. What this session did, by item

The boot report listed six items; the user said "address suggested work in order". Items 1, 2
and 6 are done; 3, 4 and 5 were not started.

**Item 1, upstream 1.37.1.** Merged, commands redeployed, all five 1.37.1 fixes found in the
merged files (grep per fix: `stat -f %m` fallback, basename compare at four sites, `target_path`
in wrap-up Step 0.5, the `fork-INDEX.md` switch in `/dsm-align` 11b, the manifest's category 7).
BACKLOG-019's Linux test (T-6) was closed by its second trigger, the owner's review and the
release note "Linux behaviour is unchanged"; it was never run on a Linux host here.

**Item 2, waves 2 and 3.** Every claim was rechecked against v1.37.1, which is Central's `main`
(tag `v1.37.1` on Central `main`, read with `gh api`). Nine claims, all still open upstream:
H (research-add stub), I (gate numbering), J (inbox entry count), K (User block wording),
BACKLOG-014, -015, -016, -017, -008. One claim narrowed on rereading: BACKLOG-017's "the
budget's measure is not stated" is half true (Gates 1 and 2 name word or page counts; how words
are counted is not stated). One new finding went into issue I: DSM_0.2 §21.3 cites "§8.4 Gate 3
(Run Approval)", but §8.4 is Gate Scope; Run Approval is §8.3. Central's active backlog (not
mirrored) was grepped for every topic; it holds a design item on inbound contributions from
forks that covers BACKLOG-008, so 008 went as input to that item rather than as a rule proposal.

The user chose the routes (one question each, all four recommended options):

| Item | Route | Fork BL |
|---|---|---|
| H: `/dsm-research-add` stub puts Sources last | PR | BACKLOG-022 (new) |
| J: `/dsm-go` Step 2b counts entries, not files | PR | BACKLOG-023 (new) |
| K: worklog User block keeps the user's words | PR | BACKLOG-024 (new) |
| I: gate numbering 0-3 vs 1-4, and the §8.4 reference | issue | none (as with wave 1's issues) |
| BACKLOG-014: open task branches on merge to `main` | issue | existing |
| BACKLOG-015: revised plan before acting against it | issue | existing |
| BACKLOG-016: worklog rules without hooks | issue | existing |
| BACKLOG-017: per-bite budget check at Gate 3 | issue | existing |
| BACKLOG-008: four contribution rules | issue, as input to Central's design item | existing |

How the PRs were built: one `git worktree` per PR off a freshly fetched Central `origin/main`
in `/tmp`, because the Central clone's checked-out branch (`dsm-v1371-boottest`) is not this
hub's and was left untouched. Before each commit: `cmp` of the target file against the reviewed
base, and `git diff --numstat` asserted equal to the reviewed stat (+4/-4, +10/-1, +2/-2). After
each send: PR head equal to the local commit, live body equal to the approved body (only
trailing blank lines differ). Bodies came from the review files, which the user approved
unedited.

**Item 6, cleanup.** User-approved: branches `session-15/2026-10-15` and `session-16/2026-10-15`
deleted with `git branch -d`; `/tmp/s19-fix` and `/tmp/s19-guard` removed.

## 3. Pending, in the order the dependencies force

### 3.1. Post the #130 ledger update (needs the user's approval of the text)

The draft is `.claude/drafts/2026-10-22_s20_tab-130-ledger.md` (diff plus full new body). It
moves the three wave-1 fixes to "Absorbed" with the public release numbers take-ai-bite's own
CHANGELOG already prints (v1.37.1, BACKLOG-609/-610/-611), puts everything open on Central in
one table without numbers, and leaves only the reference-read item (BACKLOG-011) queued.
**Why first:** #130 is the public index the owner reviews from, and it currently misstates
three absorbed items as open and nine submitted items as queued. **Before posting:** recheck
Central (`gh` lists above); if anything merged or closed since the draft, move its row first.
Post with `gh issue edit 130 --repo albertodiazdurana/take-ai-bite --body-file <file>`; write
the body file in one call and edit in the next (the egress hook reads body files before the
command runs). GitHub keeps the previous body in the edit history.

### 3.2. Follow the Central items; nothing new can go out as a PR until one resolves

The fork keeps at most three open PRs on Central, and three are open (022, 023, 024).

- **When the owner merges a PR:** wait for the release that ships it, merge that upstream
  release into the fork, rerun `scripts/sync-commands.sh --deploy`, verify the change arrived,
  then close the fork BL per DSM_0.2 §21.5 (Status Implemented, `**Central BL:**` line with
  the release, move to `done/`, row from the README to `done/fork-INDEX.md`, no Central PR
  number in the row).
- **If the owner asks for changes:** recreate a worktree from the existing `fix/*` branch in
  the Central clone, edit, push that branch. The local guard refuses pushes to Central `main`;
  never retry a refused push in another form.
- **When the owner decides an issue:** record the outcome in the BL (014-017, 008). An issue
  that becomes a Central BL is "absorbed" once a release ships it; one that is declined either
  narrows the fork BL or closes it as withdrawn (§21.5 "Done and archive").
- **PR K changes DSM_0.2 §6/§7 (User block wording).** If it ships, this hub's worklog
  practice already matches it; nothing to migrate.
- **PR J and Central's own zsh item.** 1.37.1 spawned an upstream item on zsh no-match globs.
  PR J already uses `find` instead of a glob, so it does not add a site to that item.

### 3.3. Item 3: `.claude/CLAUDE.md` sections 2-4, then BACKLOG-011's open questions

`/dsm-go` Step 2a.8 reports sections 2, 3 and 4 missing (report only; the project has session
history). DSM_0.2 §17.1 names them: **2. Participation Pattern**, **3. Project Type**,
**4. Project Specific**, all outside the alignment delimiters. The current project-specific
content (Common Commands, Key Paths, Command Execution, Destructive Command Protocol, Secret
Exposure Prevention, Change Tracking Workflow, Humanizer Protocol) sits under unnumbered `##`
headings, so adding the sections means restructuring that file: a Gate 1 brief first (what
moves where, what is new), with the user. Candidate content for section 2: the fork acting as
its own local hub, Central write access, "never push Central `main`", the egress and
name-list rules. **Why before BACKLOG-011:** the BL's implementation is blocked on these
sections (S19 checkpoint) and on five open questions that are the user's:

1. Who confirms when the source belongs to someone other than the human in the session?
2. Does the trial run in this hub, in the reporting spoke, or both?
3. What counts as a correction? (T-6 cannot be written until this is defined.)
4. How long does the trial run, and what result keeps, changes or drops the rule?
5. Where does the trial text live (in-place edits to DSM_0.2.B / DSM_6.0 / DSM_0.2, which
   conflict at upstream merges, or a fork-local guide referenced from CLAUDE.md)? This also
   settles the placement inside DSM_0.2.B.

BACKLOG-011 was deliberately not sent upstream: its own preconditions (a comparative pass
against work outside DSM, a name-free account of the reporting spoke's case) are unmet.

### 3.4. Item 4: process the inbox

At boot: 4 files, 7 entry headers (counted with `grep -c '^### '` per file; all 4 files are
gitignored by name pattern). One is the `/dsm-align` notification from 2026-10-16 about the
missing `fork-INDEX.md`, which is resolved: archive it as
`_inbox/done/2026-10-23_dsm-align-update.md` (dated name, per the Inbox Lifecycle rule). The
other three come from downstream spokes and were not read this session; read each, process per
DSM_3 §6.4.3, archive with plain `mv` (gitignored), and keep their project names out of tracked
files ("a downstream spoke").

### 3.5. Item 5: the user's carry-overs from S18

- Record BACKLOG-012's last check in its BL file (S18 measured 0 hits on the fork's `main`
  after PR #16; still not written down).
- Extend `.claude/name-denylist.txt`. It holds 1 entry, so every "0 name hits" this session
  covers that one name only; client and project names not on the list were never checked.
- PR #11's edit history (old text retained by GitHub).
- Retire `/Users/alberto/TAB/HUB` or keep it as the fallback.
- The research README's 19 links to files absent in this fork.

### 3.6. Optional

- **`/dsm-staa` on this session** (recommended: two same-family shell slips and nine outward
  sends). Run it in a separate conversation. 16 `[STAA]` lessons are not yet shared with the
  aggregation file (hub role, Step 8b).
- **Local leftovers, deletion only on request:** `/tmp/s20-wave2.*`, `/tmp/s20-wave3`,
  `/tmp/s20-j-*` (scratch copies, test fixtures, approved body files). Keep
  `.claude/drafts/2026-10-22_s20_*.md` until #130 is posted and the PRs resolve; they hold the
  number map.
- **Ecosystem registry:** `.claude/dsm-ecosystem.md` has only the `dsm-central` row. DSM_0.2
  §18 calls a `portfolio` row required; without a `blog-spoke` row, `/dsm-go` Step 2e prints
  `UNRESOLVED`. Add rows only if those projects exist for this hub.

## 4. Settled this session (do not reopen without new evidence)

- Routes for waves 2-3 and BACKLOG-008 (table in section 2), chosen by the user.
- BACKLOG-011 stays local until its preconditions are met.
- Central numbers (PR, issue, commit, active BL) stay out of tracked fork files; the per-commit
  sweep pattern covers `#NNN`, 7-40-character hex IDs and the one active Central BL number this
  session handled.
- The Central clone's own branch is not this hub's working branch; PRs are built in `/tmp`
  worktrees.

## 5. Pitfalls met (also in `.claude/reasoning-lessons.md`, S20)

- macOS `/bin/bash` 3.2: `$((n+590))` on "019" fails as an invalid octal number; `declare -A`
  is unsupported and the indexed fallback maps by octal index without stopping the script.
- BSD `sed` does not read `\t` in a bracket expression; use `diff --label`. A diff containing a
  ``` line needs a four-backtick fence.
- `sync-commands.sh --check` passes on the tracked project-level copies even when the user-level
  copies are stale; verify the user level after `--deploy`.
- The checkpoint's letter codes (H-K) were defined only in an archived S18 handoff; the first
  item-2 plan missed them until that handoff was reread.
