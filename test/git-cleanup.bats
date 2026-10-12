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

@test "deletes a branch whose merged pull request got commits pushed from GitHub" {
	git switch --quiet -c feature
	git commit --quiet --allow-empty -m "work"
	git push --quiet origin feature:refs/pull/8/head
	head=$(push_to_pull_request 8)
	push_and_delete_on_origin feature
	merged_pull_request 8 feature "$head"
	git switch --quiet main

	git-cleanup

	run git rev-parse --verify --quiet refs/heads/feature
	[ "$status" -ne 0 ]
}

@test "keeps a branch with commits after its pull request was merged" {
	git switch --quiet -c feature
	git commit --quiet --allow-empty -m "work"
	git push --quiet origin feature:refs/pull/8/head
	head=$(push_to_pull_request 8)
	push_and_delete_on_origin feature
	merged_pull_request 8 feature "$head"
	git commit --quiet --allow-empty -m "after the merge"
	git switch --quiet main

	run git-cleanup

	git rev-parse --verify --quiet refs/heads/feature
	[[ "$output" == *"feature: has commits after its pull request was merged, keeping"* ]]
}

@test "deletes a branch whose pull request someone else opened and got merged" {
	git switch --quiet -c renovate/tools
	git commit --quiet --allow-empty -m "update tools"
	push_and_delete_on_origin renovate/tools
	merged_pull_request 9 renovate/tools "$(git rev-parse HEAD)" renovate
	git switch --quiet main

	git-cleanup

	run git rev-parse --verify --quiet refs/heads/renovate/tools
	[ "$status" -ne 0 ]
}
