#!/usr/bin/env bash
# WorktreeRemove hook, the counterpart of worktree-create.sh. A worktree that
# is open in herdr is removed through herdr, which also closes its workspace;
# any other goes through plain git. Neither forces: a checkout with uncommitted
# or untracked files stays on disk and the removal fails, so nothing is lost
# silently. The branch is deleted only when it has no commits of its own.
set -euo pipefail

path=$(jq -r .worktree_path)

common_dir=$(git -C "$path" rev-parse --path-format=absolute --git-common-dir)
repo_root=$(dirname "$common_dir")
branch=$(git -C "$path" branch --show-current)

workspace_id=""
if [ "${HERDR_ENV:-}" = "1" ]; then
	workspace_id=$(herdr worktree list --cwd "$repo_root" |
		jq -r --arg path "$path" '.result.worktrees[] | select(.path == $path) | .open_workspace_id // empty')
fi

if [ -n "$workspace_id" ]; then
	herdr worktree remove --workspace "$workspace_id" >&2
else
	git -C "$repo_root" worktree remove "$path" >&2
fi

default=$(git -C "$repo_root" symbolic-ref --quiet --short refs/remotes/origin/HEAD || true)
if [ -n "$branch" ] && [ -n "$default" ] && [ "$(git -C "$repo_root" rev-list --count "$default..$branch")" = 0 ]; then
	git -C "$repo_root" branch -D "$branch" >&2
fi
