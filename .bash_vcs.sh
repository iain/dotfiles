# misc
NO_COLOR='\e[0m' #disable any colors
# regular colors
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
# emphasized (bolded) colors
EBLACK='\e[1;30m'
ERED='\e[1;31m'
EGREEN='\e[1;32m'
EYELLOW='\e[1;33m'
EBLUE='\e[1;34m'
EMAGENTA='\e[1;35m'
ECYAN='\e[1;36m'
EWHITE='\e[1;37m'
# underlined colors
UBLACK='\e[4;30m'
URED='\e[4;31m'
UGREEN='\e[4;32m'
UYELLOW='\e[4;33m'
UBLUE='\e[4;34m'
UMAGENTA='\e[4;35m'
UCYAN='\e[4;36m'
UWHITE='\e[4;37m'
# background colors
BBLACK='\e[40m'
BRED='\e[41m'
BGREEN='\e[42m'
BYELLOW='\e[43m'
BBLUE='\e[44m'
BMAGENTA='\e[45m'
BCYAN='\e[46m'
BWHITE='\e[47m'

__prompt_command() {
  local vcs base_dir sub_dir ref last_command svnversion
  sub_dir() {
    local sub_dir
    # uncomment next line for OSX:
    sub_dir=$(stat -f "${PWD}")
    # or choose next line for Ubuntu:
    #sub_dir=$(stat --printf="%n" "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }

  # http://github.com/blog/297-dirty-git-state-in-your-prompt
  function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "" # -e "\033[1;32;31m"
  }

  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(parse_git_dirty)\1/"
  }

  git_dir() {
    base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir=$(git rev-parse --show-prefix)
    sub_dir="/${sub_dir%/}"
    if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]]; then
      ref=""
      __dirty=" $(parse_git_branch)"
    else
      ref=" $(parse_git_branch)"
      __dirty=""
    fi
    vcs="git"
    alias pull="git pull"
    alias commit="git commit -v -a"
    alias push="commit ; git push"
    alias revert="git checkout"
  }
 
  svn_dir() {
    [ -d ".svn" ] || return 1
    base_dir="."
    while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
    base_dir=`cd $base_dir; pwd`
    sub_dir="/$(sub_dir "${base_dir}")"
    #ref=$(dirty_svn "$base_dir")
    if `svnversion $1 | grep -Eq 'M$'`; then
      __dirty=" `svnversion | grep -o '[0-9]*' --color=no`"
      ref=""
    else
      __dirty=""
      ref=" `svnversion | grep -o '[0-9]*' --color=no`"
    fi
    vcs="svn"
    diff_options=" | colordiff"
    if [ " $sub_dir " = " / " ]; then
    status_options=""
    else # perform a status for the entire project
      status_options=" ${base_dir}"
    fi
    alias pull="svn up"
    alias commit="svn commit"
    alias push="svn ci"
    alias revert="svn revert"

  }
 
  bzr_dir() {
    base_dir=$(bzr root 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(bzr revno 2>/dev/null)
    vcs="bzr"
    alias pull="bzr pull"
    alias commit="bzr commit"
    alias push="bzr push"
    alias revert="bzr revert"
  }

  git_dir || svn_dir || bzr_dir
 
  if [ -n "$vcs" ]; then
    alias st="$vcs status"
    alias d="$vcs diff"
    alias up="pull"
    alias cdb="cd $base_dir"
    base_dir="$(basename "${base_dir}")"
    working_on="[$base_dir] "
    __vcs_prefix="$vcs "
    __vcs_ref="$ref "
    __vcs_sub_dir="${sub_dir}"
    __vcs_base_dir="${base_dir/$HOME/~}"
  else
    __vcs_prefix=''
    __vcs_base_dir="${PWD/$HOME/~}"
    __vcs_ref=''
    __vcs_sub_dir=''
    working_on=""
  fi
 
  last_command=$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")
  __tab_title="$working_on[$last_command]"
  __pretty_pwd="${PWD/$HOME/~}"
}

PROMPT_COMMAND=__prompt_command

PS1='\[\033[1;32;34m\]${__vcs_base_dir}\[\033[1;32;31m\]${__dirty}\[\033[1;32;33m\]${__vcs_ref}\[\033[1;32;34m\]${__vcs_sub_dir}\[\033[1;32;32m\] \$\[\033[00;00m\] '
  #PS1='\[\e]2;\h:$__pretty_pwd\a\e]1;$__tab_title\a\]\[\033[1;32;34m\]${__vcs_base_dir}${__dirty}\[\033[1;32;33m\]${__vcs_ref}\[\033[1;32;34m\]${__vcs_sub_dir}\[\033[1;32;32m\] \$\[\033[00;00m\] '

# Show the currently running command in the terminal title:
# http://www.davidpashley.com/articles/xterm-titles-with-bash.html
#if [ -z "$TM_SUPPORT_PATH"]; then
#case $TERM in
#  rxvt|*term|xterm*)
#    trap 'echo -e "\e]2;$working_on$BASH_COMMAND\007\c"' DEBUG
#  ;;
#esac
#fi
