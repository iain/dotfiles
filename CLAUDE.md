# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repo. Config files live in `config/`, rc files in `rc/`. Machine setup is declarative via `mise bootstrap`, driven entirely by `config/mise/config.toml`.

## Bootstrap

Run from the cloned repo (relative dotfile sources resolve against the config file's real location, so it can be cloned anywhere):

```bash
export MISE_GLOBAL_CONFIG_FILE="$PWD/config/mise/config.toml"
mise bootstrap -n      # preview — changes nothing
mise bootstrap         # apply
mise bootstrap status  # show drift from the declared state
```

`config/mise/config.toml` declares, in pipeline order:
1. `[bootstrap.hooks.pre-packages]` — installs Homebrew if missing
2. `[bootstrap.packages]` — Homebrew formulae (`brew:`) and casks/fonts (`brew-cask:`)
3. `[dotfiles]` — `symlink-each` for `config/` → `~/.config/`, `claude/` → `~/.claude/`, `bin/` → `~/.local/bin/`, plus per-file `rc/*` → `~/.<name>`. `symlink-each` links each file individually, so machine-local siblings (`config.local`, `config.local.fish`) inside managed dirs are left untouched.
4. `[bootstrap.user].login_shell` — sets fish
5. `[bootstrap.macos.defaults]` — the declarative `defaults write` set; the non-declarative tail (currentHost scope, chflags, PlistBuddy, killall, `$HOME`-expanded screenshot dir) is in `[bootstrap.hooks.post-defaults]`
6. `[tools]` — `mise install`
7. `[tasks.bootstrap]` — depends on `setup-identity`, `setup-vim-dirs`, `setup-claude`
8. `[bootstrap.hooks.final]` — the read-only commit-signing diagnostic

Everything is idempotent — anything already in its desired state is skipped, so re-running is safe.

### Imperative setup: `bin/dotfiles-setup`

The parts mise can't express declaratively live in `bin/dotfiles-setup` (a Ruby script). The dotfiles phase deploys it to `~/.local/bin` before the `bootstrap` task runs, and it locates the repo via its own realpath — no hardcoded path. Subcommands, each a mise task and idempotent:
- `identity` (`mise run setup-identity`) — interactive git identity → `~/.config/git/config.local`, ssh config, fish local config
- `vim-dirs` (`mise run setup-vim-dirs`) — vim swap/backup/undo dirs
- `claude` (`mise run setup-claude`) — installs the marketplaces/plugins declared in `claude/settings.json` and registers the rubocop MCP server at user scope
- `signing` (`mise run check-signing`) — read-only diagnostic: warns, with the exact fix, if `config.local` is missing, the signing key is absent, or that key isn't in `allowed_signers` / not registered on GitHub

## Structure

- **`config/fish/config.fish`** — Fish shell config: PATH, Homebrew, aliases (eza, bat, zoxide, fzf, rg), git/ruby abbreviations, Starship prompt
- **`config/git/`** — Git config with SSH signing, histogram diff, zdiff3 merge conflicts, rerere, auto-rebase on pull. Per-machine identity goes in `~/.config/git/config.local` (see `config.local.example`)
- **`config/vim/`** — Modular vim config auto-sourced via glob in `rc/vimrc`. Files prefixed with `_` (e.g. `_plug.vim`, `_nvim-defaults.vim`, `_macvim.vim`) are sourced explicitly and excluded from the glob
- **`config/starship.toml`** — Single-line Starship prompt with Nerd Font symbols
- **`config/mise/config.toml`** — mise settings and pinned `[tools]`, plus the whole `mise bootstrap` config (packages, dotfiles, login shell, macOS defaults, setup tasks)
- **`claude/`** — Claude Code config symlinked into `~/.claude`: `settings.json` (permissions, status line, `SessionStart` hook, plus the enabled plugins and known marketplaces that drive the `setup-claude` task), `statusline.sh` (hostname-led status line), `hooks/machine-context.sh` (a `SessionStart` hook that injects the hostname into the model's context so it knows which machine it's on), and `bin/rubocop-mcp` (a per-repo-adaptive rubocop MCP launcher, registered user-scope by the `setup-claude` task). Note: `settings.json` is a tracked file but Claude also writes to `~/.claude/settings.json` at runtime (theme, plugin state), so machine-local tooling that rewrites it — e.g. peon-ping — is intentionally **not** tracked here; its hooks land in `~/.claude/settings.json.backup` after a bootstrap run
## Conventions

- Commit messages: **short, imperative, title case** (e.g. `Add Pagination to Query Endpoint`). No bullet-point bodies unless a single sentence of context is genuinely needed.
- No test suite — this is a config-only repo.
- Git config enforces signed commits (SSH), rebase on pull, and auto-setup of remote tracking.
