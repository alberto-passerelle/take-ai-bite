# Strict-model boot refusal after v1.33.1 migration (quarantine + diagnosis)

**Date:** 2026-10-13 (Session 12)
**Status:** Root cause found + resolved locally (Session 14) — a cumulative boot-context
content-load on the Opus 5 family, not a single file or a wording. HUB migrated to a lean
boot state; run on Opus 4.8 meanwhile. Upstream issue drafted below. See "Session 14", below.
**Why this file:** the verbatim detail below is kept here (a non-boot-loaded
`dsm-docs/research/` quarantine log, per the `validate-boot-safeguard-write.sh`
guidance) so the always-loaded / boot-read files (MEMORY, checkpoint,
reasoning-lessons) can stay in general terms per runbook step F.

## Symptom (verbatim, from the user's strict-model session)

After completing the v1.33.1 boot-safeguard fork migration (runbook
`dsm-docs/guides/boot-safeguard-fork-migration.md` steps 1-4), the user opened a
fresh session on **Opus 5.5** and sent a bare `start`:

- Opus 5.5's safeguards stopped the response; the client auto-fell-back to Opus 5.
- Opus 5 also refused with a hard API error.
- Both reported detail label **`[reasoning_extraction]`**.
- `Request ID: req_011CfzEDQwqjChcmFsgSV3V1` · `Message ID: msg_011CfzEDRoC6RXREogx6VfmU`

The same content loads and runs normally on **Opus 4.8** (the migration session).

## Migration verified complete (not the cause)

Runbook section H diagnostic re-run on 2026-10-13:
- `.claude/CLAUDE.md`: 0 occurrences of the retired work-log filename token.
- `DSM_0.2_Custom_Instructions_v1.1.md` (core, @-imported at start): clean; §7 is
  "Worklog Protocol" on disk (post-merge 1.33.1).
- `MEMORY.md`: 0 occurrences.
- Only `DSM_0.2.G_Transcript_Enforcement.md` (an on-demand module, NOT loaded at
  bare `start`) and the guard hook itself carry the token — both legitimate.

So no always-loaded file carries leftover pre-1.33.0 content. This is the §H
"still refused at boot after all steps" case.

## Two hypotheses for the `[reasoning_extraction]` trigger

1. **Upstream reasoning-capture protocol (most likely for `reasoning_extraction`).**
   The always-loaded DSM instructions direct the model to externalize its
   plan / reasoning / decision process every turn (Worklog Protocol in the
   CLAUDE.md managed block + DSM_0.2 §7, incl. the "Contemporaneous Work Log"
   paragraph). A `reasoning_extraction` classifier keys on exactly that shape.
   v1.33.0 reworded some phrasings but the protocol's core instruction to log
   reasoning necessarily remains. If this is the cause, it is an UPSTREAM matter
   (the mirror must not locally edit methodology files) and no local change fixes it.
2. **Local safeguard-describing notes added during the S12 wrap-up (secondary).**
   The wrap-up wrote content describing the safeguard/refusal mechanism into
   boot-read files (MEMORY S12 entry, the S12 checkpoint, 3 of the 5 S12
   reasoning-lessons, the `last-align.txt` note). Runbook step F says such notes
   must be general, not describe the refusal. This is a hygiene defect regardless,
   and a possible contributor.

**Disambiguation:** neutralize the local notes (hypothesis 2), then re-test a
strict-model boot. Still refused -> hypothesis 1 confirmed (upstream). Passes ->
the local notes were the trigger.

## Session 14 — isolation, root cause, and resolution

Hypothesis 2 (local notes) was neutralized and re-tested: a fresh **Opus 5.5** boot
**still stopped**, so local notes were not the (sole) cause. A full bisection followed,
each step a fresh strict-model boot (the user ran each; Opus 4.8 cannot reproduce):

| State | Result |
|-------|--------|
| `CLAUDE.md` moved aside (removes it + the `@`-imported methodology core); worklog hook ON | STILL STOPS |
| `CLAUDE.md` off AND the `UserPromptSubmit` worklog hook off | CLEAN |
| `CLAUDE.md` restored (full methodology); hook off | STILL STOPS |
| Full config, boot-read work-log replaced with a clean stub | bare `start` recovers; `/dsm-go` still stops |
| HUB `reasoning-lessons` shrunk to clean-copy size | `/dsm-go` still stops |

Three clean references settle it: the **AISA spoke**, a **pristine public-TAB clone**, and a
**fresh clone of HUB itself** all boot `/dsm-go` clean on Opus 5.5. The fresh HUB clone's
`DSM_0.2` is **byte-for-byte identical** to the failing working copy, and its `CLAUDE.md`
differs only cosmetically.

**Root cause:** the `[reasoning_extraction]` safeguard on the Opus 5 family reacts to the
**aggregate volume/density** of methodology + meta content in the boot context — not any
single file, hook, or wording. A pristine clone stays under the threshold; the mature HUB
working copy tips over it (accumulated gitignored boot files, 9 local task branches that
`/dsm-go` scans with `git log main..branch`, path-keyed MEMORY, and the git/gh boot activity
over 20 branches / 5 PRs). Ruled out individually: the methodology core (identical to a
clean-booting copy), the worklog hook (same hook boots the clean references), MEMORY, the
`reasoning-lessons` file alone, blog/plans, and the `SessionStart` hook (a benign one-liner).

**Resolution (Session 14):** migrated the HUB working copy to a lean boot state — deleted the
9 local task branches (all preserved on `origin`), reset `reasoning-lessons` / MEMORY /
work-log to lean (full content backed up under `hub-migration-backup-2026-10-14/`). Standing
discipline: prune `reasoning-lessons` on cadence, delete merged branches promptly, keep
MEMORY lean, and keep boot-read files free of the flagged vocabulary.

## Upstream issue draft (for the user to post on the public mirror)

> **Title:** Opus 5 family trips `[reasoning_extraction]` at DSM boot on the hub but not on
> a spoke or a fresh clone — cumulative methodology content-load, not any single file
>
> **Body:**
> On the Opus 5 family (Opus 5.5, Opus 5), a mature DSM hub session is stopped by the
> `[reasoning_extraction]` safeguard at boot. Opus 5.5 soft-stops on a bare `start` and
> hard-stops on `/dsm-go`; the client falls back to Opus 5, which returns a hard API error
> with the same detail label. The identical setup runs normally on Opus 4.8.
>
> **Reproduction:** open a fresh Opus 5.5 session in a mature DSM hub repo; send `start`,
> then `/dsm-go`.
>
> **Isolation (each a fresh Opus 5.5 boot):**
> - Project `CLAUDE.md` moved aside (removes it + the `@`-imported methodology core),
>   worklog-reminder hook still on → still stops.
> - Worklog-reminder hook also disabled → clean.
> - `CLAUDE.md` restored (full methodology), hook off → still stops.
> - Full config, boot-read work-log replaced with a clean stub → `start` recovers,
>   `/dsm-go` still stops. Shrinking the 35 KB `reasoning-lessons` mirror alone → still stops.
>
> **Key comparison:** three clean references boot `/dsm-go` fine on Opus 5.5 — a lighter DSM
> *spoke*, a *pristine public-TAB clone*, and a *fresh clone of the hub itself*. The fresh
> hub clone's `DSM_0.2` is **byte-for-byte identical** to the failing working copy and its
> `CLAUDE.md` differs only cosmetically; all run the same worklog hook. So no single file,
> hook, or wording is the trigger — the difference is the *accumulated* boot state a mature
> working copy carries (gitignored boot files, many local branches that `/dsm-go` scans,
> path-keyed memory, git/gh boot activity over branches/PRs).
>
> **Assessment (classifier is opaque, not reverse-engineered):** the safeguard appears to
> read the cumulative volume/density of methodology + meta content in the boot context. A
> pristine clone stays under the threshold; a mature hub sits over it.
>
> **Suggested DSM-side actions:** (a) keep boot-read files (work-log, MEMORY, checkpoints)
> free of safeguard-vocabulary; (b) bound the hub's boot footprint — prune `reasoning-lessons`
> on cadence, delete merged branches, make heavy boot reads lazy; (c) consider raising with
> Anthropic that the safeguard over-fires on a benign data-science methodology corpus at
> scale. Not quoting any flagged text.
>
> (Anthropic-side identifiers, if useful: Requests `req_011CfzEDQwqjChcmFsgSV3V1`,
> `req_011CfzwzpNH3uF3Urv6bZZFb`, `req_011CfzyaP9JAJxr7Tvgdi3Js`.)

## Practical workaround

Use **Opus 4.8** for DSM sessions on this fork until upstream resolves it. Both
Opus 5.5 and Opus 5 currently refuse at boot; Opus 4.8 is unaffected.
