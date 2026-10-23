# Distributing a Claude skill to a team so it runs on each member's laptop

**Date:** 2026-10-23
**Linked BL:** none (feeds a personal skill draft, `.claude/drafts/2026-10-23_s21_tab-update/SKILL.md`)
**Author:** Alberto
**Status:** Active
**Validation depth:** Two passes (delegated docs read, then a source pass on two of the pages)

---

## 1. Purpose / Question

A team member's local TAB hub (a clone of their own fork of take-ai-bite) needs
an update path that does not start a DSM session in the hub. The proposed
answer is a skill, `/tab-update`, shared through the Team's Claude app. The
skill must run git and a bash script on the member's own laptop (Windows or
macOS). Questions:

1. Does a skill shared or provisioned in the Claude app reach Claude Code?
2. Where does a skill run when invoked in the Claude app itself?
3. What does Claude Code on Windows need to run a bash script?
4. Which SKILL.md fields control invocation and arguments?

## 2. Sources

- S1: https://code.claude.com/docs/en/skills.md
- S2: https://support.claude.com/en/articles/13119606-provision-and-manage-skills-for-your-organization
- S3: https://support.claude.com/en/articles/12512180-use-skills-in-claude
- S4: https://support.claude.com/en/articles/14479288-claude-cowork-architecture-overview
- S5: https://code.claude.com/docs/en/setup.md
- S6: https://code.claude.com/docs/en/tools-reference.md
- S7: https://code.claude.com/docs/en/plugins/install.md
- S8: https://code.claude.com/docs/en/plugins/org.md

## 3. Pass log

**Pass 1 (delegated, 2026-10-23):** a research subagent read S1-S8 and reported
per question, labelling each point confirmed, unclear or inferred. Its report
was checked against its own scope before use (§19.3): specific, sourced, and
proportionate to the pages read.

**Pass 2 (source pass, 2026-10-23):** S1 and S2 fetched directly. Scope of
this pass, by finding ID in section 4: F1, F2, F3, F4, F5, F8, F9. Findings F6,
F7, F10 and F11 rest on pass 1 only.

## 4. Findings

- **F1 (S2, pass 2):** Only organization owners add or remove org-wide skills
  (Team and Enterprise). Prerequisite: code execution and Skills enabled in the
  Policy tab. Provisioned skills are on by default; members can switch them off.
- **F2 (S2, pass 2):** Upload is "a .zip file containing your skill (must
  include a SKILL.md file)". Folder layout and name/description limits are not
  stated there.
- **F3 (S2, pass 2):** Members can share a skill with specific colleagues when
  skill sharing is on (default on for Team). Shared skills are view-only for
  recipients.
- **F4 (S2, pass 2):** "Provisioned skills also load in Claude Code for users
  who sign in with their Claude account." Admins can stop this with
  `syncClaudeAiSkills: false` in managed settings. S2 says this for provisioned
  skills; whether skills shared member-to-member also sync is not stated.
- **F5 (S1, pass 2):** Claude Code downloads the account's skills into
  `~/.claude/skills/synced/` at session start "in your terminal", only with a
  `/login` sign-in, and only from Claude Code v2.1.273. No sync with an API key,
  `CLAUDE_CODE_OAUTH_TOKEN`, Bedrock, bare mode or `--safe-mode`. After a
  mid-session `/login`, restart. Edits under `synced/` are never uploaded and
  can be overwritten. **The VS Code extension is not named.**
- **F6 (S3, pass 1):** In the Claude app chat, skills run in Claude's code
  execution container. Nothing documents access to the user's local files or
  git credentials. Inference: a chat-invoked skill cannot update a local repo.
- **F7 (S4, pass 1):** Cowork local sessions run shell commands in a Linux VM
  on the device, limited to connected folders; git and credential access are
  not documented.
- **F8 (S1, pass 2):** Frontmatter: `disable-model-invocation: true` stops
  Claude from loading the skill on its own (manual `/name` only);
  `argument-hint` shows expected arguments; `allowed-tools` pre-approves tools
  for the invoking turn.
- **F9 (S1, pass 2):** Arguments arrive through `$ARGUMENTS` (`$0`, `$1` for
  positions). A personal skill in `~/.claude/skills/<name>/SKILL.md` loads in
  all projects on the machine, not in Cowork or cloud sessions.
- **F10 (S5, pass 1):** On native Windows the Bash tool uses Git Bash when Git
  for Windows is installed; without it, commands run through the PowerShell
  tool.
- **F11 (S6, pass 1):** Shell state such as `export` does not persist between
  Bash tool calls.

## 5. Not documented, to test

- T1: Do synced skills appear in a VS Code extension session? (F5)
- T2: Does a skill shared member-to-member (not provisioned) sync to Claude
  Code? (F3, F4)
- T3: What do `~` and `$HOME` resolve to in Git Bash under Claude Code on
  Windows? (pass 1 found no statement)
- T4: Does the claude.ai upload accept and keep the Claude Code frontmatter
  field `disable-model-invocation`? (F2, F8)

## 6. Implications for the skill draft

- Invoke in Claude Code (VS Code or terminal), never in the Claude app chat (F6).
- Provision it as owner (F1, F4) rather than share it member-to-member until T2
  is answered.
- Check for `git` and `bash` first; a Windows laptop without Git for Windows has
  no bash (F10).
- Re-derive the hub path in every snippet instead of relying on exported
  variables (F11).
- Print the resolved path before any change, so T3 is answered on the first run.
