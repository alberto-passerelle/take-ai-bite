# BACKLOG-040: Let a Project Use a Neutral Alias for Hub-Facing Inbox File Names and the Source Line, So a Client Name in Its Folder Name Does Not Reach the Hub

**Status:** Proposed (Gate 1 open)
**Priority:** Medium
**Extends:** DSM_3.0.B (one inbox file per spoke, L226; feedback push target, L286); DSM_0.2.A
(notification targets, L236-237 and L1628-1629); DSM_3.0.E §6.7 row 10 (setup confirmation to the
hub); DSM_0.2 §18 (registry format); the skills that write into a hub inbox.
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29. The spoke is named after a client
mandate; it chose a neutral file name by hand so that the name would not reach the hub.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-040).

---

## Problem Statement

Messages to the hub are written to `{hub}/_inbox/{project-name}.md` (DSM_3.0.B L226 and L286,
DSM_0.2.A L236-237 and L1628-1629), carry the project name in their `Source:` line, and point to
files by path. When a project folder is named after a client mandate, that name reaches the hub and
every project that reads it, which conflicts with keeping mandates separate.

BACKLOG-026 A2 keeps names out of a message's text. It does not cover the file name, the `Source:`
line, or paths, which the protocol generates from the project name.

## Proposed Solution (sketch for Gate 1)

- An optional neutral alias in `.claude/dsm-ecosystem.md` (DSM_0.2 §18).
- Every hub-facing file name, `Source:` line and path in an entry uses the alias when it is set.

Open for Gate 1: the field's form; whether paths in entries are dropped instead (A2 already proposes
"no file paths").

## Success Criteria (draft)

- [ ] With an alias set, no hub-facing file name, `Source:` line or entry path carries the project
  folder name.
- [ ] Without an alias, behaviour is unchanged.
- [ ] Every site that builds a hub-facing name from the project name reads the alias.

## Test Plan (draft)

- [ ] T-1: §21.4 sweep for `{project-name}` and `basename` uses in `DSM_*.md` and
  `scripts/commands/*.md` that build a hub-facing name; each site listed and routed through the
  alias.
- [ ] T-2: scratch project with an alias: the wrap-up feedback push writes `{alias}.md` and the
  entry's `Source:` line names the alias.
- [ ] T-3: scratch project without an alias: unchanged file name.
- [ ] T-4: `git merge-tree --write-tree --name-only HEAD upstream/main` on the changed files.
- [ ] T-5: egress sweep of the diff and the commit message, counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **A missed site still leaks the name:** mitigation: T-1 lists every site; the hub's own gitignore
  pattern for spoke inbox files stays as a second layer.
- **Two projects pick the same alias and overwrite each other's hub file:** mitigation: dated file
  names, or the hub checks for a clash before writing.
- **Upstream drift on several files:** mitigation: send the change upstream, as input to Central's
  item on inbox messages next to BACKLOG-026 A2.

## Upstream Contribution

Offer to Central as an issue plus a PR (DSM_0.2 §21.5), when a PR slot is free.

## Test Execution Log (per DSM_0.2 §21.3)

<!-- Filled at close. -->

### Pending verification

- [ ] none yet
