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

@test "new branches from the just-fetched default branch, without an upstream" {
	newest=$(advance_origin_main)
	cd "$REPO"

	run worktree new feature/thing

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/feature-thing" ]
	cd "$HOME/Code/worktrees/app/feature-thing"
	[ "$(git branch --show-current)" = "feature/thing" ]
	[ "$(git rev-parse HEAD)" = "$newest" ]
	run git rev-parse --abbrev-ref '@{u}'
	[ "$status" -ne 0 ]
}

@test "new checks out a branch that already exists" {
	cd "$REPO"
	git branch existing
	git -C "$REPO" commit --quiet --allow-empty -m "only on main"

	run worktree new existing

	[ "$status" -eq 0 ]
	[ "$(git -C "${lines[-1]}" rev-parse HEAD)" = "$(git rev-parse existing)" ]
}

# The directory name ends up in pitchfork's proxy URLs, where a ticket number
# and a long title don't belong.
@test "new names the worktree's directory after the given name instead of the branch" {
	cd "$REPO"

	run worktree new iain/NFKO-123-redesign-the-vraagbaak-page "Vraagbaak redesign"

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/vraagbaak-redesign" ]
	[ "$(git -C "${lines[-1]}" branch --show-current)" = "iain/NFKO-123-redesign-the-vraagbaak-page" ]
}

@test "new again returns the existing worktree" {
	cd "$REPO"
	worktree new feature

	run worktree new feature

	[ "$status" -eq 0 ]
	[ "${lines[-1]}" = "$HOME/Code/worktrees/app/feature" ]
}

@test "--focus switches herdr to the worktree's workspace" {
	stub_herdr
	cd "$REPO"

	worktree new --focus feature

	grep -qxF "worktree open --cwd $REPO --path $HOME/Code/worktrees/app/feature --focus" "$HERDR_LOG"
}

@test "rm removes a worktree and its branch when the branch has nothing of its own" {
	cd "$REPO"
	path=$(worktree new feature | tail -n 1)

	run worktree rm "$path"

	[ "$status" -eq 0 ]
	[ ! -d "$path" ]
	run git rev-parse --verify --quiet refs/heads/feature
	[ "$status" -ne 0 ]
}

@test "rm deletes a review branch that has nothing beyond its pull request" {
	open_pull_request 7
	cd "$REPO"
	path=$(worktree pr 7 | tail -n 1)

	worktree rm "$path"

	run git rev-parse --verify --quiet refs/heads/pr-7
	[ "$status" -ne 0 ]
}

@test "rm keeps a branch with commits of its own" {
	cd "$REPO"
	path=$(worktree new feature | tail -n 1)
	git -C "$path" commit --quiet --allow-empty -m "mine"

	worktree rm "$path"

	[ ! -d "$path" ]
	git rev-parse --verify --quiet refs/heads/feature
}

@test "rm closes the worktree's herdr workspace along with it" {
	cd "$REPO"
	path=$(worktree new feature | tail -n 1)
	stub_herdr
	herdr_replies "worktree list" <<<"{\"result\": {\"worktrees\": [{\"path\": \"$path\", \"open_workspace_id\": \"w9\"}]}}"

	# The stub leaves the checkout in place, so deleting the branch fails after.
	run worktree rm "$path"

	grep -qxF "worktree remove --workspace w9" "$HERDR_LOG"
}

@test "herdr-sync opens worktrees without a workspace and closes those whose checkout is gone" {
	cd "$REPO"
	stub_herdr
	herdr_replies "worktree list" <<EOF_JSON
{"result": {"worktrees": [
	{"path": "$REPO", "is_bare": false, "is_prunable": false, "open_workspace_id": "w1"},
	{"path": "/wt/closed", "is_bare": false, "is_prunable": false, "open_workspace_id": null},
	{"path": "/wt/open", "is_bare": false, "is_prunable": false, "open_workspace_id": "w2"},
	{"path": "/wt/gone", "is_bare": false, "is_prunable": true, "open_workspace_id": "w3"}
]}}
EOF_JSON

	run worktree herdr-sync

	[ "$status" -eq 0 ]
	grep -qxF "worktree open --cwd $REPO --path /wt/closed --no-focus" "$HERDR_LOG"
	grep -qxF "workspace close w3" "$HERDR_LOG"
	[ "$(grep -c "^worktree open\|^workspace close" "$HERDR_LOG")" -eq 2 ]
}
