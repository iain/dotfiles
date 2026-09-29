load test_helper

setup() {
	setup_repos
	HOOKS=$BATS_TEST_DIRNAME/../claude/hooks
}

@test "the WorktreeCreate hook prints the new worktree's path last" {
	run bash "$HOOKS/worktree-create.sh" <<<"{\"name\": \"fix+login\", \"cwd\": \"$REPO\"}"

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/fix-login" ]
	[ "$(git -C "${lines[-1]}" branch --show-current)" = "fix/login" ]
}
