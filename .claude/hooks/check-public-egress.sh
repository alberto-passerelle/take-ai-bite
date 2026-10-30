#!/bin/bash
# Hook: block pushes and GitHub posts that contain listed names (fork-local BACKLOG-013)
#
# One checker, two callers:
#   --pre-push   from .git/hooks/pre-push (git passes the remote name and URL as
#                arguments and the pushed refs on stdin). Checks every commit not
#                yet on that remote: added lines, file names, the commit message,
#                and the message of an annotated tag.
#   --tool-use   Claude Code PreToolUse hook on Bash (tool JSON on stdin). Acts
#                only on gh commands that post text, and checks the command text
#                plus every body file the command references.
#
# Names come from .claude/name-denylist.txt (gitignored, maintained by the user):
# one entry per line; blank lines and '#' comments are ignored. Matching is
# whole-word, case-insensitive, fixed-string. A missing or empty list blocks
# (fail closed). Output never contains a listed value (DSM_0.2.C §5.8): only
# commit IDs, sources and counts.
#
# Install (both local and untracked):
#   1. .git/hooks/pre-push, executable:
#        #!/bin/bash
#        exec "$(git rev-parse --show-toplevel)/.claude/hooks/check-public-egress.sh" --pre-push "$@"
#   2. .claude/settings.json, hooks.PreToolUse, matcher "Bash", command:
#        .claude/hooks/check-public-egress.sh --tool-use
#
#   3. (S27) .git/hooks/pre-commit and .git/hooks/commit-msg, executable:
#        exec "$(git rev-parse --show-toplevel)/.claude/hooks/check-public-egress.sh" --pre-commit
#        exec "$(git rev-parse --show-toplevel)/.claude/hooks/check-public-egress.sh" --commit-msg "$1"
#
# Exit codes: 0 allow; 1 refuse the push or commit (--pre-push, --pre-commit, --commit-msg);
# 2 block the tool call (--tool-use).

MODE="$1"
[ $# -gt 0 ] && shift

case "$MODE" in
  --pre-push) BLOCK_CODE=1 ;;
  --tool-use) BLOCK_CODE=2 ;;
  --pre-commit|--commit-msg) BLOCK_CODE=1 ;;
  *) echo "[BACKLOG-013] usage: check-public-egress.sh --pre-push|--tool-use|--pre-commit|--commit-msg FILE" >&2; exit 2 ;;
esac

block() {
  echo "[BACKLOG-013] $1" >&2
  exit "$BLOCK_CODE"
}

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT="$PWD"
LIST="$ROOT/.claude/name-denylist.txt"
PATTERNS=""

# Load the list into a temp file of clean patterns; block if there is none.
load_patterns() {
  PATTERNS=$(mktemp "${TMPDIR:-/tmp}/egress-patterns.XXXXXX") || block "cannot create a temp file; refusing."
  trap 'rm -f "$PATTERNS"' EXIT
  if [ -f "$LIST" ]; then
    grep -v '^[[:space:]]*#' "$LIST" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | grep -v '^$' > "$PATTERNS"
  fi
  if [ ! -s "$PATTERNS" ]; then
    HINT=""
    [ "$MODE" = "--pre-push" ] && HINT="
  Deliberate bypass: git push --no-verify (only on the user's explicit request)."
    block "Refused: the name list .claude/name-denylist.txt is missing or empty, so nothing can be checked.
  Create it (one name per line, gitignored) and retry.$HINT"
  fi
}

# Count stdin lines that contain a listed name. Prints a number, or ERR if grep failed.
count_hits() {
  local out rc
  out=$(grep -i -w -F -c -f "$PATTERNS" 2>/dev/null)
  rc=$?
  if [ "$rc" -gt 1 ]; then echo "ERR"; else echo "${out:-0}"; fi
}

if [ "$MODE" = "--pre-push" ]; then
  REMOTE="$1"
  load_patterns
  REPORT=""
  while read -r lref loid rref roid; do
    [ -z "$loid" ] && continue
    case "$loid" in *[!0]*) ;; *) continue ;; esac   # all zeros: a ref deletion
    if [ "$(git cat-file -t "$loid" 2>/dev/null)" = "tag" ]; then
      n=$(git cat-file -p "$loid" | count_hits)
      [ "$n" = "ERR" ] && block "Refused: matching failed on tag $lref."
      [ "$n" -gt 0 ] && REPORT="$REPORT
  tag $lref: $n line(s) in the tag message"
    fi
    for c in $(git rev-list "$loid" --not --remotes="$REMOTE" 2>/dev/null); do
      m=$(git log -1 --format=%B "$c" | count_hits)
      a=$(git show --format= --diff-merges=first-parent -U0 --no-color --no-ext-diff "$c" \
            | grep '^+' | grep -v '^+++ ' | count_hits)
      f=$(git show --format= --diff-merges=first-parent --name-only "$c" | count_hits)
      if [ "$m" = "ERR" ] || [ "$a" = "ERR" ] || [ "$f" = "ERR" ]; then
        block "Refused: matching failed on commit $(git rev-parse --short "$c")."
      fi
      if [ "$m" -gt 0 ] || [ "$a" -gt 0 ] || [ "$f" -gt 0 ]; then
        REPORT="$REPORT
  commit $(git rev-parse --short "$c"): $m in the message, $a in added lines, $f in file names"
      fi
    done
  done
  if [ -n "$REPORT" ]; then
    block "Push refused: listed names in outgoing content.$REPORT
  Values are not shown (DSM_0.2.C §5.8). Find them with a redacted search, fix them, and push again.
  Deliberate bypass: git push --no-verify (only on the user's explicit request)."
  fi
  exit 0
fi

# --pre-commit (staged added lines and file names) / --commit-msg FILE (the message).
# Blocks on a listed name; prints the rest of the .claude/CLAUDE.md §2 pre-commit sweep
# as counts only (report, never block): #NNN, hex IDs, non-fork BL numbers, and lines
# that mention Central, upstream or the owner, which still need reading.
if [ "$MODE" = "--pre-commit" ] || [ "$MODE" = "--commit-msg" ]; then
  load_patterns
  if [ "$MODE" = "--pre-commit" ]; then
    TEXT=$(git diff --cached -U0 --no-color --no-ext-diff | grep '^+' | grep -v '^+++ ')
    FILES=$(git diff --cached --name-only)
    WHERE="staged added lines"
  else
    [ -r "$1" ] || block "Refused: the commit message file cannot be read, so it cannot be checked."
    TEXT=$(grep -v '^#' "$1")
    FILES=""
    WHERE="commit message"
  fi
  a=$(printf '%s\n' "$TEXT" | count_hits)
  f=$(printf '%s\n' "$FILES" | count_hits)
  if [ "$a" = "ERR" ] || [ "$f" = "ERR" ]; then block "Refused: matching failed on the $WHERE."; fi
  if [ "$a" -gt 0 ] || [ "$f" -gt 0 ]; then
    block "Commit refused: listed names in the $WHERE ($a line(s)) or in file names ($f).
  Values are not shown (DSM_0.2.C §5.8). Fix them and commit again.
  Deliberate bypass: git commit --no-verify (only on the user's explicit request)."
  fi
  h=$(printf '%s\n' "$TEXT" | grep -cE '#[0-9]+')
  x=$(printf '%s\n' "$TEXT" | grep -cE '(^|[^0-9A-Za-z])[0-9a-f]{7,40}([^0-9A-Za-z]|$)')
  b=$(printf '%s\n' "$TEXT" | grep -oE 'BL-[0-9]{3}|BACKLOG-[0-9]{3}' | grep -vcE '^(BL|BACKLOG)-0[0-3][0-9]$')
  c=$(printf '%s\n' "$TEXT" | grep -ciE 'central|upstream|owner')
  echo "[egress $MODE] names: 0 hits against a $(grep -c . "$PATTERNS")-entry list; report only: #NNN=$h hex=$x non-fork-BL=$b central/upstream/owner lines=$c" >&2
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
POSTING=0
printf '%s\n' "$CMD" | grep -qE "${GH}(pr|issue)[[:space:]]+(create|edit|comment|review)([[:space:]]|\$)" && POSTING=1
printf '%s\n' "$CMD" | grep -qE "${GH}release[[:space:]]+(create|edit)([[:space:]]|\$)" && POSTING=1
if printf '%s\n' "$CMD" | grep -qE "${GH}api([[:space:]]|\$)"; then
  printf '%s\n' "$CMD" | grep -qE '[[:space:]](-f|-F|--field|--raw-field|--input)([[:space:]=]|$)|(-X|--method)[[:space:]=]*(POST|PATCH|PUT|post|patch|put)' && POSTING=1
fi
[ "$POSTING" -eq 0 ] && exit 0

load_patterns

DETAIL=""
TOTAL=0
n=$(printf '%s\n' "$CMD" | count_hits)
[ "$n" = "ERR" ] && block "Blocked: matching failed on the command text."
if [ "$n" -gt 0 ]; then TOTAL=$((TOTAL + n)); DETAIL="$DETAIL command text: $n line(s);"; fi

# Body files: --body-file X, -F X (gh pr/issue), --input X, and field=@X (gh api).
i=0
for tok in $(printf '%s\n' "$CMD" | grep -oE '(--body-file|-F|--input)[[:space:]=]+[^[:space:]]+' \
             | sed -E 's/^(--body-file|-F|--input)[[:space:]=]+//'); do
  # Drop shell operators glued to the path (`--body-file x.md;`), then surrounding quotes.
  tok=$(printf '%s' "$tok" | sed -e 's/[;&|)]*$//' -e "s/^[\"']//" -e "s/[\"']\$//")
  case "$tok" in
    *=@*) path="${tok#*=@}" ;;
    *=*)  continue ;;            # a literal field value, already in the command text
    -)    continue ;;            # stdin, e.g. a heredoc: already in the command text
    *)    path="$tok" ;;
  esac
  i=$((i + 1))
  case "$path" in /*) ;; *) path="$CWD/$path" ;; esac
  if [ ! -r "$path" ]; then
    block "Blocked: body file $i referenced by this gh command cannot be read, so it cannot be checked."
  fi
  n=$(count_hits < "$path")
  [ "$n" = "ERR" ] && block "Blocked: matching failed on body file $i."
  if [ "$n" -gt 0 ]; then TOTAL=$((TOTAL + n)); DETAIL="$DETAIL body file $i: $n line(s);"; fi
done

if [ "$TOTAL" -gt 0 ]; then
  block "Blocked: this gh command would post listed names to GitHub.
  Hits:$DETAIL
  Values are not shown (DSM_0.2.C §5.8). Remove them and retry."
fi
exit 0
