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
