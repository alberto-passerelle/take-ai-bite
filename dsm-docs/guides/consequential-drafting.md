# Consequential Drafting: Source Maps and a Validator per Bite (Fork-Local)

This guide defines an option for chunked drafting (DSM_0.2.F §8.10): every bite written into a
draft file is followed by its source map, and a second agent checks the bite against that map while
the user reviews it. It is fork-local and not part of upstream DSM (BACKLOG-027). One downstream
spoke tested it on one document; that test is interim.

**Applies when:** both hold.

1. A document is being drafted in bites under DSM_0.2.F §8.10.
2. The user turned the option on at Gate 1 (section 1 says when to offer it).

If either does not hold, stop reading.

## 1. Consequential Drafting Purpose and Offer

This section says what the option adds and when to offer it.

In plain chunked drafting the user reviews each bite's text and nothing else. The text does not
show which source determines a statement, whether its wording is verbatim, paraphrased or the
agent's own interpretation, or whether the source was read in the original or through a summary, a
handoff or a subagent extract. With the option on, each bite carries that record as its map, and a
validator that did not draft the bite opens the cited originals to check it. Later readers can trace
each statement back to its source. DSM_0.2 §10.1 asks for validation passes on research claims;
nothing checks the drafting step that turns sources into prose.

**Offer it at Gate 1** as a sixth item after purpose, audience, outcome, length and scope: "Should
every bite carry a source map and a validator run?" Offer it when the document draws on sources
whose wording matters (specifications, minutes, contracts, regulations); leave it off for prose
without sources.

**Cost.** Each bite gets one validator run, which spends substantial tokens and time. It runs
while the user reviews the bite, so it adds no waiting time unless the review finishes first
(section 5). Say both when offering the option.

## 2. Project Setup Before the First Bite

This section lists what the project records before the first bite (R4), in its AI collaboration
guide (`dsm-docs/guides/ai-collaboration.md`, DSM_3.0.E §6.7.3). Maps and validation rest on these
fields; set up any missing one with the user at Gate 1.

| Field | What it holds |
|---|---|
| Source IDs | Short IDs resolved in a source map kept outside the tracked draft, so the draft cites IDs, not titles |
| Reading rule | Originals only (R2, section 4): which originals exist and where each is read |
| Copies policy | Where tools, the drafting agent and the validator leave copies of what they read, and when the copies are deleted |
| Confidentiality boundary | What no bite or map may carry: names, amounts, file titles, details from another confidential context (section 5, V5) |
| Validator setup | The agent file from section 8, its model, and one read tool per source type |

**Validator agent.** Copy the template in section 8 to `.claude/agents/bite-validator.md` with a
read tool for every source type the document cites. A claim resting on a source the validator
cannot read comes back as a blocker, so match the tools to the sources now, or record the gap for
each bite. Claude Code picks up a new agent file within seconds, unless `.claude/agents/` did not
exist when the session started; then the file loads only in a new conversation (the tested setup
hit this). Until then, run the general-purpose agent on the template's model with the template's
instructions, and use its side-effect list as the control.

## 3. Bite and Map File Shape

This section fixes where bites and maps sit in the draft file (R1). Each bite is followed
immediately by its source map, separated by comment markers, so the pairing can be checked with
`grep` and the maps can be moved at assembly without touching the text.

```
<!-- BITE n: <TOC section(s)> -->
… bite text …
<!-- MAP n -->
**Map n** · serves TOC §x (approved YYYY-MM-DD)

| Source             | Read in the original       | Determines in this bite          | Location                                | Verbatim terms (location)           |
| ------------------ | -------------------------- | -------------------------------- | --------------------------------------- | ----------------------------------- |
| [ID] or repo path  | where and when it was read | (1) first item; (2) second item  | (1) heading, line or timestamp; (2) …   | "term" (heading, line or timestamp) |
| our interpretation | —                          | statements no source determines  | where the joined sources sit, if any    | —                                   |
<!-- /MAP n -->
```

One row per source that determines the bite. When a row lists several items, number them and give
each item's location under the same number. The last row, "our interpretation", lists whatever no
source determines.

## 4. Source Map Content Rules

This section states what a map may and may not contain.

1. Source IDs and locations only; no file titles, names or amounts. Files in this repository are
   cited by their path instead of an ID.
2. Originals only (R2), read in the session that drafts the bite, where they live: a repository file
   in place, a cloud document in its service, a chat message in the chat tool, or an export the user
   names as the source of truth, with its date. Summaries, handoffs, subagent extracts and
   agent-made copies may point to an original; they never ground a row.
3. A map quotes no more than its bite does; it must not become a channel for source text.
4. Whatever no source determines is listed under "our interpretation".
5. Approving a bite approves its map; changing a bite updates its map in the same edit.
6. Maps do not count toward section word budgets or a document's length cap.
7. An interpretation already recorded in an earlier map of the same document is referenced as
   "as Map n" instead of repeated.
8. Where a bite translates a source and the translation may not be reliable, keep the original term
   in parentheses.

## 5. Bite Validator Checks and Approval

This section defines the validator run that follows each bite (R3).

**When and who.** Right after the drafting agent writes bite n and map n, a read-only subagent on a
different model, with a fresh context and without the drafting conversation, checks the bite
against its map while the user reviews the same bite. Input: the draft file path, the bite number,
the file that resolves the source IDs, and the rule text (sections 3 to 5).

| #   | Check           | Question |
| --- | --------------- | -------- |
| V1  | Coverage        | Is every statement in the bite determined by a map row or listed as our interpretation? |
| V2  | Verbatim        | Does every verbatim term in the bite appear in the map, and word for word at the cited location in the original? |
| V3  | Determination   | Does each cited location in the original support what the row says the source determines? |
| V4  | Originals       | Is every source an original under R2, read where it lives? |
| V5  | Confidentiality | Are bite and map free of names, amounts, file titles and details carried over from another confidential context (beyond the tested version), and does the map quote nothing beyond the bite? |
| V6  | Interpretation  | Are our own conclusions marked as interpretation rather than presented as a source's statement? |

**Output.** A findings table (check, bite sentence or map row, finding, severity: blocker / fix /
note), a verdict (pass or findings) and its side effects (files and services read, tools used),
ending with "writes: none". It reads the cited originals itself, quotes nothing from them beyond
the bite's verbatim terms, and uses roles instead of names. A source it cannot read is a blocker,
not a guess.

**After validation.** Relay the findings as soon as they arrive, fix or answer each one, and update
bite and map. A bite counts as approved once the user approves it and every finding is fixed or
answered; a blocker that arrives after the user's approval reopens the bite.

## 6. Maps at Assembly and Open Defaults

This section covers Gate 4 and two of the three points the test left open; the third, V5's scope,
is settled in section 5.

**Pairing check.** Before the Gate 4 read, count the markers: `<!-- BITE n`, `<!-- MAP n -->` and
`<!-- /MAP n -->` occur once each for n = 1 to N, without gaps. Remove one map from a scratch copy
and count again; the counts must now differ, or the check proves nothing.

**Maps at assembly (open).** Suggested, not settled: an internal document keeps its maps in an
appendix; a document that leaves the team keeps them in a companion file, so the version that
leaves the team carries none.

**Row granularity (open).** Default: one row per source, as tested. Use one row per statement if
one row per source proves too coarse to check wording.

## 7. Worked Example With an Invented Source

This section shows one bite with its map; both sources are invented. The bite takes one term
verbatim from [SPEC] and one decision from [MTG]; the limit that comes from joining the two goes
in the interpretation row.

```
<!-- BITE 3: §2 Requirements -->
The service answers "within two seconds". Batch export is left out of the first release.
<!-- MAP 3 -->
**Map 3** · serves TOC §2 (approved 2026-01-15)

| Source             | Read in the original           | Determines in this bite      | Location                        | Verbatim terms (location)           |
| ------------------ | ------------------------------ | ---------------------------- | ------------------------------- | ----------------------------------- |
| [SPEC]             | in its service, 2026-01-15     | (1) response-time target     | (1) "Performance", line 12      | "within two seconds" (line 12)      |
| [MTG]              | transcript, 2026-01-15         | (1) batch export deferred    | (1) 00:14:20                    | —                                   |
| our interpretation | —                              | "first release" as the limit | joins [MTG] 00:14:20 and [SPEC] | —                                   |
<!-- /MAP 3 -->
```

## 8. Validator Agent Template File

This section holds the agent file a project copies at Gate 1 (section 2). Save it as
`.claude/agents/bite-validator.md`, add one read tool per source type the document cites (for
example a cloud-document reader or a chat-history reader), and keep every tool read-only; check
this for each reader you add. The model must differ from the drafting session's; if the drafting
session runs on Sonnet, pick another.

```markdown
---
name: bite-validator
description: Read-only check of one drafted bite against its source map (consequential drafting)
tools: Read, Grep, Glob
model: sonnet
---

You validate one bite of a draft written under consequential drafting. You are read-only: do not
write, edit or delete any file, and do not run commands that change anything.

Input: the draft file path, the bite number n, the file that resolves the source IDs, and the path
of the rule text (sections 3 to 5 of the consequential-drafting guide).

Procedure:
1. Read bite n and map n, from `<!-- BITE n` to `<!-- /MAP n -->`.
2. Read every cited original yourself, at the cited location, where it lives; not a summary or a
   cached copy. A source you cannot read is a blocker, not a guess.
3. Run checks V1 to V6 from the rule text.

Report:
- Findings table: check | bite sentence or map row | finding | severity (blocker / fix / note).
- Verdict: pass, or findings.
- Side effects: files and services read, tools used, ending with the line "writes: none".

Quote nothing from the originals beyond the verbatim terms already in the bite, and use roles
instead of names.
```

If the harness offers no Grep or Glob, Read alone is enough; in the test the validator used Read.
The file format follows the Claude Code subagent documentation (code.claude.com/docs/en/sub-agents,
checked 2026-10-28).
