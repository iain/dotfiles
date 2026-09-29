#!/usr/bin/env bash
# WorktreeRemove hook, the counterpart of worktree-create.sh.
set -euo pipefail

exec worktree rm "$(jq -r .worktree_path)"
