---
description: Run tests then commit — prompts if changes are mixed
allowed-tools: Bash, Read, Edit, Write, Glob, Grep
---

# Commit

## Context

- Current branch: !`git branch --show-current`
- Unstaged + staged changes: !`git diff HEAD`
- Untracked files: !`git status --short`
- Recent commits (for message style): !`git log --oneline -8`

## Instructions

### Step 0 — Check project rules

Check CLAUDE.md for any branch restrictions before proceeding.

### Step 1 — Run tests

Check CLAUDE.md for a documented test runner command and use it. If CLAUDE.md does not
specify one, detect the project's test runner (`mise`, `make`, `npm`, `cargo`, etc.).
If tests fail, stop and report the failures. Do not commit.

If no test runner is found, skip this step and proceed.

### Step 2 — Assess the changes

Read the diff carefully. Decide whether the changes form **one cohesive unit** (single
concern, single feature, single fix) or **multiple unrelated concerns**.

- If cohesive: proceed directly to Step 3 with a single commit. Do not ask.
- If mixed: ask the user once — "These changes cover multiple concerns. One commit or
  separate commits?" — then follow their answer.

### Step 3 — Commit

For each commit:
1. Stage only the files that belong to it (`git add <files…>`).
   **Never stage sensitive files** (`.env`, credentials, keys, tokens). If any are in the
   diff, warn the user and skip them.
2. Write a commit message that is **short, imperative, title case** (capitalise each
   significant word), easy to scan in a `git log --oneline`. Examples:
   `Add Pagination to Query Endpoint`, `Fix Null Check in Validator`, `Update Dependencies`.
3. No bullet-point bodies, no "Co-Authored-By", no fluff. Just the subject line unless a
   single sentence of context is genuinely needed (rare).
4. Write the message to a temporary file, then commit with `git commit -F <file>` and
   delete the file afterward. This avoids shell quoting issues.

If the user asked for separate commits, run `git reset` (unstage everything) before
starting, then for each concern stage only its files, commit, and repeat in logical order.
