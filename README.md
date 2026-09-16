# Dotfiles

Config files for macOS. Provisioned declaratively with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html) — the repo-root `mise.toml` describes the packages, dotfile symlinks, login shell, and macOS defaults for the whole machine; `config/mise/config.toml` holds the global mise settings and tools.

## New Laptop Setup

### 1. Install mise

```bash
curl -fsSL https://mise.run | sh
```

This installs to `~/.local/bin/mise`. Don't `brew install mise`: a brewed mise can't `mise self-update`. Everything else — including Homebrew itself — is installed by the bootstrap.

### 2. Bootstrap

One command clones this repo and bootstraps the machine from it:

```bash
~/.local/bin/mise bootstrap --from https://github.com/iain/dotfiles --from-dir ~/Code/dotfiles
```

`--from-dir` can be anywhere; nothing hardcodes a path (dotfile sources resolve relative to `mise.toml`), but the symlinks point into it, so keep it. The clone needs `git`: on a new Mac, the first use prompts to install the Command Line Tools — accept, then re-run the command.

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

### 3. Git Identity

The bootstrap task seeds `~/.config/git/config.local` interactively. If it couldn't prompt (no TTY during bootstrap), run it directly:

```bash
mise run setup-identity      # or: dotfiles-setup identity
```

### 4. Set Up an SSH Key for GitHub (Auth + Signing)

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

### 5. Install Vim Plugins

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
  mise/config.toml    — global mise settings + pinned tools (languages, jdx's CLIs)
  starship.toml       — prompt theme (single-line, Nerd Font icons)
  vim/                — modular vim config (auto-sourced via glob)
rc/
  vimrc               — vim entry point (sources files from config/vim/)
bin/
  dotfiles-setup      — per-machine setup driven by mise tasks (identity, Claude, signing)
claude/
  settings.json       — enabled plugins + marketplaces, hooks, permissions
mise.toml             — the mise bootstrap config (packages, dotfiles, login shell, macOS defaults, setup tasks)
```

## Managing Dotfiles

Bootstrap is declarative and idempotent, so day-to-day changes are just edits to `mise.toml` and the files under `config/`, `rc/`, etc. Run these from the repo:

```bash
mise bootstrap status          # what's drifted from the declared state
mise dotfiles apply -n         # preview dotfile symlink changes
mise run setup-identity        # (re)seed git identity / ssh / fish-local
mise run check-signing         # audit the commit-signing chain
```
