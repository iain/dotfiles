# encodings
set -gx LANG     "en_US.UTF-8"
set -gx LANGUAGE "en_US.UTF-8"
set -gx LC_ALL   "en_US.UTF-8"
set -gx LC_CTYPE "en_US.UTF-8"

# Homebrew setup
fish_add_path "/opt/homebrew/bin"
fish_add_path "/opt/homebrew/sbin"
set -gx CPATH "/opt/homebrew/include"
set -gx LIBRARY_PATH "/opt/homebrew/lib"
set -gx HOMEBREW_NO_ENV_HINTS "1"

if which -s bat
  set -gx HOMEBREW_BAT "1"
end

fish_add_path "$HOME/.cargo/bin"

# Macvim binaries
fish_add_path "/Applications/MacVim.app/Contents/bin/"

# configure my prefered editor
set -Ux EDITOR         "vim"
set -Ux GIT_EDITOR     $EDITOR
set -Ux SVN_EDITOR     $EDITOR
set -Ux VISUAL         "vim"
set -Ux BUNDLER_EDITOR $VISUAL
set -Ux GEMEDITOR      $VISUAL
set -Ux MANPAGER       "col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

# ls
set -Ux CLICOLOR 1
set -Ux LS_COLORS "no=00:fi=00:di=34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;35:*.rb=00;31"
set -Ux EXA_COLORS "da=37:ur=37:gr=37:tr=37:uu=33:di=34"
if which -s gls
  alias ls="gls --group-directories-first --color=auto"
end
if which -s eza
  alias l="eza --long --group-directories-first --git --all --time-style=long-iso"
else
  alias l="ls -FhAlo"
end

# pagers
abbr -a tf "tail -f -n 200"
alias less="less -R" # color codes in less

# grep
set -Ux RIPGREP_CONFIG_PATH ~/.ripgreprc
if which -s rg
  alias grep="rg" # experiment
else
  alias grep="grep --colour=always"
end

# workaround for GPG and Git
set -gx GPG_TTY (tty)

# git abbreviations
abbr -a a       "git add --all"
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
abbr -a gpb     "git-publish-branch"
abbr -a gpr     "gh pr create --assignee @me --fill"
abbr -a gr      "git recent"
abbr -a p       "git push"
abbr -a re      "git restore"
abbr -a s       "git status -s"
abbr -a st      "git status"
abbr -a sw      "git switch"
abbr -a unstage "git restore --staged --"
abbr -a up      "git pull --ff-only"

abbr -a v "vimr -n"

# ruby abbreviations
abbr -a b   "bundle"
abbr -a be  "bundle exec"
abbr -a cu  "cucumber"
abbr -a r   "rails"
abbr -a wip "cucumber -p wip"
abbr -a of  "rspec --only-failures"
abbr -a rdm "rails db:migrate"

abbr -a tap "./bin/tapioca"
abbr -a dsl "./bin/tapioca dsl"
# abbr -a ms "tmuxinator start"
# abbr -a mx "tmuxinator stop"

# disable virtualenv prompt, it breaks starship
set VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx STARSHIP_SHELL "fish"
# Set up the session key that will be used to store logs
set -gx STARSHIP_SESSION_KEY (random 10000000000000 9999999999999999)
# starship init fish | source
set async_prompt_functions starship_prompt fish-dark-mode

# FZF.fish
set fzf_preview_dir_cmd exa --all --color=always
set fzf_fish_custom_keybindings
bind \cy __fzf_search_git_log
bind \cu __fzf_search_git_status

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# ignored file, might not be there
# this is where I put secret tokens
if [ -f ~/.dotfiles/config/fish/personal.fish ]
  source ~/.dotfiles/config/fish/personal.fish
end

if which -s zoxide; zoxide init fish | source; end
if which -s direnv; direnv hook fish | source; end

# test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# 1password integration
# if [ -f ~/.config/op/plugins.sh ]
#   source ~/.config/op/plugins.sh
# end

# postgresql@16
if [ -f /opt/homebrew/opt/postgresql@16/bin/psql ]
  fish_add_path /opt/homebrew/opt/postgresql@16/bin
  set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@16/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@16/include"
  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# personal files in bin are always highest priority
fish_add_path "$HOME/.dotfiles/bin"
