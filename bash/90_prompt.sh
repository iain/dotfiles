function __load_prompt {
  PS1="$__rvm_prompt$(~/.osx_settings/prompt $?)"
}
PROMPT_COMMAND=__load_prompt
