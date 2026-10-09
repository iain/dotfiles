load test_helper

setup() {
	setup_repos
	stub_herdr
	PATH=$BATS_TEST_DIRNAME/../claude/skills/spinoff:$PATH
	herdr_replies "worktree list" <<JSON
{"result": {"worktrees": [{"path": "$HOME/Code/worktrees/app/vraagbaak-redesign", "open_workspace_id": "w2"}]}}
JSON
	herdr_replies "pane list" <<<'{"result": {"panes": [{"pane_id": "w2:p1"}]}}'
}

@test "spinoff names the worktree and its agent after the given name, not the branch" {
	cd "$REPO"

	run spinoff iain/NFKO-123-redesign-the-vraagbaak-page vraagbaak-redesign <<<"the brief"

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/vraagbaak-redesign" ]
	[ "$(git -C "${lines[-1]}" branch --show-current)" = "iain/NFKO-123-redesign-the-vraagbaak-page" ]
	grep -q "^agent start vraagbaak-redesign --kind claude --pane w2:p1 " "$HERDR_LOG"
}
