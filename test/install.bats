#!/usr/bin/env bats
# install.sh runs on a fresh Mac before anything else. Every program it
# drives is a stub that logs its calls to $CALLS; Homebrew lives under a
# throwaway $HOMEBREW_PREFIX.

setup() {
	bats_require_minimum_version 1.5.0
	export HOME=$BATS_TEST_TMPDIR/home
	export HOMEBREW_PREFIX=$BATS_TEST_TMPDIR/homebrew
	export CALLS=$BATS_TEST_TMPDIR/calls
	mkdir -p "$HOME" "$HOMEBREW_PREFIX/bin" "$BATS_TEST_TMPDIR/stubs"
	touch "$CALLS"
	# Only stubs and the system's own programs: a real gh or mise must never
	# run. The script itself gets the Mac's /bin/bash, as on a fresh Mac.
	PATH=$BATS_TEST_TMPDIR/stubs:/usr/bin:/bin
	INSTALL=$BATS_TEST_DIRNAME/../install.sh

	# A brew whose installs leave a logging stub behind. Homebrew's installer
	# copies it into place.
	mkdir -p "$BATS_TEST_TMPDIR/homebrew-installer"
	stub_at "$BATS_TEST_TMPDIR/homebrew-installer" brew <<STUB
if [ "\$1" = install ]; then
	$(declare -f stub_at)
	stub_at "$HOMEBREW_PREFIX/bin" "\$2" </dev/null
fi
STUB

	stub scutil <<<'[ "$1" = --get ] && echo Iains-MacBook-Pro'
	stub sudo </dev/null

	mkdir -p "$BATS_TEST_TMPDIR/mise-installer"
	stub_at "$BATS_TEST_TMPDIR/mise-installer" mise </dev/null

	# The installers that curl fetches report themselves, and leave their
	# program behind.
	stub curl <<'STUB'
url=${!#}
echo "echo 'ran $url' >>'$CALLS'"
if [ "$url" = https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh ]; then
	echo "cp '$BATS_TEST_TMPDIR/homebrew-installer/brew' '$HOMEBREW_PREFIX/bin/brew'"
elif [ "$url" = https://mise.run ]; then
	echo "mkdir -p '$HOME/.local/bin' && cp '$BATS_TEST_TMPDIR/mise-installer/mise' '$HOME/.local/bin/mise'"
fi
STUB
}

# Usage: stub <name> <<<'body'   — a program on PATH that logs its call, then
# runs body (if any) with the call's arguments.
stub() {
	stub_at "$BATS_TEST_TMPDIR/stubs" "$@"
}

stub_at() {
	local body=""
	[ -t 0 ] || body=$(cat)
	cat >"$1/$2" <<STUB
#!/usr/bin/env bash
echo "$2 \$*" >>"\$CALLS"
$body
STUB
	chmod +x "$1/$2"
}

@test "installs Homebrew when it's missing" {
	run -0 "$INSTALL" </dev/null

	grep -qx 'ran https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh' "$CALLS"
}

@test "leaves an existing Homebrew alone" {
	cp "$BATS_TEST_TMPDIR/homebrew-installer/brew" "$HOMEBREW_PREFIX/bin/brew"

	run -0 "$INSTALL" </dev/null

	! grep -q 'Homebrew/install' "$CALLS"
}

@test "installs gh with Homebrew" {
	run -0 "$INSTALL" </dev/null

	grep -qx 'brew install gh' "$CALLS"
}

@test "logs in to GitHub over SSH, with the scope to add signing keys" {
	cp "$BATS_TEST_TMPDIR/homebrew-installer/brew" "$HOMEBREW_PREFIX/bin/brew"
	stub_at "$HOMEBREW_PREFIX/bin" gh <<<'[ "$1 $2" != "auth status" ]'

	run -0 "$INSTALL" </dev/null

	grep -qx 'gh auth login --hostname github.com --git-protocol ssh --web --scopes admin:ssh_signing_key' "$CALLS"
}

@test "names the machine as asked" {
	run -0 "$INSTALL" <<<'m3'

	grep -qx 'sudo scutil --set ComputerName m3' "$CALLS"
	grep -qx 'sudo scutil --set HostName m3' "$CALLS"
	grep -qx 'sudo scutil --set LocalHostName m3' "$CALLS"
}

@test "keeps the machine's name on Enter" {
	run -0 "$INSTALL" <<<''

	! grep -q 'scutil --set' "$CALLS"
}

@test "adds the SSH key to GitHub as a signing key" {
	cp "$BATS_TEST_TMPDIR/homebrew-installer/brew" "$HOMEBREW_PREFIX/bin/brew"
	mkdir -p "$HOME/.ssh"
	echo 'ssh-ed25519 AAAAkey iain@m3' >"$HOME/.ssh/id_ed25519.pub"
	stub_at "$HOMEBREW_PREFIX/bin" gh <<<'[ "$1 $2" = "ssh-key list" ] && printf "m3\tssh-ed25519 AAAAkey\t2026-10-29\t1\tauthentication\n"; true'

	run -0 "$INSTALL" </dev/null

	grep -qx "gh ssh-key add $HOME/.ssh/id_ed25519.pub --type signing --title Iains-MacBook-Pro" "$CALLS"
}

@test "doesn't add a signing key twice" {
	cp "$BATS_TEST_TMPDIR/homebrew-installer/brew" "$HOMEBREW_PREFIX/bin/brew"
	mkdir -p "$HOME/.ssh"
	echo 'ssh-ed25519 AAAAkey iain@m3' >"$HOME/.ssh/id_ed25519.pub"
	stub_at "$HOMEBREW_PREFIX/bin" gh <<<'[ "$1 $2" = "ssh-key list" ] && printf "m3\tssh-ed25519 AAAAkey\t2026-10-29\t1\tauthentication\nm3\tssh-ed25519 AAAAkey\t2026-10-29\t2\tsigning\n"; true'

	run -0 "$INSTALL" </dev/null

	! grep -q 'gh ssh-key add' "$CALLS"
}

@test "asks for the signing key scope when already logged in without it" {
	cp "$BATS_TEST_TMPDIR/homebrew-installer/brew" "$HOMEBREW_PREFIX/bin/brew"
	stub_at "$HOMEBREW_PREFIX/bin" gh <<<'[ "$1 $2" = "auth status" ] && echo "  - Token scopes: '\''gist'\'', '\''repo'\''"; true'

	run -0 "$INSTALL" </dev/null

	grep -qx 'gh auth refresh --hostname github.com --scopes admin:ssh_signing_key' "$CALLS"
}

@test "installs mise" {
	run -0 "$INSTALL" </dev/null

	grep -qx 'ran https://mise.run' "$CALLS"
}

@test "bootstraps from GitHub into ~/Code/dotfiles" {
	run -0 "$INSTALL" </dev/null

	grep -qx "mise bootstrap --from https://github.com/iain/dotfiles --from-dir $HOME/Code/dotfiles" "$CALLS"
}

@test "bootstraps from the checkout when it's already there" {
	mkdir -p "$HOME/Code/dotfiles"

	run -0 "$INSTALL" </dev/null

	grep -qx "mise trust $HOME/Code/dotfiles/mise.toml" "$CALLS"
	grep -qx "mise -C $HOME/Code/dotfiles bootstrap" "$CALLS"
	! grep -q 'mise bootstrap --from' "$CALLS"
}
