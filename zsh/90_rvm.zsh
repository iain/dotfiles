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
