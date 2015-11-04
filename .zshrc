# After .zshrc, .zprofile, and /etc/zshrc, this file is sourced by
# *interactive* shells.

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
HISTSIZE=16000
SAVEHIST=15000

# TODO move to common location for use in bash
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

export PATH=$PATH:$HOME/dotfiles/setup/submodules/powerline/scripts
source $HOME/dotfiles/setup/submodules/powerline/powerline/bindings/zsh/powerline.zsh

git-recursive () { find . -maxdepth 2 -follow -name .git -type d -exec sh -c "(cd {}/.. && echo && pwd && git $*)" \; }
git-recursive-deep () { find . -follow -name .git -type d -exec sh -c "(cd {}/.. && echo && pwd && git $*)" \; }

startx() { command startx "$@" &> startx.log }
