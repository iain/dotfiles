case $TERM in (*xterm*|ansi)

  # set the terminal title and tab title when switching directories
  function settab { print -Pn "\e]1;%~\a" }
  function settitle { print -Pn "\e]2;%~\a" }
  function chpwd { settab; settitle }
  settab; settitle

  # For new tabs don't show the previews command from history,
  # it has nothing to do with you just yet.
  NEWLY_OPENED="yes"

  # sets the tab title to the currently running command (not process)
  preexec() {
    NEWLY_OPENED=""
    print -Pn "\e]0;★ $1\a"
  }

  # sets the tab title to the result of the last run command (not process)
  # when last command has failed, also set the title because it's important
  precmd() {
    success=$?
    if [ -z $NEWLY_OPENED ]; then
      cmd=`history | tail -n 1 | sed 's/[^0-9]*[0-9]*\ \ //'`
      if [[ $success != 0 ]]; then
        print -Pn "\e]0;✘ $cmd\a"
      else
        print -Pn "\e]1;✔ $cmd\a"
        settitle
      fi
    else
      # When using iTerm2's "Reuse Previous Tab Directory", it doesn't load the right ruby/gemset
      # This is the safest and easiest way I could think about to "fix" it
      # rvm reload
    fi
  }
  ;;
esac
