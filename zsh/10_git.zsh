function git-branch-name () {
  git branch 2> /dev/null | grep '^\*' | sed 's/^\*\ //'
}

function git-dirty () {
  git status 2> /dev/null | grep "nothing to commit (working directory clean)"
  echo $?
}

function git-need-to-push() {
  if pushtime=$(echo $1 | grep 'Your branch is ahead' 2> /dev/null); then
    echo "${RED}↑${RESET} "
  fi
}

function git-prompt() {
  gstatus=$(git status 2> /dev/null)
  branch=$(echo $gstatus | head -1 | sed 's/^# On branch //')
  dirty=$(echo $gstatus | sed 's/^#.*$//' | tail -2 | grep 'nothing to commit (working directory clean)'; echo $?)
  if [[ x$branch != x ]]; then
    dirty_color=$GREEN
    push_status=$(git-need-to-push $gstatus 2> /dev/null)
    if [[ $dirty = 1 ]]; then
      dirty_color=$RED
    fi
    basedir=$(git-basedir)
    subdir=$(git-subdir)
    if [ x$branch != x ]; then
      echo "$basedir %{$dirty_color%}$branch%{$RESET%} $push_status$subdir "
    fi
  else
    echo "$BLUE${PWD/$HOME/~}$RESET "
  fi
}

function git-subdir() {
  sub_dir=$(git rev-parse --show-prefix)
  sub_dir="/${sub_dir%/}"
  echo "$CYAN$sub_dir$RESET"
}

function git-basedir() {
  base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
  if [ -n "$base_dir" ]; then
    base_dir=`cd $base_dir; pwd`
  else
    base_dir=$PWD
  fi
  base_dir_basename="$(basename "${base_dir}")"
  echo "$BLUE$base_dir_basename$RESET"
}

function cdb() {
  base_dir=$(git rev-parse --show-cdup 2>/dev/null)
  cd $base_dir
}

function git-scoreboard () {
  git log | grep '^Author' | sort | uniq -ci | sort -r
}

function git-track () {
  branch=$(git-branch-name)
  code="git branch --set-upstream $branch origin/$branch"
  eval $code
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

function nhgk () {
  nohup gitk --all &
}

# some aliases
alias st='git status'
alias d='git diff'

# open gitx from the terminal
alias gitx='open /Applications/GitX.app'
