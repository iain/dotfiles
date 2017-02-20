export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="/usr/local/bin:$PATH"
export PATH=$HOME/.dotfiles/bin:$PATH

# =============================================================================
# General config
# =============================================================================

if which gls > /dev/null; then
  alias ls='gls --group-directories-first --color=auto'
fi
alias l='ls -FhAlo'
alias ltr='ls -lt'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias less='less -R' # color codes in less
alias m='mvim --remote-silent' # open file in existing mvim
alias grep='grep --colour=always'

# Use VIM for reading manpages.
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

# grep for a process, this ps aux | grep, but without finding itself
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# List all ruby processes
function psr {
  FIRST=`echo ruby | sed -e 's/^\(.\).*/\1/'`
  REST=`echo ruby | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep -v "Pow" | grep "[$FIRST]$REST"
}

# =============================================================================
# Git config
# =============================================================================

alias g='git'
alias c='git commit'
alias p='git push'
alias co='git checkout'
alias st='git status'
alias cdb='base=$(git rev-parse --show-cdup) && cd $base'
alias amend='git commit --amend'
alias up='git up'
alias upstash='git stash && git pull --ff-only && git stash pop'
alias lg='git log -p'
alias ll='git l'
alias la='git la'
alias aa='git add --all && git status -sb'
alias d='git diff'
alias dc='git diff --cached'
alias gf='git fetch --all && git status'
alias po='powder open'

# unstage and by making it a function it will autocomplete files
unstage() {
  git reset HEAD -- $*
  echo
  git status
}

# =============================================================================
# Ruby config
# =============================================================================

# Load a Ruby version manager
if [[ -a /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh
elif which rbenv > /dev/null; then
  eval "$(rbenv init - zsh --no-rehash)";
elif [ -s ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
  __rvm_project_rvmrc
fi

# Setting the editor of choice
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

# Ruby Optimalizations
# export RUBY_HEAP_MIN_SLOTS=1100000 (obsolete in Ruby 2.1)
export RUBY_GC_HEAP_INIT_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Ruby aliases
alias rdm='rake db:migrate db:test:prepare'
alias rr='mkdir -p tmp && touch tmp/restart.txt'
alias cu='cucumber'
alias wip='cucumber --profile wip'
alias pening='cucumber --profile pending'
alias rspec_focus='_spring rspec --require ~/.dotfiles/script/rspec_focus --order default --color'
alias be='bundle exec'
alias irb='pry'
alias guard='bundle exec guard'
alias fs='foreman start'
alias po='powder open'

# uses spring if there is a binstub, otherwise, just use bundle exec
function _spring() {
  if [ -f "./bin/spring" ]; then
    ./bin/spring $*
  elif [ -f "Gemfile" ]; then
    bundle exec $*
  else
    command $*
  fi
}

function r() {
  _spring rails $*
}

# the following overrides existing ruby commands to hook up into Spring
# this might not be to your liking.

function spring() {
  if [ -f "./bin/spring" ]; then
    ./bin/spring $*
  else
    bundle exec $*
  fi
}


function rspec() {
  _spring rspec $*
}

function rake() {
  _spring rake $*
}

function cucumber() {
  _spring cucumber $*
}
alias cucumber_focus="cucumber -p all"

# checks to see if your bundle is complete, runs bundle install if it isn't
# if any arguments have been passed it will run it with bundle exec
function b() {
  bundle check || bundle install -j4
  if [ $1 ]; then
    bundle exec $*
  fi
}
