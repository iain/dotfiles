#!/bin/bash
exit_status=$1
result=""

function finish {
  status=$(git status 2> /dev/null)
  if [[ $? == 0 ]]; then
    git_prompt
  fi
  append $reset
  echo $result
}

function git_prompt {
  branch=$(branch_or_commit)
  time_since_last_commit
  branch
}

function branch_or_commit {
  branch=$(git branch --no-color | grep --color=never '^\*' | sed 's/^\*\ //')
  if [[ $branch == "(no"* ]]; then
    # when not on any branch, always color red
    echo "$red$(git rev-list -n 1 --abbrev-commit HEAD)"
  elif [ "$branch" == "" ]; then
    # you are not on any branch or commit
    echo "$red???"
  else
    echo $branch
  fi
}

function time_since_last_commit {
  minutes=$(minutes_since_last_commit)
  if [ "$minutes" -ne -1 ]; then
    space
    append $gray
    if [ "$minutes" -ge 518400 ]; then
      append $(($minutes/518400))
      append y
    elif [ "$minutes" -ge 43200 ]; then
      append $(($minutes/43200))
      append mo
    elif [ "$minutes" -ge 10080 ]; then
      append $(($minutes/10080))
      append w
    elif [ "$minutes" -ge 1440 ]; then
      append $(($minutes/1440))
      append d
    elif [ "$minutes" -ge 60 ]; then
      append $(($minutes/60))
      append h
    else
      append $minutes
      append m
    fi
  fi
}

function minutes_since_last_commit {
  now=`date +%s`
  last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`
  if $lastcommit ; then
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
  else
    echo "-1"
  fi
}

function append {
  result=$result$1
}

function space {
  result="$result "
}

function clean {
  echo $status | grep "working tree clean" > /dev/null
}

function branch {
  space
  if clean; then
    append $green
  else
    append $yellow
  fi
  append $branch
}

finish
