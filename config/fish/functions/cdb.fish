function cdb
  set -l top (git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo "cdb: not inside a git repository" >&2
    return 1
  end

  # Phase 1: inside a subdirectory of a worktree → go to the worktree root
  if test -n (git rev-parse --show-prefix)
    builtin cd $top
    return
  end

  # Phase 2: at a worktree root → go to the main repo root (the first
  # entry of `git worktree list` is always the main worktree)
  set -l main (git worktree list --porcelain | string match -rg '^worktree (.*)' | head -n1)

  if test -n "$main"; and test "$main" != "$top"
    builtin cd $main
  end
end
