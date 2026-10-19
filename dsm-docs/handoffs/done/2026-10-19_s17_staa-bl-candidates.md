# Session 17 STAA Handoff: six BL candidates for the next session

**Date:** 2026-10-19
**Date Completed:** 2026-10-19
**Outcome Reference:** Consumed at session 18 start
**Origin:** `/dsm-staa` analysis of the Session 17 worklog (6 `[STAA] S17` lessons appended to
`.claude/reasoning-lessons.md` the same day)
**Status:** candidates only, none filed. STAA files no BL and commits nothing, so this file is
uncommitted; the next `/dsm-go` Step 3 reads it and moves it to `done/`, the next wrap-up commits it.
**Read with:** `2026-10-16_s17_backlog-011-and-upstream-feedback.md` (same folder). Its feedback
item 10 overlaps candidate 3 below.

## Filing these candidates

1. File each one through the DSM_0.2 §21.5 workflow: name-free body, Risks (§21.2), a Test Plan,
   an `**Extends:**` line, and the README row, committed on the branch sessions start from.
2. Numbers start at 012. BACKLOG-011 is already reserved for the reference-reading research.
3. For the candidates marked upstream, check the upstream issue list for an existing issue before
   drafting, as the S17 handoff asks for its own feedback set.
4. Suggested order: 1 first (confidentiality, public repo), then 2, then 3-6 together with the
   S17 feedback candidates.

| # | Working title | Priority | Lands in |
|---|---|---|---|
| 1 | Remove the reporting spoke's name from the public fork's main | High | Fork only |
| 2 | Check for names before pushing to the public fork | Medium | Fork, then upstream |
| 3 | Run the §20.2 check whenever a plan merges into main; name upstream syncs as an exception | Medium | Upstream |
| 4 | A turn that does something its plan ruled out appends a revised plan first | Low | Upstream |
| 5 | Keep the worklog rules in harnesses where the hooks do not run | Low | Upstream |
| 6 | Check word count against the section budget for each bite at Gate 3 | Medium | Upstream |

## 1. Remove the reporting spoke's name from the public fork's main

**Problem.** The S17 publish check (10:05) found a session artifact naming the reporting spoke,
against the name-free rule of §21.5. The adopted recommendation (10:49) was to leave it, partly
because the fork's history already carries the name. The S17 fork-sync PR then brought that
artifact into the public main for the first time (checked by the STAA run: absent from main
before the PR, present after it).
**Proposal.** Sweep the public main, every pushed branch and every pushed tag (the `archive/bl-*`
tags included) for the name, and replace each hit with "a downstream spoke". Supply the name at
run time from a gitignored list; never write it into the BL.
**Success sketch.** The sweep returns zero hits on the current tree of main, and was first shown
to find the name in a known file (§19.1). The history decision is recorded either way.
**Open question for the user.** Rewriting history needs a force-push, which the Destructive
Command Protocol allows only on explicit request. Fixing the current tree does not need one.

## 2. Check for names before pushing to the public fork

**Problem.** §21.5 says fork-local content is "name-free, always", and nothing enforces it. In
S17 the check ran by hand, found the hit, and the hit still shipped.
**Proposal.** Before any push or PR to the public fork, grep the outgoing diff
(`git diff origin/main...HEAD`) against a gitignored deny-list and halt on a hit. Fork-local
first; offer it upstream as an addition to the egress discipline §21.5 cites (DSM_0.2.C §5.7,
§5.8).
**Success sketch.** A planted test name in a scratch commit stops the push. A clean diff passes.
**Split note.** Kept apart from candidate 1 per §21: remediation and prevention succeed
independently.

## 3. Run the §20.2 check whenever a plan merges into main

**Problem.** §20.2 lets a session branch reach main only at wrap-up and only once every Level 3
branch is merged back. In S17 the fork-sync PR merged the session branch into main mid-session
(main `360d5f2`, 12:15) while bl-011 held unmerged work (S16's `e1bca8b`; on 2026-10-19 bl-011
is not an ancestor of main and is 11 commits ahead). The 10:05 plan did not name this as an
exception. At 20:12 the same rule was the reason wrap-up Step 10 was skipped.
**Proposal.** (a) Any plan with a step that merges into main lists the open Level 3 branches and
states the §20.2 exception it relies on. (b) §20.2 either names an upstream sync as an allowed
mid-session merge to main, or routes it through a dedicated sync branch. Which of the two is a
decision for the BL.
**Related.** S17 handoff feedback item 10 (Step 10 does not restate §20.2). One upstream issue
could carry both.

## 4. Revised plan when a turn leaves its plan

**Problem.** The 09:59 plan said "Read-only investigation first ... decisions belong to the
user". The 10:05 output of the same turn reports stray `.git` files deleted and a memory write
attempted (blocked by the cross-repo hook). The user's "resolve the issues" may have covered the
deletion, but the worklog does not record that reading.
**Proposal.** A clause in §7 or DSM_0.2.G: when a turn is about to do something its plan block
ruled out, it appends a revised Plan block first, or its Output names the user's words that
authorized it. Scope it to writes, deletions and outward-facing actions so it does not fire on
every small deviation (§8.9.2 over-firing guard).

## 5. Worklog rules in harnesses where the hooks do not run

**Problem.** The S17 boot ran first in Cowork, where no hooks fire. Its first Plan block is
stamped 07:31 (UTC, the VM clock) and lists Steps 0-6 as already done; the matching Output is
stamped 09:31 (local) for the same moment. The log shows a two-hour gap that did not happen, and
an after-the-fact summary labelled as a plan without the `[RETROACTIVE]` marker.
**Proposal.** DSM_0.2.G guidance for hook-less harnesses: stamp in local time or mark UTC
explicitly, label entries written after the work `[RETROACTIVE]`, and have the session that
adopts such a boot note the clock offset in its first Output.
**Related.** The S17 `[auto]` lesson on adopting a Cowork boot instead of re-running Steps 5.5/6.

## 6. Per-bite budget check at Gate 3

**Problem.** Section budgets set at Gate 2 were not checked while drafting. S16: eight of nine
drafted sections ran over. S17: Gate 4 trims took the note from 1,949 to 1,829 words; the 17:06
entry says reaching 1,600 "needs about 270 beyond Tier 1, i.e. cutting prose approved bite by
bite", and the note was signed off over that figure. Whether 1,600 was a cap or a target is not
recorded in the worklog.
**Proposal.** In §8.10, each Gate 3 bite is delivered with its word count against its section
budget, and an overrun is accepted or cut at that bite, not at Gate 4. The budget names its
measure: S17's measure (tokens with a letter or digit, headings and table separators excluded)
gave 1,949 where `wc -w` gave 2,128.
**Success sketch.** §8.10 states the per-bite check; the next prose deliverable shows a count
with every bite.
