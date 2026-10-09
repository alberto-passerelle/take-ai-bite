# BACKLOG-001: Data-Protection / Compliance Briefing by Design (project-type-adaptive)

**Status:** Implemented (fork-local, v1); session-start wiring deferred to v1b; upstream contribution pending
**Priority:** Medium
**Date Created:** 2026-10-08
**Origin:** Downstream Documentation spoke feedback (project processing mandate PII); routed via hub inbox 2026-10-08. Name-free per egress discipline.
**Author:** Alberto
**Backlog line:** Fork-local independent numbering (BL-001). Distinct from DSM Central's line; see "Contribution routing" below.

---

## 1. Problem

Projects that process personal or confidential data need a data-protection /
compliance review of their data-handling model. Today that need arises **ad hoc**:
in the originating project it surfaced only after a local-only PII model was already
in operation, and was captured by hand as an open item in the decisions log. DSM has
no mechanism that requests a DP/compliance briefing *by design* for such projects.
Consequences: the review need is easy to miss or is discovered late, and there is no
uniform form in which it is documented and handed to a human/expert reviewer.

## 2. Proposed Behavior (generic, adaptive)

For projects handling personal/confidential data, DSM requests a **DP/compliance
briefing artifact**:

- **Trigger:** the project holds/processes personal or confidential data. Detection is
  primarily **declarative** (a field in project setup / CLAUDE.md), optionally heuristic
  (a gitignored mandate/PII store is present).
- **Requirement:** when the trigger is active, DSM asks for a briefing following a fixed
  requirements list (§4) based on a template (§5), placed at a conventional location
  (e.g. `dsm-docs/decisions/`).
- **Not a hard blocker:** the briefing gates no in-flight technical task; its absence
  *surfaces* at session-start / scaffold completeness check (like other DSM completeness
  checks) rather than locking work.
- **Idempotent:** once the briefing exists, the check is silent.

## 3. Scope Note (§21 single-topic check)

This is **one capability** (a DP/compliance briefing mechanism) whose implementation
touches several methodology modules. It is not a multi-topic BL: the success criteria
(§7) are cohesive and the artifact is completable as a unit. If implementation proves
too large for one review bite, the natural split is **(a) template + declarative trigger**
vs **(b) per-project-type adaptation rules**; this split is held in reserve, not taken now.

## 4. Requirements Checklist (constant across project types)

Every DP/compliance briefing must contain:

- **Context** — what the project does, why PII arises, the processing environment
  (device, local/remote, model context).
- **Data scope** — categories of data subjects, affected groups, sensitivity; special
  categories (Art. 9 GDPR) yes/no.
- **Data flows & storage locations** — zones, what crosses the boundary, processing in
  the model context, history/retention relevance.
- **Control model & TOMs** — how data is protected; open TOM points.
- **Open review questions** — the expert-review core (legal basis, processor /
  third-country, controller role, retention/deletion, minimization/purpose limitation,
  TOMs) phrased as **questions**, with no invented legal conclusions.
- **Blocked steps / decision needs** — what stays "provisional" until sign-off; possible
  outcomes (approval / approval-with-conditions / rework).
- **References** — operative rules, decision log, project governance.
- **Egress discipline** — the briefing is itself **name-free** (potentially shareable /
  external).

## 5. Template (generalized A–G skeleton)

Instances **localize to their audience's language** (e.g. a national-DSB briefing is
written in that country's language).

```
# <Project> — Data-Protection / Compliance Briefing

Header: Purpose · Audience · Status (OPEN | APPROVED | CONDITIONS) · Date ·
        Scope note (name-free; no legal conclusions) · References

A. Context            — project, why PII arises, processing environment (device,
                        local/remote, model context)
B. Data scope         — subject categories, affected groups, sensitivity; Art. 9 yes/no
C. Data flows/storage — zones, boundary crossings, model-context processing,
                        history/retention relevance
D. Control model/TOMs — protections in place; open TOM points
E. Open review Qs     — legal basis / processor & third-country / controller role /
                        retention & deletion / minimization & purpose / TOMs
                        [mandatory set varies by project type — see §6]
F. Blocked steps      — what stays provisional until sign-off; outcomes
                        (approval / conditions / rework)
G. References         — operative rules, decision log, project governance
```

**Conditional behavior:** §E's mandatory question set and §B's special-category depth
scale with project type (§6). For a "not applicable" case (e.g. a synthetic-data
Application), the template collapses to Header + a justified negative decision.

## 6. Project-Type Adaptation

The requirements checklist (§4) stays constant. What adapts is (a) whether the trigger
fires and (b) which review questions are mandatory vs optional:

- **Documentation / consulting with mandate PII:** full catalog, mandatory.
- **Application on synthetic/anonymous data:** lightweight — the briefing may be "not
  applicable, with justification" (a documented negative decision instead of the full
  catalog).
- **External Contribution:** points to the upstream project's data-protection /
  compliance regime; DSM does not duplicate it.

The template (§5) carries **conditional sections** for this.

## 7. Success Criteria

- A generic DP/compliance briefing template exists in the HUB and is referenced by the
  relevant modules.
- The trigger is defined declaratively (project type + a "handles personal/confidential
  data" flag), with an optional heuristic.
- A completeness check surfaces a missing briefing for triggered projects;
  idempotent/silent when present.
- Project-type adaptation is specified (full / lightweight "n/a-with-justification" /
  upstream-deferral).
- Documented: how a project instantiates and localizes the template.

## 8. Candidate DSM Hook Points (for maintainer evaluation)

Candidate anchors only; module internals not yet read, so no assertion of current
behavior:

- **DSM_0.2.C (Security/Safety)** — where PII/egress rules already live; natural home for
  the trigger + requirement rule.
- **Session-start / scaffold completeness check** — surface a missing briefing (like
  other completeness checks), per §2 "not a hard blocker."
- **Template module (DSM_0.2.T Alignment Templates or DSM_2.0.A Planning Templates)** —
  ship the §5 template.
- **`/dsm-align` scaffold** — ensure the conventional location and (optionally) a
  declarative "handles personal data" field for the trigger.
- **Project-type adaptation modules** (DSM_4.0 Application, DSM_5.0 Documentation,
  DSM_3.0.x External Contribution) — carry the per-type trigger / mandatory-scope rules
  of §6.

The final hook-point selection is an implementation-design decision, confirmed before
editing any methodology file.

## 9. Test Plan

Executed on the implementation branch before merge (§19, §21.3). Structural tests run in
the implementing session; behavioral session-start tests are deferred-by-design with a
named trigger.

- **T-1 (structural):** the A–G briefing template exists at its conventional HUB location;
  `grep` confirms the file and its A–G headings.
- **T-2 (structural):** the declarative trigger field is specified in the methodology text
  (project-type + "handles personal/confidential data" flag); `grep` the spec.
- **T-3 (structural):** project-type adaptation (full / lightweight-n-a / upstream-deferral)
  is present in the relevant module text; `grep` each of the three paths.
- **T-4 (structural):** all new cross-references (section numbers, file paths, template
  location) resolve — no dangling ref (§19 minimum).
- **T-5 (behavioral, deferred):** the session-start/scaffold completeness check surfaces a
  missing briefing for a triggered project and stays silent when present. Untestable in the
  authoring session → **deferred to the next `/dsm-go` on a triggered project**; verification
  plan: set the trigger flag in a scratch project, boot, confirm the surfaced line; add the
  briefing, boot, confirm silence.
- **T-6 (documentation):** instantiation + localization guidance is present; `grep`.

## 10. Risks (§21.2)

- **Over-firing** — a trigger that fires on every project trains dismissal (cf. DSM's own
  over-firing guard, §8.9.2). *Mitigation:* declarative-primary trigger + the
  "n/a-with-justification" path, so ordinary projects clear it with one line.
- **Project-type misdetection** — wrong type → wrong mandatory scope. *Mitigation:*
  declarative, human-confirmable field rather than pure heuristic.
- **Scope creep into legal advice** — the briefing is a hand-off to human/expert review,
  not a substitute. *Mitigation:* §E is phrased as questions only; the template forbids
  invented legal conclusions; this is stated in the template header.
- **Cross-module sprawl** — touching five candidate modules risks an inconsistent landing.
  *Mitigation:* confirm the hook-point set (§8) before editing; apply the §21.4 resolver
  sweep after implementation.
- **Public-repo egress** — the template and BL ship publicly. *Mitigation:* name-free by
  construction; worked instances live only in the (gitignored/private) originating project.

## 11. Open Questions (for maintainer / DSM Central)

- BL numbering / routing into the DSM Central backlog pipeline (this BL uses fork-local
  BL-001; Central assigns its own number on absorption).
- Where the trigger flag belongs (CLAUDE.md, project setup, or `/dsm-align`).
- Whether "compliance" should be broader than data protection (sector/regulatory) or kept
  DP-focused for v1.

## 12. Contribution Routing

Fork-local BL-001 is implemented on this mirror on branch `bl-001/dp-compliance-briefing`.
On completion: update `dsm-docs/plans/README.md`, open a **GitHub issue** on the upstream
public repo (`albertodiazdurana/take-ai-bite`) describing the enhancement, and open a
**cross-fork PR** carrying the methodology-document changes with this BL attached, so **DSM
Central** manages final numbering, de-identification reconciliation, and integration. The
methodology *documents* are public; the BL *body* is contributed as an attachment for
Central's private backlog pipeline.

## 13. Test Execution Log (S6, 2026-10-08)

Implemented v1 on branch `bl-001/dp-compliance-briefing`. Scope: DSM_0.2.C §5.9 + CHANGELOG.
Per-item results against §9 Test Plan:

- **T-1 (structural) — PASS.** `### 5.9. Data-Protection / Compliance Briefing by Design`
  present in `DSM_0.2.C_Security_Safety.md` after §5.8; the embedded A–G template and its
  `dsm-docs/decisions/` location are in the section.
- **T-2 (structural) — PASS.** Declarative trigger specified (`**Handles personal/confidential
  data:** yes` in project CLAUDE.md; §5.1 Restricted basis; optional heuristic).
- **T-3 (structural) — PASS.** Per-type adaptation table present with all three paths
  (Documentation full / Application-synthetic lightweight-n-a / External-Contribution deferral).
- **T-4 (structural) — PASS.** Cross-refs resolve: §5.9 → §5.1, §5.4, DSM_0.2 §8.9.2, §21.3,
  `dsm-docs/decisions/`. §21.4 sweep: additive at EOL, §5.8 remained the prior last section, no
  renumbering of any §6+ (none exists in this module), no dangling reference.
- **T-5 (behavioral) — DEFERRED (v1b).** The session-start/scaffold check that surfaces a
  missing briefing is declared as behavior in §5.9 but not wired. Deferred-by-design (§21.3
  carve-out): wiring edits the session-start skill + DSM_0.2.A + redeploy, untestable in the
  authoring session.
- **T-6 (documentation) — PARTIAL.** Instantiation (produce at `dsm-docs/decisions/` from the
  A–G template) and localization ("localize to the reviewer's language") are stated in §5.9. A
  standalone copyable template file was deliberately not shipped in v1 (template embedded); a
  separate file is a possible follow-up.

Egress (DSM_0.2.C §5.8): §5.9, the CHANGELOG entry, and this log are name-free; no matched value
echoed. Not moved to `done/`: "done" for a fork-local BL is upstream absorption by Central.

## 14. Pending Verification (follow-ups)

- **v1b — operational surfacing wiring.** Wire the session-start / scaffold completeness check
  that surfaces a missing DP/compliance briefing for a triggered project (edit the session-start
  skill + DSM_0.2.A; redeploy). Verification plan: set the trigger flag in a scratch project,
  boot, confirm the surfaced line; add the briefing, boot, confirm silence (BL-001 T-5).
- **Optional — standalone template file.** If projects should `cp` the A–G template rather than
  transcribe it from §5.9, ship it as a file under `dsm-docs/` and reference it from §5.9.
