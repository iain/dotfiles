#!/usr/bin/env bash
# WorktreeCreate hook: create Claude's worktrees with ~/.claude/bin/worktree-create,
# so they land where herdr puts its own. Claude reads the last line of stdout
# as the path.
set -euo pipefail

input=$(cat)
name=$(jq -r .name <<<"$input")
cwd=$(jq -r .cwd <<<"$input")

# Claude writes the slash of a branch-style name as "+"; the branch keeps it.
exec "$HOME/.claude/bin/worktree-create" "$cwd" "${name//+//}"
