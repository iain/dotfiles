# Load self compiled shit too
export PATH="/usr/local/bin:$PATH"

# Load Node.js bin:
export PATH="/usr/local/share/npm/bin:$PATH"

# colors (used mainly in prompt coloring)
export reset=$'%{\e[0;00m%}'
export gray=$'%{\e[0;90m%}'
export red=$'%{\e[0;31m%}'
export green=$'%{\e[0;32m%}'
export yellow=$'%{\e[0;33m%}'
export blue=$'%{\e[0;34m%}'
export magenta=$'%{\e[0;35m%}'
export cyan=$'%{\e[0;36m%}'
export white=$'%{\e[0;37m%}'

# I am single minded
export EDITOR=vim
export VISUAL=mvim
export GIT_EDITOR=vim
export SVN_EDITOR=vim

# color!
export CLICOLOR=1

# actually just here for zsh colored completion
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'
