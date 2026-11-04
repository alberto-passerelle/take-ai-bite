# BACKLOG-038: Let the Agent See the Worklog Clock-Drift Warning, Not Only the User

**Status:** Proposed (Gate 1 open)
**Priority:** Low
**Extends:** `.claude/hooks/validate-transcript-edit.sh` Check 4 (delimiter time against the wall
clock); `scripts/templates/settings-hooks.json` if a new hook entry is needed.
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. A delimiter typed into an Edit was
683 minutes off; Check 4 warned, the agent did not see the warning and carried on.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-038).

---

## Problem Statement

Check 4 warns and never blocks: it exits 1 (`validate-transcript-edit.sh` L298). A non-zero, non-2
hook exit reaches the user and the session log but not the agent's tool result (measured and
recorded in the comment block of `validate-cross-repo-write.sh`). So the one reader
who can fix the stamp at once never learns it is wrong, and the worklog keeps a wrong time.

## Proposed Solution (sketch for Gate 1)

Route the warning to the agent. Candidates, to be checked against the Claude Code hook documentation
before Gate 2 (and captured per DSM_0.2 §10 if fetched): a PostToolUse check that returns the
warning to the model; or a block (exit 2) with the reason, so the agent redoes the append with a
correct stamp.

Open for Gate 1: which channel; whether a block is acceptable for an append.

Note: BACKLOG-030 would stop per-turn worklog writes in this hub; spokes keep them, so the gap stays
there.

## Success Criteria (draft)

- [ ] A drifted delimiter produces a message the agent receives in the same turn.
- [ ] A correct delimiter produces nothing.

## Test Plan (draft)

- [ ] T-1: the chosen channel confirmed in the documentation, with the source recorded.
- [ ] T-2: hook fed a drifted and a correct delimiter on stdin: exit code and output as designed.
- [ ] T-3: in a live session, a drifted append: the agent's next step shows it received the warning.
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` on the hook.
- [ ] T-5: egress sweep of the diff and the commit message, counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **A block on drift interrupts every turn when the clock source is wrong:** mitigation: Gate 1
  weighs warn-to-agent against block; Check 4's tolerance stays.
- **The documented channel behaves differently in this harness:** mitigation: T-3 tests it live.
- **Upstream drift on the hook:** mitigation: send the change upstream.

## Upstream Contribution

Offer to Central as an issue plus a PR (DSM_0.2 §21.5), when a PR slot is free.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
