# Dotfiles

Config files for macOS. Managed with symlinks via `install.rb`.

## New Laptop Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone This Repo

Clone it anywhere — `install.rb` resolves paths relative to itself:

```bash
git clone <repo-url>
cd dotfiles
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

### 6. Set Up an SSH Key for GitHub (Auth + Signing)

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

Confirm everything is wired up with an empty signed commit:

```bash
git commit --allow-empty -m "test signing" && git log --show-signature -1
```

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
