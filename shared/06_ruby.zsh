# Rails 2.X shortcuts
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias sdb='script/dbconsole'

# Rails 3 shortcuts
alias r='./script/rails'

# Run rake db:migrate and fill the test db, so autotest doesn't have to restart
alias rdm='rake db:migrate db:test:prepare'

# I already know in which directoy I am, thank you
# alias rake='rake --silent'

alias rr='touch tmp/restart.txt'

# Ruby Enterprise Edition Optimalizations
export RUBY_HEAP_MIN_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# open stuff with mvim
export BUNDLER_EDITOR='mvim'
export GEMEDITOR='mvim'

# cucumber shortcuts, because I can save seconds not using rake for this
alias c='bundle exec ./script/cucumber -r features'
alias wip='c --profile wip'

alias specdoc='time rspec -fd'

function b() {
  gem which bundler > /dev/null 2>&1 || gem install bundler --no-ri --no-rdoc
  bundle check || bundle install
}
