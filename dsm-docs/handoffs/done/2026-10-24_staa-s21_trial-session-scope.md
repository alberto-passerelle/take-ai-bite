# STAA Handoff (S21 analysis): settle how STAA runs and parallel sessions count in the reference-read trial before S22

**Date:** 2026-10-24
**Source:** `/dsm-staa` analysis of Session 21, written with the user's approval (STAA's own write list
does not include handoffs)
**Branch:** none; the file is untracked until the next `/dsm-go` Step 3 consumes it
**Consumer:** the next `/dsm-go` (S22, the first session of the trial window)
**Date Completed:** 2026-10-25
**Outcome Reference:** Consumed at session 22 start

This file ships with the public fork. It names no Central PR, issue, commit or active-backlog
numbers and no spoke, client or person names.

---

## 1. Reference-Read Trial Session Scope Gap

`dsm-docs/guides/reference-read-protocol.md` applies to any session in this hub during S22-S26
("Applies when", lines 6-12). It does not say how two session types inside that window are
treated:

- **STAA runs.** `/dsm-staa` writes only the files listed in its Notes
  (`scripts/commands/dsm-staa.md`); `.claude/reference-read-log.md` is not among them. A STAA run
  that presents findings drawn from a transcript meets both "Applies when" conditions but cannot
  log the exchange.
- **Parallel sessions.** `/dsm-parallel-session-go` numbers them `{N}.{M}` (e.g. 22.1). The
  guide's counting commands (section 5, lines 102-104) anchor on `^- S[0-9]+ [|]`, so a line
  labelled `- S22.1 | ...` is not counted. Tested 2026-10-24 on a scratch log in zsh and bash:
  3 exchanges (1 human correction) gave `exchanges=1 human=0`. A correction logged by a parallel
  session would vanish, and the decision rule's first clause (keep, if at least one human
  correction) depends on that count.

## 2. Decision Needed Before the First Exchange

| Session type | Recommended | Alternative |
|---|---|---|
| STAA run | Exempt it from the trial in the guide: it analyses a closed session, and its lessons are already reviewed one by one | Log its exchanges, which needs a change to the synced `dsm-staa.md` that an upstream merge would overwrite |
| Parallel session | Log under the main session's label (`S22`), so the existing commands count it | Keep `S22.1` and widen the three patterns to `S[0-9]+(\.[0-9]+)?` |

Where: one or two lines in the guide ("Applies when" and section 5), recorded in BACKLOG-025.
Retest the counting commands after the edit, with a parallel-session line in the test log.

## 3. Other Items From This STAA Run

- `.claude/last-staa.txt` now names Session 21. The S20 STAA run had appended its lessons but not
  written the marker, so the S21 boot raised a STAA reminder for S20 that did not apply.
  Fork-local BL candidate: `/dsm-staa` Step 2 and `/dsm-go` Step 5.7 take the last analysed session
  from both the marker and the newest `[STAA] S{N}` entry in `.claude/reasoning-lessons.md`.
- For the user's review: the S21 handoff calls the guide text "as approved section by section",
  but T-3 added one clause to guide section 4 after the guide was approved ("unless section 3
  exempts it", line 78). The change is logged in BACKLOG-011's Test Execution Log.
