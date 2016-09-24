export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Setting the editor of choice
export EDITOR='mvim'
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

# Paths
export PATH="/usr/local/bin:$PATH"
if [[ -d "$HOME/.rvm/bin" ]]; then
  export PATH=$PATH:$HOME/.rvm/bin
fi
if [[ -d "/usr/local/sbin" ]]; then
  export PATH=$PATH:/usr/local/sbin
fi
# Load Node.js bin:
export PATH="/usr/local/share/npm/bin:$PATH"
export NODE_PATH="/usr/local/lib/node_modules"

# Our own bin directory is more important than the rest
export PATH=$HOME/.dotfiles/bin:$PATH
export PATH=$HOME/.bin:$PATH

# General aliases
alias l='ls -FhAlo'
alias ltr='ls -lt'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias less='less -R' # color codes in less
alias m='mvim --remote-silent' # open file in existing mvim
alias grep='grep --colour=always'
alias g='git'

# Ruby aliases
alias rdm='rake db:migrate db:test:prepare'
alias rr='mkdir -p tmp && touch tmp/restart.txt'
alias cu='bundle exec cucumber -r features'
alias wip='cu --profile wip'
alias specdoc='time rspec -fd'
alias rspec_focus='_spring rspec --require ~/.dotfiles/script/rspec_focus --order default --color'
alias be='bundle exec'
alias irb='pry'
alias guard='bundle exec guard'
alias fs='foreman start'

# Git aliases
alias c='git commit'
alias p='git push'
alias cdb='base=$(git rev-parse --show-cdup) && cd $base'
alias st='git status'
alias status='git status'
alias co='git checkout'
alias checkout='git checkout'
alias ci='git commit'
alias commit='echo "Use c"'
alias amend='git commit --amend'
alias up='git up'
alias upstash='git stash && git pull --ff-only && git stash pop'
alias br='git branch'
alias branch='git branch'
alias lg='git log -p'
alias ll='git l'
alias la='git la'
alias aa='git add --all && git status -sb'
alias d='git diff'
alias df='git diff'
alias dc='git diff --cached'
alias f='git fetch'
alias fetch='git fetch'
alias gf='git fetch && git status'
alias push='git push'
alias po='powder open'


# uses spring if there is a binstub, otherwise, just use bundle exec
function _spring() {
  if [ -f "./bin/spring" ]; then
    ./bin/spring $*
  else
    bundle exec $*
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

# checks to see if bundler is installed, if it isn't it will install it
# checks to see if your bundle is complete, runs bundle install if it isn't
# if any arguments have been passed it will run it with bundle exec
function b() {
  gem which bundler > /dev/null 2>&1 || gem install bundler --no-ri --no-rdoc
  bundle check || bundle install -j4
  if [ $1 ]; then
    bundle exec $*
  fi
}

# unstage and by making it a function it will autocomplete files
unstage() {
  git reset HEAD -- $*
  echo
  git status
}

function github-init () {
  git config branch.$(git-branch-name).remote origin
  git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
}

function github-url () {
  git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
}

# Seems to be the best OS X jump-to-github alias from http://tinyurl.com/2mtncf
function github-go () {
  open $(github-url)
}

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

function psr {
  FIRST=`echo ruby | sed -e 's/^\(.\).*/\1/'`
  REST=`echo ruby | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep -v "Pow" | grep "[$FIRST]$REST"
}

# this disables `git commit -m` if you want to get rid of your crappy commit message habit.

# function git {
#   args="$@";
#   if [[ -z $(grep "commit" <<< "$args") ]]; then
#     /usr/local/bin/git "$@"
#   else
#     message=$(echo "$args" | ruby -e 'ARGF.read.split(/\s/).find { |arg| arg =~ /\A-[^-]/ ? arg.include?("m") : arg.include?("--message") } ? exit(1) : exit(0)')
#     if [[ $? == 0 ]]; then
#       /usr/local/bin/git "$@"
#     else
#       echo "Don't use -m."
#     fi
#   fi
# }

# Use VIM for reading manpages.
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"
export SKIP=AuthorEmail,AuthorName
