# BACKLOG-034: Tell the Inbox Lifecycle Block to Move Untracked Entries With Plain mv, Because git mv -k Exits 0 Without Moving

**Status:** Proposed (Gate 1 open)
**Priority:** Low
**Extends:** `DSM_0.2.T_Alignment_Templates.md` Inbox Lifecycle block (L38-39) and its aligned copy
in each project's `.claude/CLAUDE.md`.
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. The spoke gitignores `_inbox/`;
an agent archived an entry with `git mv -k`, which reported success and moved nothing. The agent
noticed the entry still in place and moved it with plain `mv`.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-034).

---

## Problem Statement

The block tells the agent where a processed entry goes (`_inbox/done/YYYY-MM-DD_{source}.md`) but
not how to move it. It names `mv`/`git mv` only in its overwrite warning. In a project that
gitignores `_inbox/`, entries are untracked: `git mv` fails, and `git mv -k` exits 0 and leaves
the file where it is.

Rechecked on this machine (S29), in a fresh repository with an untracked file: `git mv -k` exited
0 and the file stayed in place; `git mv` exited 128 ("not under version control").

This hub is not affected: its local CLAUDE.md already archives spoke inbox files with plain `mv`.

## Proposed Solution (sketch for Gate 1)

Add one sentence to the block, as the spoke proposed: "Untracked entries (a spoke may gitignore
`_inbox/`) move with plain `mv`, never with `git mv -k`, which exits 0 without moving; check that
the target exists after the move."

Open for Gate 1: the exact wording; whether the block also says that tracked entries move with
`git mv`.

## Success Criteria (draft)

- [ ] The block in `DSM_0.2.T_Alignment_Templates.md` carries the sentence.
- [ ] A `/dsm-align` run regenerates the aligned copy with the sentence.

## Test Plan (draft)

- [ ] T-1: rerun the S29 check in a fresh `mktemp -d` repository: `git mv -k` exits 0 without
  moving; plain `mv` moves the file and the target exists.
- [ ] T-2: in a scratch spoke, run `/dsm-align`: the aligned block contains the sentence once.
- [ ] T-3: `git merge-tree --write-tree --name-only HEAD upstream/main` reports no conflict on the
  T file.
- [ ] T-4: egress sweep of the diff and the commit message: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **The fork's T file drifts from upstream:** `/dsm-align` copies the template verbatim, and an
  upstream merge overwrites a local edit or conflicts with it. Mitigation: send the change
  upstream; the hub's local rule covers the hub until then.
- **Plain `mv` on a tracked entry:** git then sees a deletion and an untracked file. Mitigation:
  the sentence scopes plain `mv` to untracked entries.
- **Every aligned CLAUDE.md grows by one sentence:** a small context cost in every project.
  Accepted: one sentence.

## Upstream Contribution

Offer to Central as a fix (an issue plus a PR on the T file) when one of the fork's three Central
PR slots is free (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
