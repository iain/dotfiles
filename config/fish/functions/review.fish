function review --description 'Review a GitHub PR with tuicr in its own herdr worktree'
  set -l pr $argv[1]
  if test -z "$pr"
    set pr (gh pr list --json number,title,author \
      --template '{{range .}}{{.number}}{{"\t"}}{{.title}} ({{.author.login}}){{"\n"}}{{end}}' \
      | fzf --height 40% --reverse --delimiter \t --with-nth 1,2 \
      | cut -f1)
    test -n "$pr"; or return
  end

  # Outside herdr there is no workspace to open, so review in place.
  if test "$HERDR_ENV" != 1
    tuicr pr $pr
    return
  end

  # A second review of the same PR goes back to its workspace as it was left.
  set -l reviewed_before 0
  if git rev-parse --verify --quiet refs/heads/pr-$pr >/dev/null
    set reviewed_before 1
  end

  set -l repo_root (path dirname (git rev-parse --path-format=absolute --git-common-dir))
  set -l path (worktree pr $pr | tail -n 1); or return 1
  set -l pane (herdr worktree open --cwd $repo_root --path $path --focus | jq -er .result.root_pane.pane_id)
  or return 1

  if test $reviewed_before -eq 0
    herdr pane run $pane "tuicr pr $pr"
  end
end
