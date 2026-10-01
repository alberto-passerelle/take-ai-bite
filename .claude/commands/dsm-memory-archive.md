Move the oldest session group from MEMORY-long-term.md to MEMORY-archived.md when the
long-term tier exceeds its size threshold. The deepest memory tier. $ARGUMENTS

## When this runs

- Auto-invoked by `/dsm-wrap-up` and `/dsm-quick-wrap-up` when MEMORY-long-term.md
  exceeds 10 KB (BACKLOG-544).
- Manual: run directly to force one archive regardless of threshold.

## Steps

1. **Resolve the auto-memory dir deterministically** (never a search that could return
   another project's files; Claude Code maps both `/` and `_` to `-`, BL-504):
   `MEMDIR="$HOME/.claude/projects/$(pwd | sed 's#[/_]#-#g')/memory"`.
   If `$MEMDIR/MEMORY-long-term.md` does not exist, report "no long-term tier yet;
   nothing to archive" and stop.

2. **Pre-confirm the cross-repo target (BL-391).** Append `$MEMDIR` to
   `.claude/cross-repo-writes-session.txt` if not already present.

3. **Measure and gate.** Byte size of MEMORY-long-term.md. If `<= 10240 B`, report
   "nothing to archive (long-term {N} B within 10 KB)" and stop (no-op). The whole
   long-term file is decommissioned session groups plus the recall-hook index; there
   is no evergreen zone to protect here (that distinction is MEMORY.md's alone).

4. **Identify the oldest session group.** Group headers are `## S{N}` lines; a group
   is ALL blocks sharing the same `{N}`. The oldest group is the lowest `{N}`; it
   moves whole, never split. The Key Patterns recall-hook index (non-`## S{N}`
   content) is not a session group and is never moved by this skill.

5. **Back up first.** Copy MEMORY-long-term.md and (if present) MEMORY-archived.md to
   the session scratchpad.

6. **Move the group (move-only; never `replace_all`):**
   a. Read the oldest group's block(s) verbatim.
   b. If MEMORY-archived.md is absent, create it with a title line and a one-line
      comment naming it the deepest (archived) memory tier.
   c. Insert the block(s) so MEMORY-archived.md stays in descending-N order (the
      archived group is newer than everything already there, so it goes at the top of
      the archived sessions area, below any header).
   d. Delete the block(s) from MEMORY-long-term.md (anchored Edit or explicit
      line-range cut; never a global replace).

7. **Validate.** Assert and report: the recall-hook index and any non-session content
   in MEMORY-long-term.md are byte-identical before/after; the moved group is absent
   from long-term and present in archived; total bytes conserved (allow only a new
   archived header, if just created). On any failure, restore from the scratchpad
   backup and report.

8. **Report** before/after `wc -c` for both files and which `S{N}` group moved.

## Notes

- Move-only, backed up, validated (same corruption guard as `/dsm-memory-decommission`,
  though MEMORY-archived.md and MEMORY-long-term.md are read on demand, not at boot).
- The Key Patterns recall-hook index stays in MEMORY-long-term.md; only session groups
  age downward.
- A long-term block with no recognizable `## S{N}` header is left in place (it is
  index content, not a session group), not moved.
- Companion: `/dsm-memory-decommission` (MEMORY.md -> MEMORY-long-term.md, 4 KB
  sessions-zone trigger).
- Follow .claude/CLAUDE.md conventions and the Session Transcript Protocol.
