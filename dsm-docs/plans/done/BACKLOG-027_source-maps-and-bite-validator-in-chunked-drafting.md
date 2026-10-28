# BACKLOG-027: Offer Source Maps and an Independent Validator for Each Drafted Bite as a Gate 1 Option in Chunked Drafting

**Status:** Implemented (S25, 2026-10-28; kept local; Central issue open)
**Priority:** High
**Extends:** DSM_0.2.F §8.10 (Chunked Drafting Protocol, Gates 1, 3 and 4); DSM_3.0.E §6.7.3 (AI Collaboration Norms); a validator agent template shipped with the skills
**Date Created:** 2026-10-25
**Date Implemented:** 2026-10-28
**Origin:** Backlog proposal from a downstream spoke, received 2026-10-24 through the inbox and processed in S22. The user named it the only priority in that inbox file and approved the scope, route and evidence decisions (S22, B1-B4).
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-027).

---

## Problem Statement

Chunked drafting (DSM_0.2.F §8.10) has the user review each bite before the next one, but the
review sees only the text. After each bite the user reviews, flags or approves, and the agent moves
on (F lines 1019-1022). Nothing in the draft shows which source determines a statement, whether its
wording is verbatim, paraphrased or the agent's own interpretation, or whether the source was read
in the original or through a summary, a handoff or a subagent extract. The reviewer cannot check
borrowed wording bite by bite, and later nobody can trace where a statement came from.

Checked in S22 against this fork (TAB 1.37.1) and Central's main, identical for DSM_0.2.F:

- §10.1 (validation depth) covers claims that will be cited or quoted in a user-facing artifact,
  but its passes run "before synthesis" (core lines 258-263, 275). It is adjacent to the drafting
  step, not a check on it.
- §6.7.3 has every project create `dsm-docs/guides/ai-collaboration.md` (DSM_3.0.E lines 109-110),
  with no fields for sources, reading rules or confidentiality boundaries.
- A 10-term search of `DSM_*.md` found no per-bite source mechanism.

## Proposed Solution

Sent to Central as a proposal (S22). In S25 the user decided to adopt it in this fork without
waiting for Central's answer: a fork-local guide, `dsm-docs/guides/consequential-drafting.md`,
carries the method (the spoke's name for it: consequential drafting) and the validator agent
template, and DSM_0.2.F §8.10 Gate 1 gains one line offering it. Every spoke imports this hub's
DSM_0.2, so the line reaches all of them. This adds an option and contradicts no Central rule
(§21.5). The spoke's design, in name-free form:

- **Option at Gate 1.** §8.10 Gate 1 gains a sixth item next to purpose, audience, outcome, length
  and scope: "Should every bite carry a source map and a validator run?" Worth offering when the
  document draws on sources whose wording matters (specifications, minutes, contracts,
  regulations); off for prose without sources.
- **R1 Bite and map.** With the option on, every bite written into the draft file is followed by its
  source map, separated by comment markers so the pairing can be checked with `grep` and the maps
  can be moved at assembly without touching the text. One row per source: source ID or path, where
  and when it was read, what it determines in this bite, location, verbatim terms with their
  location. A last row, "our interpretation", lists what no source determines.
- **R2 Originals only.** A map cites originals read where they live. Summaries, handoffs and
  subagent extracts may point to an original; they never ground a row.
- **R3 Validator.** A subagent with a fresh context, on a different model and without the drafting
  conversation, checks each bite against its map while the user reviews the same bite: coverage,
  verbatim terms, determination, originals, confidentiality, interpretation presented as a
  source's statement. It reports findings (blocker / fix / note) and ends with "writes: none". A
  bite counts as approved once the user approves it and every finding is fixed or answered; a
  blocker that arrives after approval reopens the bite.
- **R4 Project guide.** Projects that turn the option on record in the §6.7.3 guide: source IDs and
  where they resolve, the reading rule (R2), the policy for agent-made copies, the
  confidentiality boundary and the validator setup. If they are missing, the agent sets them up at
  Gate 1, before the first bite.
- **Template.** A validator agent template ships with the skills (for example
  `.claude/agents/bite-validator.md`, read-only tools), with one read tool per source type; the
  Gate 1 setup checks that the project's source types are covered.

**Evidence.** Interim: one downstream spoke tested it on one document, and the spoke's own adopt /
adjust / drop decision was pending when it sent the proposal. The spoke's measurements (issues
caught, findings, map length, validator cost) go to the Central issue only, not into this public
file (S22 decision B3).

**Open questions carried from the spoke:** where the maps go at Gate 4 (an appendix for internal
documents, a companion file for documents that leave the team); row granularity (one row per
source, as tested, or one per statement); whether the confidentiality check also covers details
carried over from another confidential context.

**Scope note (DSM_0.2 §21).** One BL for the whole mechanism (S22 decision B1). The template's
distribution is a split candidate: `scripts/sync-commands.sh` has no path for agent files (0
references in S22), so shipping the template is a different execution context from the protocol
text. Split it out if Central accepts the proposal.

**Related fork-local items:**

- BACKLOG-025 (reference-read trial): kept separate (S22 decision B4). Both check a statement against
  the passage instead of the memory of a read; 025 covers claims the agent uses in plans,
  decisions and messages in this hub, 027 covers drafted prose in a deliverable, bite by bite.
- BACKLOG-017 (per-bite budget check at Gate 3): also adds to what each Gate 3 bite carries. If both
  land, the bite delivery names its word count and its map; the wording should be coordinated.

## Success Criteria

- [x] Central issue posted with the text the user approved; its number stays out of this fork.
- [x] Fork-local adoption decided: adopt now, before Central answers (S25).
- [x] `dsm-docs/guides/consequential-drafting.md` exists: name-free, R1-R4 and the six validator
      checks stated generally, an invented example, and a validator agent template that a project
      copies into its `.claude/agents/` at Gate 1.
- [x] The guide has its row in the Fork-local guides section of `dsm-docs/guides/README.md`.
- [x] DSM_0.2.F §8.10 Gate 1 offers the option in one line that points to the guide.

Not blocking the close (§21.5: "kept local and its local work is complete"):

- Central's response, recorded here when it arrives: accepted (with `**Central BL:**` when known),
  declined with a reason, or deferred. If Central ships its own version, the fork's line and guide
  are reconciled with Central's text at the next fork-sync, Central's text winning.

## Test Plan

For the fork implementation (S25); run on the `bl-027` branch before merge:

- [x] T-1: DSM_0.2.F §8.10 Gate 1 holds the option line, and the line names the guide path; `grep`
      returns 1 hit for the path in F.
- [x] T-2: every spoke's `@` line resolves to this hub's DSM_0.2 core, the file that dispatches to
      F (`grep` over the spokes' `.claude/CLAUDE.md`, a count, no names).
- [x] T-3: on a sample draft in a scratch directory, the counts of bite markers and map markers are
      equal (`grep -c`), and removing one map makes the counts differ (positive control).
- [x] T-4: a validator run from the guide's template, on a sample bite of a few lines with one
      deliberately wrong verbatim term, reports a verbatim finding and ends with "writes: none".
- [x] T-5: the guide lists the R4 fields (source IDs and where they resolve, reading rule, copies
      policy, confidentiality boundary, validator setup); `grep` per field.
- [x] T-6: the guide's row is in the Fork-local guides section of `dsm-docs/guides/README.md`.
- [x] T-7: the added lines are name-free: the fork's pre-commit sweep (numbers, IDs, the name list
      with its coverage) plus the spoke directory names built by script, 0 hits.
- [x] T-8 (resolver, DSM_0.2 §21.4): sweep for any string the change removes or renames; record the
      sweep even when empty.

The upstream version (Gate 3 wording in §8.10, R4 fields in DSM_3.0.E §6.7.3, a distribution path
for the template) is Central's to test if it ships its own.

## Risks (per DSM_0.2 §21.2)

- **Cost per bite.** A validator run per bite spends substantial tokens and time. *Mitigation:*
  opt-in at Gate 1, offered only where wording matters; the run happens while the user reviews, so
  it adds no waiting time.
- **Thin evidence.** One spoke, one document. *Mitigation:* the issue says the evidence is interim
  and carries the open questions; Central decides with that stated.
- **Confidential reads and copies.** The validator reads originals, including confidential ones,
  and tools cache large reads as files. *Mitigation:* R4's copies policy covers the validator's
  reads; a source the validator cannot read is a blocker, not a guess.
- **Template silently missing in spokes.** The deploy script has no path for agent files, so a
  shipped template may never reach a spoke. *Mitigation:* split the distribution out on
  acceptance; T-5 checks the deployed copy.
- **Overlapping rules.** §10.1 and BACKLOG-017 touch the same ground. *Mitigation:* the issue names
  §10.1 as adjacent; 017 and 027 cross-reference each other's Gate 3 additions.

## Upstream Contribution

Route chosen in S22 (decision B2): a Central issue now, stating that the evidence is interim and
carrying the three open questions and the spoke's measurements (no document content, no spoke
name). Posted only after the user approves the full text (voice-attribution gate). Its number is
kept out of this fork.

**Sent (S22, 2026-10-25):** as an issue on Central with the user-approved text; read back after
posting, title and body equal to the approved draft.

## Test Execution Log (per DSM_0.2 §21.3)

Run on `bl-027/consequential-drafting-guide`, 2026-10-28 (S25), after the guide commit.

- T-1: pass. `grep -c` for the guide path in DSM_0.2.F returns 1 (§8.10 Gate 1 item 6).
- T-2: pass. 4 of 4 spokes' `.claude/CLAUDE.md` files carry an `@` line that resolves to this
  hub's `DSM_0.2_Custom_Instructions_v1.1.md` (the file exists); the core names DSM_0.2.F 3 times.
- T-3: pass. A 2-bite sample draft in a gitignored scratch folder counts BITE / MAP / /MAP as
  1 / 1 / 1 for n = 1 and 2. Control: the same draft with map 2 removed counts 1 / 0 / 0 for n = 2.
- T-4: pass. A Sonnet subagent given the template's instructions checked a one-sentence sample bite
  whose map carried a verbatim term that differs from the original. It reported a V2 blocker on
  that term and a V3 fix following from it, used Read only, and ended with "writes: none". The run
  used the general-purpose fallback the guide describes, not an installed agent file.
- T-5: pass. The guide's §2 table names all five R4 fields (Source IDs, Reading rule, Copies policy,
  Confidentiality boundary, Validator setup); `grep`, at least 1 hit each.
- T-6: pass. One row for the guide, in the Fork-local guides section of `dsm-docs/guides/README.md`.
- T-7: pass. Sweep of the 207 added lines: `#NNN` 0, hex IDs 0, BL references 2 (both this BL),
  Central item numbers 0, name list 0 hits against a 1-entry list, spoke directory names 0 hits
  against 4.
- T-8: the guide commit removes or renames nothing. The amendment commit replaced 16 lines of this
  BL; their opening fragments occur 18 times in 6 sibling fork BLs (008, 014-017, 026), each in
  that BL's own text for a proposal still with Central: deliberate, none stale. Control: a known
  string elsewhere in the corpus was found (1 hit).

Drafting record: 8 bites under §8.10. Bites 1-4 were checked by per-claim reading confirmations
(BACKLOG-025 trial); from bite 5 on, at the user's request, a Sonnet validator checked the bites
against the spoke's name-free proposal (header to §5 in one run; §6 to §8 twice, because the first
run stopped on an API safety filter before any check). Its fixes were applied before approval.

### Pending verification

- [x] All Test Plan items run on the bl-027 branch before merge (S25). Nothing deferred.
