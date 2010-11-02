# Load self compiled shit too
export PATH="/usr/local/bin:$PATH"

# Ruby Enterprise Edition Optimalizations
export RUBY_HEAP_MIN_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

export BUNDLER_EDITOR='mvim'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Awesome Sweetness (tm)
PROJECT_PARENT_DIRS[0]="$HOME"
PROJECT_PARENT_DIRS[1]="$HOME/Projects"
. ~/.osx_settings/.general.sh
. ~/.osx_settings/.aliases.sh
. ~/.osx_settings/.git.sh
. ~/.osx_settings/.git_autocompletion.sh
. ~/.osx_settings/.project_aliases.sh
. ~/.osx_settings/.rails.sh
. ~/.osx_settings/.ruby.sh
. ~/.osx_settings/.ssh_autocompletion.sh
. ~/.osx_settings/.vcs.sh

# RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
PS1="\[\033[1;32;30m\]\$(~/.rvm/bin/rvm-prompt i v g) $PS1"
