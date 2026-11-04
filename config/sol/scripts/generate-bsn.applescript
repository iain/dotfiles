# name: Generate BSN
# icon: 🪪
# Copies a test BSN to the clipboard. Not a shell script: Sol pops up an output
# panel for those.
set bsn to do shell script quoted form of (POSIX path of (path to home folder) & ".local/bin/bsn")
set the clipboard to bsn
