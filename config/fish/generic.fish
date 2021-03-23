export CLICOLOR=1

if which gls > /dev/null
  alias ls='gls --group-directories-first --color=auto'
end

export LS_COLORS='no=00:fi=00:di=34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;35:*.rb=00;31'
if which exa > /dev/null
  export EXA_COLORS="da=30:ur=37:gr=37:tr=37:uu=33:di=34"
  alias l='exa --long --group-directories-first --git --all --grid --time-style=long-iso'
else
  alias l='ls -FhAlo'
end

# pagers
alias tf='tail -f -n 200'
alias less='less -R' # color codes in less

# grep
if which rg > /dev/null
  alias grep='rg' # experiment
  export RIPGREP_CONFIG_PATH=~/.ripgreprc
else
  alias grep='grep --colour=always'
end

alias m='mvim --remote-silent'
alias v='mvim --remote-tab-silent .'

export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nmap q :q<cr>' -"
