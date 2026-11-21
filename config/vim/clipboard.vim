" Over SSH, the + register would be the remote machine's clipboard. Send yanks
" through the terminal (OSC 52) instead, so they land on the Mac in front of
" you. On macOS, Vim only uses osc52 when it's the sole clipmethod.
if !empty($SSH_CONNECTION)
  " Auto-detection queries the terminal, which herdr may not pass on
  let g:osc52_force_avail = 1
  " Ghostty's ⌘V already pastes, and an unanswered paste query blocks Vim
  let g:osc52_disable_paste = 1
  packadd osc52
  set clipmethod=osc52
endif
