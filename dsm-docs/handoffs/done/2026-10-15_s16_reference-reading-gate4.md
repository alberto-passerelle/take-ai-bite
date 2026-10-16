# Session 16 Handoff: reference-reading research at Gate 4, then BACKLOG-011
**Date Completed:** 2026-10-16
**Outcome Reference:** Consumed at session 17 start

**Date:** 2026-10-15
**Branch for this work:** `bl-011/reference-reading` (rebased onto `session-16/2026-10-15`; both local only, origin not found)
**Read first:** `dsm-docs/research/2026-10-15_reference-reading.md` (200 lines), then this handoff

## Where things stand
- The research note is fully drafted. The user approved all 12 bites under DSM_0.2
  §8.10 Gate 3 (sections 1, 2, 3.1, 3.2 in four paragraphs, 3.3, 3.4, 3.5, 4, 5).
  Gate 4 (full-document review) has not started.
- Recommendation in section 5: C, a reference-read protocol in DSM_0.2.B carrying the
  section 3.4 exchange, trigger and exemptions; B, a bullet in DSM_6.0 §1.3; E, a
  clarification of the scope of DSM_0.2 §10/§10.1. Implement fork-local as
  BACKLOG-011, run as a trial that counts exchanges and the corrections they produce.
- BACKLOG-011 is not filed. The number is free (fork-local line: 001-002 done,
  003-010 active).
- Inbox: the processed spoke file is archived under `_inbox/done/` (gitignored).
  Nothing else is pending in the inbox.

## Settled decisions (do not reopen without the user)
- **Name-free:** the reporting spoke is not named in tracked artifacts, as in
  BACKLOG-001; it is "a downstream spoke". Its inbox files are gitignored by name
  pattern.
- **Case 1 evidence stays the inbox summary.** The spoke's full feedback file was not
  read and should not be, because the spoke handles confidential mandate data; section
  5 asks the spoke for a name-free account instead.
- **3.2 order:** §1.1/§1.3 first (the report's own frame), then §1.4, §1.10, §1.14.
  The user approved it.
- **Recommendation C + B + E** was stated before section 4 so that section 4 could
  test it; it survived the test with a trial-first condition.
- **Quotes:** every quote in the note was checked word for word against its source,
  on newline-joined text because several wrap across lines. Keep that standard for
  any edit at Gate 4.
- **Reference convention:** "§" means a DSM section; the note's own sections are
  "section N". Six older internal references still use "§" (Gate 4 step 1).
- **Length:** the user accepted drafting over budget with the trim at Gate 4 (draft
  about 1,850-2,000 words against a 1,600-word plan).

## Next steps (causal order)
1. **Gate 4, mechanical batch (no judgment needed, one edit pass)** in the research
   file:
   - Rewrite six internal references as "section N": line 18 `(§3.1)`, line 40
     `(§5)`, line 62 `(§3.4)`, line 91 `(§3.3)`, line 99 `(§1)`, line 122 `(§3.4)`.
     The others (`§1.1`, `§1.4`, `§1.10` at lines 132-136, `§10.1` at line 195) are
     DSM references and stay.
   - Add to section 2 Sources the five rules the text cites but the list lacks:
     DSM_0.2.D §9, DSM_1.0 §1.3.5, DSM_2.0.C §5 (Template 13), DSM_0.2.A §1,
     DSM_0.2.F §8.9.2.
2. **Gate 4, repetition pass (Present Once, §8.10):** known overlaps are section 2 and
   section 4 on case 1 resting on a summary, and the §1.1/§1.3 paragraph in 3.2 versus
   row A in 3.5 on §1.1 giving the unit but not the timing. Propose one location per
   fact.
3. **Gate 4, trim toward 1,600 words:** show the user a list of specific cuts before
   cutting (mainly the 3.3 table and 3.2). The user's sign-off on the assembled
   document closes Gate 4. No humanizer pass: `dsm-docs/research/` is not human-facing
   per CLAUDE.md.
4. **File BACKLOG-011** in `dsm-docs/plans/` (fork-local; required fields Status,
   Priority, Date Created, Origin, Author). Point at the research for the
   recommendation and conclusion instead of copying them. Then move the research
   README row from "Findings ready for promotion" to "Tied to an active backlog item"
   and set the research header's "Linked BL" to BACKLOG-011. Commit on
   `bl-011/reference-reading`.
5. **Merge `bl-011` into the session branch** once Gate 4 and the BL are committed.
   Merging to main still waits on the origin decision (S16 checkpoint item 3).

## Open questions carried in the research (section 5)
- Who confirms when the source belongs to someone other than the human in the session?
- Does the trial run in this hub, in the reporting spoke, or both?
- What counts as a correction in the trial count?

## Candidate upstream feedback (not yet written as feedback files; push waits on the hub decision)
- DSM_0.1 §8 places a research document's Sources section at the end; the
  `/dsm-research-add` stub places it second.
- DSM_0.2 §10 exempts internal file reads from capture; whether that exemption also
  applies to §10.1 Validation Depth is not stated.
- `/dsm-go` Step 0c checks out an open Level 3 branch before Step 3 reads handoffs and
  checkpoints from the working tree, so artifacts committed only on the session branch
  are missed. This wrap-up worked around it by rebasing `bl-011` onto the session
  branch.

## Carry-overs from S15 (decisions for the user)
Hub identity (registry and `@` import point at `/Users/alberto/TAB/HUB`), `origin`
remote not found, S14 close-out, research README dangling links: see the S16
checkpoint, items 2-4.

## Addendum: STAA results (added after wrap-up, 2026-10-15)
STAA analysed Session 16 the same evening; its 9 [STAA] lessons are in
`.claude/reasoning-lessons.md`. Two results are not in the lessons:

- **Trial data for BACKLOG-011 (input for Gate 4, section 4 or 5):** 28 quotes were
  checked against their sources during drafting (counted from the worklog's
  verification records). None differed; one check gave a false miss because the
  quote wraps across two lines (DSM_6.0 L178-179), fixed by matching on
  newline-joined text. The session's one substantive error, the merged §10/§10.1
  row, was a compressed paraphrase in a table, not a quote. The trial should
  therefore count checks of paraphrases and interpretations, not only of quotes.
- **Three more candidate feedback items** (same status as the list above):
  - `/dsm-go` reports inbox files as "entries", but a per-source file can hold
    several entries, including processed ones (S16: "1 entry" was two, one already
    BACKLOG-001).
  - DSM_0.2.F numbers the gates 0-3, while §8.10 and CLAUDE.md number the prose
    gates 1-4 (§8.10 Gate 2 is the §8.1 concept gate), so gate-numbered rules such
    as §8.2.1 need mapping for prose work.
  - DSM_0.2 §7 asks for a "[prompt summary]" in User blocks, which lets the agent's
    reading of a terse prompt be logged as the prompt itself; keeping the literal
    words and marking the reading separately would close that.
