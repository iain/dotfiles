function wtpr --description 'Create a worktree from a GitHub PR number'
  if test (count $argv) -eq 0
    echo "usage: wtpr <pr-number>" >&2
    return 1
  end

  set -l pr $argv[1]
  set -l branch pr-$pr

  # `+` forces the local branch to follow the PR head even after a force-push.
  git fetch origin "+pull/$pr/head:$branch"; or return 1

  wta $branch
end
