# encodings
set -Ux LANG     "en_US.UTF-8"
set -Ux LANGUAGE "en_US.UTF-8"
set -Ux LC_ALL   "en_US.UTF-8"
set -Ux LC_CTYPE "en_US.UTF-8"

# setting $PATH
set -Ux PATH $PATH "/usr/local/sbin"
set -Ux PATH $PATH "/usr/local/bin"
set -Ux PATH $PATH "/usr/local/opt/openssl/bin"
set -Ux PATH $PATH "/usr/local/opt/postgresql/bin"
set -Ux PATH $PATH "$HOME/.dotfiles/bin"

set -Ux JAVA_HOME "/Library/Java/Home"

# configur prefered editor
set -Ux EDITOR         "vim"
set -Ux GIT_EDITOR     $EDITOR
set -Ux SVN_EDITOR     $EDITOR
set -Ux VISUAL         "mvim"
set -Ux BUNDLER_EDITOR $VISUAL
set -Ux GEMEDITOR      $VISUAL
set -Ux VIM_APP_DIR    "/usr/local/opt/macvim"
set -Ux MANPAGER       "col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

# ls
set -Ux CLICOLOR 1
set -Ux LS_COLORS "no=00:fi=00:di=34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;35:*.rb=00;31"
set -Ux EXA_COLORS "da=30:ur=37:gr=37:tr=37:uu=33:di=34"
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
set -Ux GPG_TTY (tty)

# git abbreviations
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
abbr -a up    "git pull"

# ruby abbreviations
abbr -a b  "bundle"
abbr -a be "bundle exec"
abbr -a cu "cucumber"
abbr -a r  "rails"

# stop cucumber spam
set -x CUCUMBER_PUBLISH_QUIET "true"

starship init fish | source
zoxide init fish | source
source /usr/local/opt/asdf/asdf.fish

# ignored file, might not be there
# this is where I put secret tokens
if [ -f ~/.dotfiles/config/personal.fish ]
	source ~/.dotfiles/config/personal.fish
end
