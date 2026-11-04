# BACKLOG-035: Let the User Keep a Persistent Allowlist of Inbox Folders That the Cross-Repo Write Hook Accepts Without Per-Session Confirmation

**Status:** Implemented (S29; Gate 1 and Gate 2 approved in S29; T-6 and T-9 text corrected in S29)
**Date Completed:** 2026-11-04
**Priority:** High
**Extends:** `.claude/hooks/validate-cross-repo-write.sh` (Write/Edit and Bash branches);
DSM_0.2.C §2 (cross-repo writes and its anti-pattern list); `DSM_0.2.T_Alignment_Templates.md`
Cross-Repo Write Safety block; `scripts/commands/dsm-go.md` Step 0f.
**Deviation (DSM_0.2 §21.5):** this changes a rule Central states: DSM_0.2.C §2 requires one
confirmation per cross-repo target per session and lists inbox pushes as not exempt. The fork
carries the change openly, re-applies it after upstream merges where Central's text wins, and
offers it upstream.
**Date Created:** 2026-11-04
**Origin:** Inbox entry from a downstream spoke, processed in S29 and first recorded as input to
BACKLOG-026. The user then chose to implement it in the fork: an allowlist, rule text and hook
changed together, `_inbox` targets only.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-035).

---

## Problem Statement

`validate-cross-repo-write.sh` blocks every Write or Edit outside the repository unless the
target is in `.claude/cross-repo-writes-session.txt`, and `/dsm-go` Step 0f empties that file at
every boot. A project that writes inbox entries to other projects every day starts each session
with a confirmation before the first entry. The spoke reports this in two sessions in a row, and
once one of two confirmation lines did not reach the file.

The agent cannot remove the friction itself. `/dsm-wrap-up` Step 0.5 has the agent pre-confirm
known inbox folders, and in S28 the auto-mode classifier denied that step as self-modification.
BACKLOG-026 A1 also plans to stop it. A list that only the user writes is a standing confirmation
by the user, not one the agent gives itself.

## Proposed Solution (concept for Gate 2)

1. **The file.** `.claude/cross-repo-allowlist.txt`: one directory per line, `~` allowed, `#`
   comments and blank lines skipped. `/dsm-go` never resets it. Only the user writes it, in the
   editor.
2. **What a line allows.** A line counts only if its last path segment is `_inbox` and it resolves
   (`realpath`) to an existing directory. It allows Write and Edit of `.md` files directly inside
   that directory. Subdirectories (such as `done/`), other file types, and paths that resolve
   elsewhere through `..` or a symlink still need the session confirmation.
3. **Hook, Write/Edit branch.** After the session-file check and before the block: accept when
   the canonical target's parent equals a listed directory and the target ends in `.md`. Before
   the in-repo early exit: block (exit 2) a Write or Edit whose target is the allowlist file
   itself.
4. **Hook, Bash branch.** Treat the same targets as confirmed, so no warning. Warn (exit 1) on a
   Bash write whose target is the allowlist file.
5. **`/dsm-go` Step 0f.** After the reset, when the file exists, report one line per entry
   (allowed, or ignored with the reason) and whether git ignores the file, because it holds other
   projects' paths. Silent when the file is absent.
6. **Rule text.** DSM_0.2.C §2: a paragraph after the per-session cache sentence, and an
   "unless listed" clause on the inbox-push anti-pattern. T file: one bullet in the Cross-Repo
   Write Safety block. The list confirms the path only; Voice-Attribution Review (§2.3) still
   governs the content.

The exact hook code, snippet and wording are shown edit by edit at implementation (DSM_0.2.B §8.2).

## Success Criteria

- [ ] A listed `_inbox` directory accepts Write/Edit of a direct `.md` child with an empty session
  file; every other cross-repo target behaves as before.
- [ ] Write/Edit on the allowlist file is blocked; a Bash write to it warns.
- [ ] `/dsm-go` Step 0f reports the entries and the ignore status; silent without the file.
- [ ] DSM_0.2.C §2 and the T block state the rule, and the hook does what they state.
- [ ] Runtime copy deployed (`scripts/sync-commands.sh --deploy`), `diff -q` clean for `dsm-go.md`.

## Test Plan

Hook cases run by feeding tool JSON on stdin, against `mktemp -d` fixtures (a repo root and a
target project with `_inbox/`), asserting exit code and stderr reason (§19.1):

- [ ] T-1: listed `_inbox`, direct `.md`, empty session file: exit 0.
- [ ] T-2: listed `_inbox`, `done/x.md`: exit 2.
- [ ] T-3: listed `_inbox`, `x.txt`: exit 2.
- [ ] T-4: listed directory not named `_inbox`: exit 2.
- [ ] T-5: unlisted `_inbox`: exit 2.
- [ ] T-6: `_inbox/../x.md`: exit 2; a listed `_inbox` line that resolves to a folder with another
  name: exit 2; a symlink from elsewhere into a listed `_inbox` lands there: exit 0.
- [ ] T-7: Write and Edit on the allowlist file: exit 2 with the user-only reason.
- [ ] T-8: Bash `cp` into a listed `_inbox`: exit 0, no warning; into an unlisted one: exit 1;
  a redirect into the allowlist file: exit 1.
- [ ] T-9: no allowlist file: same results as the `upstream/main` hook, except the guard cases (T-7
  and the Bash write to the allowlist file), which apply whether the file exists or not (run the old
  hook first, per the regression lesson).
- [ ] T-10: Step 0f snippet in a Claude Code Bash session: one allowed line, one ignored line,
  ignore status; silent without the file.
- [ ] T-11: resolver sweep (§21.4) for the changed anti-pattern sentence and
  `cross-repo-writes-session` mentions that describe the confirmation rule.
- [ ] T-12: `git merge-tree --write-tree --name-only HEAD upstream/main`: record the result for
  the four upstream-owned files.
- [ ] T-13: egress sweep of the diff and the commit messages: `#NNN`, hex IDs, Central BL numbers
  and the name list, reported as counts with coverage.

## Risks (per DSM_0.2 §21.2)

- **A standing path gate admits writes nobody reviewed.** Mitigation: `.md` directly in `_inbox`
  only; the content gate (Voice-Attribution Review, and BACKLOG-026 A1 when it lands) is unchanged.
- **The agent writes the allowlist.** Mitigation: Write/Edit blocked, Bash warns, and every boot
  lists the entries. A Bash write is detected, not prevented; accepted.
- **The file is committed with other projects' paths.** Mitigation: the boot line reports the
  ignore status; here `.claude/` is excluded.
- **Upstream drift.** Four Central-owned files change; an upstream merge can conflict, and
  Central's text wins (§21.5). Mitigation: additive blocks re-applied mechanically; offer upstream.
- **Spokes do not get it automatically.** `/dsm-align` copies hooks from this hub, but `/dsm-go`
  skips `/dsm-align` on a version match. Mitigation: after merge, a spoke inbox note (its own
  approval) asks for one manual `/dsm-align`.

## Upstream Contribution

Offer to Central as an issue plus a PR on the four files, and as input to its item on human review
of inbox messages (DSM_0.2 §21.5).

## Test Execution Log (per DSM_0.2 §21.3)

S29, 2026-11-04, on `bl-035/cross-repo-inbox-allowlist`. Hook cases ran in `mktemp -d` fixtures (a
git repo, a project with `_inbox/`, `_inbox/done/` and `other/`, a second project, two symlinks),
tool JSON fed on stdin to the edited hook and to the `upstream/main` hook, exit code and first
stderr line recorded per case.

- [x] T-1: Write of a new `.md` and Edit of an existing `.md` directly in the listed `_inbox`,
  empty session file: exit 0 (upstream hook: 2 for both, so the cases discriminate).
- [x] T-2: `_inbox/done/a.md`: exit 2, "Cross-repo write blocked".
- [x] T-3: `_inbox/a.txt`: exit 2.
- [x] T-4: listed folder named `other`: exit 2.
- [x] T-5: unlisted `_inbox` of the second project: exit 2.
- [x] T-6: `_inbox/../a.md`: exit 2; listed line `X/_inbox`, a symlink to a folder named `other`:
  exit 2; a symlink from the second project into the listed `_inbox`: exit 0. The T-6 text was
  corrected in S29 to match the approved concept (the write is judged by where it lands).
- [x] T-7: Write and Edit on the allowlist file: exit 2 each, "Write to the inbox allowlist
  blocked" (upstream hook: 0, the file is inside the repo).
- [x] T-8: Bash `cp` into the listed `_inbox`: exit 0 (upstream: 1); into the unlisted one: 1;
  into `_inbox/done/`: 1; a `>>` redirect into the allowlist file: 1, and stderr carries the
  "only the user edits this file" note.
- [x] T-9: allowlist file absent: 12 of 15 cases give the upstream result; the 3 others are
  T-7 (Write, Edit) and the T-8 redirect, the guard that applies whether the file exists or not
  (T-9 text corrected in S29).
- [x] T-10 (dry run): the Step 0f snippet, run under zsh and bash in the fixture repo, printed
  the same lines: 2 allowed (an absolute path and a `~` path), 3 ignored (a folder not named
  `_inbox`, a symlink named `_inbox` resolving to `other`, a missing folder); ignore status `NO`
  without a `.gitignore` and `yes` with `.claude/` ignored; 0 bytes when the file is absent. The
  block in `dsm-go.md` is byte-identical to the tested file (`cmp`). Live boot: pending below.
- [x] T-11: §21.4 sweep over `DSM_*.md` and `scripts/commands/*.md` for `always requires
  confirmation`, `First write to any path outside`, `requires explicit user confirmation`,
  `one confirmation per cross-repo target` and `cross-repo-allowlist`. Hits: DSM_0.2.C L85
  (followed by the new paragraph), L218 (the amended line), T file L66 (qualified by the new
  bullet at L69), and the 5 new-text lines. 0 stale. Nothing was removed or renamed.
- [x] T-12: `git merge-tree --write-tree --name-only HEAD upstream/main`: exit 0;
  `upstream/main` is 0 commits ahead, so the four upstream-owned files merge clean today.
- [x] T-13: added lines of the branch diff (112 non-empty): `#NNN` 0, hex IDs 0, the source
  spoke's name 0 (control: 7 in the source file); 1 line mentions upstream (the T-9 text, a
  git ref). Name list: reported by the commit hooks.

### Pending verification

- [ ] T-10 live: the first `/dsm-go` after the deploy runs Step 0f in this hub (silent unless the
  user has created the allowlist).
- [ ] Spokes: each runs `/dsm-align` once to receive the hook; a spoke inbox note asks for it
  (separate approval).
- [ ] This hub's `.claude/CLAUDE.md` alignment block gets the T bullet at the next `/dsm-align`.
- [ ] Upstream offer (issue plus PR), per the Upstream Contribution section.
