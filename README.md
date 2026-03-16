# Dotfiles

Config files for macOS. Managed with symlinks via `install.rb`.

## New Laptop Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone This Repo

```bash
git clone <repo-url> ~/iain/dotfiles
cd ~/iain/dotfiles
```

### 3. Install Everything

```bash
ruby install.rb -n   # preview what will happen
ruby install.rb      # do it
```

This does three things in order:
1. **Symlinks** config files into place (`config/*` → `~/.config/*`, `rc/*` → `~/.<name>`, `claude/*` → `~/.claude/*`). Existing files are backed up with a `.backup` suffix.
2. **`brew bundle`** — installs packages from the `Brewfile` (auto-detected when the file exists).
3. **`macos.sh`** — applies macOS defaults (auto-detected on macOS).

Each step can be controlled with flags:

```bash
ruby install.rb --no-brew    # skip brew bundle
ruby install.rb --no-macos   # skip macOS defaults
```

### 5. Set Up Git Identity

Create `~/.config/git/config.local` with your per-machine identity (see `config/git/config.local.example`):

```ini
[user]
  email = you@example.com
  name = Your Name
  signingKey = ~/.ssh/id_ed25519.pub
```

### 6. Generate an SSH Key (for Git Signing)

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Add the public key to `config/git/allowed_signers` and to your GitHub account (both for authentication and signing).

### 7. Set Fish as Default Shell

```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### 8. Install Vim Plugins

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
  mise/config.toml    — runtime version manager settings
  starship.toml       — prompt theme (single-line, Nerd Font icons)
  vim/                — modular vim config (auto-sourced via glob)
rc/
  vimrc               — vim entry point (sources files from config/vim/)
claude/
  commands/           — custom Claude Code slash commands
Brewfile              — Homebrew packages and casks
install.rb            — installer: symlinks, brew bundle, macOS defaults
macos.sh              — macOS system preferences (run via install.rb or standalone)
```
