# Reference reading: checking claims against their source passage

**Date:** 2026-10-15
**Linked BL:** (none, candidate for promotion; planned as fork-local BACKLOG-011)
**Author:** Alberto
**Status:** Active
**Validation depth:** Single-pass internal

---

## 1. Purpose / Question

Should DSM add a rule for what a downstream spoke calls a *reference read*? The
spoke's proposal: "whenever a file is used as a reference, the used passage is
read as a small bite, the use is matched against the original wording (quote +
location), and the human drafting alongside validates it" (hub inbox entry,
2026-10-15, archived under `_inbox/done/`, gitignored and local only). The spoke
also reports the failure this targets (§3.1). This note maps the principles and
existing rules that bear on the proposal, tests it rather than adopting it, and
recommends whether and where to anchor a rule.

## 2. Sources

DSM references are to v1.33.1 as present in this fork on 2026-10-15, located by
file and section.

**Reports**
- Hub inbox entry, 2026-10-15, from a downstream spoke (`_inbox/done/`,
  gitignored). It summarizes a fuller observation kept in the spoke, which was
  not read; this note relies on the summary only.
- Session 16 worklog, Output entry 11:14 (not tracked in git): the
  self-corrected coverage claim used as the second case in §3.1.

**Principles:** DSM_6.0 §1.1, §1.3, §1.4, §1.10, §1.11, §1.14.

**Rules and protocols:** DSM_0.2 §10, §10.1; DSM_0.2.A §22; DSM_0.2.B §1, §2;
DSM_0.2.F §8.0, §8.0.1; DSM_0.2.T Code Output Standards; DSM_0.1 §8.

No external sources. A comparative pass against work outside DSM is deferred
(§5).

## 3. Findings

### 3.1 Incident pattern: two cases

**Case 1 (spoke).** The report: "When many files are ingested for context and
one of them is later used as a reference, the claim travels as the agent's
interpretation; in this spoke two load-bearing claims reached tracked plans and
an outgoing message before the source owner corrected them." What the claims
were, and how they were wrong, is not reported.

**Case 2 (this session, self-reported).** In a Gate 1 brief, the agent merged
DSM_0.2 §10 and §10.1 into one table row and attributed §10's exemption for
internal file reads to both, calling it "the central finding". One turn later
it checked the row against the passage: the exemption sits in §10 only. The
claim reached the human but no tracked artifact.

**Pattern.** A file read during a broad pass for context becomes the basis of
a specific claim. The claim travels as the agent's interpretation, without the
passage. The correction comes from the source side: the owner in case 1, a
re-check of the passage in case 2. The cases differ in reach, which matters
for where a check has to sit (§3.4).

### 3.2 Principle analysis

**§1.1 Take a Bite and §1.3 Earn Your Assertions.** The report frames the gap
through §1.1: "DSM applies Take a Bite to drafting (DSM_0.2 §8.10) but has no
counterpart for reading." §1.1 defines a bite as "the smallest increment the
reviewer can verify"; its table lists only what the agent delivers. Applied to
a source, the bite is the passage a claim rests on: §1.1 gives the check its
unit, not its timing. §1.3 adds the demand: "When the agent presents a fact, it
should be something it checked." A broad read for context can pass for that
check, because the file was read; §1.3 does not say that checking a sourced
claim means matching it to the passage.

**§1.4 Critical Thinking.** §1.4's rule is "Question your own reasoning before
asking others to trust it." A claim taken from a source is the agent's
reasoning about it, so the agent's check is to match the claim against the
wording before passing it on. Before approving, §1.4.2 has the human ask "what
would need to be different for you to reject this". Shown only a paraphrase,
they cannot answer: any mismatch lies between the claim and a passage they
never see. Review then yields what §1.4 warns of, oversight "in form but not in
substance", even when the reviewer is diligent.

**§1.10 We Need to Talk.** §1.10 applies at "every entry point where work is
defined", and plans are one. In case 1 the claims entered the plans as the
agent's interpretation. Unless the human checked the source, any approval of
those plans was "acquiescence to a structure the human did not co-create". For
the request itself, DSM has the conversation §1.10 asks for: Gate 0 (DSM_0.2.F
§8.0) confirms the "threads extracted from the user's request". For source
documents it has narrower mechanisms (§3.3), but none found in which the human
confirms the agent's reading against the passage before the claim is used.

**§1.14 Observe Before Engaging.** §1.14 allows "read it, summarize it, extract
what it says, report it" by default and governs only the transition from
observing external content to acting on its framing. Whether the summary is
faithful is left open; reference reading addresses exactly that. The same
principle is why this note tests the spoke's proposal instead of adopting it
(§1).

### 3.3 Coverage map of existing rules

Rules and protocols beyond the principles in §3.2 that bear on reading or on
fidelity to a source.

| Rule | Location | Covers | Stops at |
|------|----------|--------|----------|
| Read the User's Manual | DSM_6.0 §1.11 | Reading the documentation of external tools and standards before building on them | Project files and stakeholder sources |
| Web Research Capture | DSM_0.2 §10 | Saving web findings with URLs before synthesis | Exempts "Internal file reads within the repository (already traceable via git)" |
| Validation Depth | DSM_0.2 §10.1 | At least two passes for deliverable-critical claims, including "Claims that will be cited or quoted in a user-facing artifact" | One pass suffices for internal notes and backlog context; passes are framed for external sources; whether §10's exemption applies is not stated |
| Two-Pass Reading | DSM_0.2.A §22 | Complete, structured reading of files over 200 lines | Exempts "files the agent has already read in the current session" |
| Read-Before-Draft | DSM_0.2.D §9 | OSS targets: contribution rules read before drafting, checklist presented at Gate 0 | Requires a derived checklist, not the passages |
| Decision References | DSM_1.0 §1.3.5 | "Never paraphrase from memory"; cite decisions by ID | Decisions only; no check against the wording |
| Reference, do not copy | DSM_2.0.C §5, Template 13 | Plans point at an external specification "by section" instead of restating it; reconciliation log | Pre-decomposed projects only; reconciliation is periodic, not at each use |
| Feedback roles | DSM_0.2.A §1 | Inbox entry is a notification; the feedback file holds the evidence and "verbatim quotes" | Governs where evidence is placed, not whether a reader consults it |
| Read the relevant source | DSM_0.2.T, Code Output Standards | "Read the relevant source (file, definition, documentation) before answering questions about it" | An earlier broad read can count as having read it |
| Citation Standards | DSM_0.1 §8 | Citation format and placement | Not required in checkpoints, handoffs and decisions |
| Composition Challenge, Edit Explanation Stop | DSM_0.2.B §1–2 | §1.4.2 applied to collections and edits the agent produces | Not the agent's readings of sources |
| Gate 0 | DSM_0.2.F §8.0 | Human confirms the threads extracted from the request | Not the agent's reading of source documents |

None of the rows reaches the point of use with the passage in front of the
human (§3.4).

### 3.4 Ingestion read versus reference read

An *ingestion read* is a broad read for orientation and supports no specific
claim. A *reference read* starts when a claim drawn from a file is about to be
used in a plan, a decision, a brief or a message. The trigger is the use, not
the earlier read; the report's own sequence is ingestion first, reference
later. The exchange has four parts:

1. **Passage:** the wording the claim rests on, quoted as a small bite (§1.1).
2. **Location:** file and section.
3. **Reading:** the agent's interpretation, stated apart from the quote so a
   gap between them shows (§1.4).
4. **Confirmation:** by the human, before the claim is used (§1.10).

A claim that can stay a pointer, as in Template 13's "by section" references,
needs no exchange: nothing is restated, so the claim cannot drift from the
wording, though the pointer itself can be wrong. The exchange applies when the
agent restates or interprets.

**Exempt,** mirroring §1.10's exemption for work "with no ambiguity": values
checkable at a glance (a version number, a path, a count shown with its output)
and claims already confirmed with their passage. Any other claim that later
work depends on is load-bearing and triggers the exchange.

### 3.5 Anchoring options

| Level | Candidate | For | Against |
|-------|-----------|-----|---------|
| Principle | **A.** Reading row in the §1.1 table (DSM_6.0) | Matches the report's frame; one row; keeps the bite vocabulary | §1.1 governs size; it gives the check its unit, not its timing or the human's confirmation (section 3.2) |
| Principle | **B.** Bullet in §1.3 (DSM_6.0) | Closes the gap that a broad read can pass for "something it checked" | Principle text only; no trigger, no exchange |
| Protocol | **C.** Reference-read protocol in DSM_0.2.B, beside Composition Challenge and Edit Explanation Stop | Those two apply §1.4.2 to what the agent produces; a third would apply it to what the agent reads, with room for trigger, exchange, exemptions and anti-patterns | One more protocol to maintain and follow; over-firing risk (section 4) |
| Protocol | **D.** Source step in Gate 0 (DSM_0.2.F §8.0) | Gate 0 already confirms the agent's reading of the request; Read-Before-Draft already fires there | Gate 0 runs at work definition; claims used later escape it |
| Rule | **E.** Clarify §10 and §10.1 (DSM_0.2) | Removes the ambiguity found in section 3.3; small edit | Reaches deliverable-critical claims only; internal notes and backlog context keep the single-pass exemption |
| Rule | **F.** Narrow the §22 exemption (DSM_0.2.A) | Targets the sequence of case 1: read earlier, used later | §22 is a reading strategy for long files, not a rule about claims |
| Rule | **G.** Amend "Read the relevant source" in the alignment template (DSM_0.2.T) | Reaches every aligned project's CLAUDE.md | Adds always-loaded context; a single line has no room for trigger and exemptions |
| Rule | **H.** Extend Decision References beyond decisions (DSM_1.0 §1.3.5) | Closest existing wording: "Never paraphrase from memory" | Lives in the data-science methodology; asks for a citation, not a check against the wording |

The candidates combine, for example a principle bullet with a protocol that
carries it; section 5 recommends one combination.

## 4. Strongest counter-evidence and risks

- **Already covered by §1.3 and §1.4.** Case 1 can be read as a lapse, not a
  gap. Against this, DSM records that a principle alone did not stop a
  recurring failure: §8.0 "does not by itself prevent the failure mode"
  (DSM_0.2.F §8.0.1).
- **Thin evidence.** Case 1 rests on a notification, which DSM_0.2.A §1 defines
  as a summary pointing to the full record (section 2). Case 2 is self-reported.
  Two cases show no recurrence; §8.0.1 rested on six.
- **Over-firing.** If most claims in a plan count as load-bearing, the exchange
  fires on ordinary work. The over-firing guard of DSM_0.2.F §8.9.2, written for
  another gate, states the risk: such a gate "trains the user to accept
  reflexively", and "a reflex-accepted gate still reads as protection".
- **Cost and ritual.** Each exchange adds reading and a turn. A pasted quote with
  no stated reading keeps the form and drops the check.

**Why C + B + E still stands.** Only C has room for the trigger and exemptions
that answer over-firing; B and E add no procedure of their own. The thin
evidence argues for a fork-local trial that counts exchanges and corrections
before any upstream proposal (section 5), not for dropping the rule.

## 5. Conclusion

**Recommendation.** Anchor reference reading in three places: C, a
reference-read protocol in DSM_0.2.B that carries the exchange, trigger and
exemptions of section 3.4; B, a bullet in DSM_6.0 §1.3 that a claim from a
source is checked against the passage, not the memory of a read; E, a
clarification of the scope of §10 and §10.1. Implement it fork-local as
BACKLOG-011, as a trial that counts exchanges and the corrections they produce.

**Before any upstream proposal:** a second, comparative pass against work
outside DSM (§10.1), and a name-free account of the two case 1 claims from the
reporting spoke.

**Open questions.** Who confirms when the source belongs to someone other than
the human in the session? Does the trial run in this hub, in the reporting
spoke, or both? What counts as a correction?
