ANSI_BLACK='\033[30m'
ANSI_BLACK_BOLD='\033[0;30;1m'
ANSI_RED='\033[31m'
ANSI_RED_BOLD='\033[0;31;1m'
ANSI_GREEN='\033[32m'
ANSI_GREEN_BOLD='\033[0;32;1m'
ANSI_YELLOW='\033[33m'
ANSI_YELLOW_BOLD='\033[0;33;1m'
ANSI_BLUE='\033[34m'
ANSI_BLUE_BOLD='\033[0;34;1m'
ANSI_MAGENTA='\033[35m'
ANSI_MAGENTA_BOLD='\033[0;35;1m'
ANSI_CYAN='\033[36m'
ANSI_CYAN_BOLD='\033[0;36;1m'
ANSI_WHITE='\033[37m'
ANSI_WHITE_BOLD='\033[0;37;1m'
ANSI_RESET='\033[0m'

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000

export PATH=$HOME/bin:$PATH

export EDITOR=vim

#export EPREFIX=/home/poston/gentoo
#export PATH=${EPREFIX}/bin:$PATH

export P4CONFIG=.p4config
export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export PATH=/apollo/env/SDETools/bin:$PATH
#export PATH=/apollo/env/eclipse-3.7/bin:$PATH
#export PATH=$PATH:/apollo/env/envImprovement/bin

export REPORTTIME=10
#export TIMEFMT=" Elapsed: %*E User: %U Kernel: %*S"

alias grep='grep --color=auto'
alias ls='ls --color=auto'

setopt autocd
setopt extendedglob
setopt correctall
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history


bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^R' history-incremental-search-backward
#bindkey '^R' history-incremental-pattern-search-backward
#bindkey -M vicmd '?' history-incremental-search-backward

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Replace some annoying vi widgets
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

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

git-recursive () { find . -maxdepth 2 -follow -name .git -type d -exec sh -c "(cd {}/.. && echo && pwd && git $@)" \; }
git-recursive-deep () { find . -follow -name .git -type d -exec sh -c "(cd {}/.. && echo && pwd && git $@)" \; }

