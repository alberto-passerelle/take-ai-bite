#!/usr/bin/env bash
# validate-l3-branch-index.sh — PreToolUse(Bash) guard (BL-007 / DSM_0.2 §20.9).
#
# Warns when a Level 3 task branch is created (`git checkout -b bl-*` / `sprint-*`,
# or `git switch -c ...`) while the git index holds staged changes. `git checkout -b`
# carries the staged index onto the new branch, and the first `git commit` there
# commits the ENTIRE index — so boot-staged session-artifact moves (from /dsm-go
# Steps 3/3.5) get absorbed into the task commit silently.
#
# WARN, NOT BLOCK: this hook ALWAYS exits 0 and never denies the command. An
# implementer may legitimately carry staged work onto the task branch; a hard block
# would obstruct that. The warning is surfaced via JSON on stdout:
#   - systemMessage       -> shown to the user
#   - additionalContext   -> injected into the agent's context
# permissionDecision is intentionally omitted so the normal permission flow is
# unchanged.
#
# Exit codes:
#   0 — always (allow). Warning, when applicable, is in the JSON stdout.
#
# Origin: BACKLOG-007 (clean index before an L3 branch; S7 §22 incident, 2026-10-09).

set +e

# Read the PreToolUse JSON from stdin; extract the Bash command.
INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    print(json.load(sys.stdin).get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Fire only on L3 task-branch CREATION that carries the index:
# git [-C dir] checkout -b <bl-*|sprint-*>  OR  git [-C dir] switch -c <bl-*|sprint-*>.
# Allow an optional quote before the branch name.
if ! printf '%s' "$COMMAND" | grep -qE "(^|&&|[;]|[[:space:]])git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?(checkout[[:space:]]+-b|switch[[:space:]]+-c)[[:space:]]+['\"]?(bl-|sprint-)"; then
  exit 0
fi

# Not inside a git repo -> nothing to check.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

# Staged paths in the index. Clean index -> no warning.
STAGED=$(git diff --cached --name-only 2>/dev/null)
if [ -z "$STAGED" ]; then
  exit 0
fi

# Dirty index + L3 branch creation -> emit a non-blocking warning (exit 0).
# Build the JSON in python (no shell interpolation of staged content; robust to odd paths).
COUNT=$(printf '%s\n' "$STAGED" | grep -c .)
export HOOK_STAGED="$STAGED"
export HOOK_COUNT="$COUNT"
printf '%s' "$INPUT" >/dev/null  # keep INPUT referenced; no-op

python3 <<'PYEOF'
import json, os
count = os.environ.get("HOOK_COUNT", "?")
staged = os.environ.get("HOOK_STAGED", "")
lines = "\n".join("  - " + p for p in staged.splitlines() if p)
system_message = (
    "⚠️  DSM_0.2 §20.9: the index has %s staged change(s) while you are "
    "creating a Level 3 task branch. The first commit on the new branch commits the "
    "ENTIRE index, so these would be absorbed into the task commit. Commit or re-home "
    "them on the session branch first, unless you intend to carry them." % count
)
additional_context = (
    "Clean-index-before-L3-branch guard (DSM_0.2 §20.9). Staged changes present at "
    "`git checkout -b`/`git switch -c`:\n" + lines + "\nThese land in the first task "
    "commit. Verify this is intended; otherwise commit or re-home them on the session "
    "branch before cutting the branch."
)
print(json.dumps({
    "systemMessage": system_message,
    "additionalContext": additional_context,
    "hookSpecificOutput": {"hookEventName": "PreToolUse"},
}))
PYEOF

exit 0
