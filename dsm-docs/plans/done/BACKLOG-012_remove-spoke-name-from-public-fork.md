# BACKLOG-012: Remove the Reporting Spoke's Name From the Public Fork

**Status:** Implemented
**Date Implemented:** 2026-10-19
**Priority:** High
**Extends:** DSM_0.2 §21.5, the "Name-free, always" bullet (applied to session artifacts and configuration already on the public fork)
**Date Created:** 2026-10-19
**Origin:** STAA analysis of the S17 worklog, candidate 1 (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`); scope measured by a read-only sweep in S18.
**Author:** Alberto (with AI assistance)
**Backlog line:** Fork-local independent numbering (BL-012).

---

## Problem Statement

§21.5 requires every fork-local file on a public fork to be name-free. The fork
`alberto-passerelle/take-ai-bite` is public, and the S18 sweep (2026-10-19) found the name of the
reporting downstream spoke in:

- the current tree of `main`: 8 files, 11 mentions. `.gitignore` (3: an ignore pattern and its
  two-line comment) and 7 checkpoints in `dsm-docs/checkpoints/done/` (S4, S7, S7-continuation,
  S9, S10, S11, S15);
- 5 of the 6 `archive/bl-*` tags on the fork (`bl-003`, `bl-004`, `bl-007`, `bl-009`, `bl-010`;
  `bl-005-006` is clean);
- the title of fork PR #11;
- the history of `main`: 12 commits since 2026-10-06, 2 of them in the commit message.

Upstream TAB is clean: its tree, the six PRs this fork opened there (#122, #125, #128, #136,
#138, #140) and its issue and PR search returned no match. The STAA handoff named one session
artifact; the sweep found seven plus `.gitignore`.

## Proposed Solution

1. **Checkpoints:** replace each mention with "a downstream spoke", wording adjusted per line.
2. **`.gitignore`:** remove the pattern and its comment; add the pattern to `.git/info/exclude`
   (local, untracked), so the spoke's inbox files stay ignored outside `_inbox/` as well. A
   neutral comment in `.gitignore` points there.
3. **Tags:** delete the five affected `archive/bl-*` tags from the fork; keep them locally as the
   archive.
4. **PR #11:** retitle it to say "a downstream spoke's archives". Its description also named the
   spoke (found by T-6, see the log); the same phrase was replaced there.
5. **History of `main`:** not rewritten; recorded under Risks as an accepted risk.

The name is never written into this BL, a command line or the worklog. Sweeps decode it at run
time, or read it from the gitignored deny-list `.claude/name-denylist.txt` with `grep -f`, which
does not print the pattern. The user maintains the deny-list.

## Success Criteria

- [ ] A sweep of the fork's `main` tree returns 0 files once the session PR merges.
- [x] The spoke's inbox files stay ignored, inside and outside `_inbox/`.
- [ ] No branch or tag on the fork contains the name (tags done; `main` waits for the session PR).
- [x] A search of the fork's issues and PRs returns 0.
- [x] The history decision is recorded with what it leaves in place.

## Test Plan

- [ ] T-1 (§19.1): before any zero is trusted, the same sweep finds the name in a known location
      (`.git/info/exclude` after step 2).
- [ ] T-2: `git grep -l -i` over the `bl-012` tree returns 0 files; after the session PR merges,
      the same over `origin/main`.
- [ ] T-3: `git check-ignore -v` ignores the spoke's inbox file inside `_inbox/` and a test path
      outside `_inbox/`, the second through `.git/info/exclude`.
- [ ] T-4: `git diff --name-only` between `session-17` and `bl-012` lists exactly the 7 checkpoints,
      `.gitignore` and this BL's own files.
- [ ] T-5: `git ls-remote origin` lists none of the five tags; locally all six `archive/bl-*` tags
      still resolve to the SHAs recorded before deletion.
- [ ] T-6: `gh search issues --include-prs` on the fork returns 0, with a self-test on a word known
      to be present.
- [ ] T-7: once `.claude/name-denylist.txt` exists, `git grep -i -f` with it over the tree returns
      0 files and the T-1 self-test passes with it. Deferred until the user creates the file.
- [ ] T-8 (§21.4): the removed string is the name itself, so T-2 is the Resolver sweep; record it
      once, not twice.

## Risks (per DSM_0.2 §21.2)

- **The name stays reachable.** History, the fork's 16 PR refs and GitHub's caches keep it
  reachable for anyone who opens older commits; deleting tags removes refs, not objects.
  *Accepted* (user decision, S18): rewriting `main` needs a force-push and would still leave the
  PR refs, which a push cannot change. GitHub's documentation on removing sensitive data routes
  full removal through GitHub Support (to verify before relying on it). Revisit if the spoke's
  owner asks for removal.
- **PR #11 keeps the old wording on its page.** The retitle added a public "renamed" event whose
  old-title field still names the spoke, and the description edit left the old text in the
  description's edit history. *Accepted* for the event (user decision, S18): no way for users to
  remove it is known; GitHub Support is the route if removal is ever requested. The edit
  history is open: GitHub states that "Comment authors and anyone with write access to a
  repository can delete sensitive information from a comment's edit history"
  (docs.github.com, "Tracking changes in a comment", read 2026-10-19), but does not say whether
  this covers a PR description. Not attempted; it is a further change on GitHub that needs the
  user's approval.
- **Weaker ignore protection in other clones.** A fresh clone of the fork lacks the local exclude.
  *Mitigation:* `_inbox/*` and `_inbox/done/*` still ignore the inbox in every clone; only files
  outside `_inbox/` depend on the local exclude.
- **Checkpoints lose which spoke they meant.** *Accepted:* the mapping survives in the local,
  gitignored inbox archive.
- **The fix republishes the name.** A sweep that prints matches, or a commit message quoting the
  old line, puts the name back in public. *Mitigation:* redacted output only; commit messages pass
  the same sweep before any push.
- **Recurrence.** Nothing yet stops the next artifact from naming the spoke. *Mitigation:* STAA
  candidate 2 (a name check before every push), filed separately per §21.

## Test Execution Log (per DSM_0.2 §21.3)

Executed in S18 (2026-10-19) on `bl-012/remove-spoke-name` (fix commit `9ba66a1`). The name was
decoded at run time; all printed output was redacted.

- T-1: pass. The sweep finds the name once in `.git/info/exclude` (line 16) after the move, and
  three times in `.gitignore` on `HEAD` before it.
- T-2: pass for `bl-012`: tracked working tree 0 files, file names 0, committed tree at `9ba66a1`
  0 files. The `origin/main` half is pending (below).
- T-3: pass. `git check-ignore -v` matched the spoke's inbox file through `.gitignore:131`
  (`_inbox/*`) and a test path outside `_inbox/` through `.git/info/exclude:16`. Evidence is the
  printed match lines; that command's exit code came from a pipe and is not used.
- T-4: pass. The fix commit changes exactly `.gitignore` and the 7 checkpoints; closing adds this
  file's move and the two index files.
- T-5: pass. After deleting the five tags (`git push origin --delete`, exit 0), `git ls-remote`
  lists only `archive/bl-005-006`, which has 0 hits. The six local `archive/bl-*` tags match the
  record taken before deletion (`diff` exit 0).
- T-6: first run FAILED, then pass. After the retitle the fork search still returned PR #11: its
  description named the spoke once (comments, reviews, review comments and branch name: 0). After
  the description edit, `gh pr view` shows 0 hits in title and body, and the search returns 0
  (self-test on "downstream": 1). The timeline "renamed" event is not covered by the search and is
  recorded under Risks.
- T-7: deferred; `.claude/name-denylist.txt` does not exist yet.
- T-8: T-2 is the Resolver sweep. Prose checks: the one path this BL cites
  (`dsm-docs/handoffs/done/2026-10-19_s17_staa-bl-candidates.md`) exists; the counts in the
  Problem Statement are the sweep's output; mirror/deploy coverage does not apply (fork-local
  files, no mirror).

### Pending verification

- [ ] T-2 on `origin/main`: once the S18 session PR (#16) merges at wrap-up, `git grep -l -i`
      over `origin/main` returns 0 files, with the T-1 self-test.
- [x] T-7: done in S18 after the list was created (one entry): `git grep -l -i -w -F` with the
      list over `HEAD` and over `origin/session-17` returns 0 files; the self-test with the same
      list matches 1 line in `.git/info/exclude`.
