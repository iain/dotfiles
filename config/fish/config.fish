
# encodings
set -gx LANG     "en_US.UTF-8"
set -gx LANGUAGE "en_US.UTF-8"
set -gx LC_ALL   "en_US.UTF-8"
set -gx LC_CTYPE "en_US.UTF-8"

# setting $PATH
set -gx PATH "/opt/homebrew/bin" $PATH
# set -gx PATH $PATH "/usr/local/sbin"
# set -gx PATH $PATH "/usr/local/bin"
# set -gx PATH $PATH "/usr/local/opt/openssl/bin"
# set -gx PATH $PATH "/usr/local/opt/postgresql/bin"
set -gx JAVA_HOME "/Library/Java/Home"

# configure my prefered editor
set -Ux EDITOR         "vim"
set -Ux GIT_EDITOR     $EDITOR
set -Ux SVN_EDITOR     $EDITOR
set -Ux VISUAL         "mvim"
set -Ux BUNDLER_EDITOR $VISUAL
set -Ux GEMEDITOR      $VISUAL
# set -Ux VIM_APP_DIR    "/usr/local/opt/macvim"
set -Ux MANPAGER       "col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# ls
set -Ux CLICOLOR 1
set -Ux LS_COLORS "no=00:fi=00:di=34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;35:*.rb=00;31"
set -Ux EXA_COLORS "da=37:ur=37:gr=37:tr=37:uu=33:di=34"
if which -s gls
  alias ls="gls --group-directories-first --color=auto"
end
if which -s exa
  alias l="exa --long --group-directories-first --git --all --grid --time-style=long-iso"
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
abbr -a a     "git add --all"
abbr -a aa    "git add --all"
abbr -a amend "git commit --amend"
abbr -a c     "git commit"
abbr -a co    "git checkout"
abbr -a d     "git diff"
abbr -a dc    "git diff --cached"
abbr -a g     "git"
abbr -a g12   "git rev-parse HEAD | cut -c 1-12"
abbr -a gf    "git fetch --all"
abbr -a gl    "git log"
abbr -a glp   "git log -p"
abbr -a gpb   "git-publish-branch"
abbr -a gpr   "gh pr create --draft --assignee @me --fill"
abbr -a p     "git push"
abbr -a re    "git restore"
abbr -a s     "git status -s"
abbr -a st    "git status"
abbr -a sw    "git switch"
abbr -a up    "git pull --ff-only"
abbr -a unstage "git restore --staged --"

# ruby abbreviations
abbr -a b   "bundle"
abbr -a be  "bundle exec"
abbr -a cu  "cucumber"
abbr -a r   "rails"
abbr -a wip "cucumber -p wip"
abbr -a of  "rspec --only-failures"

abbr -a ms "tmuxinator start"
abbr -a mx "tmuxinator stop"

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

source /opt/homebrew/opt/asdf/asdf.fish

# ignored file, might not be there
# this is where I put secret tokens
if [ -f ~/.dotfiles/config/fish/personal.fish ]
	source ~/.dotfiles/config/fish/personal.fish
end

zoxide init fish | source

# personal files in bin are always highest priority
set -gx PATH "$HOME/.dotfiles/bin" $PATH
