. ~/.osx_settings/.general.sh
. ~/.osx_settings/.vcs.sh
. ~/.osx_settings/.aliases.sh
. ~/.osx_settings/.ruby.sh
. ~/.osx_settings/.ssh_autocompletion.sh

# Load project aliases, every directory inside these will become an alias
PROJECT_PARENT_DIRS[0]="$HOME"
PROJECT_PARENT_DIRS[1]="$HOME/Projects"
. ~/.osx_settings/.project_aliases.sh
