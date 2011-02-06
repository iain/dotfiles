case $TERM in (*xterm*|ansi)
  preexec() {
    print -Pn "\e]0;Running: $1\a"
  }
  precmd() {
    success=$?
    cmd=`history | tail -n 1 | sed 's/[^0-9]*[0-9]*\ \ //'`
    if [[ $success != 0 ]]; then
      print -Pn "\e]0;Error: $cmd\a"
    else
      print -Pn "\e]0;Finished: $cmd\a"
    fi
  }
  ;;
esac

