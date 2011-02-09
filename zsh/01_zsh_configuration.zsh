HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd beep extendedglob nomatch
setopt hist_ignore_all_dups

autoload -Uz compinit
compinit
