# Load RVM
if [ -s ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
  __rvm_project_rvmrc
  RPROMPT="$gray$(~/.rvm/bin/rvm-prompt)$reset"
fi
