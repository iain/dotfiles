# Each test gets its own HOME holding an "origin" bare repo and a clone of it
# at ~/Code/app, so worktrees land in ~/Code/worktrees/app like on a real
# machine. The user's git config stays out: it signs commits.

setup_repos() {
	# Physical, as git reports worktree paths with /var resolved to /private/var.
	mkdir -p "$BATS_TEST_TMPDIR/home/Code"
	export HOME=$(cd "$BATS_TEST_TMPDIR/home" && pwd -P)
	unset HERDR_ENV

	export GIT_CONFIG_NOSYSTEM=1
	export GIT_CONFIG_GLOBAL=$HOME/.gitconfig
	git config --global user.name Test
	git config --global user.email test@example.com
	git config --global init.defaultBranch main
	git config --global advice.detachedHead false

	ORIGIN=$BATS_TEST_TMPDIR/origin.git
	REPO=$HOME/Code/app
	git init --quiet --bare "$ORIGIN"
	git clone --quiet "$ORIGIN" "$REPO" 2>/dev/null
	git -C "$REPO" commit --quiet --allow-empty -m "first"
	git -C "$REPO" push --quiet origin main
	git -C "$REPO" remote set-head origin main

	PATH=$BATS_TEST_DIRNAME/../bin:$PATH
}

# Pushes a commit to refs/pull/<n>/head on origin, the way GitHub publishes a
# pull request's head, and prints that commit.
open_pull_request() {
	local number=$1 scratch=$BATS_TEST_TMPDIR/pr-$1
	git clone --quiet "$ORIGIN" "$scratch" 2>/dev/null
	git -C "$scratch" commit --quiet --allow-empty -m "pull request $number"
	git -C "$scratch" push --quiet origin "HEAD:refs/pull/$number/head"
	git -C "$scratch" rev-parse HEAD
}

# Puts a fake herdr on PATH that logs each call to $HERDR_LOG, and makes
# the scripts believe they run inside herdr. It answers "{}", or what
# herdr_replies set for the first two words of the call.
stub_herdr() {
	export HERDR_ENV=1
	export HERDR_LOG=$BATS_TEST_TMPDIR/herdr.log
	export HERDR_REPLIES=$BATS_TEST_TMPDIR/herdr-replies
	mkdir -p "$BATS_TEST_TMPDIR/stubs" "$HERDR_REPLIES"
	cat >"$BATS_TEST_TMPDIR/stubs/herdr" <<'STUB'
#!/usr/bin/env bash
echo "$*" >>"$HERDR_LOG"
if [ -f "$HERDR_REPLIES/$1 $2" ]; then
	cat "$HERDR_REPLIES/$1 $2"
else
	echo '{}'
fi
STUB
	chmod +x "$BATS_TEST_TMPDIR/stubs/herdr"
	PATH=$BATS_TEST_TMPDIR/stubs:$PATH
}

# Usage: herdr_replies "worktree list" <<<'{"result": ...}'
herdr_replies() {
	cat >"$HERDR_REPLIES/$1"
}

# Puts a fake gh on PATH. `gh pr view <n>` answers with the state set by
# pull_request_state; every other call prints nothing.
stub_gh() {
	mkdir -p "$BATS_TEST_TMPDIR/stubs" "$BATS_TEST_TMPDIR/pr-states"
	cat >"$BATS_TEST_TMPDIR/stubs/gh" <<STUB
#!/usr/bin/env bash
if [ "\$1 \$2" = "pr view" ]; then
	cat "$BATS_TEST_TMPDIR/pr-states/\$3"
fi
STUB
	chmod +x "$BATS_TEST_TMPDIR/stubs/gh"
	PATH=$BATS_TEST_TMPDIR/stubs:$PATH
}

pull_request_state() {
	echo "$2" >"$BATS_TEST_TMPDIR/pr-states/$1"
}

# Pushes a commit to origin's main that the clone hasn't fetched, and prints it.
advance_origin_main() {
	local scratch=$BATS_TEST_TMPDIR/advance
	git clone --quiet "$ORIGIN" "$scratch" 2>/dev/null
	git -C "$scratch" commit --quiet --allow-empty -m "newer on main"
	git -C "$scratch" push --quiet origin main
	git -C "$scratch" rev-parse HEAD
}
