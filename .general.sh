# Genereric bash configuration (with color) below:
# =============================================================================

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


export SVN_EDITOR=mvim
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_colored_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "`id -u`" -eq 0 ]; then
  alias hosts='mvim /etc/hosts'
else
  alias hosts='sudo mvim /etc/hosts'
fi

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

PROJECT_PARENT_DIRS[0]="$HOME/Development/Finalist"
PROJECT_PARENT_DIRS[1]="$HOME/Development/Ruby"
PROJECT_PARENT_DIRS[2]="$HOME/Development"
. ~/src/etc/bash/bash_vcs.sh
. ~/src/etc/bash/aliases.sh
. ~/src/etc/bash/git.sh
. ~/src/etc/bash/git_autocompletion.sh
. ~/src/etc/bash/project_aliases.sh
. ~/src/etc/bash/rails.sh
. ~/src/etc/bash/ruby.sh
. ~/src/etc/bash/ssh_autocompletion.sh

# MacPorts Installer addition on 2009-05-14_at_18:43:39: adding an appropria    te PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
# MacPorts Installer addition on 2009-05-14_at_18:43:39: adding an appropria    te MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH
# Finished adapting your MANPATH environment variable for use with MacPorts.
