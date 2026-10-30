# Dotfiles

Config files for macOS. Provisioned declaratively with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html) — the repo-root `mise.toml` describes the packages, dotfile symlinks, login shell, and macOS defaults for the whole machine; `config/mise/config.toml` holds the global mise settings and tools.

## New Laptop Setup

### 1. Run the Install Script

In Terminal.app:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/iain/dotfiles/main/install.sh)"
```

Have your GitHub password and 2FA at hand: no password manager is installed yet, and the GitHub login opens in Safari. [`install.sh`](install.sh) does what the bootstrap can't do for itself, then starts it:

1. **Names the machine.** The status line, Claude's machine context and the signing key's title use it, and a new Mac comes with a name like `Iains-MacBook-Pro`.
2. **Installs Homebrew**, interactively: it asks for your password, and brings the Command Line Tools and with them `git`, which mise needs to clone this repo.
3. **Logs `gh` in to GitHub over SSH.** Let it generate and upload a key: the bootstrap clones `~/Code/spectral` over SSH, and mise gets its GitHub token from `gh` (without one, installing tools runs into the 60/hour anonymous API limit).
4. **Adds that key to GitHub again, as a signing key.** GitHub keeps authentication and signing keys apart.
5. **Installs mise** from `mise.run` (a brewed mise can't `mise self-update`) and bootstraps from this repo, cloned to `~/Code/dotfiles`.

Every step is skipped when already done, so after a failure just run it again; it then bootstraps from the existing checkout. Run it as above rather than through `curl | bash`, so its prompts can read the terminal.

In order, bootstrap:

1. Installs Homebrew if missing, then the **`[bootstrap.packages]`** (formulae + casks/fonts), and copies the root-owned **system files**: Touch ID for `sudo`, and pitchfork's port forward.
2. Symlinks **dotfiles** (`config/*` → `~/.config/*`, `rc/*` → `~/.<name>`, `claude/*` → `~/.claude/*`, `bin/*` → `~/.local/bin/*`). `symlink-each` links each file individually, so machine-local files like `~/.config/git/config.local` are left untouched. `config.local.example` is excluded — it's documentation, not config.
3. Writes **macOS defaults**.
4. Sets **fish** as the login shell.
5. Installs the pinned **tools** (`ruby`, `node`, `hk`, …). mise reloads config after step 2, so on a fresh machine this already sees the just-linked `~/.config/mise/config.toml` — one run is enough.
6. Runs the **`bootstrap` task** — per-machine setup that isn't declarative, then a read-only commit-signing diagnostic. It asks for your git identity, suggesting the name and email of your GitHub account, and writes it to `~/.config/git/config.local`; if it couldn't prompt, run `mise run setup-identity`. It also adds this machine's signing key to `config/git/allowed_signers`, and sets up the Claude plugins.

Re-run the bootstrap from the checkout any time; anything already in its desired state is skipped:

```bash
cd ~/Code/dotfiles
mise bootstrap -n      # preview — changes nothing
mise bootstrap         # apply
mise bootstrap status  # drift from the declared state
```

> The machine bootstrap lives in the repo-root `mise.toml` — a project config — on purpose. mise merges `[bootstrap]` across the config hierarchy like `[tools]`, so if it lived in the global config, running `mise bootstrap` in *any* project would also re-apply these packages, dotfiles, and macOS defaults.

### 2. Switch to Ghostty

From here on, work in Ghostty, where fish is now the login shell. Set Firefox as the default browser, and grant the permissions apps ask for on first launch, such as Screen Recording for macshot. Vim installs its plugins the first time it starts.

### 3. Commit Your Signing Key

The bootstrap added this machine's key to `config/git/allowed_signers`, so its commits verify locally. Commit that change, which also tests signing:

```bash
cd ~/Code/dotfiles
git commit -am "Allow Signing Key for $(scutil --get LocalHostName)" && git log --show-signature -1
```

`mise run check-signing` re-runs the diagnostic and prints the exact fix for anything still missing.

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
  etc/pam.d/sudo_local                                — Touch ID for sudo
  etc/pf.anchors/dotfiles-pitchfork                   — forwards loopback 443 to pitchfork's proxy on 8443
  Library/LaunchDaemons/dev.dotfiles.pitchfork-pf.plist — loads that rule at boot
install.sh            — first thing on a new Mac: machine name, Homebrew, gh and its keys, mise, bootstrap. Outside bin/, so it isn't linked onto PATH
mise.toml             — the mise bootstrap config (packages, system files, dotfiles, login shell, macOS defaults, LaunchAgents, setup tasks)
```

## Managing Dotfiles

Bootstrap is declarative and idempotent, so day-to-day changes are just edits to `mise.toml` and the files under `config/`, `rc/`, etc. Run these from the repo:

```bash
mise bootstrap status          # what's drifted from the declared state
mise dotfiles apply -n         # preview dotfile symlink changes
mise run setup-identity        # (re)seed git identity / ssh / fish-local
mise run check-signing         # audit the commit-signing chain
mise doctor project            # check drift, GitHub login, signing and pitchfork
```

## Upgrading

`mise bootstrap` only installs what's missing; it never upgrades. One task does all the upkeep:

```bash
mise run upgrade -n            # preview — changes nothing
mise run upgrade
```

In order, it:

1. Upgrades **mise** itself, then the **bootstrap packages**, everything else **Homebrew** manages (Homebrew itself, formulae a project installed, casks from before the bootstrap), the **mise tools** and the **uv tools**.
2. Removes what's no longer used: tool versions no config asks for (`mise prune`), and old Homebrew versions and downloads (`brew cleanup`).
3. Re-runs the **Claude setup**, so a new herdr's hooks reach Claude, then updates the **Claude plugins** of both profiles (restart Claude to load them) and the **vim plugins**.
4. Relinks any Homebrew formula a failed upgrade left unlinked, which once took `gh` off `PATH`.
5. Lists pending **macOS updates**. It doesn't install them, as they can need a restart: use System Settings or `softwareupdate --install`.

`mise bootstrap packages upgrade` only upgrades what `mise.toml` declares, and leaves casks that Homebrew installed before the switch to bootstrap alone, so `brew upgrade` follows it for the rest; it also updates Homebrew itself. Casks that update themselves, like macshot, are left to their own updater.
