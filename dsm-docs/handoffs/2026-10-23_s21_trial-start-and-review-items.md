# Session 21 Handoff: the reference-read trial starts in S22; items that need the user's review

**Date:** 2026-10-23
**Session:** 21
**Branch:** session-21/2026-10-23 (merged into `main` by the wrap-up; if that merge did not complete, `/dsm-go` Step 0c finds the leftover branch)
**Author:** Alberto (with AI assistance)
**Consumer:** the next `/dsm-go` (Step 3 reads this in full and surfaces the pending items)

This file ships with the public fork. It names no Central PR, issue, commit or active-backlog
numbers and no spoke, client or person names.

---

## 1. Where things stand

| Area | State at wrap-up | Evidence |
|---|---|---|
| Fork version | TAB 1.37.1; `/dsm-align` check-only pass at boot | `.claude/last-align.txt` (1.37.1, pass) |
| `.claude/CLAUDE.md` | Sections 1-4 present; §2 carries `### Fork-as-hub rules`; §4 carries the reference-read trigger | `/dsm-go` 2a.8 snippet: `OK` |
| Fork backlog, closed this session | BACKLOG-011 (trial setup) | `dsm-docs/plans/done/fork-INDEX.md`, 16 rows = 16 bodies |
| Fork backlog, filed this session | BACKLOG-025 (run the trial), BACKLOG-026 (spoke-hub messages, High, later) | `dsm-docs/plans/README.md` |
| Public ledger (take-ai-bite #130) | Current: wave 1 absorbed, waves 2-3 open, one item queued | posted S21, live body read back equal |
| Open on Central from this account | 3 PRs, 8 issues; nothing merged or closed since S20 | read-only `gh` lists, S21 |
| Subscription file | `~/.claude/claude-subscription.md`: Team plan, Premium seat; sources listed in the file | written S21 |

## 2. Starts at S22: the reference-read trial (BACKLOG-025)

The trial runs in sessions S22-S26 and the next session is the first. What it needs from every
session, and why:

- **When a claim drawn from a file is about to be used in a plan, a decision, a brief or a
  message**, the agent shows passage, location and reading and waits for confirmation (guide
  `dsm-docs/guides/reference-read-protocol.md` §2-§3). The trigger line in `.claude/CLAUDE.md` §4
  loads this every session; if a session ignores it, the trial measures nothing.
- **Every exchange is logged** in `.claude/reference-read-log.md` (untracked) in the format of
  guide §5, and a session without exchanges logs `- S22 | no-exchange`. Without the per-session
  line, an unapplied rule reads as "no corrections" and the decision rule would drop it for the
  wrong reason (BACKLOG-025 Risks).
- **At each wrap-up**, the session's counts (from the guide's three commands, never from memory)
  go into BACKLOG-025's Test Execution Log. The log is untracked, so these counts are the only
  record that survives a lost `.claude/`.
- **After S26**, BACKLOG-025 applies the first-match rule: keep / drop / narrow / user decides.

## 3. Needs the user, in the order the dependencies force

### 3.1. Central items (unchanged since S20)

Three PRs are open, which is the fork's limit, so nothing new goes to Central as a PR until one
resolves. At S22 start, recheck the lists (`gh pr list` / `gh issue list` with `--repo
albertodiazdurana/agentic-ai-data-science-methodology --author alberto-passerelle --state all`).
A merge or a closure changes #130's rows and closes or narrows the matching fork BL; the closing
steps are in the S20 handoff (`dsm-docs/handoffs/done/2026-10-23_s20_central-waves-and-open-items.md`
§3.2).

### 3.2. Inbox: three downstream-spoke files, unread

Six entries (counted by `### [` header) in three files. They were left unread on purpose: they
may carry client material, and BACKLOG-026 asks that only methodology concepts cross between spoke
and hub. The user decides which to open; the agent reads each one only on request, processes it per
DSM_3 §6.4.3, archives it with plain `mv` to `_inbox/done/YYYY-MM-DD_{source}.md`, and cites it in
tracked files as "a downstream spoke".

### 3.3. Wave-4 candidates for Central (route is the user's)

None was sent. Each would follow the S19-S20 practice: recheck against Central's current text,
read Central's plans README for an existing item, then choose PR or issue within the 3-PR limit.

- **DSM_0.2.A §14.1 is out of date.** Its fast-mode price ($30/$150 per MTok) differs from the
  Claude Code fast-mode page ($8/$40 on Opus 5.5, retrieved 2026-10-23), and its Thinking column
  cannot apply to models that always think (Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable). Before
  sending, capture the web sources as a research file (DSM_0.2 §10), since the claim would leave
  the session.
- **`.claude/CLAUDE.md.template` lags its own runtime copy.** Its Branching "Agent behavior" line
  lacks the §20.9 clean-index clause that this hub's `.claude/CLAUDE.md` already carries.
- **BACKLOG-026.** Part A2 (only methodology concepts cross) as input to Central's existing item
  on reviewing inbox messages; Part B (drop `/dsm-align` Step 12b, report from
  `.claude/last-align.txt` instead) as an issue or PR. Decide also whether to adopt A locally first,
  since this hub deploys the commands its spokes run.

### 3.4. S18 carry-overs (still open, the user's decisions)

- Record BACKLOG-012's last check in its BL file (0 hits on the fork's `main` after PR #16).
- Extend `.claude/name-denylist.txt` (1 entry; every "0 name hits" covers that name only).
- PR #11's edit history keeps the old text.
- Retire `/Users/alberto/TAB/HUB` or keep it as the fallback.
- The research README's 19 links to files absent in this fork.

### 3.5. Parallel session 21.1 (QA) follow-up

It wrapped during S21. Its research file is committed
(`dsm-docs/research/2026-10-23_claude-skill-team-distribution.md`, indexed under tool
assessments). Its own handoff, a skill draft and an archive stay in `.claude/drafts/` (gitignored;
`/dsm-go` does not read them): `2026-10-23_s21_parallel-21.1_tab-update-handoff.md`,
`2026-10-23_s21_tab-update/`, `2026-10-23_s21_tab-update.zip`. Read that handoff for its pending
items; this session did not read it.

### 3.6. Optional

- `/dsm-staa` on S20 and S21 (separate conversation). 18 `[STAA]` lessons are not yet shared with
  the aggregation file (hub role, Step 8b).
- Scratch files, deletion only on request: `/tmp/s20-*` and `/tmp/s21-*`. The
  `/tmp/s21-central-*` files hold copies of Central's private backlog text and PR/issue titles;
  deleting those is advisable.
- Ecosystem registry: only the `dsm-central` row exists; add `portfolio` / `blog-spoke` rows only
  if those projects exist for this hub (`/dsm-go` Step 2e prints `UNRESOLVED` without the latter).

## 4. Settled this session (do not reopen without new evidence)

- `.claude/CLAUDE.md` follows the template's sections 2-4; fork rules live in §2
  `### Fork-as-hub rules`; the 3-PR limit is a rule; shell lessons stay out of CLAUDE.md.
- Reference-read trial: this hub only, S22-S26, two correction categories, first-match decision
  rule, guide text as approved section by section; BACKLOG-011 (setup) and BACKLOG-025 (run) split.
- Fork-local guides are indexed in the guides README's Fork-local guides section, in the same
  commit as the guide.
- BACKLOG-026 is filed for later, not to be implemented without the user.
