# Dotfiles

Config files for macOS. Provisioned declaratively with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html) — the repo-root `mise.toml` describes the packages, dotfile symlinks, login shell, and macOS defaults for the whole machine; `config/mise/config.toml` holds the global mise settings and tools.

## New Laptop Setup

Steps 1–3 run in Terminal.app, with Safari for the GitHub login. Ghostty and Firefox arrive with the bootstrap. Have your GitHub password and 2FA at hand: no password manager is installed yet.

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run it by hand, before anything else. It asks for your password and installs the Command Line Tools, which bring `git`. mise can't clone this repo without `git`, and the bootstrap's own Homebrew hook runs non-interactively, so it can't ask for the password.

### 2. Log In to GitHub With an SSH Key

```bash
/opt/homebrew/bin/brew install gh
/opt/homebrew/bin/gh auth login
```

Choose SSH and let `gh` generate and upload a key; the browser step works in Safari. The bootstrap needs both results: it clones `~/Code/spectral` over SSH, and mise gets its GitHub token from `gh` (without it, installing tools runs into the 60/hour anonymous API limit).

GitHub treats authentication and signing keys separately, so upload the same key once more as a signing key:

```bash
/opt/homebrew/bin/gh auth refresh -h github.com -s admin:ssh_signing_key
/opt/homebrew/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(hostname -s)"
```

### 3. Install mise and Bootstrap

```bash
curl -fsSL https://mise.run | sh
~/.local/bin/mise bootstrap --from https://github.com/iain/dotfiles --from-dir ~/Code/dotfiles
```

mise installs to `~/.local/bin/mise`. Don't `brew install mise`: a brewed mise can't `mise self-update`.

`--from-dir` can be anywhere; nothing hardcodes a path (dotfile sources resolve relative to `mise.toml`), but the symlinks point into it, so keep it.

`--from` trusts the repo for that one run only. Afterwards, re-run bootstrap from the clone, trusting it once:

```bash
cd ~/Code/dotfiles
mise trust
mise bootstrap -n      # preview — changes nothing
mise bootstrap         # apply
```

In order, bootstrap:

1. Installs Homebrew if missing, then the **`[bootstrap.packages]`** (formulae + casks/fonts).
2. Symlinks **dotfiles** (`config/*` → `~/.config/*`, `rc/*` → `~/.<name>`, `claude/*` → `~/.claude/*`, `bin/*` → `~/.local/bin/*`). `symlink-each` links each file individually, so machine-local files like `~/.config/git/config.local` are left untouched. `config.local.example` is excluded — it's documentation, not config.
3. Writes **macOS defaults**.
4. Sets **fish** as the login shell.
5. Installs the pinned **tools** (`ruby`, `node`, `hk`, …). mise reloads config after step 2, so on a fresh machine this already sees the just-linked `~/.config/mise/config.toml` — one run is enough.
6. Runs the **`bootstrap` task** — per-machine setup that isn't declarative (git identity, Claude plugins), then a read-only commit-signing diagnostic.

Check for drift any time with `mise bootstrap status`. Re-running is safe: anything already in its desired state is skipped.

> The machine bootstrap lives in the repo-root `mise.toml` — a project config — on purpose. mise merges `[bootstrap]` across the config hierarchy like `[tools]`, so if it lived in the global config, running `mise bootstrap` in *any* project would also re-apply these packages, dotfiles, and macOS defaults.

### 4. Switch to Ghostty

From here on, work in Ghostty, where fish is now the login shell. Set Firefox as the default browser, and grant the permissions apps ask for on first launch, such as Screen Recording for macshot.

### 5. Git Identity

The bootstrap task seeds `~/.config/git/config.local` interactively. If it couldn't prompt (no TTY during bootstrap), run it directly:

```bash
mise run setup-identity      # or: dotfiles-setup identity
```

### 6. Allow Your Signing Key

Add the public key from step 2 to `config/git/allowed_signers` so local verification works (`git log --show-signature`), and commit the change:

```bash
echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" >> config/git/allowed_signers
```

`mise run check-signing` re-runs the diagnostic and prints the exact fix for anything still missing. Confirm everything is wired up with an empty signed commit:

```bash
git commit --allow-empty -m "test signing" && git log --show-signature -1
```

### 7. Install Vim Plugins

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
  mise/config.toml    — global mise settings, XDG + tool storage env vars, pinned tools (languages, jdx's CLIs, kubectl, uv, yq)
  starship.toml       — prompt theme (single-line, Nerd Font icons)
  vim/                — modular vim config (auto-sourced via glob)
rc/
  vimrc               — vim entry point (sources files from config/vim/)
bin/
  dotfiles-setup      — per-machine setup driven by mise tasks (identity, Claude, signing)
  pitchfork-supervisor — starts the pitchfork supervisor as the user for its LaunchAgent
claude/
  settings.json       — enabled plugins + marketplaces, hooks, permissions
system/               — root-owned files copied (not symlinked) by mise bootstrap
  etc/pf.anchors/dotfiles-pitchfork                   — forwards loopback 443 to pitchfork's proxy on 8443
  Library/LaunchDaemons/dev.dotfiles.pitchfork-pf.plist — loads that rule at boot
mise.toml             — the mise bootstrap config (packages, system files, dotfiles, login shell, macOS defaults, LaunchAgents, setup tasks)
```

## Managing Dotfiles

Bootstrap is declarative and idempotent, so day-to-day changes are just edits to `mise.toml` and the files under `config/`, `rc/`, etc. Run these from the repo:

```bash
mise bootstrap status          # what's drifted from the declared state
mise dotfiles apply -n         # preview dotfile symlink changes
mise run setup-identity        # (re)seed git identity / ssh / fish-local
mise run check-signing         # audit the commit-signing chain
```

## Upgrading

`mise bootstrap` only installs what's missing; it never upgrades. To move mise, packages and tools to their latest versions:

```bash
mise run upgrade -n            # preview what would be upgraded
mise run upgrade               # upgrade mise itself, bootstrap packages, then mise tools
```

mise fetches current formula metadata from Homebrew's API on every run, so there's no `brew update` step. Casks that Homebrew installed before the switch to bootstrap are left alone by mise; upgrade those with `brew upgrade --cask`.
