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

### 3. Install Packages

```bash
brew bundle
```

This installs Fish, Starship, vim, git-delta, fzf, ripgrep, eza, bat, zoxide, mise, direnv, Ghostty's font (JetBrains Mono Nerd Font), and everything else in the `Brewfile`.

### 4. Symlink Config Files

```bash
ruby install.rb -n   # preview what will happen
ruby install.rb      # do it
```

This links:
- `config/*` → `~/.config/*` (fish, git, vim, starship, mise, ghostty)
- `rc/*` → `~/.<name>` (e.g. `rc/vimrc` → `~/.vimrc`)
- `claude/*` → `~/.claude/*`

Existing files are backed up with a `.backup` suffix.

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
install.rb            — symlink installer (supports -n dry run)
```
