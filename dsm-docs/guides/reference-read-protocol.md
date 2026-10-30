# Reference-Read Protocol (Fork-Local Trial)

This guide defines how the agent checks a claim against the passage it rests on before using it,
and how the trial of that rule is logged and decided. It is fork-local and not part of upstream DSM.

**Applies when:** both hold.

1. The session runs in this hub during the trial window, S22-S26, or after BACKLOG-025 recorded a
   decision that keeps or narrows the rule (S27: narrowed). A `/dsm-staa` run does not count: it
   analyses a closed session and reviews its lessons one by one.
2. A claim drawn from a file is about to be used in text that leaves the hub (an issue, PR or
   comment on Central, a spoke inbox note, a tracked file or commit message in the public fork), or
   as the basis of a decision the user is asked to make.

If either does not hold, stop reading.

## 1. Reference-Read Trial Purpose and Status

A claim taken from a file reaches the human as the agent's interpretation, without the passage,
and the correction comes only from the source side (research
`dsm-docs/research/2026-10-15_reference-reading.md`, §3.1); no DSM rule puts the passage in front
of the human at the point of use (§3.3). This guide is a fork-local trial of such a rule:
BACKLOG-011 sets it up, and BACKLOG-025 runs it in S22-S26 and decides by the rule in section 5.
The trial ended in S27 with rule 3, narrow: the trigger now covers only claims that leave the hub
or decide something (condition 2 at the top).

## 2. Reference-Read Trigger and Four-Part Exchange

This section defines when the check starts and what the agent shows (research §3.4).

An *ingestion read* is a broad read for orientation and supports no specific claim. A *reference
read* starts when a claim drawn from a file is about to be used in text that leaves the hub, or as
the basis of a decision the user is asked to make (condition 2 at the top). The trigger is the use, not the earlier read, so a file read hours ago and one read a
moment ago are treated alike.

At the trigger, before the claim is used, the agent shows four parts in the conversation:

1. **Passage:** the wording the claim rests on, quoted as a small bite (DSM_6.0 §1.1) and copied
   from a numbered tool output (`grep -n` on an anchor phrase, or `sed -n 'a,bp' f | nl -ba -v a`),
   never retyped.
2. **Location:** file, section and line numbers, taken from the same numbered output as the
   passage.
3. **Reading:** the agent's interpretation, stated apart from the quote so a gap between them
   shows (DSM_6.0 §1.4).
4. **Confirmation:** the human's answer, awaited before the claim is used (DSM_6.0 §1.10).

Several claims used in one turn go into one block, one entry per claim, so the human answers once.

Example:

> - **Passage:** "The correction comes from the source side: the owner in case 1, a re-check of
>   the passage in case 2."
> - **Location:** `dsm-docs/research/2026-10-15_reference-reading.md` §3.1, lines 61-62
> - **Reading:** corrections came from the source, and only in one case from its owner.
> - Confirm before I use this?

## 3. Confirmation, Pointer Case and Exemptions

This section names who confirms and which claims need no exchange (BACKLOG-011 answer 1;
research §3.4).

**Who confirms.** The human in the session, also when the source belongs to someone else (a
spoke's report, Central's text, a client document). When the claim goes back to the source's
owner in a PR, an issue or a message, the outgoing text quotes the passage for the owner too.

**Pointer case.** A claim that stays a pointer ("see DSM_0.2 §10.1") needs no exchange: nothing is
restated, so it cannot drift from the wording, though the pointer itself can be wrong. The exchange
applies when the agent restates or interprets.

**Exempt,** by analogy with DSM_6.0 §1.10, which spares work "with no ambiguity" its dialog on
scope: values checkable at a glance (a version number, a path, a count shown with its output) and
claims already confirmed with their passage. Any other claim that later work depends on is
load-bearing and triggers the exchange.

## 4. Source-Checked Claims and §10 Scope

This section states the principle the trial tests and how this fork reads DSM_0.2 §10 and §10.1.

**Principle.** A claim drawn from a source is checked against the passage, not against the memory
of a read. This sharpens DSM_6.0 §1.3 ("When the agent presents a fact, it should be something it
checked"), under which an earlier broad read can pass for the check.

**§10 and §10.1, this fork's reading.** §10 exempts "Internal file reads within the repository"
from research capture because git traces them; this fork reads that exemption as covering capture
only. §10.1's passes still apply to a deliverable-critical claim wherever it comes from, and a claim
from a repository file also gets the section 2 exchange unless section 3 exempts it. Upstream DSM
states neither reading; recommendation E in BACKLOG-011 carries the question upstream.

## 5. Reference-Read Trial Log and Decision Rule

This section fixes where each exchange is recorded, how it is counted and how the trial ends
(BACKLOG-011 answers 3 and 4; BACKLOG-025).

**Log.** `.claude/reference-read-log.md`, untracked: entries quote sources that can be private and
the user's own words, so only counts leave it. One line per exchange, appended when the human
answers and labelled with the session that showed it; until then an `unanswered` status line
records it. An exchange still unanswered when S26 closes is listed separately at the decision and
counts toward rule 3's rate only, never toward rules 1-2. Field 2 is that answer:
`human-correction` only when it changes what the claim asserts, not just its wording. Field 3 is
`self-corrected` for a claim the agent changed while quoting, before showing it, and
`self-corrected-after-show` for an error the agent found after showing it; both count as
self-corrections. The agent asks for confirmation as its own question. A confirmation the human
gave only by approving a package whose message said beforehand that approving confirms the
readings still counts as `confirmed`, with a trailing `| bundling: implied` field. Earlier lines
are never rewritten: a later finding about one is a `note` line carrying the new field-3 or
bundling value. A parallel session logs under the main session's label (`S24`, not `S24.1`). A
session without exchanges writes `- S23 | no-exchange`.

```
- S22 | confirmed | - | DSM_0.2 §10.1 | passage: "..." | reading: ...
- S22 | human-correction | self-corrected | <file> §N | passage: "..." | reading: ... | user: "..."
- S24 | confirmed | self-corrected-after-show | <file> §N | passage: "..." | reading: ... | bundling: implied
- S24 | note | self-corrected-after-show | retro for log line N | ...
```

**Counts,** by command, never from memory; anchored, because a quoted passage can contain the
field words. At each wrap-up, the session's counts go into BACKLOG-025's Test Execution Log.

```bash
L=.claude/reference-read-log.md
grep -cE '^- S[0-9]+ [|] (confirmed|human-correction) [|]' "$L"   # exchanges
grep -cE '^- S[0-9]+ [|] human-correction [|]' "$L"                # human corrections
grep -cE '^- S[0-9]+ [|] [a-z-]+ [|] self-corrected(-after-show)? [|]' "$L"   # self-corrections
grep -cE '^- S[0-9]+ [|] [a-z-]+ [|] .*[|] bundling: implied$' "$L"   # implied confirmations
```

**Decision after S26,** first match wins: (1) keep, if at least one human correction; (2) drop, if
no correction of either kind; (3) narrow the trigger, if more than 5 exchanges per session on
average; (4) otherwise, the user decides.

## 6. Reference-Read Exchange Anti-Patterns to Avoid

These forms keep the shape of the exchange and lose the check.

- A quote with no stated reading: the human cannot see a gap (research §4, "Cost and ritual").
- A paraphrase shown as the passage, or a passage cut short so that it fits the reading.
- Skipping the exchange because the file was read moments ago: the trigger is the use.
- Counts or corrections reported from memory instead of from the log and its commands.
