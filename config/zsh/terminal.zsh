export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'
alias l='ls -FhAlo'
alias ltr='ls -lt'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias less='less -R' # color codes in less
alias m='mvim --remote-silent' # open file in existing mvim
alias grep='grep --colour=always'

# Use VIM for reading manpages.
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"
export SKIP=AuthorEmail,AuthorName

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

function psr {
  FIRST=`echo ruby | sed -e 's/^\(.\).*/\1/'`
  REST=`echo ruby | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep -v "Pow" | grep "[$FIRST]$REST"
}
