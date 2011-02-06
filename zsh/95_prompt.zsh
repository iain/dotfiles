setopt prompt_subst
function error-prompt() {
  if [[ $? != 0 ]]; then
    msg="error!"
    echo "$RED$msg$RESET "
  fi
}

PROMPT='$(error-prompt)$(git-prompt)'
RPROMPT='$(rvmprompt)'
