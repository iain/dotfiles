# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repo. Config files live in `config/`, rc files in `rc/`. The `install.rb` script symlinks everything into place.

## Install Script

```bash
ruby install.rb        # symlinks + brew bundle + macOS defaults
ruby install.rb -n     # dry run — preview what would happen
ruby install.rb --no-brew --no-macos  # symlinks only
```

The script does six things:
1. `config/*` → `~/.config/*` (preserving directory structure)
2. `rc/*` → `~/.<name>` (adds dot prefix, e.g. `rc/vimrc` → `~/.vimrc`)
3. `brew bundle` — installs Homebrew packages (auto-detected when `Brewfile` exists, skip with `--no-brew`)
4. `mise install` — installs tools pinned in mise config, e.g. `hk` for git hooks (auto-detected when `mise` present, skip with `--no-mise`)
5. Claude plugins + MCP servers — installs the marketplaces/plugins declared in `claude/settings.json` and registers the rubocop MCP server at user scope (auto-detected when `claude` present, skip with `--no-plugins`). Idempotent: each item is skipped if already present
6. `macos.sh` — applies macOS defaults (auto-detected on macOS, skip with `--no-macos`)

Files listed in `SKIP` (currently `config.local.example`) are excluded. Existing non-symlink files are backed up with `.backup` suffix.

At the end of a run it also does a read-only **commit-signing check** (`check_git_signing`): warns, with the exact fix, if `config.local` is missing, the signing key is absent, or that key isn't trusted in `allowed_signers` / not registered on GitHub. It changes nothing — a new machine just gets told what to wire up.

## Structure

- **`config/fish/config.fish`** — Fish shell config: PATH, Homebrew, aliases (eza, bat, zoxide, fzf, rg), git/ruby abbreviations, Starship prompt
- **`config/git/`** — Git config with SSH signing, histogram diff, zdiff3 merge conflicts, rerere, auto-rebase on pull. Per-machine identity goes in `~/.config/git/config.local` (see `config.local.example`)
- **`config/vim/`** — Modular vim config auto-sourced via glob in `rc/vimrc`. Files prefixed with `_` (e.g. `_plug.vim`, `_nvim-defaults.vim`, `_macvim.vim`) are sourced explicitly and excluded from the glob
- **`config/starship.toml`** — Single-line Starship prompt with Nerd Font symbols
- **`config/mise/config.toml`** — Global mise settings (legacy version files, experimental features)
- **`claude/`** — Claude Code config symlinked into `~/.claude`: `settings.json` (permissions, status line, `SessionStart` hook, plus the enabled plugins and known marketplaces that drive the install-script plugin step), `statusline.sh` (hostname-led status line), `hooks/machine-context.sh` (a `SessionStart` hook that injects the hostname into the model's context so it knows which machine it's on), and `bin/rubocop-mcp` (a per-repo-adaptive rubocop MCP launcher, registered user-scope by the install script). Note: `settings.json` is a tracked file but Claude also writes to `~/.claude/settings.json` at runtime (theme, plugin state), so machine-local tooling that rewrites it — e.g. peon-ping — is intentionally **not** tracked here; its hooks land in `~/.claude/settings.json.backup` after an install run
## Conventions

- Commit messages: **short, imperative, title case** (e.g. `Add Pagination to Query Endpoint`). No bullet-point bodies unless a single sentence of context is genuinely needed.
- No test suite — this is a config-only repo.
- Git config enforces signed commits (SSH), rebase on pull, and auto-setup of remote tracking.
