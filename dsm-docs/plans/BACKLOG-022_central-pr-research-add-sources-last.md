# BACKLOG-022: Send Central a Fix So the /dsm-research-add Stub Puts Sources Last

**Status:** In Progress (merged on Central 2026-10-24; awaiting the release that ships it)
**Priority:** Low
**Extends:** Central's `/dsm-research-add` ("Header stub template"); DSM_0.1 §8 (Citation Standards: research documents end with a `## Sources` section, categorized by topic)
**Date Created:** 2026-10-22
**Origin:** S16 feedback item 1; S18 triage claim H; S20 recheck against v1.37.1.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-022).

---

## Problem Statement

DSM_0.1 §8 places a research document's citations in an end-of-document `## Sources` section. The
header stub that `/dsm-research-add` writes puts `## Sources` second, between Purpose / Question and
Findings, so every research file the skill creates starts in the order the standard rules out. S16
met the contradiction while drafting a research file whose approved outline followed DSM_0.1. The
stub came with Central's BL-425, whose file says nothing about section order.

## Proposed Solution

Move `## Sources` after `## Conclusion` in the stub and let its placeholder name the rule ("last
section, categorized by topic, per DSM_0.1 §8"). Stub only; existing research files keep their
order. No Central BL file, no CHANGELOG version (S19 decision). The owner merges.

## Success Criteria

- [x] The stub's section order is Purpose / Question, Findings, Conclusion, Sources.
- [x] Nothing else in the corpus states the old order.
- [x] The pull request is opened on Central with a body the user approved; nothing pushed to `main`.

## Test Plan

- [x] T-1: the diff touches only the stub (`git diff --numstat`: 1 file, +4/-4).
- [x] T-2: section order extracted from the fenced stub, before and after.
- [x] T-3: corpus sweep (`scripts/commands/`, DSM documents, `dsm-docs/guides/`) for text stating the
      stub's order.

## Risks (per DSM_0.2 §21.2)

- **The order was deliberate** (sources noted first while researching). *Mitigation:* the BL that
  introduced the stub gives no reason; the PR states the check so the owner can correct it.
- **Existing research files now differ from the stub.** *Accepted:* DSM_0.1 asks for no retrofit.

## Upstream Contribution

This BL is the contribution: a pull request on Central.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S20) on macOS. Scratch copies of the fork's files at v1.37.1, which equals Central
`main` (tag v1.37.1 on Central `main`, checked with `git describe`). The PR branch was cut from
Central `origin/main` in a temporary worktree; the file there was byte-identical to the reviewed
base (`cmp`) before the change was copied in.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | `git diff --numstat`: `4 4 scripts/commands/dsm-research-add.md`, asserted before commit |
| T-2 | PASS | Before: Purpose / Question, Sources, Findings, Conclusion. After: Purpose / Question, Findings, Conclusion, Sources |
| T-3 | PASS | 0 other hits for the stub's section names in the swept paths |

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, PR head = local HEAD, live body = approved file.
- [x] Owner's merge: merged into Central `main` on 2026-10-24. S23 check (2026-10-26): the file there
      is byte-identical to the PR head, and the stub order is Purpose / Question, Findings,
      Conclusion, Sources.
- [ ] The release that ships it; then Status Implemented and move to `done/`.
