function _wt_go --description 'Run a worktree subcommand and go to the worktree it prints'
  # Inside herdr the worktree has its own workspace, so go there instead of
  # moving this shell.
  if test "$HERDR_ENV" = 1
    worktree $argv[1] --focus $argv[2..] >/dev/null
    return
  end

  set -l path (worktree $argv | tail -n 1); or return 1
  builtin cd $path
end
