# Rails 2.X shortcuts
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias sdb='script/dbconsole'

# Rails 3 shortcuts
alias r='bundle exec rails'
alias b='gem install bundler && bundle install'

# Run rake db:migrate and fill the test db, so autotest doesn't have to restart
alias rdm='rake db:migrate db:test:prepare'

# I already know in which directoy I am, thank you
alias rake='rake --silent'

# Ruby Enterprise Edition Optimalizations
export RUBY_HEAP_MIN_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# open stuff with mvim
export BUNDLER_EDITOR='mvim'
export GEMEDITOR='mvim'

# RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
PS1="\[\033[0;32;90m\]\$(~/.rvm/bin/rvm-prompt i v g) $PS1"
