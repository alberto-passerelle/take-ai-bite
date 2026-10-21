# Getting Started with Take AI Bite

How to set up your own copy of TAB (Take AI Bite) and its methodology, DSM, from nothing to a first
finished session. Every step comes with a command to check it, so you can follow it alone or with an
AI assistant. For what TAB and DSM are, read
[DSM_0.0_START_HERE_Complete_Guide.md](DSM_0.0_START_HERE_Complete_Guide.md) first.

## Contents

1. [Choose Your Starting Path](#choose-your-starting-path)
2. [Prerequisites for Working With TAB](#prerequisites-for-working-with-tab)
3. [Quick Start: Fork and Clone](#quick-start-fork-and-clone)
4. [Each Team Member Needs a Fork](#each-team-member-needs-a-fork)
5. [Quick Try Without a Fork](#quick-try-without-a-fork)
6. [Getting Updates and Sending Feedback](#getting-updates-and-sending-feedback)
7. [Instructions for AI Assistants Helping With Setup](#instructions-for-ai-assistants-helping-with-setup)

---

## Choose Your Starting Path

TAB lives in a public git repository. You never work in that original: you work in your own copy.
The usual copy is a **fork**, a copy on a git hosting service such as GitHub or GitLab that stays
linked to the original, so you can bring in TAB's updates later. There are three ways to start:

| Path | Who it is for | What you get |
|---|---|---|
| **Personal fork** (recommended) | One person using TAB for their own projects | Your own copy online, TAB's updates whenever you choose to pull them, and a route to report issues back to TAB |
| **Team use** | Several people in a team or organization | One personal fork per member; the team shares its project repositories, not a TAB fork |
| **Quick try (download)** | Someone who wants to look before committing | A copy on your computer only: no updates, and no route back to TAB from that copy |

Every path, including the quick try, needs **git** installed on your computer: DSM keeps your work's
history with it. Setting it up is the first item in the prerequisites below.

If you are unsure, choose the personal fork; the steps below follow that path, and the other two have
their own sections. If an AI assistant is helping you set up, point it to
[Instructions for AI Assistants Helping With Setup](#instructions-for-ai-assistants-helping-with-setup).

## Prerequisites for Working With TAB

Have these in place before you start. Where an item shows a check command, run it.

- **git, installed.**
  - Windows: install [Git for Windows](https://git-scm.com/install/windows); it also gives you Git
    Bash, which covers the bash item below.
  - macOS: run `xcode-select --install` (Apple's Command Line Tools include git), or
    `brew install git` if you use Homebrew.
  - Linux: your package manager, for example `sudo apt install git` or `sudo dnf install git`.

  Check: `git --version`
- **git knows who you are.** Run once:
  `git config --global user.name "Your Name"` and
  `git config --global user.email "you@example.com"`. DSM commits your work at the start and end of
  sessions, and git refuses to commit without these. Check: `git config user.name`
- **An account on a git hosting service** for your fork: GitHub, GitLab or similar. TAB itself lives
  on GitHub, so reporting an issue to TAB needs a GitHub account.
- **The GitHub CLI (`gh`)**, if your fork is on GitHub, signed in once with `gh auth login`. DSM uses
  it to open and merge pull requests on your fork when a session ends. Check: `gh auth status`
- **bash**, because DSM's helper scripts are bash scripts. macOS and Linux include it; on Windows, Git
  Bash (above) or WSL provides it. Check: `bash --version`
- **VS Code** with the **Claude Code** extension.
- **A plan that includes Claude Code**: a paid Claude plan (Pro, Max, Team or Enterprise) or an API
  account. The free plan does not include it.

**About your data.** DSM works through an AI assistant, and whatever the assistant reads from your
project (files, data, notes) is sent to its AI provider to be processed. Calling a project "private" in
DSM means it has no online git copy; it does not change where the AI processes your content. Before
working with client, employee or other personal data, check your AI provider's data terms and your
organization's rules.

**Recommended settings.** If your plan lets you choose whether your content is used to train models,
decide that first in your account's privacy settings. To also stop Claude Code's optional usage and
error reports, set `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` in `~/.claude/settings.json` (this also
stops automatic updates, so run `claude update` from time to time). In VS Code, set
`telemetry.telemetryLevel` to `off`.

## Quick Start: Fork and Clone

These steps use GitHub, where TAB lives; for GitLab and other hosts, see the note after step 7. Run
the commands in a terminal (on Windows: Git Bash or WSL).

1. **Pick a parent folder** that will hold TAB and your projects side by side, and open a terminal
   there.
2. **Fork and clone in one command:**
   `gh repo fork albertodiazdurana/take-ai-bite --clone`
   This creates your fork on GitHub and downloads it into a `take-ai-bite` folder.
   *Prefer the website?* Open [github.com/albertodiazdurana/take-ai-bite](https://github.com/albertodiazdurana/take-ai-bite),
   click **Fork**, then clone your fork and link it to the original:
   `git clone https://github.com/YOUR-USERNAME/take-ai-bite`, then, inside the folder,
   `git remote add upstream https://github.com/albertodiazdurana/take-ai-bite`
3. **Check the links.** Inside the folder, run `git remote -v`. You should see `origin` pointing to
   *your* fork and `upstream` pointing to `albertodiazdurana/take-ai-bite`.
4. **Point `gh` at your fork:** `gh repo set-default YOUR-USERNAME/take-ai-bite`
   Check: `gh repo set-default --view` prints your fork. Without this step, `gh` treats the original
   TAB repository as the default, and end-of-session pull requests could be opened there instead of
   on your fork.
5. **Open the `take-ai-bite` folder in VS Code.** In the Claude Code chat window, type `/dsm-go`.
   The first run sets your copy up: it creates your local configuration from templates, registers
   your fork as your own hub and installs the DSM commands. It asks nothing personal.
6. **Create your first project.** Tell the agent what you want to build and where (for example, a
   new folder next to `take-ai-bite`). The agent creates the project folder and links it to the
   methodology, the wiring beginners usually get wrong by hand. To help it understand your work,
   describe it in the chat or write `_preliminary_plan/preliminary_plan.md` covering: what you want
   to do; whether you are building **code**, a **Jupyter notebook** or **documentation**; whether the
   project is **private** (sensitive data, no online copy); and, if you are **contributing to an
   external project**, how and where that project lives. If your work builds on files elsewhere on
   your machine, set up the project first, then ask the agent to bring them in.
7. **Finish with `/dsm-wrap-up`.** In the `take-ai-bite` session, type `/dsm-wrap-up`. It saves what
   was done, commits it, pushes the session to your fork and merges it into your fork's `main`.
   Check: `gh pr list --repo YOUR-USERNAME/take-ai-bite --state merged` shows the session, and nothing
   new appears on the original TAB repository. Then open your project folder in VS Code and type
   `/dsm-go`. The first `/dsm-go` in a new project asks you to approve three short sections of its
   instructions file (its role, its type and what it is about). The agent drafts them from your plan,
   and no code is written until they exist; type `defer` to put this off for one session. From now on
   you work inside your project, and you end each session with `/dsm-wrap-up`.

**GitLab and other hosts.** A GitHub fork stays on GitHub, so on another service you make the copy by
importing it. On GitLab: **Create new** (+) → **New project/repository** → **Import project** →
**Repository by URL**, and enter `https://github.com/albertodiazdurana/take-ai-bite`. Then clone your new
project and add TAB as `upstream` (the import keeps no link to TAB by itself):
`git remote add upstream https://github.com/albertodiazdurana/take-ai-bite`. Skip step 4, which is for
GitHub. At wrap-up, DSM merges through a GitLab merge request if the `glab` command-line tool is
installed and signed in; otherwise, and on any other host, it merges the session locally and pushes
`main`.

## Each Team Member Needs a Fork

TAB is built for one person working with their AI assistant. Your fork holds your sessions, your
memory and your lessons, so it is yours alone. In a team:

- **Every member creates their own fork** and follows the Quick Start. Two people working in the same
  fork would collide: their session branches, checkpoints and backlog numbers would clash.
- **Share the work, not the fork.** Your projects are ordinary git repositories; the team shares them
  with its usual git workflow (branches, pull or merge requests, reviews).
- **Each member keeps their own fork up to date** with TAB (see
  [Getting Updates and Sending Feedback](#getting-updates-and-sending-feedback)).

## Quick Try Without a Fork

To look at TAB before setting up a fork, run it from a downloaded copy:

1. On [TAB's GitHub page](https://github.com/albertodiazdurana/take-ai-bite), choose **Code** →
   **Download ZIP**, and unzip it in your parent folder.
2. Rename the unzipped folder from `take-ai-bite-main` to `take-ai-bite`, so a fork can later take its
   place without breaking your projects' links to it.
3. Open the folder in VS Code and type `/dsm-go`. git must still be installed, because DSM keeps a local
   git history; when it asks for a remote repository, answer `none`. The other prerequisites apply,
   except the hosting account and `gh`.

What you give up:

- **No updates.** The copy has no link to TAB. A newer version means a new download, and changes you
  made in the old copy do not carry over by themselves.
- **No route back to TAB from this copy.** You cannot open pull requests from it; to report an issue,
  you need a GitHub account and TAB's issue page.

If you decide to keep using TAB, switch to a fork (see the Quick Start above).

## Getting Updates and Sending Feedback

TAB keeps improving, and your fork does not update itself. Bring in TAB's updates between sessions
(after a `/dsm-wrap-up`, before the next `/dsm-go`), in the `take-ai-bite` folder. Each step has a
check, so an AI assistant can do this with you one step at a time:

1. **Start clean on `main`:** `git switch main`, then `git status`.
   Check: "nothing to commit, working tree clean".
2. **See what is new:** `git fetch upstream`, then `git log --oneline main..upstream/main`.
   Check: an empty list means you are already up to date; stop here.
3. **Merge TAB's changes:** `git merge --no-edit upstream/main`.
   Check: `git status` reports no conflicts. If a file conflicts, keep TAB's version of the
   methodology text and re-apply your own change on top of it.
4. **Publish to your fork:** `git push origin main`.
   Check: `git status` says your branch is up to date with `origin/main`.
5. **Refresh the DSM commands:** `scripts/sync-commands.sh --deploy`. DSM installs its commands in your
   user folder, and those copies take priority over the ones in the repository, so skipping this step
   leaves you running the old commands. Check: `scripts/sync-commands.sh --check` ends with
   `Drifted: 0 | Missing: 0`.
6. **Start a session:** `/dsm-go`. It notices the new version and updates your configuration.
   Check: the version in `.claude/last-align.txt` matches the top entry of `CHANGELOG.md`.

Your projects follow by themselves: they read the methodology from your `take-ai-bite` folder, so each
project's next `/dsm-go` picks up the new version.

Never update with `gh repo sync --force` or the **Discard commits** option of GitHub's **Sync fork**
button: your fork's `main` also holds your own session work, and a forced sync erases it.

**Sending feedback to TAB.** Report a problem or an idea as an issue on
[TAB's issue page](https://github.com/albertodiazdurana/take-ai-bite/issues) (this needs a GitHub
account). To propose a change to the methodology itself, open a pull request from your fork; see
[CONTRIBUTING.md](CONTRIBUTING.md).

## Instructions for AI Assistants Helping With Setup

If you are an AI assistant helping someone set up TAB, follow this section. The goal: the user has
their own fork, has started and wrapped up a first session, and nothing was sent to the original
repository.

**Do, in order:**

1. Ask which path the user wants ([Choose Your Starting Path](#choose-your-starting-path)); default to
   a personal fork.
2. Verify every prerequisite with its check command before going further, including git's name and
   email. Help install what is missing.
3. Follow the Quick Start one step at a time. After each step, run its check and show the user the
   result; if a check fails, fix it before moving on.
4. On GitHub, confirm that `gh repo set-default --view` names the user's fork before the first
   `/dsm-wrap-up`.
5. For later updates, use the steps in
   [Getting Updates and Sending Feedback](#getting-updates-and-sending-feedback) the same way.

**Do not:**

- work in, push to, or open pull requests or issues on `albertodiazdurana/take-ai-bite` unless the user
  asks to report something or contribute;
- use `--force` with any push, sync or reset;
- run `/dsm-go` in a project folder before the first `/dsm-go` in `take-ai-bite` has finished (that
  first run installs the commands the projects use);
- edit the methodology files (`DSM_*.md`) to get around a setup problem; tell the user instead.

**When something does not match** (a command fails, or its output differs from the check): stop, show
the user the exact output, and ask before trying anything else.
