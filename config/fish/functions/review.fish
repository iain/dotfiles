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

  set -l common (git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  or begin
    echo "review: not inside a git repository" >&2
    return 1
  end
  set -l repo_root (path dirname $common)
  set -l branch pr-$pr

  # A second review of the same PR goes back to its existing workspace.
  if herdr worktree open --cwd $repo_root --branch $branch --focus >/dev/null 2>&1
    return
  end

  # Branching from the fetched commit rather than a ref leaves the branch
  # without an upstream, so nothing can be pushed to the author's PR by accident.
  git -C $repo_root fetch --quiet origin pull/$pr/head; or return 1
  set -l head (git -C $repo_root rev-parse FETCH_HEAD)

  set -l pane (herdr worktree create --cwd $repo_root --branch $branch --base $head \
    --label "PR $pr" --focus | jq -er .result.root_pane.pane_id)
  or return 1

  herdr pane run $pane "tuicr pr $pr"
end
