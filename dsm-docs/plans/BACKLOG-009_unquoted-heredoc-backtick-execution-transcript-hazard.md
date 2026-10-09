# BACKLOG-009: Unquoted-Heredoc Backtick/Command-Substitution Hazard in Transcript Appends

**Status:** Proposed
**Priority:** Medium
**Date Created:** 2026-10-09
**Origin:** S7 §22 incident (2026-10-09). A session-transcript Output block was appended with an unquoted heredoc (`cat >> ... << EOF`). The block's prose contained a backtick-quoted example command, and an unquoted heredoc performs command substitution on backtick (and `$(...)`) spans in its body — so the shell executed the example, creating a stray branch and writing empty where the command text should have been. Every command exited 0; the corruption surfaced only because the branch-switch message printed.
**Author:** Alberto (with AI assistance)

---

## 1. Problem

DSM_0.2 §7 (Session Transcript Protocol) warns about one heredoc hazard — a
**single-quoted** heredoc (`<< 'EOF'`) suppressing `$(date +%H:%M)` expansion, writing the
literal string instead of the timestamp (observed S69) — and its stated fix is "capture the
timestamp into a variable first and use an **unquoted** heredoc."

That fix has an unguarded inverse. An **unquoted** heredoc performs command substitution on
every backtick span and `$(...)` span in its body. Transcript prose routinely contains
backtick-quoted example commands (naming a git command, a path, a snippet under discussion).
When such prose is appended through an unquoted heredoc, the shell **executes** the example.

Two properties make it dangerous:

1. **Silent.** The substitution and any command it runs exit 0; the heredoc write succeeds.
   The only trace is whatever the executed command happened to print, and the body text is
   silently replaced by the command's stdout (usually empty).
2. **Append-only means unrecoverable at write time.** The corrupted transcript line cannot be
   un-written; the transcript is append-only, so recovery is a `[RETROACTIVE]` note, never an
   in-place fix.

§7 already names the Edit-tool append path as **preferred** and the heredoc as a fallback, but
it does not state *why the fallback is hazardous for backtick-bearing content*, so the heredoc
route is reached for whenever the Edit anchor is inconvenient (here, a duplicated last-line
anchor), carrying the hazard with it.

## 2. Proposed Behavior

Add a companion anti-pattern to DSM_0.2 §7 (alongside the existing single-quoted-heredoc
DO-NOT), stating:

- An **unquoted** heredoc executes backtick and `$(...)` spans in its body; transcript prose
  often contains backtick-quoted example commands, so the unquoted heredoc can execute them.
- Therefore the **Edit-tool append path is primary** for transcript writes (it has no shell).
  The heredoc fallback is used only when the Edit path is genuinely unavailable **and** the
  body contains no backtick or `$(...)` spans.
- If a heredoc is unavoidable and the body must contain backticks, escape them (`\``) or route
  the literal content so the shell cannot substitute it; quoting the delimiter (`<< 'EOF'`)
  blocks substitution but reintroduces the S69 timestamp-suppression bug, so the timestamp must
  then be inlined literally rather than via `$(date)`.

The two heredoc hazards are a matched pair and should sit together so neither fix reintroduces
the other.

## 3. Non-Contradiction Check (per §21.6)

This **adds** an anti-pattern bullet to §7; it does not change the transcript delimiter format,
the append-anchor rule, or the preferred/fallback ordering (it reinforces the existing
Edit-primary ordering). It contradicts no upstream rule — it closes a gap the existing S69
guidance left open. The upstream surface it relates to is §7's heredoc anti-pattern block.
Contributed upstream as a §7 clarification like any fork-local BL.

## 4. Success Criteria

- §7 states the unquoted-heredoc backtick/`$()` execution hazard as an explicit anti-pattern.
- The anti-pattern names the Edit-tool path as primary and the exact condition under which the
  heredoc fallback is safe (no backtick/`$()` in the body).
- The two heredoc hazards (S69 suppression, S7-this-incident execution) are cross-referenced so
  a future fix to one does not reintroduce the other.

## 5. Test Plan

- **T-1 (structural):** §7 contains the unquoted-heredoc execution anti-pattern; `grep`.
- **T-2 (structural):** the new anti-pattern cross-references the existing single-quoted-heredoc
  DO-NOT; `grep` both directions.
- **T-3 (behavioral):** a heredoc with an unquoted `<< EOF` and a backtick example in the body
  executes the example (the incident), while the Edit-tool path and an escaped/`<< 'EOF'` form do
  not — a three-way demonstration recorded in the Test Execution Log.

## 6. Risks (per DSM_0.2 §21.2)

- **Over-correction to "never use heredoc".** The heredoc fallback is legitimate for
  backtick-free content when the Edit anchor is unavailable. *Mitigation:* the rule scopes the
  prohibition to backtick/`$()`-bearing bodies, not all heredocs.
- **Reintroducing S69 when escaping.** Quoting the delimiter to block substitution brings back
  the timestamp-suppression bug. *Mitigation:* the rule pairs the two hazards explicitly and
  requires a literal inlined timestamp when the delimiter is quoted.
- **Ritual compliance.** "Used the Edit path" asserted without the anchor actually being valid
  (the duplicated-anchor case that drove the heredoc detour here). *Mitigation:* the rule notes
  the duplicated-last-line case and that a retroactive Bash-heredoc recovery must still avoid
  backticks in its body.

## 7. Test Execution Log (per DSM_0.2 §21.3)

_Not yet implemented (anti-pattern not yet written into §7)._

### Pending verification

- [ ] All Test Plan items (deferred: Proposed, not implemented)
