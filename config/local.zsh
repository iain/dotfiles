# color codes in zsh (used mainly in prompt coloring)
export reset=$'%{\e[0;00m%}'
export gray=$'%{\e[0;90m%}'
export red=$'%{\e[0;31m%}'
export green=$'%{\e[0;32m%}'
export yellow=$'%{\e[0;33m%}'
export blue=$'%{\e[0;34m%}'
export magenta=$'%{\e[0;35m%}'
export cyan=$'%{\e[0;36m%}'
export white=$'%{\e[0;37m%}'

# Load RVM
if [ -s ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
  __rvm_project_rvmrc
fi

function ___rvm_prompt {
  if [ -s ~/.rvm/bin/rvm-prompt ]; then
    echo "$gray$(~/.rvm/bin/rvm-prompt)$reset"
  fi
}

# rbenv support
if which rbenv > /dev/null; then
  eval "$(rbenv init - zsh --no-rehash)";
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# be like emacs (and bash)
bindkey -e

# Set prompt
setopt prompt_subst
PROMPT='$(~/.dotfiles/script/prompt $?)'
RPROMPT='$(___rvm_prompt)'

export SHELL=$(which zsh)

# Stuff I don't really understand, but I was told to use

setopt append_history share_history histignorealldups
setopt autocd beep extendedglob nomatch
setopt hist_ignore_all_dups
unsetopt auto_name_dirs

autoload -Uz compinit
compinit

# http://chneukirchen.org/blog/archive/2011/02/10-more-zsh-tricks-you-may-not-know.html
# Move to where the arguments belong.
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^b" after-first-word

# make the home key work
bindkey '^[[7~' beginning-of-line

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# color!
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=00;31'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# http://chneukirchen.org/blog/archive/2011/02/10-more-zsh-tricks-you-may-not-know.html
# Complete in history with M-/, M-,
zstyle ':completion:history-words:*' list no
zstyle ':completion:history-words:*' menu yes
zstyle ':completion:history-words:*' remove-all-dups yes
bindkey "\e/" _history-complete-older
bindkey "\e," _history-complete-newer
