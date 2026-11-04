# BACKLOG-041: Let the Egress Checker Read the Fork's BL Numbers From Its Own Indexes Instead of a Fixed 000-039 Range

**Status:** Implemented (S29)
**Date Completed:** 2026-11-04
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

S29, 2026-11-04, on `bl-041/egress-checker-fork-numbers`. T-1 to T-3 ran through the hook's
`--commit-msg` path, once with the committed hook (old) and once with the edited one (new).

- [x] T-1: added lines of commit 3658f1f: old 2, new 0. Through this path the old rule gives 2, not
  the 3 the pre-commit report showed, because `--commit-msg` drops lines starting with `#`, which
  removes the H1 holding one BACKLOG-040.
- [x] T-2: `BL-391`: old 1, new 1.
- [x] T-3: an unfiled fork-shaped number (`BACKLOG-042`, since 041 now has a row): old 1, new 1.
  Control: the filed `BACKLOG-041` and `BL-041`: old 2, new 0.
- [x] T-4: logic run with no index files: the old range applies (3 on the T-1 text). Not run
  through the hook, which fails closed without the name list in a scratch repository.
- [x] T-5: `bash -n` exit 0; the implementing commit's own report is compared with the count
  computed from its staged text (result in the commit record and the worklog).

### Pending verification

- [ ] none
