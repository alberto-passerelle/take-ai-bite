# BACKLOG-013: Block Pushes and GitHub Posts That Contain Listed Names

**Status:** Proposed
**Priority:** Medium
**Extends:** DSM_0.2.C §5.7 (the prevention half, for a fork whose `main` is the public surface and has no mirror-sync gate); DSM_0.2.C §5.8 (the check reports generically); DSM_0.2 §21.5 ("Name-free, always")
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 2 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`), widened in S18 after BACKLOG-012 found a name in a PR title and description, which no git-side check sees.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-013).

---

## Problem Statement

§21.5 requires fork-local content to be name-free, and §5.7 adds prevention, which Central
enforces with its mirror-sync content scanner. A fork has no mirror step: its `main` is the public
surface, so nothing checks content before it leaves. In S17 the check ran by hand, found the hit,
and the hit still shipped (BACKLOG-012). Names also leave as GitHub text: PR #11's title and
description carried one (BACKLOG-012, T-6).

The fork cannot reuse Central's scanner. The mirror-sync manifest (category 7) lists
`scripts/check-mirror-sync-content.sh` as mirrored 1:1, but neither this fork nor upstream TAB
ships it (checked in S18).

## Proposed Solution

One checker, `.claude/hooks/check-public-egress.sh` (a new tracked fork-local file), called from two
places:

1. **`--pre-push`**, from a local `.git/hooks/pre-push`. For each pushed ref it checks every commit
   not yet on the remote: added lines, file names, the commit message, and the message of an
   annotated tag. Checking each commit, not only the end state, catches a name added and removed
   inside one push, which stays public in history.
2. **`--tool-use`**, as a Claude Code PreToolUse hook on Bash, registered in the local
   `.claude/settings.json`. It acts on `gh pr|issue create|edit|comment|review`,
   `gh release create|edit`, and `gh api` calls that send fields (`-f`, `-F`, `--field`,
   `--raw-field`, `--input`, or a POST/PATCH/PUT method). It checks the command text and every file
   passed as `--body-file`, `-F` or `@file`.

- **Matching:** whole-word, case-insensitive, fixed strings from `.claude/name-denylist.txt`
  (gitignored; one entry per line; blank lines and `#` comments ignored), maintained by the user.
- **On a hit:** block (pre-push exit 1, hook exit 2) and report the commit or the source and a
  count, never the matched value (§5.8).
- **Missing or empty list:** block (fail closed). `git push --no-verify` is the deliberate bypass
  on the git side (user decision, S18).
- **If Central's scanner reaches the fork,** replace the matching here with it rather than keeping
  two tools.

## Success Criteria

- [ ] A push whose commits carry a listed name in an added line, a file name, a commit message or
      a tag message is refused, with a message that names no listed value.
- [ ] A `gh` command that would post a listed name in its arguments or body file is blocked before
      it runs.
- [ ] Clean pushes and clean `gh` commands pass; `gh` commands that send nothing (view, list,
      checks, GET `api`) are not checked.
- [ ] With the list missing or empty, pushes and posting `gh` commands are refused with a message
      that says how to fix it.
- [ ] A listed word inside a longer word does not match.

## Test Plan

T-2 to T-11 use a made-up test word in a temporary list, in a scratch repo under `/tmp` with a
local bare remote. No GitHub call, no real name.

- [ ] T-1: `bash -n` passes on the checker, and the file is executable.
- [ ] T-2 (pre-push, missing list): a push from the scratch repo is refused.
- [ ] T-3: test word in an added line: refused.
- [ ] T-4: test word only in a commit message: refused.
- [ ] T-5: test word only in a file name: refused.
- [ ] T-6: test word added in one commit and removed in the next, both in one push: refused.
- [ ] T-7: annotated tag whose message carries the test word: refused.
- [ ] T-8: clean commit: push succeeds; record whether the hook also runs on `git push --dry-run`.
- [ ] T-9 (tool-use, synthetic hook input): a non-posting command passes even with the list
      missing; `gh pr create` with the word in `--title`, in a `--body-file` file, or in a heredoc
      body is blocked (exit 2); a clean one passes; a posting `gh api` is blocked; a GET `gh api`
      passes; a posting command with the list missing is blocked.
- [ ] T-10 (§5.8): no hook output captured in T-2 to T-9 contains the test word.
- [ ] T-11 (over-firing): the test word inside a longer word passes.
- [ ] T-12 (live wiring, after installation): in this repo, with the real list still absent, a
      `git push --dry-run` to `origin` is refused by the hook (if T-8 shows the hook runs on
      dry-run), and a posting `gh api` call that would be harmless if it ran is blocked.
- [ ] T-13 (§21.4): the change adds files and removes or renames no string, so the sweep is
      recorded as empty; the cross-references in this BL resolve.

## Risks (per DSM_0.2 §21.2)

- **Bypass.** `git push --no-verify` skips the git side; the GitHub web UI or another client skips
  both. *Accepted:* the hooks guard the paths that leaked (the agent and the CLI); `--no-verify`
  is used only on the user's explicit request.
- **Unrecognized `gh` calls.** `gh` invoked through a variable, a script or `xargs` is not seen by
  the tool-use check. *Accepted* for GitHub text; commits stay guarded by the git side.
- **Over-firing.** A short or common entry matches ordinary text, and fail-closed blocks every
  push until the list exists. *Mitigation:* whole-word matching (T-11); the user curates the list;
  the missing-list message names the fix.
- **The checker leaks the list.** Error output, traces or temp files could expose listed values.
  *Mitigation:* messages carry counts and commit IDs only (T-10); the cleaned pattern file is a
  `mktemp` file removed on exit; no `set -x`.
- **Wiring is local.** `.git/hooks/pre-push` and `.claude/settings.json` are untracked, so a fresh
  clone runs without the check. *Mitigation:* the checker's header documents both install steps;
  `/dsm-align` keeps user-added hooks in `settings.json` (it never removes non-template entries).
- **Platform.** Tested only on macOS (bash 3.2, BSD grep). The grep flags used (`-i -w -F -f`)
  exist in GNU grep, which is untested here. *Accepted:* this hub is the only clone.

## Upstream Contribution

Optional per §21.5. Two candidates: a §5.7 note that a fork without a mirror step needs its own
prevention gate, with this checker as one example; and a feedback issue that the manifest lists
`check-mirror-sync-content.sh` as mirrored while upstream does not ship it.

## Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, not implemented)
