# BACKLOG-018: Guard Central's Main Branch Against Direct Changes From This Machine

**Status:** Implemented
**Date Implemented:** 2026-10-22
**Priority:** High (blocks the S19 pull-request work on Central)
**Extends:** DSM_0.2.C §2 (Destructive Action Protocol: an outward change to another repository); DSM_0.2 §20 (main receives merges only, never direct work)
**Date Created:** 2026-10-22
**Origin:** S19, user request after this account was given access to Central's repository.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-018).

---

## Problem Statement

This account can now change Central's repository. Its `main` must take no direct change from this
machine, whatever the server-side settings are. Any of three routes would land on the owner's `main`
without review:

1. `git push` to `main` from a local clone (plain, forced, or a deletion);
2. `gh pr merge` on one of Central's pull requests;
3. a `gh api` write call (the contents API commits straight to a branch; the refs API moves one).

A guard on this machine closes all three, independent of the server.

## Proposed Solution

One checker, `.claude/hooks/guard-protected-main.sh` (tracked, fork-local), with two callers, the
same shape as BACKLOG-013:

1. **`--pre-push`**, from the Central clone's local `.git/hooks/pre-push`. It refuses every pushed
   ref whose remote ref is `refs/heads/main` or `refs/heads/master`: update, force or deletion. It
   needs no list, because it is installed only in the clone it protects.
2. **`--tool-use`**, as a Claude Code PreToolUse hook on Bash in the local `.claude/settings.json`.
   It acts on `gh pr merge` and on `gh api` write calls (`-X`/`--method` POST, PUT, PATCH or DELETE,
   or fields that make `gh api` send a POST). It blocks when the target resolves to a repository in
   `.claude/protected-main-repos.txt` (untracked, one `owner/repo` per line):
   - a listed `owner/repo` appears in the command text (`--repo`, a PR URL, a `repos/...` path); or
   - the command names no repository, and the working directory, or a `cd` or `git -C` target in
     the command, is a git repository whose `origin` is listed.

- `gh api` writes to a listed repository are blocked whatever they touch. Pull requests and
  comments go through `gh pr create` and `gh pr comment`, which stay allowed.
- **Missing or empty list:** the checked commands are blocked (fail closed); all other commands pass.
- **Messages** name the route and the fix (open a pull request; the owner merges).

## Success Criteria

- [x] From the Central clone, a push to `main` (plain, `+` force, deletion) is refused; a push to any
      other branch passes.
- [x] `gh pr merge` and `gh api` writes aimed at a listed repository are blocked, by slug, by PR URL
      and by working directory; the same commands aimed at the fork pass.
- [x] `gh pr create`, `gh pr view`, GET `gh api` calls and non-`gh` commands pass.
- [x] With the list missing or empty, the checked commands are blocked with a message that says how
      to fix it.

## Test Plan

T-2 to T-6 run in scratch repositories under `/tmp` with a local bare remote. T-7 to T-13 feed
tool-use JSON from files written in an earlier tool call, so no hook sees a quoted `gh` command.
Every case asserts the exit code and the reason text.

- [x] T-1: `bash -n` passes; the file is executable.
- [x] T-2: pre-push, push to `main`: refused (exit 1, reason names `main`).
- [x] T-3: pre-push, force push `+HEAD:main`: refused.
- [x] T-4: pre-push, deletion `:main`: refused.
- [x] T-5: pre-push, push to `fix/x`: passes (exit 0) and the ref arrives in the bare remote.
- [x] T-6: whether `git push --dry-run` runs the pre-push hook (recorded, not asserted).
- [x] T-7: `gh pr merge N --repo <listed>`: blocked (exit 2).
- [x] T-8: `gh pr merge <PR URL of a listed repo>`: blocked.
- [x] T-9: `gh pr merge N` with `cwd` = a clone whose origin is listed: blocked; same with
      `cd <clone> && gh pr merge N` from another `cwd`.
- [x] T-10: `gh api -X PUT repos/<listed>/contents/x`: blocked; `gh api repos/<listed>/pulls`
      (GET): passes; `gh api repos/<listed>/git/refs -f ref=x`: blocked.
- [x] T-11: `gh pr merge N --repo <fork>` and `gh pr merge N` with `cwd` = the fork: pass.
- [x] T-12: `gh pr create --repo <listed> ...`, `gh pr view`, `ls`: pass.
- [x] T-13: list missing: T-7's command blocked with the fix hint; `ls` passes.
- [x] T-14 (live): after installation, `git push --dry-run origin HEAD:main` in the real clone is
      refused, or, if T-6 showed the hook does not run on `--dry-run`, the installed hook is run by
      hand with a main ref on stdin and refuses.
- [x] T-15 (live): with the hook wired, the next Bash call in the session runs normally.

## Risks (per DSM_0.2 §21.2)

- **`gh api graphql` mutations** name repositories by node ID, so the check cannot resolve them.
  *Accepted:* such calls are not part of this workflow; the memory rule covers them.
- **`git push --no-verify`, or a second clone without the hook,** bypasses the pre-push side.
  *Mitigation:* the memory rule and plans name the target ref; the tool-use side does not depend on
  the clone.
- **Over-blocking the fork's own wrap-up merge** (`gh pr merge` on the fork). *Mitigation:* T-11.
- **Working-directory resolution misses** a `pushd`, a subshell or a variable path. *Accepted and
  documented:* the slug-in-text and `cwd` routes cover the forms this workflow uses.
- **The hook sees quoted test commands** (S18 lesson). *Mitigation:* test inputs are files written
  in an earlier call; tests run before the hook is wired.

## Upstream Contribution

Not offered: a local guard for this account's access. The lasting fix is server-side protection on
Central, which is the owner's decision.

## Test Execution Log (per DSM_0.2 §21.3)

Run 2026-10-22 (S19) on macOS, bash. Scratch: `/tmp/s19-guard` (bare remote + work clone; fake
clones whose `origin` is Central over HTTPS and over SSH, and one whose `origin` is the fork over
SSH). Tool-use inputs were JSON files written by an earlier call with the `gh` string built split,
and all tool-use cases ran before the hook was wired.

| Test | Result | Evidence |
|---|---|---|
| T-1 | PASS | `bash -n` exit 0; file executable |
| T-2 | PASS | `git push origin main`: exit 1, "Push refused ... refs/heads/main -> refs/heads/main (update)" |
| T-3 | PASS | `+HEAD:main`: exit 1, "HEAD -> refs/heads/main (update)" |
| T-4 | PASS | `:main`: exit 1, "(delete) -> refs/heads/main (deletion)"; bare remote `main` unchanged after T-2 to T-4 (b6e24a4) |
| T-5 | PASS | `HEAD:refs/heads/fix/x`: exit 0; remote `fix/x` = local HEAD (acdc393) |
| T-6 | RECORDED | `git push --dry-run` runs the pre-push hook when there is something to push (exit 1, guard message). With nothing to push the hook is not called (seen in T-14). Pushes to `master` are refused the same way |
| T-7 | PASS | `--repo <Central>`: exit 2, "names <Central>"; variant with the slug in a variable assigned in the same command: exit 2 |
| T-8 | PASS | PR URL of Central: exit 2 |
| T-9 | PASS | `cwd` = fake Central clone (HTTPS origin): exit 2, "runs against ... remote 'origin' is <Central>"; `cd <fake clone> && ...` from the hub: exit 2; SSH origin (`git@github.com:`): exit 2 |
| T-10 | PASS | `-X PUT .../contents/...`: exit 2; GET `.../pulls`: exit 0; `.../git/refs -f ...`: exit 2; `-X PUT repos/{owner}/{repo}/...` with `cwd` = fake Central: exit 2; `-X GET search/issues -f q=...`: exit 0 |
| T-11 | PASS | `gh pr merge --repo <fork>`: exit 0; `gh pr merge` with `cwd` = this hub (remotes: fork, mirror): exit 0; fork over SSH: exit 0 |
| T-12 | PASS | `gh pr create --repo <Central> ...`, `gh pr view ... --repo <Central>`, `ls -la`: exit 0 each |
| T-13 | PASS | copy of the hook with no list: merge command exit 2, "protected-main-repos.txt is missing or empty"; `ls`: exit 0, no output |
| T-14 | PASS | Central cloned to `/Users/alberto/TAB/agentic-ai-data-science-methodology` (HEAD = Central main), hook installed right after the clone. `push --dry-run origin HEAD:main` exit 0 with no hook call: nothing to push (HEAD = origin/main), so it proved nothing. `push --dry-run origin +HEAD~1:refs/heads/main`: exit 1, guard message. Installed hook run by hand with a main ref on stdin: exit 1; with `fix/x`: exit 0. Remote main unchanged before and after |
| T-15 | PASS | Hook wired in the local `.claude/settings.json` (JSON parses; 6 Bash PreToolUse hooks). Next Bash call ran normally. Live probe, an `echo` whose text names a Central merge: blocked with the guard message |

**Finding from T-15:** like the egress check (S18 lesson), the guard also blocks a command that
only mentions a merge or an API write on Central, for example inside `echo` or a test string. This
fails safe; build such strings split or read them from files.

### Pending verification

None. Scratch directory `/tmp/s19-guard` left in place (no `rm -rf` without the user's request).
