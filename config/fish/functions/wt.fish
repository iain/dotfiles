function wt --description 'Switch to a git worktree via fzf'
  if not command -q fzf
    echo "wt: fzf is not installed" >&2
    return 1
  end

  # Parse porcelain into just the checkout paths, skipping bare entries.
  set -l paths (git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { path = substr($0, 10); bare = 0; next }
    /^bare$/     { bare = 1 }
    /^$/         { if (path && !bare) print path; path = ""; bare = 0 }
    END          { if (path && !bare) print path }
  ')
  or begin
    echo "wt: not inside a git repository" >&2
    return 1
  end

  # Git's registry can hold stale entries (e.g. after `rm -rf <worktree>`);
  # only offer paths that still exist. `git worktree prune` clears those.
  set -l live
  for p in $paths
    test -d $p; and set -a live $p
  end
  set paths $live

  set -l choice (printf '%s\n' $paths | fzf --height 40% --reverse --select-1 --query="$argv")
  test -n "$choice"; or return
  builtin cd $choice
end
