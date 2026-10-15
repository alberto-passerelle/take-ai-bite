# DSM_0.2 Worklog Enforcement Detail

The enforcement mechanism, turn-boundary self-check, and retroactive-recovery
detail for the Worklog Protocol (DSM_0.2 §7), extracted from §7.
Read on demand; NOT part of the `@` import chain. §7 keeps the operational rules
always-loaded and points here for the origins, rationale, and worked examples.

---

**Per-Turn Transcript Append Enforcement Mechanism:**

Static rules and operator discipline are insufficient to keep this protocol
active across long sessions; in S171 the agent skipped appends for 7
consecutive turns despite both §7 and `/dsm-go` step 6 telling it not to.
The reliable enforcement layer is a `UserPromptSubmit` hook in
`.claude/settings.json` that injects a per-turn reminder. Two hooks form a
complementary pair: the `UserPromptSubmit` hook enforces *occurrence* (an
append must happen this turn), and `validate-transcript-edit.sh` (PreToolUse
on Edit) enforces *shape* (anchor, append-only, delimiter) and, since BL-517,
*value* , check 4/4 compares the delimiter's `HH:MM` against the wall clock and
**warns** above a 5-minute tolerance.

Check 4 warns rather than blocks, and the asymmetry is deliberate. Checks 0-3
guard against an append that would damage the file, so vetoing them is
proportionate. A drifted timestamp damages nothing; it mislabels a log entry.
Blocking an append over it would wedge the protocol the hook exists to keep
running, and a gate the user learns to dismiss is worse than no gate. The
non-blocking channel is exit 1, the same convention
`validate-cross-repo-write.sh` uses. `[RETROACTIVE]` delimiters get **no**
exemption: §7 requires them to carry the current time, so they are checked like
any other. Origin: three recorded drift incidents , roughly 13 hours, 8 hours
27 minutes, and a non-monotone 132-minute swing in both directions , none of
which any check detected, because until BL-517 nothing read the number.

Neither IDE
monitoring nor session-start "behavioral activation" is the enforcement
mechanism; both are user-facing affordances that document intent without
requiring it. The hook is the mechanism.

**Turn-Boundary Transcript Append Self-Check:**

Every turn begins with a transcript append. Every turn. At the start of
every turn, before composing a response, the agent must ask: "Was my
first tool call this turn an append to `.claude/worklog.md`?"
If the answer is no, the protocol has been violated. The check is binary;
no "I planned to" or "the next call would have been" answers count.

This rule applies to turns that produce analysis, recommendations, or
decisions **without touching any files**. Analysis-only turns are
explicitly covered: a turn whose response is a multi-paragraph decision
analysis, trade-off comparison, or recommendation requires the same
first-tool-call transcript append as a turn that edits code. The
analysis-only-turn failure mode is the most damaging variant because
analysis-only turns contain the highest-value work notes (decision
rationale, considered-and-rejected paths, risk framing) and losing that
content inverts the transcript's stated purpose as a work log.

**Example of the analysis-only-turn failure mode:** a turn in which the
user asks "which of these two options should we pick?" and the agent
responds with a multi-paragraph comparison (five-question gate
evaluation, Option A vs Option B analysis, recommendation, proposed
next steps) as a pure-text response with zero tool calls. This is a
protocol violation. The agent must append the plan entry to the transcript as
the first tool call of that turn, even though the turn would otherwise
have none. The transcript append is the one required tool call.

**The only exemption is content-trivial turns:** one-word
acknowledgments ("Understood", "OK"), single-fact confirmations ("Yes",
"No"), and responses with no new work notes. The exemption is content-
based, not tool-call-count-based. A turn that produces substantive new
work notes of any length is never content-trivial, regardless of whether
it touches files. If there are new work notes, there is a transcript
append.

**[RETROACTIVE] Transcript Append Self-Detection Rule:**

If the agent detects mid-turn or at the start of a later turn that it
missed an earlier append, it must:

1. Append a recovery entry to the transcript labeled
   `<------------Start Plan [RETROACTIVE] / HH:MM------------>` where
   HH:MM is the *current* time, not a fabricated earlier time.
2. State which turn(s) were missed and a brief reconstruction of the
   work notes that would have been recorded.
3. Note the gap explicitly; never edit history or insert mid-file to make
   it look like the appends happened on time.

Retroactive entries are evidence the protocol failed and recovered, not a
workaround that makes the failure invisible.

**Plan-Block Completeness and the Contemporaneous Work Log:**

Plan blocks are a running log of the work as it proceeds, not a tidy
summary written once the outcome is known. Record the steps taken, the
options tried and dropped, the checks run, and any change of direction,
so the log reflects the actual path of the work rather than a cleaned-up
version of it. Write "did X, dropped it after Y, switched to Z" instead
of collapsing to "did Z".

The purpose is to make inefficiencies visible for later review. Work
rarely runs in a straight line: steps get repeated, approaches get
replaced, and the path doubles back, and that path is normally lost once
a turn ends, since nothing keeps a durable record of it across a session.
A log entry that reads as a clean summary hides exactly the inefficiency
signals the log exists to surface.

A useful log entry records:

- Which steps were taken and which options were tried and dropped
- Where the work doubled back, repeated a step, or changed direction
- Which steps were redundant in hindsight (re-reading a file already
  read, re-checking a fact already checked)
- The decision reached and the reason for it

Completeness matters more than brevity. A log entry that is longer than
the action it precedes is acceptable when the work warranted it; a log
entry that compresses several rounds of back-and-forth behind a single
confident sentence is a defect.

This rule does not apply to trivial turns (single-fact answers, simple
acknowledgments) where §7's "When to skip the plan entry" rule already
permits omission. It applies to every turn that warrants a plan block at all.

---

**Boot-Safeguard Reintroduction Guard:**

`validate-boot-safeguard-write.sh` (PreToolUse on Write/Edit/Bash) is the structural
prevention from BL-584 Phase 2 against re-arming the BL-543-class model-side safety
refusal. The refusal re-arms when its own description is written back into the files the
next boot reads; the terminology sweep and the euphemism discipline remove the source, and
this hook stops it re-entering.

**What it guards.** Boot-loaded / boot-read surfaces only: `.claude/CLAUDE.md`, the
`@`-imported core, `~/.claude/projects/<slug>/memory/MEMORY*.md`,
`.claude/reasoning-lessons.md` and `-compact.md`, and active `dsm-docs/handoffs/*.md` and
`dsm-docs/checkpoints/*.md`. It never fires in the allowed-verbatim zones
(`dsm-docs/decisions/`, `dsm-docs/research/`, any `done/`).

**What it matches.** Known literals only: the verbatim classifier token (stored
base64-encoded and decoded at runtime, so the hook file is not itself a carrier) and the
retired `session-transcript` path token. It deliberately does NOT match the noisy marker
phrases; they are too false-positive-prone to auto-block (§8.9.2).

**Behavior.** Write/Edit into a guarded surface with a match blocks the call (exit 2). A
Bash write warns only (exit 1; shell is not statically analysable). A genuinely required
write is confirmed per-target in `.claude/boot-safeguard-overrides-session.txt`
(session-scoped, gitignored).

**Scope limit (no over-claim, per §19.1).** A backstop for known literals, not a semantic
filter; it cannot catch novel framing in different words. The verbatim form lives only in
the quarantine research logs.

**Propagation.** Installs via `/dsm-align` Step 10b (the hook is copied from Central's
`.claude/hooks/` and wired from `settings-hooks.json`), reaching every spoke on re-align
(BL-585 Phase 1).

**Origin:** BL-584 Phase 2. Model: `validate-cross-repo-write.sh` (BL-391).
