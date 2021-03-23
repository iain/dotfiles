function __prefer_binstub
  if [ -f "./bin/$1" ]
    ./bin/$argv
  else
    command $argv
  end
end

function bundle
  __prefer_binstub bundle $argv
end

function cucumber
  __prefer_binstub cucumber $argv
end

function puma
  __prefer_binstub puma $argv
end

function rails
  __prefer_binstub rails $argv
end

function rake
  __prefer_binstub rake $argv
end

function rspec
  __prefer_binstub rspec $argv
end

function rubocop
  __prefer_binstub rubocop $argv
end

function sidekiq
  __prefer_binstub sidekiq $argv
end

function spring
  __prefer_binstub spring $argv
end

function yarn
  __prefer_binstub yarn $argv
end

alias r='rails'
alias b='bundle install'
alias be='bundle exec'
alias cu='cucumber'
alias rr='mkdir -p tmp && date > tmp/restart.txt'
alias wip='cucumber --profile wip'

export CUCUMBER_PUBLISH_QUIET=true
