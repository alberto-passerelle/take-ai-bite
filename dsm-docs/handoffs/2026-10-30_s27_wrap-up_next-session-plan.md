# Session 27 Handoff (Wrap-Up): Tool-Use Report, Worklog Trial and Narrowed Reference-Read Rule

**Date:** 2026-10-30
**Session:** 27 (full wrap-up)
**Branch:** session-27/2026-10-30, merged into `main` at this wrap-up
**Author:** Alberto (with AI assistance)
**Consumer:** S28 (`/dsm-go` Step 3)

This file ships with the public fork. It names no Central PR, issue, commit or active-backlog
numbers, describes none of Central's unreleased text, and names no spoke, client or person. The
S27 worklog (archived at the next boot) and `.claude/tool-use/S27.md` hold the full record.

## 1. What Happened in S27

The user asked whether the worklog could be written once at the end of a session instead of on
every turn, with three goals: faster sessions, better analysis at wrap-up and in STAA, and fewer
tokens.

- **Measurement.** The Claude Code session log records every prompt, tool call and request with
  its token usage. Every tool call starts a new request that re-reads the whole context
  (160,000-270,000 tokens per request in S27), so the number of calls drives cost, not their
  length. Calls that only wrote the worklog caused 39 extra requests, 31% of the session's cache
  reads; 22 of those 44 calls are guesses, because description prefixes started mid-session.
- **BACKLOG-029 (done).** `scripts/tool-use-report.py` turns the session log into a report of at
  most 40 lines (`.claude/tool-use/S{N}.md`) and one row in `.claude/tool-use/history.md`. The
  local `.claude/CLAUDE.md` §4 wires it in: every Bash description starts with a category
  (`Worklog:`, `Check:`, `Read:`, `Edit:`, `Commit:`, `Send:`), every wrap-up runs the script once
  before lesson extraction, and STAA reads the report of the session it analyses.
- **BACKLOG-030 (filed).** Option C, chosen after a demo in the chat: a `**Plan:**` line in the
  chat before acting, the worklog built from the session log at wrap-up, the per-turn reminder
  hook switched off. A local trial in the hub only, with a Rollback section.
- **BACKLOG-025 (done).** The user classified S25's human correction as a correction of wording,
  so rule 3 applied: narrow. The reference-read trigger now covers only claims that leave the hub
  (Central, a spoke inbox, the public fork) or decide something, and a passage must come from
  numbered tool output.
- **Commit hooks.** Two protocol slips in S27 (a scratch script written to /tmp without
  confirmation, and a commit made without the egress sweep) led to local `pre-commit` and
  `commit-msg` hooks that call the egress checker's new modes. They block listed names and print
  the rest of the sweep as counts; reading the lines that mention Central stays a manual step.
- **Central.** Nothing new since S26.

## 2. Order for S28, and Why

1. **The protected-data inbox entry, then BACKLOG-028.** The entry may change the tier's
   conditions, so it comes before Gate 2. Implement on `bl-028/*` from a clean index (§20.9); keep
   the existing `Restricted` row byte-identical to `upstream/main` and check `git merge-tree`
   against `upstream/main` (T-1, T-6).
2. **Prefix from the first call and run the report at wrap-up.** BACKLOG-030's start condition is
   two sessions in `history.md`; S28 provides the second, and the first with exact categories.
3. **The rest of the inbox** (5 entries in 2 files) as time allows.

## 3. Carried Items

- BACKLOG-030 from S29: dated copies of `settings.json`, `CLAUDE.md` and `reasoning-lessons.md`
  first, then the generator test on S26's log, then the switch.
- Scratch folders under `.claude/scratch/` wait for the user's go to delete (`rm -rf`).
- Next Central release: merge `upstream/main`, run `scripts/sync-commands.sh --deploy` and
  `diff -q`, close BACKLOG-022 and 023 if the release carries them.
- The user's own team-skill rollout steps (S21 parallel handoff in the drafts).
