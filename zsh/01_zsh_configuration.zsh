HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt append_history share_history histignorealldups
setopt autocd beep extendedglob nomatch
setopt hist_ignore_all_dups
unsetopt auto_name_dirs

autoload -Uz compinit
compinit
