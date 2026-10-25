# BACKLOG-025: Run the Reference-Read Trial for Five Sessions and Decide Whether to Keep, Narrow or Drop the Rule

**Status:** Proposed (starts at S22, after BACKLOG-011 sets the trial up)
**Priority:** Medium
**Extends:** BACKLOG-011 (trial setup); DSM_0.2 §10/§10.1 and DSM_6.0 §1.3 only if the result goes upstream
**Date Created:** 2026-10-23
**Origin:** Split from BACKLOG-011 in S21 (DSM_0.2 §21: setup and evaluation have independent success criteria; one BL would hold its Level 3 branch open for the whole window).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-025).

---

## Problem Statement

BACKLOG-011 puts the reference-read protocol in place as a fork-local trial. The research behind
it (`dsm-docs/research/2026-10-15_reference-reading.md`, section 4) rests on two cases, so the
rule has to show in use that it catches gaps without firing on ordinary work. The window, the
counted categories and the decision rule were fixed in BACKLOG-011's answers 3 and 4; this BL
runs the window and applies the rule.

## Proposed Solution

- Run the protocol from the guide BACKLOG-011 creates in sessions S22-S26, logging every exchange
  and every correction in the trial log (`.claude/reference-read-log.md`, untracked).
- At the end of S26, take the counts from the log by command and apply the decision rule, first
  match wins (guide `dsm-docs/guides/reference-read-protocol.md` §5; order and the last case
  settled with the user in S21):
  1. **Keep** if the window holds at least one human correction.
  2. **Drop** if there are no corrections of either kind.
  3. **Narrow the trigger** if it fires more than 5 times per session on average over the window.
  4. **Otherwise** (self-corrections only, at most 5 per session on average), the user decides.
- Record the counts and the decision here (counts only; the log stays local because its entries
  can quote private or confidential sources and the user's words).
- If kept: decide whether to offer it upstream (BACKLOG-011's Upstream Contribution
  preconditions: a comparative pass against work outside DSM, and a name-free account of the
  reporting spoke's case).

## Success Criteria

- [ ] Sessions S22-S26 each have their exchanges logged, or a logged "no exchange" line.
- [ ] Counts per category (exchanges, human corrections, self-corrections) are produced by a
      command over the log and recorded here with the command.
- [ ] The decision (keep / drop / narrow / user decision) follows the rule above and is recorded
      with its counts.
- [ ] Follow-up recorded: guide kept, trigger narrowed (with the change), or guide and CLAUDE.md
      line removed; upstream offer decided if kept.

## Test Plan

- [ ] T-6 (trial; moved here from BACKLOG-011): the log has one entry per exchange in the format of
      guide §5: session, the human's answer (confirmed / human-correction), the self-corrected
      mark, location, passage, reading and, for a human correction, the user's words quoted; a
      session without exchanges has a `no-exchange` line. Check: every session S22-S26 appears in
      the log (`grep -c` per session).
- [ ] T-7: the recorded counts equal a recount from the log by the same command, run at close.
- [ ] T-8: the decision matches the rule applied to the recorded counts (show the arithmetic).

## Risks (per DSM_0.2 §21.2)

- **Self-measurement bias.** The agent logs its own exchanges and could under-log the ones that
  went badly. *Mitigation:* human corrections quote the user's words; counts come from the log by
  command; the user can read the log at any time.
- **Under-firing hidden as success.** A rule that never fires produces no corrections and reads as
  "drop", even if the agent simply did not apply it. *Mitigation:* the per-session "no exchange"
  line makes a silent session visible; the user may judge whether claims went unchecked.
- **Thresholds set without data.** The 1-correction and 5-per-session thresholds are uncalibrated.
  *Accepted:* the window is short and the decision is recorded with its counts, so a wrong
  threshold shows in the record.
- **Log loss.** The log is untracked; losing the machine's `.claude/` loses the evidence.
  *Mitigation:* each session's counts (counts only) are added to this BL's Test Execution Log at
  wrap-up, so an interrupted window keeps its numbers.

## Upstream Contribution

Decided at close (see Proposed Solution).

## Test Execution Log (per DSM_0.2 §21.3)

**S22 (2026-10-25, light wrap-up).** Counts by the guide §5 commands over the log: exchanges 0,
human corrections 0, self-corrections 0; one `- S22 |` line. Eleven claims were shown in two
blocks during inbox processing and none was answered before wrap-up, so the log holds one
`unanswered` line, which the commands do not count; the answers carry over to S23 (handoff
`2026-10-25_s22`). One shown passage was misquoted (a word repeated in place of another) and the
agent found it after showing it.

**Gaps found in S22:** the guide has no value for an exchange that is shown but not answered, and
none for an error the agent finds after showing (field 3 covers only changes made before showing).
Decide at S23 whether unanswered exchanges count once answered, and how.

### Pending verification

- [ ] T-6, T-7, T-8 (deferred to S26, end of the trial window)
