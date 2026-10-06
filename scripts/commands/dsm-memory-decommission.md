Move the oldest session group from MEMORY.md to MEMORY-long-term.md when the sessions
zone exceeds its size threshold. Keeps the always-loaded MEMORY.md lean. $ARGUMENTS

## When this runs

- Auto-invoked by `/dsm-wrap-up` and `/dsm-quick-wrap-up` when the MEMORY.md sessions
  zone exceeds ~4 KB (BACKLOG-544).
- Manual: run directly to force one decommission regardless of threshold.

## Steps

1. **Resolve the auto-memory dir deterministically** (never a search that could return
   another project's MEMORY.md; Claude Code maps both `/` and `_` to `-`, BL-504):
   `MEMDIR="$HOME/.claude/projects/$(pwd | sed 's#[/_]#-#g')/memory"`.
   If `$MEMDIR/MEMORY.md` does not exist, report and stop.

2. **Pre-confirm the cross-repo target (BL-391).** Append `$MEMDIR` to
   `.claude/cross-repo-writes-session.txt` if not already present (the dir is outside
   the repo, so the write hook would otherwise block).

3. **Locate the sessions zone.** Find the `<!-- SESSIONS ZONE` marker line in
   MEMORY.md. Everything below it is the sessions zone; everything above (including
   the `<!-- EVERGREEN ZONE` marker) is evergreen and is never touched. If no SESSIONS
   marker exists, report "MEMORY.md not tiered (no SESSIONS marker); nothing to do"
   and stop.

4. **Measure and gate.** Byte size of the sessions zone. If `<= 4096 B`, report
   "nothing to decommission (sessions zone {N} B within ~4 KB)" and stop (no-op).

5. **Identify the oldest session group.** Group headers are `## S{N}` lines below the
   SESSIONS marker. A group is ALL blocks sharing the same `{N}` (e.g. `## S263`,
   `## S263 cont.`, `## S263 cont.2` are one group). The oldest group is the lowest
   `{N}`; it moves whole, never split.

6. **Back up first.** Copy MEMORY.md and (if present) MEMORY-long-term.md to the
   session scratchpad, so a bad move is recoverable.

7. **Move the group (move-only; NEVER `replace_all` on MEMORY.md):**
   a. Read the oldest group's block(s) verbatim.
   b. If MEMORY-long-term.md is absent, create it with a title line and a one-line
      comment naming it the decommissioned-sessions tier.
   c. Insert the block(s) into MEMORY-long-term.md so its session groups stay in
      descending-N order (a decommissioned group is newer than everything already
      there, so it goes at the top of long-term's sessions area, below any header).
   d. Delete the block(s) from MEMORY.md (anchored Edit, or an explicit line-range
      cut; never a global replace).

8. **Validate.** Assert all three, reporting each:
   - evergreen zone (above the SESSIONS marker) is byte-identical before/after;
   - the moved group is absent from MEMORY.md and present in MEMORY-long-term.md;
   - total bytes across the two files are conserved (allow only the new long-term
     header, if just created). On any failure, restore from the scratchpad backup
     and report.

9. **Report** before/after `wc -c` for both files and which `S{N}` group moved.

## Notes

- Evergreen zone is NEVER moved (BACKLOG-544 top risk: a botched edit degrades every
  boot). Move-only, backed up, validated.
- A sessions-zone block with no recognizable `## S{N}` header is reported as a defect
  to fix by hand, not moved (BACKLOG-544 timestamp-ambiguity risk).
- The threshold is on the SESSIONS ZONE, not total MEMORY.md: the evergreen zone can
  exceed 4 KB on its own, so a total-file threshold would never clear (BACKLOG-544,
  S268 measurement: evergreen was 8 KB against a 5 KB total target).
- Companion: `/dsm-memory-archive` (MEMORY-long-term.md -> MEMORY-archived.md, 10 KB).
- Follow .claude/CLAUDE.md conventions and the Session Transcript Protocol.
