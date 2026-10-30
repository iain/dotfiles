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

# For `signing`: gh reports being logged out, so GitHub isn't consulted.
stub_logged_out_gh() {
	printf '#!/bin/sh\nexit 1\n' >"$BATS_TEST_TMPDIR/stubs/gh"
	chmod +x "$BATS_TEST_TMPDIR/stubs/gh"
}

@test "signing fails and prints the fix when the key isn't allowed" {
	stub_logged_out_gh
	touch "$HOME/.config/git/config.local"

	run -1 "$REPO/bin/dotfiles-setup" signing

	[[ "$output" == *"iain@iain.nl ssh-ed25519 AAAAnew"* ]]
}

@test "signing passes when the chain is complete" {
	stub_logged_out_gh
	touch "$HOME/.config/git/config.local"
	echo 'iain@iain.nl ssh-ed25519 AAAAnew' >>"$REPO/config/git/allowed_signers"

	run -0 "$REPO/bin/dotfiles-setup" signing

	[[ "$output" == *"signing OK"* ]]
}

# For `upgrade`: claude, vim, brew and softwareupdate become stubs that log
# their calls to $CALLS, and nothing else but ruby and the system's own
# programs is on PATH, so no real update ever runs.
stub_upgrade_tools() {
	# The stubs log the Claude profile; the one running the tests isn't theirs.
	unset CLAUDE_CONFIG_DIR
	export CALLS=$BATS_TEST_TMPDIR/calls
	touch "$CALLS"
	mkdir -p "$REPO/claude"
	echo '{"enabledPlugins": {"one@market": true, "off@market": false}}' >"$REPO/claude/settings.json"
	for tool in claude vim brew softwareupdate; do
		printf '#!/bin/sh\necho "${CLAUDE_CONFIG_DIR:-default} %s $*" >>"$CALLS"\n' "$tool" >"$BATS_TEST_TMPDIR/stubs/$tool"
		chmod +x "$BATS_TEST_TMPDIR/stubs/$tool"
	done
	PATH=$BATS_TEST_TMPDIR/stubs:$(dirname "$(command -v ruby)"):/usr/bin:/bin
}

# Like the real herdr, adds its hook with an absolute path unless that exact
# hook is already there, writing through the symlink.
stub_herdr_integration() {
	mkdir -p "$HOME/.claude"
	ln -s "$REPO/claude/settings.json" "$HOME/.claude/settings.json"
	cat >"$BATS_TEST_TMPDIR/stubs/herdr" <<'STUB'
#!/bin/sh
settings=$HOME/.claude/settings.json
hook="bash '$HOME/.claude/hooks/herdr-agent-state.sh' session"
if [ "$1" = integration ] && ! grep -qF "$hook" "$settings"; then
	updated=$(sed "s|\"hooks\": \[|\"hooks\": [\"$hook\", |" "$settings")
	echo "$updated" >"$settings"
fi
STUB
	chmod +x "$BATS_TEST_TMPDIR/stubs/herdr"
}

@test "claude keeps herdr's hook in settings.json free of the home path" {
	stub_upgrade_tools
	stub_herdr_integration
	echo '{"hooks": ["bash ~/.claude/hooks/herdr-agent-state.sh session"]}' >"$REPO/claude/settings.json"

	run -0 "$REPO/bin/dotfiles-setup" claude

	[ "$(cat "$REPO/claude/settings.json")" = '{"hooks": ["bash ~/.claude/hooks/herdr-agent-state.sh session"]}' ]
}

@test "claude makes a freshly installed herdr hook free of the home path" {
	stub_upgrade_tools
	stub_herdr_integration
	echo '{"hooks": []}' >"$REPO/claude/settings.json"

	run -0 "$REPO/bin/dotfiles-setup" claude

	grep -qF '"bash ~/.claude/hooks/herdr-agent-state.sh session"' "$REPO/claude/settings.json"
	! grep -qF "$HOME" "$REPO/claude/settings.json"
}

@test "upgrade updates the marketplaces and enabled plugins of each Claude profile" {
	stub_upgrade_tools

	run -0 "$REPO/bin/dotfiles-setup" upgrade

	grep -qx 'default claude plugin marketplace update' "$CALLS"
	grep -qx 'default claude plugin update one@market' "$CALLS"
	grep -qx "$HOME/.claude-private claude plugin marketplace update" "$CALLS"
	grep -qx "$HOME/.claude-private claude plugin update one@market" "$CALLS"
	! grep -q 'off@market' "$CALLS"
}

@test "upgrade updates vim-plug and the vim plugins" {
	stub_upgrade_tools

	run -0 "$REPO/bin/dotfiles-setup" upgrade

	grep -qx "default vim -N -u $HOME/.vimrc -es +PlugUpgrade +PlugUpdate --sync +qa" "$CALLS"
}

@test "upgrade relinks formulae that a failed upgrade left unlinked" {
	stub_upgrade_tools
	cat >"$BATS_TEST_TMPDIR/stubs/brew" <<'STUB'
#!/bin/sh
echo "brew $*" >>"$CALLS"
if [ "$1" = info ]; then
	echo '{"formulae": [
		{"name": "gh", "keg_only": false, "linked_keg": null},
		{"name": "libpq", "keg_only": true, "linked_keg": null},
		{"name": "git", "keg_only": false, "linked_keg": "2.56.0"}
	]}'
fi
STUB

	run -0 "$REPO/bin/dotfiles-setup" upgrade

	grep -qx 'brew link gh' "$CALLS"
	! grep -q 'brew link libpq\|brew link git' "$CALLS"
}

@test "upgrade lists pending macOS updates without installing them" {
	stub_upgrade_tools

	run -0 "$REPO/bin/dotfiles-setup" upgrade

	grep -qx 'default softwareupdate --list' "$CALLS"
	! grep -q 'softwareupdate --install' "$CALLS"
}

@test "upgrade --dry-run says what it would change, and changes nothing" {
	stub_upgrade_tools
	cat >"$BATS_TEST_TMPDIR/stubs/brew" <<'STUB'
#!/bin/sh
echo "brew $*" >>"$CALLS"
[ "$1" = info ] && echo '{"formulae": [{"name": "gh", "keg_only": false, "linked_keg": null}]}'
true
STUB

	run -0 "$REPO/bin/dotfiles-setup" upgrade --dry-run

	[[ "$output" == *"would run: claude plugin update one@market"* ]]
	[[ "$output" == *"would run: brew link gh"* ]]
	! grep -q 'claude\|vim\|brew link' "$CALLS"
}
