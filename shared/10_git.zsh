alias s='git status --short'
alias st='git status'
alias co='git checkout'
alias ci='git commit'
alias up='git pull --ff-only'
alias br='git branch'
alias lg='git log -p'
alias aa='git add --all'
alias d='git diff'
alias df='git diff'
alias dc='git diff --cached'
alias f='git fetch'
alias gf='git fetch && git status'

alias cdb='base=$(git rev-parse --show-cdup) && cd $base'

alias git-scoreboard="git log | grep '^Author' | sort | uniq -ci | sort -r"
