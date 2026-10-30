# BACKLOG-030: Build the Worklog From the Session Log at Wrap-Up and Switch Off the Per-Turn Writes in the Hub

**Status:** Proposed (Gate 1 approved in S27; starts after BACKLOG-029's baseline)
**Priority:** High
**Extends:** DSM_0.2 §7 (Worklog Protocol) and DSM_0.2.G. During the trial the per-turn rule is
replaced only in the hub's local, untracked `.claude/CLAUDE.md` (DSM_0.2 §17: a project's
CLAUDE.md takes precedence); the fork's main carries no rule that contradicts §7. If the trial
works, the change goes to Central as a proposal (DSM_0.2 §21.5).
**Date Created:** 2026-10-30
**Origin:** User request, S27. The user asked whether the worklog could be written once at the end
of a session instead of on every turn, saw the option "plan line in the chat, worklog built at
wrap-up" run in the chat, and chose to test it on this machine first.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-030).
**Depends on:** BACKLOG-029 (the log reader and a baseline of two or three sessions).

---

## Problem Statement

Writing the worklog on every turn costs two tool calls per turn, and four for a turn with a
question in the middle. In S27 those calls took about a third of the session's cache-read tokens
(BACKLOG-029). The Output blocks they write are the agent's own account of its work, while the
session log already records prompts and tool calls with exact times.

DSM_0.2.G gives the reason for writing per turn: "the user follows the log live and cannot review
work notes after the fact". The one thing the session log cannot rebuild is the plan written
before acting, which STAA compares with what followed. In the VS Code extension, text the agent
writes before a tool call stays visible, so a plan line in the chat serves both: the user sees it
live, and the session log records it with its time.

## Proposed Solution

- **T1, generator:** extend BACKLOG-029's script to build `worklog.md` from the session log, in
  the existing delimiter format, appended below the header that `/dsm-go` writes. User block: the
  user's words, with names on the local name list and spoke names replaced by bracketed roles.
  Plan block: the agent's text from a `**Plan:**` line up to the first tool call. Output block:
  the tool calls with their times and the agent's text up to the next stop. All times come from
  the log.
- **T2, test on a finished session:** build S26's worklog from its session log and compare it
  with the hand-written one; record what each holds that the other lacks, and fix or accept each
  difference. No live session pays for this test.
- **T3, switch the hub** (local files only):
  - first, dated copies of `.claude/settings.json`, `.claude/CLAUDE.md` and
    `.claude/reasoning-lessons.md` (for example `settings.json.pre-bl030`); none of the three is in
    git;
  - a rule in `.claude/CLAUDE.md` §4 that replaces §7's per-turn appends: a `**Plan:**` line in
    the chat before the first tool call of a turn and after each stop, and the generated file at
    wrap-up. The "Read as / Not read as" line goes into the plan line only when the user's message
    approves or decides something (recommended in S27, to be confirmed at Gate 2);
  - the `transcript-reminder.sh` entry removed from the local `.claude/settings.json`, with a
    backup copy kept;
  - the generator run by the full, light and quick wrap-ups before their lesson extraction, and
    at boot when the previous session ended without a wrap-up and its worklog holds only the
    header;
  - the wrap-up lists turns that have tool calls but no `**Plan:**` line;
  - `validate-transcript-edit.sh` stays if the generator's append passes it (T-2 below).
  - Rollback: see the Rollback section below.

Open at Gate 2: how parallel sessions use the worklog under the new rule (`/dsm-parallel-session-go`
mentions it on four lines), and the reasoning lessons that describe per-turn blocks, to be reworded
at the next STAA prune.

Out of scope: the rollout to the spokes (after two or three good hub sessions, one inbox note per
project, each project decides) and the Central proposal; each becomes its own step once the hub
trial is done.

## Success Criteria

- [ ] The S26 comparison is recorded, with each difference fixed or accepted.
- [ ] In two hub sessions after the switch: no worklog calls during turns, and the generated
  worklog exists before wrap-up Step 0; STAA reads it without change.
- [ ] Each wrap-up reports the turns without a `**Plan:**` line, with a count.
- [ ] `history.md` (BACKLOG-029) shows cache-read tokens per turn before and after the switch.
- [ ] The full rollback (T-6) was run once, and the hub was switched on again afterwards.

## Test Plan

- [ ] T-1: generator on the S26 log; compare block counts by type and the contents with the
  archived S26 worklog; record the differences.
- [ ] T-2: the generator's append passes `validate-transcript-edit.sh`, or the bypass is chosen
  and documented.
- [ ] T-3: the generated file splits into typed blocks the way `/dsm-staa` Step 3 parses them;
  count the blocks by type.
- [ ] T-4: names on the local name list and spoke names are replaced; sweep reported as counts
  with coverage.
- [ ] T-5: crash case in a scratch copy: a header-only worklog and no wrap-up marker; the boot
  step builds the worklog before archiving it.
- [ ] T-6: full rollback, once: restore the three dated copies; the next prompt shows the reminder,
  the §4 rule is gone and the lessons have their old wording. Then switch on again.
- [ ] T-7: a scratch turn with tool calls and no `**Plan:**` line appears in the wrap-up list.
- [ ] T-8: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **A forgotten plan line leaves no trace:** no hook can check text in the chat. Mitigation: the
  wrap-up list (T-7) and its count in `history.md`.
- **Longer text in the chat:** multi-step plans move from the file into the chat. Accepted as the
  user's choice in S27; revisit if it gets in the way.
- **Names reach the worklog through the user's own words:** STAA and the lessons read it.
  Mitigation: replacement and sweep (T-4).
- **No worklog for a session:** if neither the wrap-up nor the next boot runs the generator, and
  the session log has expired (30 days by default). Mitigation: the boot check (T-5); the rest is
  accepted.
- **Drift from Central's §7:** the spokes keep the per-turn rule until their rollout, and a
  Central release may assume per-turn blocks. Mitigation: the rule stays local, upstream merges
  are checked for worklog changes, and the rollback takes one minute.
- **Stale lessons and protocol references:** lessons on the Open line or on block boundaries at a
  stop describe the per-turn blocks. Mitigation: reword them at the next STAA prune.

## Rollback

Nothing in DSM text or in Central's files changes, so a rollback touches only this fork's own
files.

| Layer | Change | Undo |
|---|---|---|
| Local `.claude/settings.json` | Reminder hook entry removed | Restore the dated copy |
| Local `.claude/CLAUDE.md` §4 | Worklog rule (and BACKLOG-029's wiring, if that goes too) | Restore the dated copy, or delete the lines |
| Local `.claude/reasoning-lessons.md` | Lessons on per-turn blocks reworded | Restore the dated copy: the file is not in git, and wrap-up backs up only MEMORY.md |
| Tracked `scripts/tool-use-report.py` | Generator added | `git revert` the merge, or leave it unused |
| Worklogs built during the trial | Same format as before | Nothing to undo |
| Spokes, if a later step rolled it out | Their own local switch | One inbox note per project |
| Central, if proposed | A proposal | Withdraw it |

Partial rollback, the most likely one: keep BACKLOG-029's report and undo only this BL by
restoring the hook entry and deleting the worklog rule. The report works with per-turn writes too.
If the trial ends in a rollback, this BL closes as withdrawn (DSM_0.2 §21.5).

## Upstream Contribution

After the hub trial and the spoke rollout, offer the change to Central with the numbers from
`history.md`, once a Central PR slot is free (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
