# Session 18 Handoff: upstream issue batch, triaged and rechecked

**Date:** 2026-10-19
**Date Completed:** 2026-10-22
**Outcome Reference:** Consumed at session 19 start
**Read with:** the S18 checkpoint (pending item 1), `dsm-docs/handoffs/done/2026-10-16_s17_backlog-011-and-upstream-feedback.md`
(the 13 S16/S17 feedback items) and fork BACKLOG-014 to -017.
**Status:** triaged; no issue drafted or posted. Every body is posted under the user's name and
needs the user's approval of its text before the `gh` call.

## Readiness checklist (Read-Before-Draft, DSM_0.2.D §9)

- Upstream (`albertodiazdurana/take-ai-bite`) has no `.github/` directory: no issue or PR templates.
- CONTRIBUTING.md: check existing issues first (done in S18: no duplicates among the 14 upstream
  issues); open an issue first for major changes; bug reports and inconsistencies between
  documents are explicitly welcome.
- House style of the fork's earlier issues (for example #142): the title states the problem in one
  sentence; the body has **Problem.** and **Proposed.**, optionally a reference-implementation note.
- Name-free (§21.5); cite file, section or step, and version v1.35.0.
- List every posted issue in tracking issue #130, which is stale: it shows PRs #136, #138 and #140 as
  open (all closed) and the boot-plan item as queued (absorbed in v1.35.0). Issue #135 is still
  open although its concern was absorbed in v1.34.0 (fork BACKLOG-004).
- Posting goes through the egress hook: write each body file in one call and send it in the next.

## Triage (all claims rechecked against upstream/main v1.35.0 in S18)

| Wave | Id | Issue | Source | S18 recheck |
|---|---|---|---|---|
| 1 | A | `/dsm-go` and `/dsm-staa` boot snippets fail silently on macOS: `stat -c %Y` prints age 0, and the Step 6 pid walk compares `comm` exactly to `claude` | S17 items 7 + 8 | `stat -c %Y` once in each skill; exact compare once in `/dsm-go` |
| 1 | B | `/dsm-wrap-up` Step 0.5 assigns a variable named `path`, which zsh ties to `PATH` | S17 item 11 | one `path=$(` assignment |
| 1 | C | `/dsm-align` Step 11b checks `done/` only against `INDEX.md`, not a fork's `done/fork-INDEX.md` | S17 item 9 | 4 mentions of `done/INDEX.md`, 0 of `fork-INDEX` |
| 1 | D | `/dsm-go` Step 0c checks out an open task branch before Step 3 reads handoffs and checkpoints | S16 item 2 | step order unchanged |
| 1 | E | Five `.claude/commands/` copies lag `scripts/commands/` | S17 item 13 | `dsm-go` +6/-7, `dsm-light-go`, `dsm-refresh-all`, `dsm-refresh-memory` 1/1 each, `dsm-staa` +1/-30; `dsm-wrap-up` and `dsm-align` match |
| 1 | F | The mirror-sync manifest (category 7) lists `scripts/check-mirror-sync-content.sh` as mirrored 1:1; upstream does not ship it | S18 | upstream `scripts/` has commands, three `.py` files, `sync-commands.sh`, templates |
| 1 | G | A stray line, "Confirm that you understand what I need. Be concise in your work.", sits in the always-loaded DSM_0.2 core | S17 item 12 | present once |
| 2 | H | DSM_0.1 §8 places Sources last; the `/dsm-research-add` stub places it second | S16 item 1 | stub: Purpose, Sources, Findings, Conclusion |
| 2 | I | DSM_0.2.F numbers its gates 0-3 while §8.10 and the CLAUDE.md template number prose gates 1-4 | S16 item 4 | "Gate 0" 9 times, "Gate 4" 3 times in F |
| 2 | J | `/dsm-go` Step 2b reports inbox files as entries, though one per-source file can hold several | S16 item 3 | "pending entries" wording present |
| 2 | K | Worklog User blocks record a summary, which logs the agent's reading of a terse prompt as the prompt; keep the literal words and mark the reading | S16 item 5 | "Summary of the user's prompt" present in §6 |
| 3 | L | BACKLOG-014 (includes S17 item 10) | fork BL | §20.2 and Step 10 unchanged |
| 3 | M | BACKLOG-015 | fork BL | nothing in §7 or DSM_0.2.G |
| 3 | N | BACKLOG-016 | fork BL | nothing in DSM_0.2.G |
| 3 | O | BACKLOG-017 | fork BL | §8.10 Gate 3 has no budget check |

Held, not an issue: S16 item 6 (does §10's internal-read exemption apply to §10.1) travels upstream
with BACKLOG-011 once its preconditions are met.

## Recommended order

1. Refresh #130 (list waves 1-3 and their state) and close #135; show both texts to the user first.
2. Wave 1 drafts into one review file, `dsm-docs/feedback-to-dsm/2026-10-19_s18_upstream-issue-drafts.md`
   or a dated successor; the user edits and approves per issue; post approved ones one at a time.
3. Waves 2 and 3 after Central responds to wave 1, so the open set stays reviewable.

## Pitfalls met while preparing this

- Rechecking with `git show upstream/main:path` in zsh corrupts the expression (`$U:scripts`
  applies zsh's `:s` modifier) and returns silent zeros; run rechecks under bash with a self-test.
- A command that only quotes a posting `gh` call is checked by the egress hook too; build such
  strings split or read them from a file.
