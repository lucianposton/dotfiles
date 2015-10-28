# After /etc/profile, this file is sourced by sh and bash when the shell is a
# *login* shell. bash sources this file for *login* shells only if
# ~/.bash_profile and ~/.bash_login do not exist.
#
# Since this file is shared by multiple shells, it should not contain settings
# specifically related to any one shell.

# 027 to prevent others from reading newly created files, but also may affect
# system files created while sudo'd.
#umask 027

#stty erase 
stty erase 

# set PATH so it includes user's private bin if it exists
export PATH="$HOME/bin:$PATH"

# /usr/local/bin first for homebrew
export PATH="/usr/local/bin:$PATH"

export EDITOR="vim"

export PROMPT=$'
%{\e[0;31m%}[ %{\e[0;36m%}%M %{\e[0;31m%}: %{\e[0;32m%}%d%{\e[0;31m%} ]
%{\e[0;33m%}%n%{\e[0m%} > '

export CLICOLOR="true"
export LS_COLORS="di=35:fi=0:ln=31:pi=4:so=4:bd=4:cd=33:or=31:*.deb=90"

# Create predictable $SSH_AUTH_SOCK to enable reattached tmux/screen sessions
# to continue to use ssh-agent.
if [ -n "$SSH_AUTH_SOCK" ] ; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/.ssh_auth_sock"
    chmod go-rwx "$HOME/.ssh/.ssh_auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/.ssh_auth_sock"
fi

alias ls='ls -F --color=auto'
alias la='ls -A'
alias l='ls -lA'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias g='git'
alias prettyxml='xmllint --format -'
alias prettyjson='python -m json.tool'
alias xargs1pl="tr '\n' '\0' | xargs -0 -n1"

if [ -e "$HOME/dotfiles_local/.profile" ]
then
    . "$HOME/dotfiles_local/.profile"
fi

