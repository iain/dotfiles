function unmouse --description 'Stop the terminal echoing mouse position as input'
  # A full-screen program (tmux with `mouse on`, Claude Code, any TUI) switches
  # the terminal into mouse-reporting mode and is meant to switch it back on
  # exit. Killed outright -- or cut off mid-session when SSH drops -- it never
  # does, so the terminal keeps reporting and the shell echoes the events as
  # input: `66;16M67;17M68;18M...`. Those are SGR reports, ESC[<btn;col;rowM,
  # with the escape prefix swallowed by the line editor, leaving col;row.
  #
  # 1000 clicks, 1002 drags, 1003 any motion; 1006 and 1015 are the encodings.
  set -l seq '\033[?1000l\033[?1002l\033[?1003l\033[?1006l\033[?1015l'

  # Inside a multiplexer, printing this to stdout achieves nothing: screen and
  # tmux each parse it in their own terminal emulator and consume it, so it
  # never reaches the real terminal that is actually stuck. (Confirmed for
  # screen -- the only escape that made it to the display was screen's own
  # cursor move.) So bypass the multiplexer and write to the pty its *client*
  # is attached to: that is the far end of the ssh connection, i.e. ghostty.
  set -l targets

  if set -q argv[1]
    # Explicit target, bare or absolute: `unmouse ttys005`, `unmouse /dev/ttys005`.
    for t in $argv
      if string match -q '/*' -- $t
        set -a targets $t
      else
        set -a targets /dev/$t
      end
    end
  else if set -q TMUX
    set -a targets (tmux display-message -p '#{client_tty}' 2>/dev/null)
  else if set -q STY
    # $STY is <pid>.<session>. The attached client runs as lowercase `screen`
    # on a real tty; the detached backend shows as uppercase SCREEN on `??`.
    set -l session (string split -m1 . -- $STY)[2]

    set -l ttys
    set -l cmds
    for line in (ps -ax -o tty=,command= 2>/dev/null)
      # Regex-capture rather than split/rejoin: other processes' arguments get
      # parsed as options otherwise, and something on this box runs --minimal.
      set -l m (string match -r '^(\S+)\s+(screen\s.*)$' -- $line)
      test (count $m) -eq 3; or continue
      test "$m[2]" = '??'; and continue
      set -a ttys $m[2]
      set -a cmds $m[3]
    end

    for i in (seq (count $ttys))
      string match -q -- "*$session*" $cmds[$i]; and set -a targets /dev/$ttys[$i]
    end

    # A session reattached with a bare `screen -r` has no name on its command
    # line to match against, so fall back to the sole client if there is one.
    if not set -q targets[1]; and test (count $ttys) -eq 1
      set targets /dev/$ttys[1]
    end

    if not set -q targets[1]
      echo "unmouse: in screen session '$session' but found no attached client tty." >&2
      echo "unmouse: locate it with  ps -ax -o tty,command | grep 'screen -'" >&2
      echo "unmouse: then pass it explicitly, e.g.  unmouse ttys005" >&2
      return 1
    end
  end

  if not set -q targets[1]
    # Not multiplexed: stdout already is the terminal.
    printf $seq
    return
  end

  for t in $targets
    if not test -w $t
      echo "unmouse: $t is not writable" >&2
      return 1
    end
    printf $seq > $t
    echo "unmouse: reset mouse reporting on $t"
  end

  # If this starts happening often enough to be a chore, automate it: emitting
  # the same sequence from a `fish_postexec` handler clears the mode every time
  # you return to the prompt. That is safe precisely because the prompt only
  # draws when no TUI is in the foreground, so it cannot stomp on a running
  # program that legitimately wants the mouse. Note it would need the same
  # multiplexer-aware targeting as above to be any use inside screen or tmux.
end
