# Need to do this so you use backspace in screen...I have no idea why
alias screen='TERM=screen screen'

# listing files
alias l='ls -alh'
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias t500='tail -n 500'
alias t1000='tail -n 1000'
alias t2000='tail -n 2000'

# svn
alias sup='svn up'
alias sst='svn st'
alias sstu='svn st -u'
alias sci='svn ci -m'
alias sdiff='svn diff | colordiff'
alias smate='svn diff | mate && svn ci'
alias sadd="sst | grep '?' | cut -c5- | xargs svn add"

# editing shortcuts
alias m='mvim --remote-silent'

# ignore svn metadata - pipe this into xargs to do stuff
alias no_svn="find . -path '*/.svn' -prune -o -type f -print"

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

alias h?="history | grep "

# display battery info on your Mac
# see http://blog.justingreer.com/post/45839440/a-tale-of-two-batteries
alias battery='ioreg -w0 -l | grep Capacity | cut -d " " -f 17-50'

# start tmux in utf8
alias t='tmux -u'

# open gitx from the terminal
alias gitx='open /Applications/GitX.app'
