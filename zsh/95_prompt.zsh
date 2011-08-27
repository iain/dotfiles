setopt prompt_subst
function error-prompt() {
  if [[ $? != 0 ]]; then
    msg="error!"
    echo "$RED$msg$RESET"
  fi
}

PROMPT='$(git-prompt)'
RPROMPT='$(error-prompt) $(rvmprompt)'
