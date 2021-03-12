# ls
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;36:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'
if which gls > /dev/null; then
  alias ls='gls --group-directories-first --color=auto'
fi
alias l='ls -FhAlo'

# pagers
alias tf='tail -f -n 200'
alias less='less -R' # color codes in less

# grep
# alias grep='grep --colour=always'
if which rg > /dev/null; then
  alias grep='rg' # experiment
  export RIPGREP_CONFIG_PATH=~/.ripgreprc
fi

if  [ -f /usr/bin/time ]; then
  # built-in time keyword is kinda crappy,
  # so use the installed version instead
  alias time='/usr/bin/time'
fi

alias m='mvim --remote-silent'
alias v='mvim --remote-tab-silent .'

export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"

# ps aux | grep, but without finding the grep process
function psg() {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep --color=always "[$FIRST]$REST"
}

# like psg, but only ruby processes
function psr() {
  FIRST=`echo ruby | sed -e 's/^\(.\).*/\1/'`
  REST=`echo ruby | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep -v "Pow" | grep --color=always "[$FIRST]$REST"
}

# import other configs:
source "$HOME/.dotfiles/config/git.sh"
source "$HOME/.dotfiles/config/ruby.sh"
