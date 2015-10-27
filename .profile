# After /etc/profile, this file is sourced by sh and bash when the shell is a
# *login* shell. bash sources this file for *login* shells only if
# ~/.bash_profile and ~/.bash_login do not exist.
#
# Since this file is shared by multiple shells, it should not contain settings
# specifically related to any one shell.

#umask 027

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

alias ls='ls --color=auto'

#stty erase 
stty erase 

if [ -e $HOME/dotfiles_local/.profile ]
then
    . $HOME/dotfiles_local/.profile
fi

