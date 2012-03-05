HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000

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
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt gentoo
#autoload -U colors
#colors

mailpath=$HOME/.maildir/new

export P4CONFIG=.p4config
