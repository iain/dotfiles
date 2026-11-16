# name: Generate IBAN
# icon: 🏦
# Copies a Dutch test IBAN to the clipboard.
set iban to do shell script quoted form of (POSIX path of (path to home folder) & ".local/bin/iban")
set the clipboard to iban
