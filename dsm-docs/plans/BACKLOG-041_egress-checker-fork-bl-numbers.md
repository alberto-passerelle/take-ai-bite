# BACKLOG-041: Let the Egress Checker Read the Fork's BL Numbers From Its Own Indexes Instead of a Fixed 000-039 Range

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** `.claude/hooks/check-public-egress.sh` (`--pre-commit` and `--commit-msg` report line),
fork-local since BACKLOG-013; the commit-hook modes were added in S27.
**Date Created:** 2026-11-04
**Origin:** S29. The commit that filed BACKLOG-036 to 040 reported `non-fork-BL=3`; all three were
BACKLOG-040 and BL-040, this fork's own new item.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-041).

---

## Problem Statement

`check-public-egress.sh` L137 counts BL references that are not this fork's:

> `b=$(printf '%s\n' "$TEXT" | grep -oE 'BL-[0-9]{3}|BACKLOG-[0-9]{3}' | grep -vcE '^(BL|BACKLOG)-0[0-3][0-9]$')`

Only 000-039 count as fork numbers. The fork line reached 040 in S29, so every later fork BL is
counted as a possible Central number. The count is report-only, but a count that is wrong on
ordinary commits trains the reader to ignore it, and it exists to catch Central BL numbers before
they reach the public fork.

## Proposed Solution (sketch for Gate 1)

Take the fork numbers from the first column of the fork's own index rows
(`dsm-docs/plans/README.md` and `dsm-docs/plans/done/fork-INDEX.md`), read from the working tree
at run time. When neither file yields a number (for example a fresh clone without them), fall back
to the old range. A number without an index row still counts, which is right: a filing commit adds
the row in the same commit.

## Success Criteria (draft)

- [ ] Commits that cite only filed fork BLs report `non-fork-BL=0`.
- [ ] A Central-shaped number still counts.
- [ ] Without the index files, the old range applies.

## Test Plan (draft)

- [ ] T-1: the added lines of commit 3658f1f: old rule 3, new rule 0.
- [ ] T-2: a released Central-shaped number (`BL-391`): 1 under both rules.
- [ ] T-3: an unfiled fork-shaped number (`BACKLOG-041` before its row exists): 1.
- [ ] T-4: index files absent: the old range applies (3 on the T-1 text).
- [ ] T-5: `bash -n` on the hook; the commit that implements this BL reports through the changed line.

## Risks (per DSM_0.2 §21.2)

- **An index row with a Central number would whitelist it:** the indexes are fork-local and name-free
  by rule, and their rows are written by this fork's own filing steps. Accepted.
- **A changed table shape (column order, a prefix other than `BACKLOG-`) yields no numbers:** the
  fallback keeps the old behaviour; T-4 covers it.
- **The checker is local to this fork:** no upstream drift; nothing to offer upstream.

## Upstream Contribution

None: the egress checker exists only in this fork.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
