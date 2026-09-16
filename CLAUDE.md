# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repo. Config files live in `config/`, rc files in `rc/`. Machine setup is declarative via `mise bootstrap`, driven by the repo-root `mise.toml`. mise itself is installed from `https://mise.run`, never Homebrew (a brewed mise can't `self-update`).

## Bootstrap

A fresh machine clones and bootstraps in one go with `mise bootstrap --from https://github.com/iain/dotfiles --from-dir ~/Code/dotfiles` (trusts the repo for that run only). After that, run from the cloned repo (dotfile sources are relative to `mise.toml`, so it can be cloned anywhere):

```bash
mise trust
mise bootstrap -n      # preview — changes nothing
mise bootstrap         # apply
mise bootstrap status  # show drift from the declared state
```

**Keep bootstrap config out of `config/mise/config.toml`.** That file is symlinked to the global `~/.config/mise/config.toml`, and mise merges `[bootstrap]`/`[dotfiles]` across the config hierarchy like `[tools]` — anything bootstrap-related there would be applied by `mise bootstrap` in every project on the machine. The global file holds only `[settings]`, `[env]` (XDG and tool storage locations, see below) and `[tools]` (languages plus jdx's CLIs: `hk`, `pitchfork`, `aube`, `fnox`); it still merges into a bootstrap run from this repo.

`mise.toml` declares, in pipeline order:
1. `[bootstrap.hooks.pre-packages]` — installs Homebrew if missing
2. `[bootstrap.packages]` — Homebrew formulae (`brew:`) and casks/fonts (`brew-cask:`)
3. `[dotfiles]` — `symlink-each` for `config/` → `~/.config/`, `claude/` → `~/.claude/`, `bin/` → `~/.local/bin/`, plus per-file `rc/*` → `~/.<name>` (a new `rc/` file needs its own entry). `symlink-each` links each file individually, so machine-local siblings (`config.local`, `config.local.fish`) inside managed dirs are left untouched. `exclude` keeps `config.local.example` out of `~/.config`.
4. `[bootstrap.macos.defaults]` — the declarative `defaults write` set, plus `[bootstrap.macos.trackpad]` (tap to click on both built-in and Bluetooth domains) and `[[bootstrap.macos.defaults_entries]]` for what plain tables can't express: `host = "current"` (`-currentHost`) and `path` (patch one key inside a dict, e.g. the Spotlight hotkey). Prefer these over hook commands — they get drift detection. What's left in `[bootstrap.hooks.post-defaults]` (chflags, `$HOME`-expanded screenshot dir, killall) runs on every bootstrap
5. `[bootstrap.user].login_shell` — sets fish
6. `[tools]` from the global config — `mise install`. mise reloads config after the dotfiles phase, so a fresh machine picks up the just-linked global config in the same run
7. `[tasks.bootstrap]` — depends on `setup-identity`, `setup-claude`
8. `[bootstrap.hooks.final]` — the read-only commit-signing diagnostic

Everything is idempotent — anything already in its desired state is skipped, so re-running is safe.

### Imperative setup: `bin/dotfiles-setup`

The parts mise can't express declaratively live in `bin/dotfiles-setup` (a Ruby script). The dotfiles phase deploys it to `~/.local/bin` before the `bootstrap` task runs, and it locates the repo via its own realpath — no hardcoded path. Subcommands, each a mise task and idempotent:
- `identity` (`mise run setup-identity`) — interactive git identity → `~/.config/git/config.local`, ssh config, fish local config
- `claude` (`mise run setup-claude`) — installs the marketplaces/plugins declared in `claude/settings.json` and registers the rubocop MCP server at user scope
- `signing` (`mise run check-signing`) — read-only diagnostic: warns, with the exact fix, if `config.local` is missing, the signing key is absent, or that key isn't in `allowed_signers` / not registered on GitHub

## Structure

- **`config/fish/config.fish`** — Fish shell config: PATH, Homebrew, aliases (eza, bat, zoxide, fzf, rg), git/ruby abbreviations, Starship prompt, and mise activation last (which exports the XDG vars, so anything reading them goes after it)
- **`config/git/`** — Git config with SSH signing, histogram diff, zdiff3 merge conflicts, rerere, auto-rebase on pull. Per-machine identity goes in `~/.config/git/config.local` (see `config.local.example`)
- **`config/vim/`** — Modular vim config auto-sourced via glob in `rc/vimrc`. Files prefixed with `_` (e.g. `_plug.vim`, `_nvim-defaults.vim`, `_macvim.vim`) are sourced explicitly and excluded from the glob. Plugins live in `$XDG_DATA_HOME/vim`, swap/backup/undo in `$XDG_STATE_HOME/vim` (vim creates those dirs itself)
- **`config/starship.toml`** — Single-line Starship prompt with Nerd Font symbols
- **`config/mise/config.toml`** — global mise settings, `[env]` with the XDG and tool storage locations, and pinned `[tools]`; deployed to `~/.config/mise/config.toml`
- **`mise.toml`** — the whole `mise bootstrap` config (packages, dotfiles, login shell, macOS defaults, setup tasks); a project config so it never leaks into other projects' bootstraps
- **`claude/`** — Claude Code config symlinked into `~/.claude`: `settings.json` (permissions, status line, `SessionStart` hook, plus the enabled plugins and known marketplaces that drive the `setup-claude` task), `statusline.sh` (hostname-led status line), `hooks/machine-context.sh` (a `SessionStart` hook that injects the hostname into the model's context so it knows which machine it's on), and `bin/rubocop-mcp` (a per-repo-adaptive rubocop MCP launcher, registered user-scope by the `setup-claude` task). Note: `settings.json` is a tracked file but Claude also writes to `~/.claude/settings.json` at runtime (theme, plugin state), so machine-local tooling that rewrites it — e.g. peon-ping — is intentionally **not** tracked here; its hooks land in `~/.claude/settings.json.backup` after a bootstrap run

## XDG Locations

`[env]` in `config/mise/config.toml` sets all four XDG base dirs explicitly (standard paths, built from `{{env.HOME}}`) and points tools that ignore XDG on macOS at them: Homebrew, npm, pnpm, cargo/rustup, mr-boxington (`mbx`), Go, pip, bundler, NuGet, Playwright, Maven. Split by kind — credentials and settings under `XDG_CONFIG_HOME`, installs under `XDG_DATA_HOME`, anything re-downloadable under `XDG_CACHE_HOME`. mise, uv, aube and podman already follow XDG on their own.

- **Never hardcode `~/.local/share`, `~/.cache`, or `~/Library/...` paths.** Derive from the XDG vars. Outside fish (git hooks, vim launched from the Dock) the vars may be unset, so fall back to the XDG default: `${XDG_DATA_HOME:-$HOME/.local/share}` in shell; in vim, use `g:xdg_data_home` / `g:xdg_state_home`, which `rc/vimrc` resolves with that fallback.
- Only redirect a tool after checking it actually honours the variable. `npm_config_devdir` (node-gyp) was dropped: npm warns about it on every command.
- Setting an XDG var can also move a tool that only uses `~/Library` while the var is unset — k9s moves its per-cluster settings to `XDG_DATA_HOME` this way. Probe the tool with the var pointed elsewhere before assuming it stays put, and move its existing data when the var lands.
- **They live in mise's `[env]`, not fish, on purpose.** They reach everything mise sets up: fish via `mise activate`, mise tasks, and commands under `mise x` — including pitchfork daemons, since the monorepo and tayaway `pitchfork.toml` set `mise = true`. The pitchfork supervisor runs as root through sudo or a LaunchDaemon, which strips the shell environment, so fish-only vars never reached its daemons. Processes that bypass mise still don't get them: apps launched from the Dock and git hooks run by GUI clients.

## Conventions

- Commit messages: **short, imperative, title case** (e.g. `Add Pagination to Query Endpoint`). No bullet-point bodies unless a single sentence of context is genuinely needed.
- No test suite — this is a config-only repo.
- Git config enforces signed commits (SSH), rebase on pull, and auto-setup of remote tracking.
