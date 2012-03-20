HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000

export PATH=$HOME/bin:$PATH

#export EPREFIX=/home/poston/gentoo
#export PATH=${EPREFIX}/bin:$PATH

export P4CONFIG=.p4config
export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export PATH=/apollo/env/SDETools/bin:$PATH
#export PATH=/apollo/env/eclipse-3.7/bin:$PATH
#export PATH=$PATH:/apollo/env/envImprovement/bin

alias grep='grep --color=auto'
alias ls='ls --color=auto'

setopt autocd
setopt extendedglob
setopt correctall
setopt hist_ignore_all_dups
setopt hist_ignore_space
bindkey -e

# The following lines were added by compinstall

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' select-prompt %SSelection at %p%s
zstyle ':completion::complete:*' use-cache 1
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt gentoo
autoload -U colors
#colors

mailpath=$HOME/.maildir/new

export TERM="xterm-color"
export CLICOLOR="true"
export LS_COLORS='di=35:fi=0:ln=31:pi=4:so=4:bd=4:cd=33:or=31:*.deb=90'

export PROMPT=$'
%{\e[0;31m%}[ %{\e[0;36m%}%M %{\e[0;31m%}: %{\e[0;32m%}%d%{\e[0;31m%} ]
%{\e[0;33m%}%n%{\e[0m%} > '

export P4CONFIG=.p4config
