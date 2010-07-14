# Ruby Enterprise Edition Optimalizations
export RUBY_HEAP_MIN_SLOTS=600000
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Awesome Sweetness (tm)
PROJECT_PARENT_DIRS[0]="$HOME"
PROJECT_PARENT_DIRS[1]="$HOME/Projects"
. ~/Projects/osx_settings/.general.sh
. ~/Projects/osx_settings/.aliases.sh
. ~/Projects/osx_settings/.git.sh
. ~/Projects/osx_settings/.git_autocompletion.sh
. ~/Projects/osx_settings/.project_aliases.sh
. ~/Projects/osx_settings/.rails.sh
. ~/Projects/osx_settings/.ruby.sh
. ~/Projects/osx_settings/.ssh_autocompletion.sh
. ~/Projects/osx_settings/.vcs.sh

# RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
PS1="\[\033[1;32;30m\]\$(~/.rvm/bin/rvm-prompt i v g) $PS1"
