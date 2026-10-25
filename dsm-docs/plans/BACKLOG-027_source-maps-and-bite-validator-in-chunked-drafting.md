# BACKLOG-027: Offer Source Maps and an Independent Validator for Each Drafted Bite as a Gate 1 Option in Chunked Drafting

**Status:** Proposed (Central issue drafted in S22; posted only after the user approves its text)
**Priority:** High
**Extends:** DSM_0.2.F §8.10 (Chunked Drafting Protocol, Gates 1, 3 and 4); DSM_3.0.E §6.7.3 (AI Collaboration Norms); a validator agent template shipped with the skills
**Date Created:** 2026-10-25
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

A proposal for Central; this fork does not edit the methodology files (§21.5). The spoke's design,
in name-free form:

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

- [ ] Central issue posted with the text the user approved; its number stays out of this fork.
- [ ] Central's response recorded here: accepted (with `**Central BL:**` when known), declined with
      a reason, or deferred.
- [ ] If Central ships it: §8.10 offers the option at Gate 1 and pairs each bite with a map and a
      validator run when it is on; §6.7.3 lists the R4 fields; the validator template has a
      distribution path.
- [ ] Fork-local adoption decided: use the option in this hub before Central ships it, or wait.

## Test Plan

For whoever implements it upstream:

- [ ] T-1: §8.10 Gate 1 lists the option; Gate 3 names the map and the validator run; `grep`.
- [ ] T-2: on a sample draft, the counts of bite markers and map markers are equal (`grep -c`), and
      removing one map makes the counts differ (positive control).
- [ ] T-3: a validator run on a sample bite with one deliberately wrong verbatim term reports a
      verbatim finding and ends with "writes: none".
- [ ] T-4: §6.7.3 lists the R4 fields; `grep`.
- [ ] T-5: the validator template reaches a spoke through the deploy mechanism (`diff -q` against
      the deployed copy).
- [ ] T-6 (resolver, DSM_0.2 §21.4): sweep for any string the change renames; record the sweep even
      when empty.

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

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, upstream implementation)
