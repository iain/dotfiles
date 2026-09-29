function wta --description 'Create a worktree for a branch and go to it'
  if test (count $argv) -eq 0
    echo "usage: wta <branch>" >&2
    return 1
  end

  _wt_go new $argv[1]
end
