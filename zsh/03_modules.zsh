# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch
# bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/iain/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Fix backspace in vi keymap
# bindkey -M viins '^?' backward-delete-char
# bindkey -M viins '^H' backward-delete-char
# make the home key work
bindkey '^[[7~' beginning-of-line

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
