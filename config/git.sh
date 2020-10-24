export GPG_TTY=`tty`

alias aa='git add --all && git status -s'
alias amend='git commit --amend'
alias c='git commit'
alias cdb='base=$(git rev-parse --show-cdup) && cd $base'
alias d='git diff'
alias dc='git diff --cached'
alias g12='git rev-parse HEAD | cut -c 1-12'
alias gf='git fetch --all && git status -s'
alias gl="git log"
alias glp='git log -p'
alias gpb='git-publish-branch'
alias gpr='gh pr create --draft --fill'
alias p='git push'
alias re='git restore'
alias s='git status -s'
alias st='git status'
alias sw='git switch'
alias up='git pull --ff-only'
alias upstash='git stash && git pull --ff-only && git stash pop'

# Trying to lose the habit of using `git checkout`, by disabling it.
function git {
  if [ "$1" = "checkout" ]; then
    echo "\033[0;31mStop using 'git checkout'.\033[0;0m Instead, use these:"
    echo "- git switch     # for branches, create with -c"
    echo "- git restore    # for files"
    echo "Waiting \033[0;36m10 seconds\033[0;0m as punishment"
    sleep 30
    command git $*
  fi
  command git $*
}

# things that might be handy, but I'm not currently using

# alias g='git'
# alias co='git checkout'
