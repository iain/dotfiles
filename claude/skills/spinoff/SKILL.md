---
name: spinoff
description: Spin a bug or task from this session off into a new git worktree with its own Claude session in herdr, which investigates it and builds a PR
disable-model-invocation: true
argument-hint: "[what to spin off]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/spinoff *) Bash(git branch --show-current)
---

Spin this off into a new session: $ARGUMENTS

If that's empty, spin off the bug or task we discussed most recently; if that's ambiguous, ask which one. The new session starts in a fresh worktree branched from the just-fetched default branch, and it sees nothing of this conversation except the brief you write.

The new session does the work, including the investigation. Your only job is to write down what this conversation already knows. Don't read files, search, or explore git to write the brief: anything you'd have to look up, the new session can look up itself.

1. Check that `$HERDR_ENV` is `1`. If it isn't, say that spinoff needs herdr and stop.
2. Pick a branch name. If this conversation already settled one (a plan names it, or the tracker suggests one, such as Linear's `gitBranchName`), use it. Otherwise make it short and kebab-case, with the same prefix as `git branch --show-current` if it has one (e.g. `iain/`).
3. Write the brief in markdown:
   - **Problem:** what was reported or seen, with exact error text if we have it.
   - **What we know:** only what already came up here: files, causes, reproduction steps, fix ideas. Mark each as confirmed or a hunch.
   - **Goal:** investigate, reproduce, fix it test-first, and open a draft pull request.

   A few lines is fine when little is known. Leave out everything that isn't about this task.

   When this session wrote a plan that the new session implements, the plan holds the detail. The brief then points at it, says the worktree is already on the plan's branch, and makes the plan's own hand-off command the **Goal**, for example `/pr-from-linear NFKO-78` after `plan-from-linear`.
4. From the repo, run:

   ```bash
   ${CLAUDE_SKILL_DIR}/spinoff <branch> [file...] <<'BRIEF'
   <the brief>
   BRIEF
   ```

   It creates the worktree as a herdr workspace, starts Claude there on the brief (saved in the worktree's git dir, so it's never committed), and prints the worktree path. Each `file`, relative to the repo root, is copied to the same path in the worktree. Pass the files the new session needs that a checkout leaves out: untracked or gitignored ones, such as a plan in `.claude/plans/`.
5. Report the branch and path in one line. Don't carry on with the spun-off work in this session.
