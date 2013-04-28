# Color codes for Bash
export reset="\[\033[0;0m\]"
export gray="\[\033[0;90m\]"
export red="\[\033[0;31m\]"
export green="\[\033[0;32m\]"
export yellow="\[\033[0;33m\]"
export blue="\[\033[0;34m\]"
export magenta="\[\033[0;35m\]"
export cyan="\[\033[0;36m\]"
export white="\[\033[0;37m\]"

# RVM
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
  source $HOME/.rvm/scripts/rvm
  __rvm_prompt="$gray\$(~/.rvm/bin/rvm-prompt) "
else
  __rvm_prompt=""
fi

# rbenv support
if which rbenv > /dev/null; then
  eval "$(rbenv init - bash)";
fi

function __load_prompt {
  PS1="$__rvm_prompt$(~/.dotfiles/script/prompt $?)"
}
PROMPT_COMMAND=__load_prompt

# Autocomplete SSH hosts
SSH_KNOWN_HOSTS=( $(cat ~/.ssh/known_hosts | \
  cut -f 1 -d ' ' | \
  sed -e s/,.*//g | \
  uniq | \
  egrep -v [0123456789]) )
SSH_CONFIG_HOSTS=( $(cat ~/.ssh/config | grep "Host " | grep -v "*" | cut -f 2 -d ' ') )

complete -o default -W "${SSH_KNOWN_HOSTS[*]} ${SSH_CONFIG_HOSTS[*]}" ssh

export HISTCONTROL=ignoredups # don't put duplicate lines in the history.
export HISTCONTROL=ignoreboth # ... and ignore same sucessive entries.

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
