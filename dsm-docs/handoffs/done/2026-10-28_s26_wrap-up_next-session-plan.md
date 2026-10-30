# Session 26 Handoff (Wrap-Up): Data-Protection Tier, Trial Decision and Central Check for S27

**Date:** 2026-10-28
**Session:** 26 (full wrap-up)
**Branch:** session-26/2026-10-28, merged into `main` at this wrap-up
**Author:** Alberto (with AI assistance)
**Consumer:** S27 (`/dsm-go` Step 3)
**Date Completed:** 2026-10-30
**Outcome Reference:** Consumed at session 27 start

This file ships with the public fork. It names no Central PR, issue, commit or active-backlog
numbers, describes none of Central's unreleased text, and names no spoke, client or person. The
per-spoke detail lives in the gitignored `.claude/drafts/s26-spoke-dp-notes.md`, and the S26
worklog (archived at the next boot) holds the full record.

## 1. What Happened in S26

An organization changed the data-protection rule in its agent instructions. The earlier rule, read
literally, kept all personal data out of the agent's input; the new one has two tiers: ordinary
personal data is used as far as the task needs it, while Art. 9 data, ratings of individual
employees and personnel or application files may be read but go into outputs only when the task
is about exactly that. The rule is part of the instructions every session loads, so nothing had to
be configured; the work was finding the project rules that contradict it or lack its second tier.

- **Hub:** DSM_0.2.C §5.1 has one `Restricted` class for names and health data alike, and §5.9's
  briefing asks only about Art. 9. BACKLOG-028 (filed, Gate 1 approved) adds the protected tier,
  one sentence that §5 governs storage and not reading, and the wider §5.9 data scope.
- **Spokes:** one inbox note each, written as
  `_inbox/2026-10-28_data-protection-rule-update.md` and read back identical to the approved draft.
  One spoke has an external-send rule that conflicts with the new rule; one keeps a stricter send
  rule for a reason it should write down; two declare personal-data handling without the §5.9
  briefing; one has a briefing question to widen.
- **Trial:** five readings confirmed (asked as their own question), one location error found after
  showing and logged as a `note` line. Counts are in BACKLOG-025.

## 2. Order for S27, and Why

1. **Central's answers.** All three Central PR slots are in use, so nothing new goes upstream until
   one resolves; the answers decide whether BACKLOG-028's upstream offer and the queued fixes can
   move. Check each answer one success criterion at a time and record status only in tracked files.
   Read Central with `gh api .../contents`, not `git fetch` in the Central clone: S26 fetched there
   for a "read-only" check, which wrote refs into that clone against the recorded practice.
2. **Trial decision.** Ask one question: is S25's human correction a correction of the claim (a
   question that changed what the claim asserted) or only of its wording? Then run the four
   commands in `dsm-docs/guides/reference-read-protocol.md` §5 and apply the rule (first match
   wins). With the correction confirmed, rule 1 gives "keep"; without it, no correction remains and
   rule 2 does not apply because self-corrections exist, so rule 3 ("narrow", about 17 exchanges
   per session) decides. Record the result in BACKLOG-025 (T-6 to T-8) and close or narrow the
   guide accordingly.
3. **BACKLOG-028.** Implement on `bl-028/*` from a clean index (§20.9). Keep the existing
   `Restricted` row byte-identical to `upstream/main` (T-1); run `git merge-tree` against
   `upstream/main` (T-6) because Central may touch §5 in its next release. DSM_0.2.C reaches every
   spoke through the hub's `@` chain, so the tier applies to all of them at merge.
4. **Spokes.** Each spoke's next session decides its own note with the user. The hub acts only if
   a spoke reports a problem.

## 3. Carried Items

- Lessons prune at the next STAA run: an S18 lesson still suggests a Bash write past the
  cross-repo gate, against a spoke lesson aggregated in S25.
- Name list: `.claude/name-denylist.txt` still has one entry.
- Next Central release: merge `upstream/main`, run `scripts/sync-commands.sh --deploy` and
  `diff -q`, and reconcile the fork's §8.10 item 6 and guide with Central's text.
- The user's own team-skill rollout steps (S21 parallel handoff in the drafts).
