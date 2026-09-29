function wtpr --description 'Create a worktree from a GitHub PR number and go to it'
  if test (count $argv) -eq 0
    echo "usage: wtpr <pr-number>" >&2
    return 1
  end

  _wt_go pr $argv[1]
end
