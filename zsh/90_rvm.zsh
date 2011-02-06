# Load RVM
if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi

# Define a prompt to use later on
rvmprompt() {
  echo "${GRAY}$(~/.rvm/bin/rvm-prompt)${RESET}"
}
