source /usr/local/share/chruby/chruby.sh
chruby 2.3.1

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

# Ruby aliases
alias rdm='rake db:migrate db:test:prepare'
alias rr='mkdir -p tmp && touch tmp/restart.txt'
# alias cu='bundle exec cucumber -r features'
alias wip='cu --profile wip'
alias specdoc='time rspec -fd'
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

function cucumber() {
  _spring cucumber $*
}
alias cucumber_focus="cucumber -p all"

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
