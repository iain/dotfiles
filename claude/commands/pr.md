---
description: Create a GitHub pull request with a short, diff-based description
allowed-tools: Bash, Read, Glob, Grep
---

# PR

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>/dev/null || echo "main"`
- Existing PR (if any): !`gh pr view --json number,title,body,isDraft 2>/dev/null || echo "none"`
- Commits (for reference only — do not rely on these for the summary): !`git log --oneline -20`

## Instructions

### Step 0 — Check project rules

Check CLAUDE.md for any branch restrictions before proceeding.

### Step 1 — Derive an issue ID (optional)

Check the branch name for a pattern like `abc-123` or `ABC-123`. If found, that is the
issue ID. Otherwise there is no issue ID.

### Step 2 — Read the diff

First run `git diff --stat <default-branch>...HEAD` for an overview, then
`git diff <default-branch>...HEAD` for the full diff. Base the title and summary
**entirely on the diff**, not on the commit messages. Commit history often goes back and
forth and may not reflect what ended up in the PR. The diff is the ground truth.

### Step 3 — Write the title

Format: `[ISSUE-ID] short title` if an issue ID was found, otherwise just `short title`.

- Title case, imperative, under 60 characters excluding the issue prefix
- Describe what the change *does*, not how

### Step 4 — Write the description

A short summary of what changed and why — plain prose or a bullet list, whichever is
clearer. No headers, no test plan, no "Co-Authored-By". Keep it brief.

### Step 5 — Push and create or update the PR

Always push first:
```
git push -u origin HEAD
```

Write the PR body to a temporary file, then use `--body-file`:

**If no existing PR:**
```
gh pr create --draft --title "<title>" --body-file <file>
```

**If a PR already exists:** update the title and body with a freshly derived summary
based on the current diff. Do not change the draft status.
```
gh pr edit --title "<title>" --body-file <file>
```

Delete the temporary file afterward.

Print the PR URL when done.
