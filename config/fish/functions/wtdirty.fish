function wtdirty --description 'List worktrees with uncommitted changes'
  set -l paths (git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { path = substr($0, 10); bare = 0; next }
    /^bare$/     { bare = 1 }
    /^$/         { if (path && !bare) print path; path = ""; bare = 0 }
    END          { if (path && !bare) print path }
  ')
  or begin
    echo "wtdirty: not inside a git repository" >&2
    return 1
  end

  set -l any 0
  for p in $paths
    test -d $p; or continue
    set -l out (git -C $p status --porcelain)
    if test -n "$out"
      echo $p
      set any 1
    end
  end

  test $any -eq 0; and echo "All worktrees clean."
end
