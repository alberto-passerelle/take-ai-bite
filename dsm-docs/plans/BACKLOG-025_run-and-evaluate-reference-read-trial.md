# BACKLOG-025: Run the Reference-Read Trial for Five Sessions and Decide Whether to Keep, Narrow or Drop the Rule

**Status:** In Progress (trial window S22-S26; S22-S24 run)
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

**Related (S22):** BACKLOG-027 (source maps and a validator per drafted bite) is kept separate.
Both check a statement against the passage instead of the memory of a read; 027 covers drafted
prose in a deliverable, this trial covers claims used in plans, decisions and messages.

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

**S22, continued (light continuation and full wrap-up, 2026-10-25).** Counts by the guide §5
commands over the whole log at wrap-up: exchanges 11, human corrections 0, self-corrections 0.
All 11 claims shown in S22 were answered in the continuation: 6 through the user's approval of a
package whose message said beforehand that approving it confirms the readings it rests on, and 5
with an explicit "readings ok" given in the same reply as an outbound approval. The log also holds
two `unanswered` status lines and two `note` lines (a typed time in one log line, then a wrong time
in its first correction); the commands count none of them.

**Added for the S23 decision:** whether a confirmation bundled with another approval counts the
same as a separate answer. All 11 S22 confirmations were bundled.

**S23 (2026-10-26, full wrap-up).** Counts by the guide §5 commands over the whole log at wrap-up:
exchanges 18, human corrections 0, self-corrections 0; S23 alone: 7, 0, 0, with no `unanswered`,
`note` or `no-exchange` lines. The 7 claims (readings of an upstream project's text, used to
check fork BLs against it) were shown in one block and confirmed in one reply whose own clause
confirmed them ("confirm readings 1-7"), in the same message as an action approval: a third
bundling shape next to S22's two. The three gaps and the scope question were not decided in S23;
the options, with the decision rule applied to today's counts, are prepared for S24. Applied to
today's counts, rule 2 (drop) matches; counting S22's after-show misquote as a self-correction
would make rule 3 (narrow, 18 exchanges over 2 sessions) match instead.

**S24 (2026-10-27): the three gaps and the scope decided.** The user chose the recommended option
for each; the guide's "Applies when" and §5 changed in the same commit as this entry.

- Gap 1: an exchange is logged when answered, under the session that showed it; an `unanswered`
  status line holds it until then. One still unanswered when S26 closes counts toward rule 3's
  rate only.
- Gap 2: field 3 gains `self-corrected-after-show`, counted as a self-correction. S22's after-show
  misquote is marked by one retro `note` line; the original line is not rewritten.
- Gap 3: a confirmation given only through a package approval still counts as `confirmed`, with a
  trailing `bundling: implied` field and its own count. The six S22 lines of that shape are marked
  by retro `note` lines; the agent now asks for confirmations as their own question.
- Scope: `/dsm-staa` runs are exempt; a parallel session logs under the main session's label.

Test of the guide's four commands, extracted from the guide and run on a scratch log with one
line per shape (including a passage that holds the field words): exchanges 6, human corrections
1, self-corrections 3, implied confirmations 2, all as expected; the old self-correction pattern
gives 1 on the same log, so the widening shows. Recount of the real log by the same commands:
exchanges 18, human corrections 0, self-corrections 1, implied confirmations 6. Applied to these
counts: rule 1 does not match (no human correction), rule 2 does not match (one self-correction),
rule 3 matches (18 exchanges over S22-S23, 9 per session, more than 5): narrow. S24's first seven
readings are so far logged as unanswered.

**External evidence (S24, inbox):** a downstream spoke reported two more cases of the failure this
trial tests: a delegated read's framing carried unverified into plans and a message, and a
paraphrased key term that changed meaning in four plan files. Both were corrected from the source
side (the document's owner; a verification pass).

**S24 (2026-10-27, full wrap-up).** Counts by the guide §5 commands over the whole log at wrap-up:
exchanges 54, human corrections 0, self-corrections 2, implied confirmations 6. S24 alone: 36
exchanges, 0 human corrections, 1 self-correction, 0 implied; plus 1 `unanswered` line (closed
by a note when the seven readings were answered) and 3 `note` lines. Every S24 confirmation was
asked as its own question, as the gap-3 decision requires. The S24 self-correction is an
after-show one: a confirmed reading called a snippet's failure "silent", and running the snippet
showed an error message and a blocked write. One of the notes corrects a time typed into a log
line instead of taken from the clock. Applied to these counts: rule 1 does not match, rule 2
does not match (two self-corrections), rule 3 matches (54 exchanges over S22-S24, 18 per session,
more than 5): narrow. S24 alone fired the trigger 36 times, mostly over inbox lessons and
upstream backlog passages, which is the volume the narrow rule would have to address.

**S25 (2026-10-28, full wrap-up).** Counts by the guide §5 commands over the whole log at wrap-up:
exchanges 81, human corrections 1, self-corrections 3, implied confirmations 10. S25 alone: 27
exchanges, 1 human correction, 1 self-correction, 4 implied; plus 3 `note` lines. The human
correction is the trial's first: a reading said that adopting BACKLOG-027 in the fork needed a new
BL, and the user's question whether 027 would be enough changed the claim to "027 suffices once
amended". It is logged as a correction because the question changed what the claim asserted, not
its wording; that classification decides the rule, so the user should confirm it at S26. The four
implied confirmations come from one question round whose wording said beforehand that choosing an
option confirms the comparison. At the fifth bite of a drafted guide the user stopped the question
rounds and asked for a validator agent instead; from then on, claims inside drafted bites were
checked by the validator and not logged as exchanges (a `note` line records the switch). Applied to
these counts: rule 1 matches (one human correction): keep. Rule 3 would also match (81 exchanges
over S22-S25, about 20 per session), and the user's stop is direct evidence for narrowing the
trigger, so the S26 decision should weigh both.

### Pending verification

- [ ] T-6, T-7, T-8 (deferred to S26, end of the trial window)
