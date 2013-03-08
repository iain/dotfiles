# rbenv support
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

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

alias rr='mkdir -p tmp && touch tmp/restart.txt'

# Ruby Enterprise Edition Optimalizations
export RUBY_HEAP_MIN_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# open stuff with mvim
export BUNDLER_EDITOR='mvim'
export GEMEDITOR='mvim'

# cucumber shortcuts, because I can save seconds not using rake for this
alias c='cucumber -r features'
alias wip='c --profile wip'

alias specdoc='time rspec -fd'

alias s='rspec --require ~/.osx_settings/rspec_focus --order default --color --tty'

# checks to see if bundler is installed, if it isn't it will install it
# checks to see if your bundle is complete, runs bundle install if it isn't
# if any arguments have been passed it will run it with bundle exec
function b() {
  gem which bundler > /dev/null 2>&1 || gem install bundler --no-ri --no-rdoc
  bundle check || bundle install
  if [ $1 ]; then
    bundle exec $*
  fi
}

alias be='bundle exec'

# I've switched to pry
alias irb='pry'


function run-tests() {
  if [ ! -p test-commands ]; then
    mkfifo test-commands
  fi
  while true; do
    cmd="$(cat test-commands)"
    echo
    echo -n "Running: "
    echo $cmd
    echo
    sh -c $cmd
  done
}
