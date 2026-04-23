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

  # Phase 2: at a worktree root → go to the parent of the shared git dir
  # (the main repo root in a normal clone, the project folder holding
  # `.bare` in a bare-repo + siblings layout).
  set -l root (path dirname (path resolve (git rev-parse --git-common-dir)))

  if test -n "$root"; and test "$root" != "$top"
    builtin cd $root
  end
end
