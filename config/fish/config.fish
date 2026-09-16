# XDG base directories, set explicitly so every path below derives from them.
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_STATE_HOME  "$HOME/.local/state"
set -gx XDG_CACHE_HOME  "$HOME/.cache"

# Tools that ignore XDG, or fall back to ~/Library on macOS, pointed at it.
# The comment is where each would write otherwise.
set -gx HOMEBREW_CACHE           "$XDG_CACHE_HOME/Homebrew"        # ~/Library/Caches/Homebrew
set -gx npm_config_cache         "$XDG_CACHE_HOME/npm"             # ~/.npm
set -gx PNPM_HOME                "$XDG_DATA_HOME/pnpm"             # ~/Library/pnpm, incl. the store
set -gx CARGO_HOME               "$XDG_DATA_HOME/cargo"            # ~/.cargo
set -gx RUSTUP_HOME              "$XDG_DATA_HOME/rustup"           # ~/.rustup
set -gx MBX_CACHE_DIR            "$XDG_CACHE_HOME/mbx"             # ~/Library/Caches/mbx
set -gx GOPATH                   "$XDG_DATA_HOME/go"               # ~/go
set -gx GOMODCACHE               "$XDG_CACHE_HOME/go-mod"          # ~/go/pkg/mod
set -gx GOCACHE                  "$XDG_CACHE_HOME/go-build"        # ~/Library/Caches/go-build
set -gx PIP_CACHE_DIR            "$XDG_CACHE_HOME/pip"             # ~/Library/Caches/pip
set -gx BUNDLE_USER_CONFIG       "$XDG_CONFIG_HOME/bundle/config"  # ~/.bundle/config
set -gx BUNDLE_USER_CACHE        "$XDG_CACHE_HOME/bundle"          # ~/.bundle/cache
set -gx BUNDLE_USER_PLUGIN       "$XDG_DATA_HOME/bundle/plugin"    # ~/.bundle/plugin
set -gx NUGET_PACKAGES           "$XDG_CACHE_HOME/NuGet/packages"  # ~/.nuget/packages
set -gx PLAYWRIGHT_BROWSERS_PATH "$XDG_CACHE_HOME/ms-playwright"   # ~/Library/Caches/ms-playwright
set -gx MAVEN_ARGS               "-Dmaven.repo.local=$XDG_CACHE_HOME/maven/repository"  # ~/.m2/repository

if test -x /opt/homebrew/bin/brew
  /opt/homebrew/bin/brew shellenv fish | source
end

fish_add_path $HOME/.local/bin
fish_add_path /Applications/MacVim.app/Contents/bin
fish_add_path /opt/homebrew/opt/libpq/bin

if status is-interactive
  # Commands to run in interactive sessions can go here
  set -g fish_greeting
  if command -q starship
    starship init fish | source
  end
end

if command -q vim
  set -gx EDITOR "vim"
  set -gx VISUAL "$EDITOR"
end

if command -q eza
  # Directories in Spectral's signature amber (#F9AD26). The rest tones down eza's
  # defaults: every permission bit is set explicitly and non-bold (eza's default triad
  # is all-bold via attribute bleed), the bright-yellow read bits and owner are dimmed.
  # Note: user-execute is keyed `ue`, not `ux`.
  set -gx EZA_COLORS "di=38;2;249;173;38:ur=2;33:uw=31:ux=32:ue=32:gr=2;33:gw=31:gx=32:tr=2;33:tw=31:tx=32:uu=2;37:un=2;37:sn=32:sb=32:xx=90:da=34:ex=32:bu=0"
  alias ls="eza --group-directories-first --icons=auto"
  alias l="eza --group-directories-first --git --all --time-style=iso --long"
end

if command -q bat
  alias cat="bat"

  # bat-extras
  if command -q batman
    alias man="batman"
  end
  if command -q batdiff
    alias diff="batdiff"
  end
  if command -q batgrep
    alias bgrep="batgrep"
  end
  if command -q prettybat
    alias pretty="prettybat"
  end
end

if command -q zoxide
  zoxide init fish | source
  alias cd="z"
end

if command -q fzf
  if command -q fd
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
  end
  fzf --fish | source
end

if command -q direnv
  direnv hook fish | source
end

if command -q rg
  set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"
  abbr -a grep rg
end

if [ -f /opt/homebrew/opt/postgresql@18/bin/psql ]
  fish_add_path "/opt/homebrew/opt/postgresql@18/bin"
  set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@18/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@18/include"
  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@18/lib/pkgconfig"
end


# git abbreviations
abbr -a aa      "git add --all"
abbr -a amend   "git commit --amend"
abbr -a c       "git commit"
abbr -a co      "git checkout"
abbr -a d       "git diff"
abbr -a dc      "git diff --cached"
abbr -a g       "git"
abbr -a g12     "git rev-parse --short=12 HEAD"
abbr -a gb      "git branch"
abbr -a gc      "git checkout"
abbr -a gf      "git fetch --all"
abbr -a gl      "git log"
abbr -a glp     "git log -p"
abbr -a gpr     "gh pr create --assignee @me --fill --draft"
abbr -a gr      "git recent"
abbr -a gw      "git worktree"
abbr -a p       "git push"
abbr -a re      "git restore"
abbr -a s       "git status -s"
abbr -a st      "git status"
abbr -a sw      "git switch"
abbr -a unstage "git restore --staged --"
abbr -a up      "git pull"

# ruby abbreviations
abbr -a b   "bundle"
abbr -a be  "bundle exec"
abbr -a cu  "cucumber"
abbr -a r   "rails"
abbr -a wip "cucumber -p wip"
abbr -a of  "rspec --only-failures"
abbr -a rdm "rails db:migrate"

# Source local config for secrets and machine-specific settings
if test -f ~/.config/fish/config.local.fish
  source ~/.config/fish/config.local.fish
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# pnpm
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# mise should run last
if command -q mise
  set -gx MISE_EXPERIMENTAL "1"
  mise activate fish | source
  # pitchfork activate fish | source
  if command -q fnox
    fnox activate fish | source
  end
  abbr -a pf "pitchfork"

  # Claude Code snapshots PATH from this shell and runs its commands under zsh
  # with that snapshot. mise's activate hook only repositions PATH at the
  # interactive prompt, which never fires there — leaving the shims dir after
  # /usr/bin, so `mise exec` and git hooks resolve system ruby. Move shims to
  # the front so the snapshot (and anything non-interactive) resolves via mise.
  fish_add_path --global --move --path $XDG_DATA_HOME/mise/shims
end
