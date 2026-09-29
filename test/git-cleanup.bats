load test_helper

setup() {
	setup_repos
	stub_gh
	open_pull_request 7
	cd "$REPO"
	worktree pr 7
}

@test "removes a review worktree once its pull request is merged" {
	pull_request_state 7 MERGED

	run git-cleanup

	[ "$status" -eq 0 ]
	[ ! -d "$HOME/Code/worktrees/app/pr-7" ]
	run git rev-parse --verify --quiet refs/heads/pr-7
	[ "$status" -ne 0 ]
}

@test "keeps a review worktree while its pull request is open" {
	pull_request_state 7 OPEN

	git-cleanup

	[ -d "$HOME/Code/worktrees/app/pr-7" ]
}

@test "keeps a closed review that has commits of its own" {
	pull_request_state 7 CLOSED
	git -C "$HOME/Code/worktrees/app/pr-7" commit --quiet --allow-empty -m "mine"

	run git-cleanup

	[ -d "$HOME/Code/worktrees/app/pr-7" ]
	[[ "$output" == *"pr-7: has commits pull request #7 doesn't, keeping"* ]]
}
