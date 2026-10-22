# BACKLOG-021: Send Central a Fix So the Mirror-Sync Manifest Stops Listing the Scanner as Mirrored

**Status:** Implemented (absorbed upstream, shipped in v1.37.1)
**Date Implemented:** 2026-10-22
**Central BL:** BACKLOG-611 (v1.37.1)
**Priority:** Low
**Extends:** Central's `dsm-docs/guides/mirror-sync-manifest.md` (category 7, section 3 "Out-of-Scope Items", section 5 cross-references)
**Date Created:** 2026-10-22
**Origin:** S18 triage claim F; S19 found the cause with Central access: Central's sync list deliberately excludes the scanner (a recorded Central decision), and the manifest was not updated.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-021).

---

## Problem Statement

The manifest, which ships publicly with take-ai-bite, lists `scripts/check-mirror-sync-content.sh`
in category 7 as mirrored 1:1 and, in its cross-references, calls it "itself in category 7". The
mirror does not carry it, and on purpose: Central's sync list excludes it by a recorded
decision. A fork reading the manifest assumes it has the scanner. Of the
other mentions in Central's mirrored files (DSM_0.2 core, DSM_7.0, `/dsm-wrap-up`), none claims the
mirror ships it.

## Proposed Solution

One pull request to Central, branch `fix/manifest-scanner-not-mirrored` off Central `main`, touching
only the manifest:

- Category 7: drop the scanner from the mirrored paths; the row's reason names command-sync tooling only.
- Section 3: add the scanner as an out-of-scope item, with a reason that stays generic (public file):
  Central-internal, citing Central's decision.
- Section 5: the cross-reference points to section 3 instead of "itself in category 7".

No Central BL file, no CHANGELOG version (S19 decision). The owner merges.

## Success Criteria

- [x] Every path in category 7's mirrored column is an active entry of Central's sync list.
- [x] The manifest names the scanner only as Central-only, with no detail of its pattern list.
- [x] The pull request is opened on Central with a body the user approved; nothing pushed to `main`.

## Test Plan

- [x] T-1: the diff touches only `mirror-sync-manifest.md`, in category 7, section 3 and section 5.
- [x] T-2: parse category 7's mirrored paths and test each against the non-comment lines of
      `scripts/take-ai-bite-sync.txt`: old 1 of 2 missing, new 0 of 1; self-test the parser on a
      path known to be listed.
- [x] T-3: the manifest's mentions of the scanner after the change: only section 3 and section 5,
      both saying Central-only; the name list check on the diff: 0 hits, reported with list size.
- [x] T-4: take-ai-bite `main` does not ship the script (the claim the new text makes).

## Risks (per DSM_0.2 §21.2)

- **The reason text says too much in a public file.** *Mitigation:* it states only that the pattern
  list is confidential; the owner can reword before merging.
- **The owner prefers to ship a scrubbed scanner instead.** *Accepted:* the PR body offers that as
  the alternative; this change matches today's decision.
- **Overlap with Central's own planned manifest check** (a bidirectional manifest-vs-sync-list
  check). *Mitigation:* the PR names this case as an instance that check would catch.

## Upstream Contribution

This BL is the contribution: a pull request on Central.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S19). Central clone, branch `fix/manifest-scanner-not-mirrored`, one local
commit on Central `main` at v1.37.0. Test script `/tmp/s19-fix/test-021.sh`.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | 1 file, 3 hunks: L50 (category 7), +L71 (section 3 row), L139 (section 5); +3/-2 |
| T-2 | PASS | Sync list: 124 active entries; parser self-test `scripts/sync-commands.sh` listed. Old: category 7 has 2 paths, 1 not in the sync list (the scanner). New: 1 path, 0 missing |
| T-3 | PASS | Scanner filename in the new manifest: L71 (section 3) and L139 (section 5, "Central-only, not mirrored"); name list on added lines 0 hits against a 1-entry list |
| T-4 | PASS | take-ai-bite `main` (fork's `upstream/main`) has no `scripts/check-mirror-sync-content.sh`; self-test `scripts/sync-commands.sh` present |

Sweep (§21.4): the other mentions in Central's mirrored files (DSM_0.2 core, DSM_7.0 §2.1,
`/dsm-wrap-up`) describe Central's own sync step and do not claim the mirror ships the scanner.

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, head = local HEAD, base `main` unchanged, open and mergeable, live body = approved file.
- [x] Owner's merge and the release that ships it: merged by the owner, shipped as Central BACKLOG-611 in v1.37.1 and merged into this fork in S20 (2026-10-22); the fork's manifest now lists only `scripts/sync-commands.sh` in category 7 and names the scanner as Central-only in section 3.
