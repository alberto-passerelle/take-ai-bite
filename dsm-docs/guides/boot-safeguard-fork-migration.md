# Boot-Safeguard Fork Migration Guide

**Applies when:** all three hold.
1. The repo is a fork or clone of the public DSM mirror, set up with the Cloned-Mirror Kick-off
   (DSM_0.2.A §25).
2. It was set up before v1.33.0 and is now updating to v1.33.0 or later.
3. You run, or plan to run, DSM sessions on a strict model (Opus 5.5, Sonnet 5.5 or later).
**Time:** about 15 minutes per fork, plus one strict-model boot to confirm.

## A. What Changed and Who Needs This

v1.33.0 fixes a model-side refusal that the strictest models (Opus 5.5, Sonnet 5.5 and later) could give
when a DSM session starts. Several phrasings in the always-loaded instructions were each harmless, but
together they crossed the model's safety threshold, so a bare "start" or `/dsm-go` could be stopped before
the session began. v1.33.0 renames the live work-log file to `.claude/worklog.md`, rewords the phrasings,
and adds a hook that blocks them from being written back into files read at session start.

Merging `upstream/main` brings you the fixed methodology files. It does not touch the files that live
only on your machine: the user-level commands, your runtime `.claude/CLAUDE.md`, your auto-memory, your
lessons and your active handoffs. This guide covers those.

If you only use non-strict models, nothing breaks today. Do the migration before you switch.

## B. Before You Start the Migration

- **Use a non-strict model (for example Opus 4.8) for steps 1 to 4.** A strict model can also stop part
  way through a session when it reads content that has not been migrated yet, and steps 1 to 4 read
  exactly that content. Switch to the strict model only for the final check in step 5.
- **Commit or stash your local work**, so the upstream merge starts from a clean tree.
- **Windows:** run the shell commands below in Git Bash or WSL.
- In the commands below, the old file name is assembled from two parts
  (`OLD="session-""transcript"`), so that this guide never contains it as one string.

## C. Step 1: Merge the Upstream Release

```bash
git remote -v | grep -q upstream || git remote add upstream https://github.com/albertodiazdurana/take-ai-bite.git
git fetch upstream
git merge upstream/main
```

The merge is an ordinary three-way merge. Your fork-local backlog items, checkpoints and other additions
are kept (DSM_0.2 §21.5). If a methodology file conflicts (`DSM_*.md`, `scripts/commands/*.md`,
`.claude/hooks/*.sh`, `.claude/*.template`, `scripts/templates/settings-hooks.json`), take upstream's
version unless you changed that file on purpose; an old version brings the problem back.

## D. Step 2: Refresh the User-Level Commands

```bash
scripts/sync-commands.sh --deploy
scripts/sync-commands.sh --check     # should report no drift
```

Kick-off installed the DSM commands into your user-level `~/.claude/commands/`, and Claude Code uses those
in preference to the copies inside the repo. After the merge they are still the old versions, so a strict
model is refused at `/dsm-go` even though every file in the repo is fixed. This is not hypothetical: it is
exactly how a fresh clone failed during the v1.33.0 rollout, and redeploying the commands fixed it. If you
run DSM from more than one machine or user profile, refresh each one.

## E. Step 3: Realign the Fork Configuration

Start a new session (non-strict model) in the fork and run `/dsm-align`. Your fork lists itself as its own
hub, so align takes the hub path and repairs the fork from its own, now updated, files:

- rebuilds the managed block in `.claude/CLAUDE.md` (between the `BEGIN` and `END DSM_0.2 ALIGNMENT`
  markers) from the clean template;
- installs the updated hooks, including the new guard `validate-boot-safeguard-write.sh`, and merges their
  wiring into `.claude/settings.json`;
- creates `.claude/worklog.md`.

The align report should list these changes. If it reports a missing or stale `@` reference, fix that first
and re-run.

## F. Step 4: Retire the Old Local Content

**The old live file and `.gitignore`.** Nothing writes the old file any more. Point `.gitignore` at the new
one, then remove the old file (copy anything you want to keep into `.claude/worklog.md` first):

```bash
OLD="session-""transcript"
grep -n "$OLD\|worklog" .gitignore            # replace the old line with .claude/worklog.md
git check-ignore -v .claude/worklog.md         # must print a .gitignore match
rm -f ".claude/$OLD.md"
```

**Files read at session start.** Replace the old file name with `worklog` wherever it appears in:

- your auto-memory, `~/.claude/projects/<slug>/memory/MEMORY*.md` (find the slug with
  `ls ~/.claude/projects/ | grep "$(basename "$PWD")"`);
- `.claude/reasoning-lessons.md` and `.claude/reasoning-lessons-compact.md`;
- active files in `dsm-docs/handoffs/` and `dsm-docs/checkpoints/` (leave their `done/` folders alone;
  they are not read at session start).

If any of those notes describe the refusal itself, describe it in general terms rather than quoting it.

**CLAUDE.md outside the managed block.** Align only rewrites the managed block. Compare whatever you have
outside it with the fresh `.claude/CLAUDE.md.template`, and adopt the template's wording for any section
that came from it.

## G. Step 5: Verify the Migration

**Mechanical check (still on the non-strict model):**

```bash
OLD="session-""transcript"
grep -rn "$OLD" .claude/CLAUDE.md .claude/hooks/ .claude/reasoning-lessons*.md \
  dsm-docs/handoffs/*.md dsm-docs/checkpoints/*.md 2>/dev/null       # expect no output
SLUG=$(ls ~/.claude/projects/ | grep "$(basename "$PWD")")
grep -n "$OLD" ~/.claude/projects/"$SLUG"/memory/MEMORY*.md 2>/dev/null   # expect no output
printf '%s\n' "$OLD" | grep -c "$OLD"                                    # positive control: must print 1
```

The positive control shows the pattern can match, so empty output above it means clean rather than broken.

**The deciding check (strict model).** Open a new session on Opus 5.5 or Sonnet 5.5 in the fork. Send a
bare `start`, then run `/dsm-go`. Both should run without a refusal, and `/dsm-go` resets
`.claude/worklog.md`, which is expected.

## H. If the Strict-Model Boot Still Fails

| Symptom | Likely cause | Fix |
|---|---|---|
| "start" works, `/dsm-go` is refused | Stale user-level commands | Step 2 again, on the machine and profile you booted from |
| Refused part way through a session | The session read content that was not migrated | Step 4 on that file, using a non-strict model |
| The guard blocks a write | The text being written contains one of the blocked phrasings | Reword it; the hook's message names the file |
| Still refused at boot after all steps | Another always-loaded file still carries the old content | Re-run step 5's check over every file your setup loads at start, then report it upstream |

To report a problem upstream, open an issue on the public mirror. Describe the symptom and the step, not the
blocked text.
