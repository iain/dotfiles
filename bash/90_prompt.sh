function __load_prompt {
  PS1="$__rvm_prompt$(~/.dotfiles/prompt $?)"
}
PROMPT_COMMAND=__load_prompt
