# Strict-model boot refusal after v1.33.1 migration (quarantine + diagnosis)

**Date:** 2026-10-13 (Session 12)
**Status:** Open — reported to user for upstream filing
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

## Upstream issue draft (for the user to post on the public mirror)

> **Title:** Strict models (Opus 5.5 / Opus 5) still refuse at `start` after the
> v1.33.1 boot-safeguard migration — detail `[reasoning_extraction]`
>
> **Body:**
> After completing the v1.33.1 fork migration (runbook
> `dsm-docs/guides/boot-safeguard-fork-migration.md`, steps 1-4), a fresh-session
> boot still refuses on strict models.
>
> Steps: complete steps 1-4 on a non-strict model (Opus 4.8, all succeed); open a
> fresh session on Opus 5.5; send a bare `start`.
>
> Symptom: Opus 5.5's safeguards stop the response; client auto-falls-back to
> Opus 5, which also refuses with a hard API error. Both report detail
> `[reasoning_extraction]`. The same content runs normally on Opus 4.8.
>
> Migration verified complete (not leftover content): no retired-filename token in
> any file loaded at `start` (CLAUDE.md, DSM_0.2 core, MEMORY); §7 is "Worklog
> Protocol" on disk; the guard hook is installed and wired.
>
> Assessment (classifier is opaque, not reverse-engineered): the always-loaded
> instruction to externalize plan/reasoning each turn (Worklog Protocol + DSM_0.2
> §7) is the likely residual trigger surface for the `reasoning_extraction` facet
> that v1.33.0's rewording did not fully resolve for the Opus 5 family. Not quoting
> any blocked text, per the runbook. Can provide the file set loaded at `start` or
> run further non-strict diagnostics.
>
> (Anthropic-side identifiers, if useful to forward: Request `req_011CfzEDQwqjChcmFsgSV3V1`.)

## Practical workaround

Use **Opus 4.8** for DSM sessions on this fork until upstream resolves it. Both
Opus 5.5 and Opus 5 currently refuse at boot; Opus 4.8 is unaffected.
