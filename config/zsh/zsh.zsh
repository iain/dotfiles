setopt append_history share_history extended_glob hist_ignore_all_dups
setopt correct

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -e

bindkey '^[[H' beginning-of-line           # home key
bindkey '^[[F' end-of-line                 # end key
bindkey "${terminfo[kdch1]}" delete-char   # delete key does what is should do
bindkey "${terminfo[kpp]}"   backward-word # PageUp goes back a word
bindkey "${terminfo[knp]}"   forward-word  # PageDown goes forward a word

# Make C-B move to the 2nd word
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^b" after-first-word

export reset=$'%{\e[0;00m%}'
export gray=$'%{\e[0;90m%}'
export red=$'%{\e[0;31m%}'
export green=$'%{\e[0;32m%}'
export yellow=$'%{\e[0;33m%}'
export blue=$'%{\e[0;34m%}'
export magenta=$'%{\e[0;35m%}'
export cyan=$'%{\e[0;36m%}'
export white=$'%{\e[0;37m%}'

setopt prompt_subst
PROMPT='$(~/.dotfiles/script/lprompt.sh $?)'
RPROMPT='$(~/.dotfiles/script/rprompt.sh $?)'
