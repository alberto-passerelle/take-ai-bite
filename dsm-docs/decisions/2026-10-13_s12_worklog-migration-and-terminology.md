# Decisions — Session 12 (2026-10-13)

**Date:** 2026-10-13
**Status:** Active
**Scope:** v1.33.0 / 1.33.1 adoption on this Kick-off'd public-mirror fork.
**Related:** `dsm-docs/guides/boot-safeguard-fork-migration.md`; `dsm-docs/research/2026-10-13_strict-model-boot-refusal.md`; BACKLOG-003; `dsm-docs/handoffs/2026-10-13_s12_handoff.md`

---

## D1 — Migration model split (non-strict for steps 1-4; strict for step 5)
Runbook steps 1-4 (merge upstream, `sync-commands --deploy`, `/dsm-align`, retire the old live work-log) run on a NON-strict model (Opus 4.8). Step 5 (strict-model boot verification) is the user's, in a separate session. Rationale: the runbook forbids strict models for steps 1-4 because they can decline mid-session on not-yet-migrated content.

## D2 — Config migration needs permission mode = manual
Writes to `.claude/` config files (CLAUDE.md, settings.json, worklog.md, markers) are declined under auto permission mode (the self-modification guard). A config / boot-safeguard migration must run with permission mode set to manual. The upstream merge and `sync-commands --deploy` (non-`.claude/` or user-level writes) are unaffected.

## D3 — Post-migration strict-model boot decline = treated as upstream
After a verified-complete migration, strict models decline at a fresh-session boot; Opus 4.8 is unaffected. Completeness was confirmed (the retired token is absent from every file loaded at boot). Leading hypothesis: the always-loaded reasoning-capture instructions (Worklog Protocol + DSM_0.2 §7) are the residual trigger surface — upstream-owned, so no fork-side change fixes it. Decision: run DSM sessions on Opus 4.8; neutralize boot-read notes (runbook step F); quarantine the verbatim detail + a drafted upstream issue in the research file; the user posts the issue. A strict-model re-test is pending to confirm this vs. the secondary hypothesis (the session's own wrap-up notes). Full symptom/label lives in the research file, not here.

## D4 — Terminology-cleanup rule for the retired live-work-log token (GOVERNS THE DEEP SWEEP)
When cleaning a file of the retired pre-1.33.0 live-work-log filename token:
- **Live / forward references** (the live log; the protocol going forward) -> `.claude/worklog.md` and "Worklog Protocol".
- **Historical references** (past-incident narratives; recorded test evidence) -> a euphemism ("the old live work-log file", "work-log") — NOT `worklog.md`, which would be anachronistic and would falsify a point-in-time record.
- **KEEP verbatim** (these are NOT the token): the hook name `validate-transcript-edit.sh`; the archive path `.claude/transcripts/...-ST.md`; git branch names (e.g. `bl-003/...transcript-displacement`); feature names in the trail (e.g. F-130 "Transcript replace_all guard"); and entire historical "Test Execution Log" blocks.
- **Boot-read files** (MEMORY, CLAUDE.md, checkpoints, handoffs, reasoning-lessons) must use the euphemism — `validate-boot-safeguard-write.sh` enforces this at write time, and these files are read at boot. **Non-boot-read files** (`dsm-docs/plans/`, `dsm-docs/blog/`) are consistency hygiene only.
- Only the CONTIGUOUS retired token is the "not-allowed" string; the word "transcript" on its own (hook names, archive paths, protocol history, feature names) is fine.

Applied S12 to BACKLOG-003 (fuller: token + protocol + live-log wording) and feature-trail.md (minimal: one historical line). This rule governs the pending deep sweep of the rest of `plans/` and `blog/`.

## D5 — Keep the BACKLOG-003 filename
Its slug contains "transcript" but not the contiguous token; renaming would ripple to `plans/README`, the held `bl-003` branch, and upstream issue #142. Kept.
