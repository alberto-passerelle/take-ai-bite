#!/bin/bash
# Hook: keep a protected upstream's main out of reach from this machine (fork-local BACKLOG-018)
#
# One checker, two callers:
#   --pre-push   from the protected clone's .git/hooks/pre-push (git passes the remote
#                name and URL as arguments and the pushed refs on stdin). Refuses every
#                ref whose remote ref is refs/heads/main or refs/heads/master: update,
#                force or deletion. Needs no list: it is installed only where it protects.
#   --tool-use   Claude Code PreToolUse hook on Bash (tool JSON on stdin). Acts only on
#                `gh pr merge` and `gh api` write calls, and blocks them when the target
#                resolves to a repository in .claude/protected-main-repos.txt: the
#                repository is named in the command text, or a remote of the working
#                directory (or of a `cd` / `git -C` target in the command) points to it.
#
# The list sits next to this hook's .claude/ directory (untracked, maintained by the user):
# one owner/repo per line; blank lines and '#' comments are ignored. A missing or empty
# list blocks the checked commands (fail closed); every other command passes.
#
# Install (both local and untracked):
#   1. <protected clone>/.git/hooks/pre-push, executable:
#        #!/bin/bash
#        exec /path/to/this/repo/.claude/hooks/guard-protected-main.sh --pre-push "$@"
#   2. .claude/settings.json, hooks.PreToolUse, matcher "Bash", command:
#        .claude/hooks/guard-protected-main.sh --tool-use
#
# Known limits: `gh api graphql` mutations name repositories by node ID and are not
# resolved; a repository held in a variable whose value is not in the command text is
# resolved only through the directories. `git push --no-verify` skips the pre-push side.
#
# Exit codes: 0 allow; 1 refuse the push (--pre-push); 2 block the tool call (--tool-use).

MODE="$1"
[ $# -gt 0 ] && shift

case "$MODE" in
  --pre-push) BLOCK_CODE=1 ;;
  --tool-use) BLOCK_CODE=2 ;;
  *) echo "[BACKLOG-018] usage: guard-protected-main.sh --pre-push|--tool-use" >&2; exit 2 ;;
esac

block() {
  echo "[BACKLOG-018] $1" >&2
  exit "$BLOCK_CODE"
}

FIX="Push a named branch, open a pull request, and leave the merge to the owner."

if [ "$MODE" = "--pre-push" ]; then
  REPORT=""
  while read -r lref loid rref roid; do
    [ -z "$rref" ] && continue
    case "$rref" in
      refs/heads/main|refs/heads/master)
        case "$loid" in *[!0]*) what="update" ;; *) what="deletion" ;; esac
        REPORT="$REPORT
  ${lref:-(delete)} -> $rref ($what)"
        ;;
    esac
  done
  if [ -n "$REPORT" ]; then
    block "Push refused: this clone never pushes to main or master.$REPORT
  $FIX"
  fi
  exit 0
fi

# --tool-use
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c '
import sys, json
print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' 2>/dev/null) || CMD="$INPUT"
[ -z "$CMD" ] && CMD="$INPUT"
CWD=$(printf '%s' "$INPUT" | python3 -c '
import sys, json
print(json.load(sys.stdin).get("cwd", ""))' 2>/dev/null)
[ -z "$CWD" ] && CWD="$PWD"

GH='(^|[^[:alnum:]_-])gh[[:space:]]+'
ROUTE=""
printf '%s\n' "$CMD" | grep -qE "${GH}pr[[:space:]]+merge([[:space:]]|\$)" && ROUTE="gh pr merge"
if [ -z "$ROUTE" ] && printf '%s\n' "$CMD" | grep -qE "${GH}api([[:space:]]|\$)"; then
  if printf '%s\n' "$CMD" | grep -qE '(-X|--method)[[:space:]=]*(POST|PUT|PATCH|DELETE|post|put|patch|delete)([[:space:]]|$)'; then
    ROUTE="gh api write"
  elif printf '%s\n' "$CMD" | grep -qE '[[:space:]](-f|-F|--field|--raw-field|--input)([[:space:]=]|$)' \
       && ! printf '%s\n' "$CMD" | grep -qE '(-X|--method)[[:space:]=]*(GET|get)([[:space:]]|$)'; then
    ROUTE="gh api write"
  fi
fi
[ -z "$ROUTE" ] && exit 0

SELF_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LIST="$SELF_DIR/../protected-main-repos.txt"
LISTED=""
if [ -f "$LIST" ]; then
  LISTED=$(grep -v '^[[:space:]]*#' "$LIST" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' \
           | grep -v '^$' | tr '[:upper:]' '[:lower:]')
fi
if [ -z "$LISTED" ]; then
  block "Blocked: .claude/protected-main-repos.txt is missing or empty, so the target of this $ROUTE
  cannot be checked. Create it (one owner/repo per line, untracked) and retry."
fi

# 1. A listed repository named in the command text (--repo, a PR URL, a repos/ path, GH_REPO=).
while read -r slug; do
  if printf '%s\n' "$CMD" | grep -qiF "$slug"; then
    block "Blocked: this $ROUTE names $slug, whose main takes no direct changes from this machine.
  $FIX"
  fi
done <<< "$LISTED"

# 2. A listed repository behind the working directory, or behind a cd / git -C target.
url_slug() {
  printf '%s' "$1" | sed -E -e 's#^(https?://[^/]+/|ssh://[^/]+/|[^@/]+@[^:]+:)##' -e 's#\.git$##' -e 's#/$##' \
    | tr '[:upper:]' '[:lower:]'
}
DIRS="$CWD"
TARGETS=$(printf '%s\n' "$CMD" | grep -oE '(^|[;&|({[:space:]])(cd|git[[:space:]]+-C)[[:space:]]+[^;&|)[:space:]]+' \
          | sed -E 's/^[;&|({[:space:]]*(cd|git[[:space:]]+-C)[[:space:]]+//' | sed -e "s/^[\"']//" -e "s/[\"']\$//")
while read -r d; do
  [ -z "$d" ] && continue
  case "$d" in *'$'*|*'`'*) continue ;; esac
  case "$d" in "~") d="$HOME" ;; "~/"*) d="$HOME/${d#\~/}" ;; /*) ;; *) d="$CWD/$d" ;; esac
  DIRS="$DIRS
$d"
done <<< "$TARGETS"

while read -r d; do
  [ -d "$d" ] || continue
  for remote in $(git -C "$d" remote 2>/dev/null); do
    s=$(url_slug "$(git -C "$d" remote get-url "$remote" 2>/dev/null)")
    [ -z "$s" ] && continue
    if printf '%s\n' "$LISTED" | grep -qxF "$s"; then
      block "Blocked: this $ROUTE runs against $d, whose remote '$remote' is $s; its main takes no
  direct changes from this machine. $FIX"
    fi
  done
done <<< "$DIRS"

exit 0
