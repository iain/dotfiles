# listing files
alias l='ls -halo'
alias ltr='ls -lt'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'

# editing shortcuts
alias m='mvim --remote-silent'

alias grep='grep --colour=always'

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}
