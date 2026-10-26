# BACKLOG-023: Send Central a Fix So /dsm-go Step 2b Counts Inbox Entries, Not Inbox Files

**Status:** In Progress (merged on Central 2026-10-24 with one owner amendment; awaiting the release that ships it)
**Priority:** Medium
**Extends:** Central's `/dsm-go` Step 2b ("Processing", inbox lazy-load); DSM_0.2.A §19 (enumerate-each-entry rule, BL-421); DSM_0.2 §19.1 (published snippets are run before they ship)
**Date Created:** 2026-10-22
**Origin:** S16 feedback item 3; S18 triage claim J; S20 recheck against v1.37.1.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-023).

---

## Problem Statement

Step 2b lists the inbox's filenames and reports "Inbox: N pending entries: [filename list]", so N
counts files. A per-source inbox file accumulates entries (a spoke's feedback push appends to
`_inbox/{project-name}.md`). At the S20 boot this hub's inbox held 7 entries in 4 files; in S16 a
file reported as one entry held two, one already processed. The enumerate-each-entry rule exists to
stop N>1 from collapsing to 1, and a file count collapses it inside each file.

## Proposed Solution

Count each file's entry headers (`^### \[`, the inbox README's entry format) with `grep -c`, which
reads no content into context, so the lazy-load rule stands. Report "E pending entries in F files"
with a count per file; a file with 0 headers is reported as not in entry format, never as empty.
The inbox path is a variable (External Contribution target), and `find` replaces a glob so an empty
inbox stays silent under zsh. No Central BL file, no CHANGELOG version (S19 decision).

## Success Criteria

- [x] On this hub's real inbox the snippet reports the entry count per file (7 in 4 files).
- [x] A file without entry headers shows 0 and is distinguishable from an empty inbox.
- [x] Identical output under bash and zsh, including an empty inbox and a path with a space.
- [x] The pull request is opened on Central with a body the user approved; nothing pushed to `main`.

## Test Plan

Snippet extracted from the edited file and run under bash and zsh.

- [x] T-1: the diff touches only the Step 2b "Processing" paragraph (`git diff --numstat`: +10/-1).
- [x] T-2: this hub's real `_inbox/` (filenames redacted in output).
- [x] T-3: an inbox holding only `README.md`.
- [x] T-4: one file with free text and a non-entry `### ` heading, one file with 2 entries.
- [x] T-5: an External Contribution style path containing a space.
- [x] T-6: no inbox directory at all.

## Risks (per DSM_0.2 §21.2)

- **Entries not written in the `### [date] title` format are not counted.** *Mitigation:* such a
  file shows 0 and the step says it is not in entry format.
- **Conflict with DSM_0.2.A §19**, which asks for type, priority and source per entry at boot.
  *Accepted:* named in the PR as found on the way; the owner decides which rule wins.
- **No inbox directory prints `find`'s error.** *Accepted:* visible, not silent; inbox creation is
  handled elsewhere.

## Upstream Contribution

This BL is the contribution: a pull request on Central.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S20) on macOS, bash and zsh, identical output in every case. Scratch copy of the
fork's `dsm-go.md` at v1.37.1 (= Central `main`); the PR branch was cut from Central `origin/main` in
a temporary worktree, where the file was byte-identical to the reviewed base before the change.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | `git diff --numstat`: `10 1 scripts/commands/dsm-go.md`, asserted before commit |
| T-2 | PASS | 1, 2, 1, 3 entries (7); the current wording reports 4 |
| T-3 | PASS | no lines |
| T-4 | PASS | `odd.md: 0 entries`, `two.md: 2 entries` |
| T-5 | PASS | `x.md: 1 entries` |
| T-6 | PASS | `find: _inbox: No such file or directory` |

A first draft hard-coded `_inbox`, which would have missed the External Contribution target; found
while reviewing the diff and fixed before T-2 to T-6 were rerun.

### Pending verification

- [x] PR body approved by the user, branch pushed, PR opened on Central (no push to `main`): opened 2026-10-22, PR head = local HEAD, live body = approved file.
- [x] Owner's merge: merged into Central `main` on 2026-10-24 with one amendment the owner approved,
      to the report line only (the snippet is unchanged). A file with no entry header now counts
      as one entry in the total and is listed as "not in entry format". S23 check (2026-10-26):
      the second criterion still holds, because the snippet still prints 0 for such a file and
      the report never calls it empty.
- [ ] The release that ships it; then Status Implemented and move to `done/`.
