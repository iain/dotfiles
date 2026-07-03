# Dotfiles

Config files for macOS. Provisioned declaratively with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html) — one config (`config/mise/config.toml`) describes the packages, dotfile symlinks, login shell, macOS defaults, and tools for the whole machine.

## New Laptop Setup

### 1. Install mise

```bash
curl https://mise.run | sh      # or: brew install mise
```

Everything else — including Homebrew itself — is installed by the bootstrap.

### 2. Clone This Repo

Clone it anywhere; nothing hardcodes a path (dotfile sources resolve relative to the config file):

```bash
git clone <repo-url> dotfiles
cd dotfiles
```

### 3. Bootstrap

Run bootstrap **from the repo** so the relative dotfile sources resolve correctly:

```bash
export MISE_GLOBAL_CONFIG_FILE="$PWD/config/mise/config.toml"
mise trust "$MISE_GLOBAL_CONFIG_FILE"
mise bootstrap -n      # preview — changes nothing
mise bootstrap         # apply
```

In order, this:

1. Installs Homebrew if missing, then the **`[bootstrap.packages]`** (formulae + casks/fonts).
2. Symlinks **dotfiles** (`config/*` → `~/.config/*`, `rc/*` → `~/.<name>`, `claude/*` → `~/.claude/*`, `bin/*` → `~/.local/bin/*`). `symlink-each` links each file individually, so machine-local files like `~/.config/git/config.local` are left untouched.
3. Sets **fish** as the login shell.
4. Writes **macOS defaults**.
5. Installs the pinned **tools** (`ruby`, `node`, …).
6. Runs the **`bootstrap` task** — per-machine setup that isn't declarative (git identity, vim dirs, Claude plugins), then a read-only commit-signing diagnostic.

Check for drift any time with `mise bootstrap status`. Re-running is safe: anything already in its desired state is skipped.

> Run bootstrap from the cloned repo, not against the deployed `~/.config/mise` symlink — relative sources resolve against the config file's real location.

### 4. Git Identity

The bootstrap task seeds `~/.config/git/config.local` interactively. If it couldn't prompt (no TTY during bootstrap), run it directly:

```bash
mise run setup-identity      # or: dotfiles-setup identity
```

### 5. Set Up an SSH Key for GitHub (Auth + Signing)

If you ran `gh auth login` and let it generate an SSH key, the key already exists at `~/.ssh/id_ed25519` and is registered with GitHub as an **authentication** key. Otherwise generate one manually:

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

GitHub treats authentication and signing keys separately, so the same public key needs to be uploaded a second time as a signing key. The `gh` CLI can do this once given the extra scope:

```bash
gh auth refresh -h github.com -s admin:ssh_signing_key
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(hostname -s)"
```

Then add the public key to `config/git/allowed_signers` so local verification works (`git log --show-signature`), and commit the change:

```bash
echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" >> config/git/allowed_signers
```

`mise run check-signing` re-runs the diagnostic and prints the exact fix for anything still missing. Confirm everything is wired up with an empty signed commit:

```bash
git commit --allow-empty -m "test signing" && git log --show-signature -1
```

### 6. Install Vim Plugins

Open vim and run:

```
:PlugInstall
```

## Structure

```
config/
  fish/config.fish    — shell: PATH, aliases, abbreviations
  git/                — git config, global ignore, diff attributes, allowed signers
  ghostty/config      — terminal appearance and keybinds
  mise/config.toml    — tools + the mise bootstrap config (packages, dotfiles, macOS defaults)
  starship.toml       — prompt theme (single-line, Nerd Font icons)
  vim/                — modular vim config (auto-sourced via glob)
rc/
  vimrc               — vim entry point (sources files from config/vim/)
bin/
  dotfiles-setup      — per-machine setup driven by mise tasks (identity, vim dirs, Claude, signing)
claude/
  settings.json       — enabled plugins + marketplaces, hooks, permissions
```

## Managing Dotfiles

Bootstrap is declarative and idempotent, so day-to-day changes are just edits to `config/mise/config.toml` and the files under `config/`, `rc/`, etc. Useful commands:

```bash
mise bootstrap status          # what's drifted from the declared state
mise dotfiles apply -n         # preview dotfile symlink changes
mise run setup-identity        # (re)seed git identity / ssh / fish-local
mise run check-signing         # audit the commit-signing chain
```
