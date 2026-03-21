set -gx XDG_CONFIG_HOME "$HOME/.config"

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
end

if command -q eza
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

if command -q mise
  mise activate fish | source
end

if command -q rg
  set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"
  alias grep="rg"
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
abbr -a g12     "git rev-parse HEAD | cut -c 1-12"
abbr -a gf      "git fetch --all"
abbr -a gl      "git log"
abbr -a glp     "git log -p"
abbr -a gpr     "gh pr create --assignee @me --fill"
abbr -a gr      "git recent"
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
