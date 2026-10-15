# DSM_0.2 Worklog Protocol Detail

Detail for the Worklog Protocol (DSM_0.2 §7): file, header and lifecycle; append
rules and the Bash append procedure; activation; the enforcement mechanism; the
turn-boundary self-check; retroactive recovery. Read on demand; NOT part of the `@`
import chain. §7 keeps the operational rules always loaded and points here for
schema, procedures, rationale and worked examples.

---

**Worklog File, Header and Lifecycle Detail:**

**Relationship to DSM_7.0 §2.1:** §7 defines the protocol shape (append-only,
first-tool-call plan entry, last-tool-call output, delimiter format). DSM_7.0
§2.1.5 describes the Claude-specific mechanism: the `UserPromptSubmit` hook that
injects the per-turn reminder and the `PreToolUse` validator that enforces anchor
shape on Edit tool calls. The protocol stays in §7; the Claude execution layer
lives in DSM_7.0 §2.1.

**Lifecycle detail:** the file lives permanently in `.claude/`. `/dsm-wrap-up` does
not touch it; stale content from the previous session is harmless because
`/dsm-go` replaces it at the next session start. The user keeps the file open in
VS Code across sessions. `/dsm-light-go` does not overwrite it: it appends a
session-boundary marker, which keeps the work-notes chain continuous across
lightweight session sequences.

**Permission detail:** the worklog is an agent-internal working artifact, not a
deliverable, so auto-approval of writes to it applies in every DSM project, not
only DSM Central.

**Header** (written by `/dsm-go` Step 6):

```
# Session N Transcript
**Started:** YYYY-MM-DDTHH:MM+TZ
**Project:** [project name]
**Agent:** [harness identifier, e.g., "Claude Code"]
**Model:** [model identifier, e.g., "claude-opus-4-7"]
```

Optional platform-specific fields (append when retrievable; omit entirely when
not; never write placeholder values like `Effort: unknown`):

```
**Effort:** [low | medium | high]
**Thinking:** [on | off]
**Fast mode:** [on | off]
```

```
---
```

`Agent` and `Model` are mandatory. If introspection is uncertain, append
`(self-reported)` to the value (e.g., `**Model:** claude-opus-4-7 (self-reported)`).
The schema is agent-agnostic; only the values differ across harnesses.

---

**Worklog Append Rules Detail:**

**Why append-only:** each entry records the work notes as they stood when written.

**Why the last-line anchor:** mid-file insertions cause out-of-order timestamps and
confuse the user reading the log live; they recurred in several sessions despite
earlier guidance.

**Why never `replace_all`:** the anchor rule assumes a unique last-line anchor;
`replace_all` duplicates the new content at every match and explodes the file (S17:
95 MB / 1.5M lines; S22: an Output block duplicated at every match). Recovery from a
botched Edit is a `[RETROACTIVE]` Bash append, never a `replace_all` cleanup.
`validate-transcript-edit.sh` blocks this case (check 0/4).

**Why no batching:** the user follows the log live and cannot review work notes after
the fact.

**Appending with Bash (when the Edit path is unavailable):** a single-quoted heredoc
(`<< 'EOF'`) suppresses shell expansion, so `$(date +%H:%M)` lands in the file as a
literal string instead of the timestamp (observed in S69). Capture the timestamp into
a variable first and use an unquoted heredoc:

```bash
NOW=$(date +%H:%M)
cat >> .claude/worklog.md << EOF
<------------Start Plan / ${NOW}------------>
...
EOF
```

The Edit path (read the last 3 lines, anchor on the last non-empty line) is preferred
and avoids heredoc quoting entirely.

**Leak-scan rationale:** the worklog is an egress artifact and append-only, so an
echoed value cannot be unwritten; the prohibition applies at write time, not as a
later scrub.

**Activation rationale:** the presence of `.claude/worklog.md` is the activation
signal, independent of `/dsm-go` Step 6 and of any session-start flow having run.
It is the third enforcement layer, alongside the per-turn hook (occurrence) and the
PreToolUse shape validator, and it covers continuation sessions that defer from
`/dsm-light-go` to `/dsm-go` mid-flight. The one authorized exception is `/dsm-staa`
(see §7).

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
