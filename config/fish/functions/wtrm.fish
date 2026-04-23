function wtrm --description 'Remove a git worktree via fzf (or matching query)'
  if not command -q fzf
    echo "wtrm: fzf is not installed" >&2
    return 1
  end

  set -l paths (git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { path = substr($0, 10); bare = 0; next }
    /^bare$/     { bare = 1 }
    /^$/         { if (path && !bare) print path; path = ""; bare = 0 }
    END          { if (path && !bare) print path }
  ')
  or begin
    echo "wtrm: not inside a git repository" >&2
    return 1
  end

  # Filter to existing paths and exclude the current worktree (can't remove
  # what you're standing in).
  set -l here (git rev-parse --show-toplevel 2>/dev/null)
  set -l candidates
  for p in $paths
    test -d $p; or continue
    test "$p" = "$here"; and continue
    set -a candidates $p
  end

  if test (count $candidates) -eq 0
    echo "wtrm: no removable worktrees"
    return 1
  end

  set -l choice (printf '%s\n' $candidates | fzf --height 40% --reverse --select-1 --query="$argv" --prompt='remove worktree> ')
  test -n "$choice"; or return

  git worktree remove $choice
end
