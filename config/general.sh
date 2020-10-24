export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# export TZ=utc

export PATH="$HOME/.dotfiles/bin:$PATH"

# Ruby 2.7.x from Homebrew:
# export PATH="/usr/local/opt/ruby/bin:$PATH"
# export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

# Other Homebrew packages:
# export PATH="/usr/local/opt/node/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

# source $(brew --prefix asdf)/asdf.sh
# brew prefix is a little slow, so here's the direct version instead:
source /usr/local/opt/asdf/asdf.sh

# ls
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'
if which gls > /dev/null; then
  alias ls='gls --group-directories-first --color=auto'
fi
alias l='ls -FhAlo'

# pagers
alias tf='tail -f -n 200'
alias less='less -R' # color codes in less

# grep
# alias grep='grep --colour=always'
alias grep='rg' # experiment
export RIPGREP_CONFIG_PATH=~/.ripgreprc

if  [ -f /usr/bin/time ]; then
  # built-in time keyword is kinda crappy,
  # so use the installed version instead
  alias time='/usr/bin/time'
fi

# Use vim everywhere:
alias m='mvim --remote-silent' # open file in existing mvim
if which mvim > /dev/null; then
  export EDITOR='mvim'
else
  export EDITOR='vim'
fi
export GIT_EDITOR='vim'
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export BUNDLER_EDITOR=$EDITOR
export GEMEDITOR=$EDITOR
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

# export SKIP=AuthorEmail,AuthorName
export JAVA_HOME="/Library/Java/Home"

. "$HOME/.dotfiles/config/git.sh"
. "$HOME/.dotfiles/config/ruby.sh"
