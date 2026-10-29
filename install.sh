#!/usr/bin/env bash
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/iain/dotfiles/main/install.sh)"
#
# Sets up a fresh Mac up to and including `mise bootstrap`, doing first what
# the bootstrap can't do for itself. Run it like Homebrew's installer, not
# through a pipe, so the prompts can read the terminal. Every step is skipped
# when already done, so it's safe to re-run after a failure.
set -euo pipefail

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}

# The status line, Claude's machine context and the signing key's title all
# use this name, and a new Mac comes with one like "Iains-MacBook-Pro".
name_machine() {
	local current name
	current=$(scutil --get LocalHostName)
	read -r -p "Machine name [$current]: " name || true
	if [ -n "$name" ] && [ "$name" != "$current" ]; then
		sudo scutil --set ComputerName "$name"
		sudo scutil --set HostName "$name"
		sudo scutil --set LocalHostName "$name"
	fi
}

install_homebrew() {
	# Interactive, unlike the bootstrap's hook: it asks for the password, and
	# installs the Command Line Tools, which bring git.
	if [ ! -x "$HOMEBREW_PREFIX/bin/brew" ]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

install_gh() {
	if [ ! -x "$HOMEBREW_PREFIX/bin/gh" ]; then
		"$HOMEBREW_PREFIX/bin/brew" install gh
	fi
}

# Over SSH, so gh offers to generate and upload a key: the bootstrap clones
# spectral over SSH. The extra scope lets add_signing_key upload it again.
log_in_to_github() {
	if ! gh auth status --hostname github.com >/dev/null 2>&1; then
		gh auth login --hostname github.com --git-protocol ssh --web --scopes admin:ssh_signing_key
	elif ! gh auth status --hostname github.com 2>&1 | grep -q admin:ssh_signing_key; then
		gh auth refresh --hostname github.com --scopes admin:ssh_signing_key
	fi
}

# GitHub keeps authentication and signing keys apart, so the key gh uploaded
# for SSH has to be added a second time before commits show as verified.
add_signing_key() {
	local public_key=$HOME/.ssh/id_ed25519.pub key
	if [ -f "$public_key" ]; then
		key=$(cut -d' ' -f1,2 "$public_key")
		if ! gh ssh-key list | awk -F'\t' -v key="$key" '$2 == key && $5 == "signing" { found = 1 } END { exit !found }'; then
			gh ssh-key add "$public_key" --type signing --title "$(scutil --get LocalHostName)"
		fi
	fi
}

# From mise.run, not Homebrew: a brewed mise can't `mise self-update`.
install_mise() {
	if [ ! -x "$HOME/.local/bin/mise" ]; then
		curl -fsSL https://mise.run | sh
	fi
}

# A re-run after a failure finds the checkout the first run cloned, which may
# hold fixes for what failed, so it bootstraps from that.
bootstrap() {
	local mise=$HOME/.local/bin/mise checkout=$HOME/Code/dotfiles
	if [ -d "$checkout" ]; then
		"$mise" trust "$checkout/mise.toml"
		"$mise" -C "$checkout" bootstrap
	else
		"$mise" bootstrap --from https://github.com/iain/dotfiles --from-dir "$checkout"
	fi
}

PATH=$HOMEBREW_PREFIX/bin:$PATH

name_machine
install_homebrew
install_gh
log_in_to_github
add_signing_key
install_mise
bootstrap
