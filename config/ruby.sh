# Load a Ruby version manager
# if [[ -a /usr/local/share/chruby/chruby.sh ]]; then
#   source /usr/local/share/chruby/chruby.sh
#   source /usr/local/share/chruby/auto.sh
# elif which rbenv > /dev/null; then
#   eval "$(rbenv init - zsh --no-rehash)";
# elif [ -s ~/.rvm/scripts/rvm ]; then
#   source ~/.rvm/scripts/rvm
#   __rvm_project_rvmrc
# fi

# Ruby Optimalizations
# export RUBY_HEAP_MIN_SLOTS=1100000 (obsolete in Ruby 2.1)
# export RUBY_GC_HEAP_INIT_SLOTS=1100000
# export RUBY_GC_MALLOC_LIMIT=110000000
# export RUBY_HEAP_FREE_MIN=20000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# export MALLOC_ARENA_MAX=2

# Ruby aliases
alias r='rails'
alias b='bundle install'
alias be='bundle exec'
alias cu='cucumber'
alias rr='mkdir -p tmp && touch tmp/restart.txt'
alias wip='cucumber --profile wip'

# uses spring if available,
# otherwise bundle exec
# otherwise real command
function _bundle_exec() {
  if [ -f "./bin/spring" ]; then
    ./bin/spring $*
  elif [ -f "Gemfile" ]; then
    bundle exec $*
  else
    command $*
  fi
}

function rails() {
  _bundle_exec rails $*
}

# the following overrides existing ruby commands to hook up into Spring
# this might not be to your liking.

function rspec() {
  _bundle_exec rspec $*
}

function rake() {
  _bundle_exec rake $*
}

function cucumber() {
  _bundle_exec cucumber $*
}

function rspec_focus() {
  _bundle_exec rspec --require ~/.dotfiles/script/rspec_focus --order default --color $*
}
