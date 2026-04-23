function wta --description 'Add a git worktree as a sibling of the current one and cd into it'
  if test (count $argv) -eq 0
    echo "usage: wta <branch> [path]" >&2
    return 1
  end

  set -l common (git rev-parse --git-common-dir 2>/dev/null)
  or begin
    echo "wta: not inside a git repository" >&2
    return 1
  end

  # Project root — where sibling worktrees live. Bare layout: parent of
  # `.bare`. Standard layout: parent of the main repo (one level above `.git`).
  set -l root
  if test (git config --get core.bare 2>/dev/null) = "true"
    set root (path resolve $common/..)
  else
    set root (path resolve $common/../..)
  end

  set -l branch $argv[1]
  set -l path
  if test (count $argv) -ge 2
    set path $argv[2]
  else
    set path $root/(string replace -a / - -- $branch)
  end

  # Fetch first so that a branch only on the remote can be picked up via
  # git's DWIM (creates a tracking branch). Silent failure is fine — offline
  # or misconfigured remotes shouldn't block worktree creation against
  # existing refs.
  git fetch --quiet 2>/dev/null

  # Let git handle existing-local and DWIM-remote cases; fall back to -b for
  # a genuinely new branch.
  if not git worktree add $path $branch 2>/dev/null
    git worktree add -b $branch $path; or return 1
  end

  builtin cd $path
end
