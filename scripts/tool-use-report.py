#!/usr/bin/env python3
"""Tool-use report from the Claude Code session log (fork-local BACKLOG-029).

Run from the repository root, once at wrap-up:

    python3 -I scripts/tool-use-report.py [--worklog PATH] [--log PATH] [--dry-run] [--turns]

It finds this session's log under ~/.claude/projects/<repo path with '/' as '-'>/ and writes
  .claude/tool-use/S{N}.md      at most 40 lines: totals, the five turns with the most cache
                                reads, and at most five flagged calls
  .claude/tool-use/history.md   one row per session; a re-run replaces the session's row
Both hold counts, times, call categories and the descriptions of flagged calls, never prompt
or tool-output text. In those descriptions, names on .claude/name-denylist.txt and the names
of the repository's sibling folders become '[project]', and paths outside the repository
become '[outside repo]'.

The session's log is the one in which a tool call overwrote .claude/worklog.md with both
'# Session N Transcript' and '**Started:**' (the /dsm-go worklog reset). A call that merely
quotes those strings does not count. Without such a call (a /dsm-light-go boot) the
fallback is the log whose first entry lies within 10 minutes of the worklog's start time and
which touches worklog.md. Known limit: a session that continued in a second log file (after a
restart) is reported from the first log only.

A call's category is the prefix of its description ('Worklog:', 'Check:', 'Worklog+Check:').
Calls of other tools fall back to the tool name; an unprefixed call that touches worklog.md
counts as Worklog. Unprefixed Bash calls are counted, because their category is a guess.

Exit codes: 0 report written (or printed with --dry-run); 2 no log or more than one log
matches; 3 the worklog header or a usage field cannot be read.
"""
import argparse
import json
import re
import sys
from collections import Counter, defaultdict
from datetime import datetime, timedelta
from pathlib import Path

USAGE_FIELDS = ("input_tokens", "cache_creation_input_tokens",
                "cache_read_input_tokens", "output_tokens")
READ_ONLY = {"Check", "Read", "Grep", "Glob"}
PREFIX = re.compile(r"^([A-Za-z]+(?:\+[A-Za-z]+)*):")
LARGE = 10000
MAX_LINES = 40
MAX_FLAGS = 5
PATH_TOOLS = {"Read", "Edit", "Write"}
RESET = re.compile(r"cat\s*>\s*\.claude/worklog\.md")  # the /dsm-go worklog reset (overwrite)
HISTORY_HEADER = (
    "| Session | Date | Turns | Requests | Calls | Worklog-only calls | Cache read "
    "| Cache creation | Output | Worklog follow-up cache read | Errors | Unprefixed Bash |\n"
    "|---|---|---|---|---|---|---|---|---|---|---|---|\n")


def stop(code, msg):
    print(f"tool-use-report: {msg}", file=sys.stderr)
    sys.exit(code)


def ts(entry):
    t = entry.get("timestamp")
    return datetime.fromisoformat(t.replace("Z", "+00:00")) if t else None


def read_header(worklog):
    try:
        text = worklog.read_text(encoding="utf-8")
    except OSError as e:
        stop(3, f"cannot read {worklog}: {e.strerror}")
    m_n = re.search(r"^# Session (\d+) Transcript", text, re.M)
    m_s = re.search(r"^\*\*Started:\*\* (\S+)", text, re.M)
    if not m_n or not m_s:
        stop(3, f"{worklog} has no '# Session N Transcript' and '**Started:**' header")
    return int(m_n.group(1)), datetime.fromisoformat(m_s.group(1))


def load(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    return rows


def tool_uses(rows):
    for e in rows:
        if e.get("type") != "assistant":
            continue
        content = (e.get("message") or {}).get("content")
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and c.get("type") == "tool_use":
                    yield e, c


def find_log(project_dir, n, started):
    if not project_dir.is_dir():
        stop(2, f"no session-log directory {project_dir}")
    marker = f"# Session {n} Transcript"
    logs = sorted(project_dir.glob("*.jsonl"))
    hits = []
    for p in logs:
        if marker not in p.read_text(encoding="utf-8", errors="replace"):
            continue
        for _, c in tool_uses(load(p)):
            inp = c.get("input") or {}
            s = json.dumps(inp, ensure_ascii=False)
            resets = RESET.search(s) or (c.get("name") == "Write" and
                                         str(inp.get("file_path", "")).endswith(".claude/worklog.md"))
            if marker in s and "**Started:**" in s and resets:
                hits.append(p)
                break
    if not hits:
        for p in logs:
            rows = load(p)
            first = next((ts(e) for e in rows if ts(e)), None)
            if first and abs(first - started) <= timedelta(minutes=10) and any(
                    "worklog.md" in json.dumps(c.get("input", {})) for _, c in tool_uses(rows)):
                hits.append(p)
    if len(hits) != 1:
        stop(2, f"{len(hits)} session logs match session {n} (started {started:%Y-%m-%d %H:%M}); "
                "need exactly 1. Pass --log to choose one.")
    return hits[0]


def classify(c):
    name = c.get("name", "?")
    inp = c.get("input") or {}
    m = PREFIX.match((inp.get("description") or "").strip())
    if m:
        return m.group(1), True
    if "worklog.md" in json.dumps(inp, ensure_ascii=False):
        return "Worklog", name != "Bash"
    return ("Ask" if name == "AskUserQuestion" else name), name != "Bash"


def make_redactor(root):
    """Return a function that redacts names and outside paths from a call description."""
    names = []
    listfile = root / ".claude" / "name-denylist.txt"
    if listfile.exists():
        for line in listfile.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                names.append(line)
    names += [d.name for d in root.parent.iterdir() if d.is_dir() and d.name != root.name]
    names = sorted(set(names), key=len, reverse=True)
    prefix = str(root) + "/"

    def path(m):
        p = m.group(0)
        return p[len(prefix):] if p.startswith(prefix) else "[outside repo]"

    def redact(text):
        text = re.sub(r"(?<![\w.])(?:~/|/)[^\s'\"`,;)]+", path, text)
        for n in names:
            text = re.sub(re.escape(n), "[project]", text, flags=re.I)
        return text.replace("|", "/")

    return redact


def describe(call):
    if call["tool"] in PATH_TOOLS and call["fpath"]:
        return f"{call['tool']} {call['fpath']}"
    return call["desc"] or call["tool"]


def analyse(rows):
    turn, turn_start = 0, {}
    usage, req_order, req_turn, req_calls = {}, [], {}, defaultdict(list)
    calls, results, assistant_times = [], {}, []
    for e in rows:
        msg = e.get("message") or {}
        content = msg.get("content")
        t = ts(e)
        if e.get("type") == "user" and not e.get("isMeta") and not e.get("isCompactSummary"):
            items = content if isinstance(content, list) else []
            is_result = any(isinstance(c, dict) and c.get("type") == "tool_result" for c in items)
            if isinstance(content, str) or (not is_result and any(
                    isinstance(c, dict) and c.get("type") == "text" for c in items)):
                turn += 1
                turn_start[turn] = t
            for c in items:
                if isinstance(c, dict) and c.get("type") == "tool_result":
                    body = c.get("content")
                    results[c.get("tool_use_id")] = dict(
                        t=t, err=bool(c.get("is_error")),
                        size=len(json.dumps(body, ensure_ascii=False)) if body is not None else 0)
        elif e.get("type") == "assistant":
            if t:
                assistant_times.append(t)
            mid = msg.get("id") or e.get("uuid")
            u = msg.get("usage")
            if u and mid not in usage:
                missing = [f for f in USAGE_FIELDS if f not in u]
                if missing:
                    stop(3, f"a request lacks usage field(s) {', '.join(missing)}; "
                            "has the log format changed?")
                usage[mid] = u
                req_order.append(mid)
                req_turn[mid] = turn
            if isinstance(content, list):
                for c in content:
                    if isinstance(c, dict) and c.get("type") == "tool_use":
                        cat, prefixed = classify(c)
                        inp = c.get("input") or {}
                        call = dict(id=c.get("id"), tool=c.get("name", "?"), cat=cat,
                                    prefixed=prefixed, t=t, req=mid, turn=turn,
                                    path=inp.get("file_path") if c.get("name") == "Read" else None,
                                    fpath=inp.get("file_path"), desc=inp.get("description") or "",
                                    size_in=len(json.dumps(inp, ensure_ascii=False)))
                        calls.append(call)
                        req_calls[mid].append(call)
    if not usage:
        stop(3, "the log holds no request with usage data")
    return dict(turn_start=turn_start, usage=usage, req_order=req_order, req_turn=req_turn,
                req_calls=req_calls, calls=calls, results=results,
                assistant_times=sorted(assistant_times))


def summarise(d):
    usage, order, req_calls = d["usage"], d["req_order"], d["req_calls"]
    nxt = {order[i]: order[i + 1] for i in range(len(order) - 1)}
    tot = Counter()
    for u in usage.values():
        for f in USAGE_FIELDS:
            tot[f] += u.get(f) or 0
    is_wl_only = {r: bool(cs) and all(c["cat"] == "Worklog" for c in cs) for r, cs in req_calls.items()}
    wl_follow = sum((usage[nxt[r]].get("cache_read_input_tokens") or 0)
                    for r, only in is_wl_only.items() if only and r in nxt)
    tool_s = wait_s = 0.0
    for c in d["calls"]:
        r = d["results"].get(c["id"])
        if not r or not r["t"] or not c["t"] or c["tool"] == "AskUserQuestion":
            continue  # a question's result time is the user's answer, not tool time
        tool_s += (r["t"] - c["t"]).total_seconds()
        after = next((a for a in d["assistant_times"] if a > r["t"]), None)
        if after:
            wait_s += (after - r["t"]).total_seconds()
    sizes = [r["size"] for r in d["results"].values()]
    reads = Counter(c["path"] for c in d["calls"] if c["path"])
    flags, seen = [], set()
    for c in d["calls"]:
        r = d["results"].get(c["id"])
        if r and r["err"]:
            flags.append((c["turn"], "error", c))
    for c in d["calls"]:
        r = d["results"].get(c["id"])
        if r and r["size"] > LARGE:
            flags.append((c["turn"], f"output {fmt(r['size'])} chars", c))
    for c in d["calls"]:
        if c["path"]:
            if c["path"] in seen:
                flags.append((c["turn"], "read again", c))
            seen.add(c["path"])
    chains = 0
    for a, b in zip(order, order[1:]):
        ca, cb = req_calls.get(a, []), req_calls.get(b, [])
        if (len(ca) == 1 and len(cb) == 1 and d["req_turn"][a] == d["req_turn"][b]
                and ca[0]["cat"] in READ_ONLY and cb[0]["cat"] in READ_ONLY):
            chains += 1
            flags.append((d["req_turn"][b], "could join previous call", cb[0]))
    per_turn = defaultdict(lambda: Counter())
    for r in order:
        k = d["req_turn"][r]
        per_turn[k]["requests"] += 1
        per_turn[k]["cache_read"] += usage[r].get("cache_read_input_tokens") or 0
    for c in d["calls"]:
        per_turn[c["turn"]]["calls"] += 1
        per_turn[c["turn"]]["worklog"] += c["cat"] == "Worklog"
    cats = Counter(c["cat"] for c in d["calls"])
    bash = [c for c in d["calls"] if c["tool"] == "Bash"]
    return dict(
        tot=tot, requests=len(order), calls=len(d["calls"]), cats=cats,
        tools=Counter(c["tool"] for c in d["calls"]),
        wl_only=cats.get("Worklog", 0),
        wl_guessed=sum(1 for c in d["calls"] if c["cat"] == "Worklog" and not c["prefixed"]),
        wl_mixed=sum(1 for c in d["calls"] if "Worklog" in c["cat"].split("+") and c["cat"] != "Worklog"),
        wl_follow=wl_follow, tool_s=tool_s, wait_s=wait_s, flags=flags,
        wl_requests=sum(1 for r, only in is_wl_only.items() if only and r in nxt),
        wl_chars=sum(c["size_in"] for c in d["calls"] if "Worklog" in c["cat"].split("+")),
        errors=sum(1 for r in d["results"].values() if r["err"]),
        large=sum(1 for s in sizes if s > LARGE), largest=max(sizes, default=0),
        reread_files=sum(1 for v in reads.values() if v > 1),
        reread_extra=sum(v - 1 for v in reads.values() if v > 1),
        chains=chains, bash=len(bash), unprefixed=sum(1 for c in bash if not c["prefixed"]),
        turns=len(d["turn_start"]), per_turn=per_turn, turn_start=d["turn_start"])


def fmt(n):
    return f"{n:,}"


def report(n, started, s, redact):
    tot, cr = s["tot"], s["tot"]["cache_read_input_tokens"]
    share = f"{100 * s['wl_follow'] / cr:.0f}%" if cr else "n/a"
    tools = ", ".join(f"{k} {v}" for k, v in s["tools"].most_common())
    cats = ", ".join(f"{k} {v}" for k, v in s["cats"].most_common(6))
    lines = [
        f"# Tool-Use Report, Session {n}",
        "",
        f"Started {started:%Y-%m-%d %H:%M}; {s['turns']} turns, {s['requests']} requests, "
        f"{s['calls']} tool calls ({tools}).",
        f"Categories: {cats}.",
        "",
        "| Measure | Value |",
        "|---|---|",
        f"| Cache read | {fmt(cr)} ({fmt(cr // max(s['requests'], 1))} per request) |",
        f"| Cache creation / output | {fmt(tot['cache_creation_input_tokens'])} / {fmt(tot['output_tokens'])} |",
        f"| Worklog calls | {s['wl_only']} worklog-only ({s['wl_guessed']} guessed: no prefix), "
        f"{s['wl_mixed']} combined |",
        f"| Extra requests caused by worklog-only calls | {s['wl_requests']} "
        f"(cache read {fmt(s['wl_follow'])}, {share} of all) |",
        f"| Input characters of calls that write the worklog | {fmt(s['wl_chars'])} "
        "(combined calls in full) |",
        f"| Tool time / wait for next step | {s['tool_s']:.0f} s / {s['wait_s']:.0f} s |",
        f"| Errors | {s['errors']} |",
        f"| Outputs over {fmt(LARGE)} chars | {s['large']} (largest {fmt(s['largest'])}) |",
        f"| Files read more than once | {s['reread_files']} ({s['reread_extra']} extra reads) |",
        f"| Single-call read-only chains | {s['chains']} |",
        f"| Bash calls without a prefix | {s['unprefixed']} of {s['bash']} |",
        "",
        "Turns with the most cache reads:",
        "",
        "| Turn | Start | Calls | Requests | Cache read | Worklog calls |",
        "|---|---|---|---|---|---|",
    ]
    top = sorted(s["per_turn"].items(), key=lambda kv: -kv[1]["cache_read"])[:5]
    for k, v in sorted(top):
        start = s["turn_start"].get(k)
        lines.append(f"| {k} | {start.astimezone():%H:%M} | {v['calls']} | {v['requests']} | "
                     f"{fmt(v['cache_read'])} | {v['worklog']} |" if start else
                     f"| {k} | - | {v['calls']} | {v['requests']} | {fmt(v['cache_read'])} | {v['worklog']} |")
    if s["flags"]:
        lines += ["", f"Flagged calls ({min(len(s['flags']), MAX_FLAGS)} of {len(s['flags'])}):", "",
                  "| Turn | Flag | Category | Call |", "|---|---|---|---|"]
        for turn, kind, c in s["flags"][:MAX_FLAGS]:
            lines.append(f"| {turn} | {kind} | {c['cat']} | {redact(describe(c))[:100]} |")
    assert len(lines) <= MAX_LINES, len(lines)
    return "\n".join(lines) + "\n"


def history_row(n, started, s):
    t = s["tot"]
    return (f"| S{n} | {started:%Y-%m-%d} | {s['turns']} | {s['requests']} | {s['calls']} | "
            f"{s['wl_only']} | {t['cache_read_input_tokens']} | {t['cache_creation_input_tokens']} | "
            f"{t['output_tokens']} | {s['wl_follow']} | {s['errors']} | {s['unprefixed']} |\n")


def write_history(path, n, row):
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True) if path.exists() else []
    if not lines:
        lines = HISTORY_HEADER.splitlines(keepends=True)
    lines = [l for l in lines if not l.startswith(f"| S{n} |")] + [row]
    path.write_text("".join(lines), encoding="utf-8")


def main():
    ap = argparse.ArgumentParser(description="Tool-use report from the Claude Code session log.")
    ap.add_argument("--worklog", default=".claude/worklog.md",
                    help="worklog whose header names the session (default: .claude/worklog.md)")
    ap.add_argument("--log", help="session log to use instead of searching for it")
    ap.add_argument("--dry-run", action="store_true", help="print the report, write nothing")
    ap.add_argument("--turns", action="store_true", help="also print every turn's numbers")
    a = ap.parse_args()

    root = Path.cwd()
    n, started = read_header(Path(a.worklog))
    project_dir = Path.home() / ".claude" / "projects" / str(root).replace("/", "-")
    log = Path(a.log) if a.log else find_log(project_dir, n, started)
    print(f"tool-use-report: session {n}, log {log.name}", file=sys.stderr)
    s = summarise(analyse(load(log)))
    text = report(n, started, s, make_redactor(root))

    if a.turns:
        for k, v in sorted(s["per_turn"].items()):
            print(f"turn {k}: calls {v['calls']}, requests {v['requests']}, "
                  f"cache read {fmt(v['cache_read'])}, worklog calls {v['worklog']}")
    if a.dry_run:
        print(text, end="")
        return
    out = root / ".claude" / "tool-use"
    out.mkdir(parents=True, exist_ok=True)
    (out / f"S{n}.md").write_text(text, encoding="utf-8")
    write_history(out / "history.md", n, history_row(n, started, s))
    print(f"tool-use-report: wrote .claude/tool-use/S{n}.md ({text.count(chr(10))} lines) "
          f"and the S{n} row of history.md")


if __name__ == "__main__":
    main()
