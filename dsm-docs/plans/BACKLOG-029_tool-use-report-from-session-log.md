# BACKLOG-029: Build a Tool-Use Report From the Claude Code Session Log at Wrap-Up

**Status:** Proposed (Gate 1 approved in S27)
**Priority:** High
**Extends:** DSM_0.2 §7 (Worklog Protocol): adds a measured record of tool use next to the worklog
and changes nothing in §7; feeds `/dsm-wrap-up` Step 0 and `/dsm-staa`.
**Date Created:** 2026-10-30
**Origin:** User request, S27: make sessions faster, make the analysis at wrap-up and in STAA
better, and use fewer tokens. A measurement in S27 found that writing the worklog is a large share
of a session's cost, and that no record of tool use reaches the analysis.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-029).

---

## Problem Statement

Measured on the S27 session log (first 95 minutes, 35 requests): 36 tool calls, 11 of which only
wrote the worklog. Every tool call starts a new request, and every request re-reads the whole
context from cache: 160,126 tokens per request on average (5,604,420 cache-read tokens over 35
requests). The 11 worklog calls therefore cost about 1.8 million cache-read tokens, roughly a third
of the session (an estimate from the average, not a count per call). In S26, 21 of 88 tool calls
touched `worklog.md` (an upper bound: some of them also did other work).

Two gaps follow:

1. **No record of tool use reaches the analysis.** Worklog Output blocks are the agent's own
   summary of what it did. Wrap-up Step 0 and STAA cannot see how many calls a turn took, what
   they cost, which failed, or which could have been one call.
2. **No baseline.** Without numbers per session, a change in how the agent uses tools, or
   BACKLOG-030's change to the worklog, cannot be judged by its effect.

The Claude Code session log already holds the data: every prompt and tool call with a timestamp,
and token usage per request (`input_tokens`, `cache_read_input_tokens`,
`cache_creation_input_tokens`, `output_tokens`). Checked on the S27 log.

## Proposed Solution

Three threads in one BL: T2 makes T1 exact, and T3 gets the report into the analysis.

- **T1, script `scripts/tool-use-report.py`** (tracked, name-free, Python standard library, run
  with `python3 -I`). It reads this session's log under `~/.claude/projects/<project-slug>/`,
  matched by the session start time in the worklog header, and stops with a message when no log
  or more than one log matches. It writes into `.claude/tool-use/` (ignored, stays local):
  - `S{N}.md`, at most 40 lines, per turn and in total: tool calls by tool and by prefix,
    bookkeeping calls, requests, cache-read, cache-creation and output tokens per request (exact),
    tool time and the wait for the next model step, errors, outputs over 10,000 characters, files
    read more than once, single-call requests directly followed by another single-call request
    (candidates for one call), and calls without a prefix.
  - `history.md`, one row of totals per session, so trends show across sessions.
  - Report and history hold counts and the agent's call descriptions only, never the content of
    a prompt or a tool output.
- **T2, description prefix:** each tool call's description starts with its category: `Worklog:`,
  `Check:`, `Read:`, `Edit:`, `Commit:`, `Send:`; a combined call names both (`Worklog+Check:`).
  The script sorts by prefix and counts calls without one.
- **T3, wiring** in the local `.claude/CLAUDE.md` §4 (untracked, so Central's command files stay
  unchanged during the trial): the full, light and quick wrap-ups run the script once before
  their lesson extraction and read `S{N}.md`; STAA reads the report of the session it analyses;
  T2's prefix rule.

Out of scope: changing the worklog itself (BACKLOG-030), editing Central's command files, and the
spokes, which follow after the hub trial.

## Success Criteria

- [ ] The S27 report matches an independent count of tool calls, requests and cache-read tokens
  from the same log.
- [ ] Running the report costs one tool call at wrap-up, and `S{N}.md` has at most 40 lines.
- [ ] Report and history contain no prompt or tool-output content.
- [ ] A missing or ambiguous log stops the script with a message and writes no report.
- [ ] The wiring lives in the local `.claude/CLAUDE.md` §4; no tracked command file changes.
- [ ] `history.md` holds rows for at least two sessions: the baseline for BACKLOG-030.

## Test Plan

- [ ] T-1: run on the S27 log; compare tool calls, requests and the cache-read sum with a one-off
  count through a separate code path.
- [ ] T-2: run with S26's start time and check that it selects S26's log; run with a start time
  that matches no log and check that it stops, exit status read directly (§19.2).
- [ ] T-3: grep the S27 report for a line known from a tool output of that session: 0 hits; name
  list sweep: 0 hits, reported with coverage; a made-up project name in a call description comes
  out as `[project]`.
- [ ] T-4: two logs overlapping in time (a STAA run in a second window), in a scratch copy: the
  script reports the ambiguity and picks neither.
- [ ] T-5: an unreadable or field-less log prints a line different from a clean run's
  (§19.1's second question); a field the script could not read is never reported as 0.
- [ ] T-6: the §4 wiring names the script and the report path, and the next wrap-up runs it in
  one call.
- [ ] T-7: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **Wrong log selected** when a parallel session or a STAA run wrote a log at the same time.
  Mitigation: match by start time, stop on none or several (T-2, T-4).
- **Harness log format changes:** field names may change between Claude Code versions.
  Mitigation: the script names a missing field and stops; it never reports 0 for a field it could
  not read (T-5).
- **Names in the report:** call descriptions are the agent's own text but can name a project.
  Mitigation: only flagged calls are listed (at most 5), with listed names and sibling project
  folder names replaced by `[project]` and outside paths by `[outside repo]`; T-3's name sweep;
  the report stays ignored and local.
- **Reading the report costs tokens:** Mitigation: the 30-line cap; details only on request.
- **Logs expire:** Claude Code deletes old session logs (`cleanupPeriodDays`, 30 days by
  default). Accepted: the report is built at wrap-up, while the log exists.
- **Prefix discipline slips:** Mitigation: the report counts calls without a prefix.

## Upstream Contribution

After the trial on this machine (BACKLOG-030), offer the script and the report to Central with
the before-and-after numbers from `history.md`, once a Central PR slot is free (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

S27, on a frozen copy of the S27 session log (89 tool calls, 78 requests at copy time):

- [x] T-1 PASS: tool calls 89 = 89, requests 78 = 78, cache read 16,962,556 = 16,962,556 against
  an independent count (a recursive walk instead of the script's loop).
- [x] T-2 PASS after a fix: the S27 worklog selects the live S27 log, S26's archived worklog
  selects the S26 log, and a session with no log exits 2 ("0 session logs match"). The first run
  FAILED: the no-log case picked the live log, because the test command itself quoted both header
  strings. The match now requires a call that overwrites `.claude/worklog.md` (the `/dsm-go`
  reset).
- [x] T-3 PASS: 0 hits in the report for 3 probes taken from the session's tool outputs; 0 hits
  against the 1-entry name list and the 7 sibling folder names; a made-up project name and an
  outside path come out as `[project]` and `[outside repo]`, a repository path as a relative
  path, and a real sibling folder name is removed.
- [x] T-4 PASS: two copies of the S27 log in a scratch project folder exit 2 ("2 session logs
  match").
- [x] T-5 PASS: a request that lacks two usage fields exits 3 and names them; a log without usage
  data exits 3.
- [ ] T-6: deferred to the S27 wrap-up, after the wiring text for `.claude/CLAUDE.md` §4 is
  approved.
- [x] T-7: run by the pre-commit and commit-msg hooks at this commit.

Finding: 22 of the 35 worklog-only calls in S27 are guessed, because the description prefix
started mid-session. The S27 share of cache reads after worklog-only calls (40%) is therefore
uncertain; from S28 on the categories are exact.

### Pending verification

- [ ] T-6: the wrap-up runs the script in one call and reads the report.
- [ ] `history.md` holds rows for two sessions.
