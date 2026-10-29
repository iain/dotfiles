#!/usr/bin/env bats
# dotfiles-setup finds the repo through its own path, so each test runs a copy
# inside a throwaway repo, and the real allowed_signers stays untouched.

setup() {
	bats_require_minimum_version 1.5.0
	export HOME=$BATS_TEST_TMPDIR/home
	REPO=$BATS_TEST_TMPDIR/repo
	mkdir -p "$HOME/.ssh" "$HOME/.config/git" "$REPO/bin" "$REPO/config/git" "$BATS_TEST_TMPDIR/stubs"
	cp "$BATS_TEST_DIRNAME/../bin/dotfiles-setup" "$REPO/bin/"
	printf '# m1\niain@iain.nl ssh-ed25519 AAAAold\n' >"$REPO/config/git/allowed_signers"

	echo 'ssh-ed25519 AAAAnew iain@m3' >"$HOME/.ssh/id_ed25519.pub"
	export GIT_CONFIG_NOSYSTEM=1
	export GIT_CONFIG_GLOBAL=$HOME/.config/git/config
	git config --global user.email iain@iain.nl
	git config --global user.signingKey '~/.ssh/id_ed25519.pub'

	cat >"$BATS_TEST_TMPDIR/stubs/scutil" <<<'#!/bin/sh
echo m3'
	chmod +x "$BATS_TEST_TMPDIR/stubs/scutil"
	PATH=$BATS_TEST_TMPDIR/stubs:$PATH
}

@test "allows this machine's signing key" {
	run -0 "$REPO/bin/dotfiles-setup" identity </dev/null

	[ "$(tail -2 "$REPO/config/git/allowed_signers")" = "# m3
iain@iain.nl ssh-ed25519 AAAAnew" ]
}

@test "doesn't allow a signing key twice" {
	"$REPO/bin/dotfiles-setup" identity </dev/null

	run -0 "$REPO/bin/dotfiles-setup" identity </dev/null

	[ "$(grep -c AAAAnew "$REPO/config/git/allowed_signers")" -eq 1 ]
}

@test "leaves allowed_signers alone without a signing key" {
	rm "$HOME/.ssh/id_ed25519.pub"

	run -0 "$REPO/bin/dotfiles-setup" identity </dev/null

	[ "$(cat "$REPO/config/git/allowed_signers")" = "# m1
iain@iain.nl ssh-ed25519 AAAAold" ]
}

@test "suggests the name and email of the GitHub account" {
	cat >"$BATS_TEST_TMPDIR/stubs/gh" <<<'#!/bin/sh
[ "$*" = "api user --jq .name" ] && echo "Iain Hecker"
[ "$*" = "api user --jq .email" ] && echo "iain@iain.nl"
true'
	chmod +x "$BATS_TEST_TMPDIR/stubs/gh"

	# script(1) gives the prompts a terminal; Enter takes each default.
	printf '\n\n\n' | script -q /dev/null "$REPO/bin/dotfiles-setup" identity

	grep -qx '  name = Iain Hecker' "$HOME/.config/git/config.local"
	grep -qx '  email = iain@iain.nl' "$HOME/.config/git/config.local"
}
