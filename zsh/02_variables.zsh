# Load self compiled shit too
export PATH="/usr/local/bin:$PATH"

# Load Node.js bin:
export PATH="/usr/local/share/npm/bin:$PATH"

# colors (used mainly in prompt coloring)
RESET=$'%{\e[1;00m%}'
GRAY=$'%{\e[0;90m%}'
RED=$'%{\e[0;31m%}'
GREEN=$'%{\e[0;32m%}'
YELLOW=$'%{\e[0;33m%}'
BLUE=$'%{\e[0;34m%}'
MAGENTA=$'%{\e[0;35m%}'
CYAN=$'%{\e[0;36m%}'
WHITE=$'%{\e[0;37m%}'

# I am single minded
export EDITOR=mvim
export VISUAL=mvim
export GIT_EDITOR=mvim
export SVN_EDITOR=mvim

# color!
export CLICOLOR=1

# actually just here for zsh colored completion
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'
