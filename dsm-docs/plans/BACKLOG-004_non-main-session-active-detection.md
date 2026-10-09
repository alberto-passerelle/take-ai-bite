# BACKLOG-004: Active-Session Detection for STAA and Non-/dsm-go Sessions

**Status:** Implemented (fork-local, S7); methodology held on `bl-004` branch, upstream PR deferred until #125/#128 reconcile
**Priority:** High
**Date Created:** 2026-10-09
**Origin:** S6 concurrent-session incident (2026-10-09). A `/dsm-staa` session, started while this session (S6) was live and unwrapped, operated on the shared git working copy — created a branch, committed a BL, and moved this session's `HEAD` — because STAA runs no concurrent-session detection.
**Author:** Alberto (with AI assistance)

---

## 1. Problem

`/dsm-go` Step 0.7 runs the Concurrent-Session Detection Protocol (DSM_0.2.A §26):
it reads `.claude/session.lock`, probes the recorded pid for liveness, and hard-halts
on a LIVE concurrent session. **No other session-entry skill does this.** Verified by
reading `scripts/commands/dsm-staa.md` (96 lines): it has no lockfile, concurrent, or
active-session check anywhere — it selects a subject from `last-wrap-up.txt` /
`last-staa.txt` and never consults `.claude/session.lock`.

Because Claude Code conversations in one directory **share a git working copy**, a
second session that acts on git without detection produces exactly the §26 data
hazard. In the S6 incident the STAA session:

1. was started while S6 was live and unwrapped (lockfile present, S6's pid);
2. did not detect S6 (no lock check);
3. created `bl-580/transcript-boot-displacement` and committed a BL — which **moved
   S6's working-copy `HEAD`** onto that branch mid-session.

A second, related defect surfaced: `dsm-staa.md` Notes state STAA does **no git
commits** ("The analysis session is lightweight; no git commits, no wrap-up needed"),
yet the session branched and committed a BL. So STAA either exceeded its documented
read-only scope, or the scope is under-specified for the real case where STAA finds a
BL-worthy issue (which it legitimately did). Either way, the write it performed is
exactly what makes the missing detection dangerous.

## 2. Proposed Behavior

- **STAA reads the lock at start.** `/dsm-staa` runs a §26-style detection as its first
  step: read `.claude/session.lock`, probe liveness (reuse the `/dsm-go` Step 0.7a
  snippet verbatim — `kill -0` + `ps … claude` on the recorded pid). On a **LIVE**
  verdict, surface a non-suppressible warning and stop: "Session {N} is active and
  unwrapped; wrap it up before running STAA (concurrent working-copy hazard)."
- **STAA reads, never writes, the lock.** STAA does not create `.claude/session.lock`
  (it is designed to run in a separate conversation and must not claim the single-session
  invariant). It only reads an existing lock. This preserves the Step 5.7 /
  separate-conversation design.
- **Clarify STAA's write scope.** Settle whether STAA may create a BL at all. If yes, it
  MUST (a) have passed the active-session detection, and (b) file through the fork-local
  BL workflow (BL-005), not a guessed Central number and an ad-hoc commit. If no, STAA
  records the finding for a later `/dsm-go` session to file.
- **Candidate generalization (design to settle in the BL):** any non-`/dsm-go`
  session-entry skill that may write (not read-only) should run the same detection. Scope
  carefully against §26.5 (parallel-session-go is deliberately exempt — it shares the
  branch by design via commit booking).

## 3. Non-Contradiction Check (per BL-006)

§26 already exists upstream; this is an **additive** extension of it to STAA, not a
change to its verdict logic or to `/dsm-go` Step 0.7. It does not touch §26.5's
parallel-session exemption. It does not make STAA write a lock, so the single-session
invariant is unchanged. No upstream rule is contradicted; the change is contributed
upstream like any fork-local BL.

## 4. Success Criteria

- `/dsm-staa` runs a §26 liveness probe before selecting a subject; a LIVE concurrent
  session produces a non-suppressible stop.
- STAA never writes `.claude/session.lock`.
- STAA's write scope (may it file a BL?) is explicitly stated; if it may, it routes
  through BL-005's workflow.
- The parallel-session exemption (§26.5) is preserved.

## 5. Test Plan

- **T-1 (structural):** `/dsm-staa` command file contains a §26 detection step; `grep`
  the lockfile read + liveness probe.
- **T-2 (behavioral, deferred):** start `/dsm-staa` with a LIVE `.claude/session.lock`
  present; confirm the non-suppressible stop fires. Untestable without a second live
  session → deferred with a named trigger (§21.3 carve-out).
- **T-3 (structural):** confirm no `.claude/session.lock` **write** path was added to
  STAA.
- **T-4 (structural):** §26.5 parallel exemption text unchanged.

## 6. Risks (per DSM_0.2 §21.2)

- **Over-firing:** STAA legitimately runs in a separate conversation; if the probe halts
  on a STALE lock (a crashed prior session), it blocks valid analysis. *Mitigation:*
  reuse §26's LIVE/STALE/UNKNOWN verdict — halt only on LIVE; STALE/UNKNOWN warn and let
  the user proceed, exactly as §0.7c.
- **Liveness-probe unreliability:** the S6 lock recorded pid 81692, which was not in the
  live process list — so the recorded pid can be stale even for a live session, and the
  probe may misreport. *Mitigation:* this is a pre-existing §26 limitation (BL-487
  territory); BL-004 inherits §26's probe and does not try to fix it here. Flag it.
- **Scope creep to all skills:** extending detection to every non-`/dsm-go` skill is a
  larger surface. *Mitigation:* v1 targets STAA (the demonstrated case); generalization
  is a noted follow-up, not pre-committed.

## 7. Test Execution Log (per DSM_0.2 §21.3)

Implemented S7 (2026-10-09) on `bl-004/non-main-session-active-detection` (commit `14a2f45`).
Edits: `scripts/commands/dsm-staa.md` (new `## Step 0: Active-Session Detection` + write-scope
Notes clause, Option A) and `DSM_0.2.A_Session_Lifecycle.md` §26.2 (one additive lifecycle-table
row). Runtime deployed via `scripts/sync-commands.sh --deploy` (exit 0); user-level
`~/.claude/commands/dsm-staa.md` verified carrying Step 0 + the scope clause.

- **T-1 (structural) — PASS.** `grep` on `scripts/commands/dsm-staa.md`: `## Step 0:
  Active-Session Detection (per BL-004)` (line 20), `Read \`.claude/session.lock\`` (line 29),
  the `kill -0 "$LOCK_PID" … ps … grep -q claude` probe and `VERDICT=LIVE` (lines 37-38).
- **T-3 (structural) — PASS.** No lock *write* path added: `grep -E '>+ *\.claude/session\.lock|cat *> *…'`
  returns nothing; the only three `session.lock` references in STAA are reads/prose (lines 29, 34, 52),
  including the explicit "STAA reads, never writes, the lock."
- **T-4 (structural) — PASS.** `git diff DSM_0.2.A` is exactly one added table row; §26.5 parallel
  exemption text unchanged (still at the `### 26.5.` heading).
- **T-2 (behavioral) — DEFERRED** (§21.3 untestable-by-design carve-out). Requires a second LIVE
  `.claude/session.lock` + a concurrent window, which the implementing session cannot stage.
  **Trigger:** next time two sessions are open on this clone, start `/dsm-staa` and confirm the
  non-suppressible LIVE halt fires. Added to Pending verification below.

### Pending verification

- [ ] T-2: behavioral LIVE-halt test (needs a concurrent live session; deferred with named trigger above)
