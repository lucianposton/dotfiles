# MacPorts Installer addition on 2009-02-22_at_15:50:55: adding an appropriate PATH variable for use with MacPorts.

# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# /usr/local/bin first for homebrew
export PATH=/usr/local/bin:$PATH

export CLICOLOR="true"
export LS_COLORS='di=35:fi=0:ln=31:pi=4:so=4:bd=4:cd=33:or=31:*.deb=90'

export PROMPT=$'
%{\e[0;31m%}[ %{\e[0;36m%}%M %{\e[0;31m%}: %{\e[0;32m%}%d%{\e[0;31m%} ]
%{\e[0;33m%}%n%{\e[0m%} > '
export P4CONFIG=.p4config
export PATH=/apollo/env/SDETools/bin:/apollo/bin:$PATH

alias ls='ls --color'
alias bb='brazil-build'
alias s="cd /workplace"
alias h="cd ~"
alias star="ssh stargazer.corp.lab126.com"
alias ent="ssh enterprise.corp.lab126.com"
alias m="sudo mount -t vfat /dev/sdc1 /mnt/us"
alias u="sudo umount /mnt/us"
alias vi=vim
alias svn="/apollo/env/SDETools/subversion-1.6/bin/svn"
alias scratch="ssh -X 10.57.162.6"
#stty erase 
stty erase 

if [ -e $HOME/dotfiles_local/.profile_custom ]
then
	. $HOME/dotfiles_local/.profile_custom
fi

