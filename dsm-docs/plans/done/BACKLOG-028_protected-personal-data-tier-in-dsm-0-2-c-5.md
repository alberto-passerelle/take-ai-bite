# BACKLOG-028: Add a Protected Tier (Art. 9 Data, Individual Employee Ratings, Personnel Files) to DSM_0.2.C §5 and State That §5 Governs Storage, Not Reading

**Status:** Implemented (S28; Gate 1 approved in S26, T1 amended in S28 after a downstream spoke's inbox entry)
**Date Completed:** 2026-10-31
**Priority:** Medium
**Extends:** DSM_0.2.C §5 (intro), §5.1 (Data Sensitivity Classification) and §5.9 (Data-Protection and Compliance Briefing by Design)
**Date Created:** 2026-10-28
**Origin:** User request, S26, after an organization changed the data-protection rule in its agent instructions (2026-10-27). The earlier rule, read literally, kept all personal data out of the agent's input, and the agent refused ordinary tasks such as reading a calendar. The new rule separates ordinary personal data, used as far as the task needs it, from special categories, ratings of individual employees and personnel files, which the agent may read but carries into outputs only when the task is about them.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-028).

---

## Problem Statement

DSM_0.2.C §5 has one class for all personal data. §5.1 L629:

> | Restricted | PII (names, addresses, financial data), health data, GDPR-scoped personal data | Anonymize or pseudonymize before inclusion; see §5.4 |

Names and health data get the same rule. Two gaps follow:

1. **No protected tier.** Special categories under GDPR Art. 9, ratings of an individual
   employee's performance or behaviour, and personnel and application files need more than an
   e-mail address does: a source may contain them, and the agent should then read them without
   carrying them into a summary, a minute or a file unless the task is about them. §5 has no
   place for that rule. §5.9 asks the same narrow question; its data-scope requirement (L843)
   asks only "whether special categories (GDPR Art. 9) are present", and template line B (L868)
   reads "Art. 9 yes/no".
2. **No line between storage and reading.** §5's title says "in Tracked Files" and its intro
   speaks of protection "at write-time, before content reaches git", but no sentence says that §5
   does not limit what the agent may read for a task. A storage rule read as a processing rule is
   the failure the organization's change fixed, and nothing in §5 prevents a project rule built
   on it from being read the same way.

## Proposed Solution

Three additions; no existing sentence or table row is changed.

- **T1, §5.1:** a new row directly below `Restricted`:

  | Level | Examples | Handling rule |
  |---|---|---|
  | Restricted, protected | Special categories under GDPR Art. 9 (for example health data and trade-union membership), ratings of an individual employee's performance or behaviour, personnel and application files | As Restricted. In addition: the agent may read such data where a source contains it, but carries it into outputs (summaries, minutes, files, messages) only when the task is about exactly that, and then says so. Agree such tasks beforehand with whoever the project names for data protection, or with the user if nobody is named. Store such data only in gitignored files, never in tracked files or in the §5.8 egress zone. |

- **T2, §5 intro:** one sentence after the first paragraph: "This section governs where data
  lands (tracked files and anything that leaves the project), not what the agent may
  read to do a task; what the agent may process follows the organization's and the project's own
  instructions, within the protected-tier rule in §5.1."
- **T3, §5.9:** the data-scope requirement (L843) becomes "whether special categories (GDPR
  Art. 9), ratings of individual employees, or personnel and application files are present";
  template line B (L868) becomes "Art. 9 / individual ratings / personnel files: yes/no".

Out of scope: separation between mandates (the affected projects carry their own rule), and the
spokes' own rule texts, which get project-specific notes outside this BL.

## Success Criteria

- [ ] §5.1 carries the `Restricted, protected` row, including its storage sentence; the existing `Restricted` row is byte-identical
  to `upstream/main`.
- [ ] The §5 intro carries the storage-versus-reading sentence.
- [ ] §5.9's data-scope requirement and template line B name all three protected kinds.
- [ ] No section is added, removed or renumbered; the §5.9 briefing title is unchanged, so
  `/dsm-go` Step 2g still finds existing briefings.

## Test Plan

- [ ] T-1: `git diff upstream/main -- DSM_0.2.C_Security_Safety.md` shows additions only in §5.1,
  plus the two replaced §5.9 lines; the `Restricted` row is unchanged.
- [ ] T-2: anchored grep finds the new row, its storage sentence, the T2 sentence and both T3 lines
  (one hit each).
- [ ] T-3: the heading list (`grep -nE '^#{2,4} '`) is identical before and after.
- [ ] T-4: `grep -c 'Data-Protection and Compliance Briefing'` in DSM_0.2.C is unchanged, and the
  Step 2g snippet still finds an existing briefing in a scratch copy.
- [ ] T-5: §21.4 sweep for the replaced strings (`Art. 9 yes/no`, `whether special categories
  (GDPR Art. 9) are present`) across `DSM_*.md`, `scripts/commands/*.md` and `dsm-docs/`; each hit
  classified as deliberate or stale.
- [ ] T-6: `git merge-tree --write-tree --name-only HEAD upstream/main` reports no conflict on
  DSM_0.2.C.
- [ ] T-7: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **Fork-sync conflict:** Central may edit §5.1 or §5.9. Mitigation: T1 and T2 add lines and
  leave existing ones alone; only T3 replaces two lines. On conflict Central's text wins and the
  fork reapplies (DSM_0.2 §21.5).
- **T2 read as permission to store personal data:** the sentence could be read as loosening §5.2.
  Mitigation: it names storage as §5's subject, so §5.2's write-time rules keep applying in full.
- **Every spoke changes behaviour at merge:** the spokes read DSM_0.2 through the hub's `@` chain,
  so the protected tier applies to them at once. Accepted: the change only adds care, and the
  spoke notes announce it.
- **Legal statements:** the row names Art. 9 with two examples and draws no legal conclusion; it
  sets handling, not lawfulness. The §5.9 briefing remains the place for professional review.
- **A project with no named data-protection contact:** the T1 handling falls back to the user.
- **Storage sentence read as banning all results about protected data from tracked files:** it
  covers "such data", so pseudonymized data stays out, while anonymized results, which are no
  longer personal data, may still be tracked. Accepted: a project whose deliverable must name
  the data keeps that deliverable untracked.

## Upstream Contribution

Offer upstream once a Central PR slot is free: an issue on the public repository plus a PR
carrying the DSM_0.2.C change (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

S28, 2026-10-31, on `bl-028/protected-tier`.

- [x] T-1: `git diff --numstat upstream/main -- DSM_0.2.C_Security_Safety.md` gives `10 2`:
  5 lines in the §5 intro, 1 row in §5.1, and the two removed lines are the §5.9 data-scope
  line and template line B, each replaced by two wrapped lines. The `Restricted` row matches
  upstream exactly (1/1). Differs from this item's wording in two approved ways: the T2
  sentence sits in the §5 intro as T2 specifies, not in §5.1, and the two §5.9 lines are
  wrapped (shown and approved at Gate 3).
- [x] T-2: one hit each for the new row (anchored), its storage sentence, the T2 sentence and
  the T3 data-scope line (searched as newline-joined text), and T3 line B.
- [x] T-3: the heading lists of `upstream/main` and the working tree are identical (19 headings).
- [x] T-4: `Data-Protection and Compliance Briefing` occurs 3 times before and after. The
  Step 2g snippet, run in two gitignored scratch projects with the trigger set, stays silent
  with a briefing carrying the template title and prints its `WARN` without one.
- [x] T-5: §21.4 sweep across `DSM_*.md`, `scripts/commands/*.md` and `dsm-docs/`; control:
  each pattern finds 1 hit in upstream's DSM_0.2.C. `Art. 9 yes/no`: 3 hits, all deliberate
  (this BL's problem statement and test plan; `done/BACKLOG-001`, the closed record of the
  template as filed). `whether special categories (GDPR Art. 9) are present`: 1 hit,
  deliberate (this BL's problem statement). No stale hit. The new text's references, §5.1
  and the §5.8 egress zone, resolve.
- [x] T-6: `git merge-tree --write-tree --name-only HEAD upstream/main` exits 0, no conflicts.
- [x] T-7: the commit hooks on the implementation commit and its message report 0 hits against
  a 1-entry name list, and `#NNN`, hex IDs, non-fork BL numbers and Central/upstream/owner
  lines all at 0.

### Pending verification

- None: every item ran in S28. The upstream offer waits for a free Central PR slot.
