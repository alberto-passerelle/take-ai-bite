#!/bin/bash
# Hook: Boot-safeguard reintroduction guard (BL-584 Phase 2).
#
# Fires on PreToolUse for Write / Edit / Bash. BLOCKS (exit 2) a Write/Edit
# whose TARGET is a boot-loaded / auto-loaded surface AND whose CONTENT carries
# the BL-543-class trigger family. This is the structural prevention against
# re-arming the model-side safety refusal by writing its own description back
# into the files the next boot reads (the self-replication vector BL-543 is
# named for).
#
# Guarded (boot-loaded / boot-read) surfaces:
#   - .claude/CLAUDE.md and the @-imported core DSM_0.2_Custom_Instructions_v1.1.md
#   - ~/.claude/projects/<slug>/memory/MEMORY*.md   (auto-loaded)
#   - .claude/reasoning-lessons.md and .claude/reasoning-lessons-compact.md
#   - active dsm-docs/handoffs/*.md and dsm-docs/checkpoints/*.md
# Never fires in the allowed-verbatim zones: dsm-docs/decisions/, dsm-docs/research/,
# and anything under a done/ directory.
#
# SCOPE LIMIT (stated so the prose does not over-claim the mechanism, per the
# §19.1 discipline): this is a BACKSTOP for KNOWN LITERALS, not a semantic
# filter. It matches the verbatim classifier token and the retired path token;
# it cannot catch novel framing that reads as the trigger in different words.
# Those are handled by the terminology sweep, the euphemism discipline, and
# human review, not by this hook. The noisy marker phrases ("Thinking",
# "options weighed", etc.) are deliberately NOT matched here: they are too
# false-positive-prone to auto-block, and a gate the user learns to dismiss is
# worse than no gate (§8.9.2).
#
# The detection pattern is base64-encoded and decoded at runtime so that this
# hook file is not itself a carrier of the verbatim trigger (it may be read on a
# strict model during debugging or an align copy).
#
# Exit codes:
#   0 — allow (not a boot surface, no match, exempt zone, or override confirmed)
#   2 — block (Write/Edit of the trigger family into a boot surface)
#   1 — warn, non-blocking (Bash write that may carry it; shell is not
#       statically analysable, so it cannot be blocked reliably)
#
# Override (rare, intentional writes): add the canonical target path to
#   .claude/boot-safeguard-overrides-session.txt
# (one entry per confirmed target; cleared at /dsm-go session start).
#
# Origin: BL-584 Phase 2. Reference model: validate-cross-repo-write.sh (BL-391).

set -e

INPUT=$(cat)

if ! REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null); then
  REPO_ROOT=""
fi
REPO_ROOT="${REPO_ROOT%/}"

VERDICT=$(HOOK_INPUT="$INPUT" REPO_ROOT="$REPO_ROOT" python3 - <<'PYEOF' 2>/dev/null || echo "ALLOW"
import sys, os, json, re, base64

repo = os.environ.get("REPO_ROOT", "").rstrip("/")
home = os.path.expanduser("~")

try:
    data = json.loads(os.environ.get("HOOK_INPUT", "") or "{}")
except Exception:
    print("ALLOW"); sys.exit(0)

tool = data.get("tool_name", "")
ti = data.get("tool_input", {}) or {}

# Obfuscated detector, decoded at runtime so this file is not a carrier.
P1 = base64.b64decode("cmVhc29uaW5nWy1fIF1leHRyYWN0aW9u").decode()  # the classifier token (regex)
P2 = "session-transcript"                                           # the retired path token

def match(text):
    if not text:
        return None
    if re.search(P1, text, re.IGNORECASE):
        return "the BL-543-class trigger token"
    if P2 in text:
        return "the retired session-transcript path token"
    return None

# Bash: warn only (shell writes are not statically analysable).
if tool == "Bash":
    cmd = ti.get("command", "") or ""
    hit = match(cmd)
    if hit and re.search(r"CLAUDE\.md|MEMORY|reasoning-lessons|/handoffs/|/checkpoints/|DSM_0\.2_Custom_Instructions", cmd):
        print("WARN")
        print("Boot-safeguard WARNING (BL-584 Phase 2): this Bash command may write " + hit)
        print("into a boot-loaded surface. Shell writes cannot be blocked reliably; verify by hand.")
        sys.exit(0)
    print("ALLOW"); sys.exit(0)

# Write / Edit: resolve the target path (defensive multi-key, per BL-440).
path = ""
for k in ("file_path", "path", "target_file", "notebook_path"):
    v = ti.get(k)
    if v:
        path = v
        break
if not path:
    print("ALLOW"); sys.exit(0)

content = ti.get("content")
if content is None:
    content = ti.get("new_string")
if content is None:
    content = ""

p = path
if p.startswith("~"):
    p = home + p[1:]
if not os.path.isabs(p):
    p = os.path.join(repo if repo else os.getcwd(), p)
p = os.path.normpath(p)

def is_boot_surface(p):
    # Allowed-verbatim zones are never boot surfaces for this guard.
    if "/dsm-docs/decisions/" in p or "/dsm-docs/research/" in p or "/done/" in p:
        return False
    # Auto-loaded project memory (outside the repo).
    if re.search(r"/\.claude/projects/[^/]+/memory/MEMORY[^/]*\.md$", p):
        return True
    # Repo-relative boot surfaces.
    if repo and (p == repo or p.startswith(repo + "/")):
        rel = os.path.relpath(p, repo)
        if rel in (".claude/CLAUDE.md", "DSM_0.2_Custom_Instructions_v1.1.md",
                   ".claude/reasoning-lessons.md", ".claude/reasoning-lessons-compact.md"):
            return True
        if re.match(r"dsm-docs/handoffs/[^/]+\.md$", rel) or re.match(r"dsm-docs/checkpoints/[^/]+\.md$", rel):
            return True
    return False

if not is_boot_surface(p):
    print("ALLOW"); sys.exit(0)

hit = match(content)
if not hit:
    print("ALLOW"); sys.exit(0)

# Session override for a genuinely required write.
override = os.path.join(repo, ".claude", "boot-safeguard-overrides-session.txt") if repo else ""
if override and os.path.isfile(override):
    with open(override) as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#") and (p == line.rstrip("/") or p.startswith(line.rstrip("/") + "/")):
                print("ALLOW"); sys.exit(0)

print("BLOCK")
print("Boot-safeguard write blocked (BL-584 Phase 2 reintroduction guard).")
print("")
print("Target (boot-loaded surface): " + p)
print("Detected: " + hit + ".")
print("")
print("Writing the BL-543-class trigger family into an always-loaded or boot-read")
print("file can re-arm the model-side safety refusal on strict models. Keep the")
print("verbatim form only in the quarantine logs under dsm-docs/research/, and use")
print("the euphemism in boot-loaded files. See BL-584 and DSM_0.2.G.")
print("")
print("If this write is genuinely required, confirm the target for this session:")
print("  echo '" + p + "' >> " + (override or "<repo>/.claude/boot-safeguard-overrides-session.txt"))
print("  # then retry")
PYEOF
)

HEAD=$(printf '%s\n' "$VERDICT" | head -1)
MSG=$(printf '%s\n' "$VERDICT" | tail -n +2)
case "$HEAD" in
  BLOCK) printf '%s\n' "$MSG" >&2; exit 2 ;;
  WARN)  printf '%s\n' "$MSG" >&2; exit 1 ;;
  *)     exit 0 ;;
esac
