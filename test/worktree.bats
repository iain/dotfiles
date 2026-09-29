load test_helper

setup() {
	setup_repos
}

@test "pr checks out a pull request's head in the shared worktree layout" {
	head=$(open_pull_request 7)

	cd "$REPO"
	run worktree pr 7

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/pr-7" ]
	[ "$(git -C "$HOME/Code/worktrees/app/pr-7" rev-parse HEAD)" = "$head" ]
	[ "$(git -C "$HOME/Code/worktrees/app/pr-7" branch --show-current)" = "pr-7" ]
}

# gh finds a branch's pull request through a refs/pull upstream, and nothing
# pushed from a review would be wanted on origin.
@test "pr tracks the pull request's ref and refuses to push" {
	open_pull_request 7
	cd "$REPO"
	worktree pr 7

	cd "$HOME/Code/worktrees/app/pr-7"
	[ "$(git config branch.pr-7.merge)" = "refs/pull/7/head" ]
	[ "$(git config branch.pr-7.remote)" = "origin" ]
	git config --global push.default current
	run git push
	[ "$status" -ne 0 ]
	run git ls-remote --heads "$ORIGIN" pr-7
	[ -z "$output" ]
}

@test "pr again returns the existing worktree" {
	open_pull_request 7
	cd "$REPO"
	worktree pr 7

	run worktree pr 7

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/pr-7" ]
}

@test "pr opens the worktree as a herdr workspace inside herdr" {
	open_pull_request 7
	stub_herdr
	cd "$REPO"

	worktree pr 7

	grep -qxF "worktree open --cwd $REPO --path $HOME/Code/worktrees/app/pr-7 --no-focus" "$HERDR_LOG"
}
