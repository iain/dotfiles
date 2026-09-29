#!/usr/bin/env bash
# WorktreeCreate hook: create Claude's worktrees with bin/worktree, so they land
# where herdr and the shell put theirs. Claude reads the last line of stdout
# as the path.
set -euo pipefail

input=$(cat)
name=$(jq -r .name <<<"$input")
cwd=$(jq -r .cwd <<<"$input")

# Claude writes the slash of a branch-style name as "+"; the branch keeps it.
cd "$cwd"
exec worktree new "${name//+//}"
