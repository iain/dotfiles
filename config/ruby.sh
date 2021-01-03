function __prefer_binstub() {
  if [ -f "./bin/$1" ]; then
    ./bin/$@
  else
    command $@
  fi
}

function bundle()   { __prefer_binstub bundle   $@ }
function cucumber() { __prefer_binstub cucumber $@ }
function puma()     { __prefer_binstub puma     $@ }
function rails()    { __prefer_binstub rails    $@ }
function rake()     { __prefer_binstub rake     $@ }
function rspec()    { __prefer_binstub rspec    $@ }
function rubocop()  { __prefer_binstub rubocop  $@ }
function sidekiq()  { __prefer_binstub sidekiq  $@ }
function spring()   { __prefer_binstub spring   $@ }
function yarn()     { __prefer_binstub yarn     $@ }

# Used by vim-test to run tests in iTerm via AppleScript
function rspec_focus() {
  __prefer_binstub rspec --require ~/.dotfiles/script/rspec_focus --order default --color $*
}

alias r='rails'
alias b='bundle install'
alias be='bundle exec'
alias cu='cucumber'
alias rr='mkdir -p tmp && date > tmp/restart.txt'
alias wip='cucumber --profile wip'

export CUCUMBER_PUBLISH_QUIET=true

function rc() {
  if [ -f "./bin/console" ]; then
    ./bin/console
  elif [ -f "./bin/rails" ]; then
    ./bin/rails console
  else
    irb
  fi
}
