alias g='git'
alias c='git commit'
alias p='git push'
alias cdb='base=$(git rev-parse --show-cdup) && cd $base'
alias st='git status'
alias status='git status'
alias co='git checkout'
alias checkout='git checkout'
alias ci='git commit'
alias commit='echo "Use c"'
alias amend='git commit --amend'
alias up='git up'
alias upstash='git stash && git pull --ff-only && git stash pop'
alias br='git branch'
alias branch='git branch'
alias lg='git log -p'
alias ll='git l'
alias la='git la'
alias aa='git add --all && git status -sb'
alias d='git diff'
alias df='git diff'
alias dc='git diff --cached'
alias f='git fetch'
alias fetch='git fetch'
alias gf='git fetch && git status'
alias push='git push'
alias po='powder open'

# unstage and by making it a function it will autocomplete files
unstage() {
  git reset HEAD -- $*
  echo
  git status
}

function github-init () {
  git config branch.$(git-branch-name).remote origin
  git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
}

function github-url () {
  git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
}

# Seems to be the best OS X jump-to-github alias from http://tinyurl.com/2mtncf
function github-go () {
  open $(github-url)
}
