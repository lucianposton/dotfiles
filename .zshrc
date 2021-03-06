# After .zshenv, .zprofile, and /etc/zshrc, this file is sourced by
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
HISTSIZE=101000
SAVEHIST=100000

# TODO move to common location for use in bash
alias x='exit'
alias cls='printf "\033c"'
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
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wanipinfo='curl ipinfo.io'
alias trim="ex +'bufdo!%s/\s\+$//e' -scxa"
alias retab="ex +'set ts=4' +'bufdo retab' -scxa"
alias bell='echo -n -e "\a"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias rcp="rsync -a --human-readable --progress --verbose"

setopt autocd
setopt extendedglob
setopt correctall
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode
autoload -Uz history-search-end;
zle -N history-beginning-search-backward-end history-search-end;
zle -N history-beginning-search-forward-end history-search-end;
bindkey '^[k' history-beginning-search-backward-end
bindkey '^[j' history-beginning-search-forward-end
bindkey '^[h' vi-backward-word
bindkey '^[l' vi-forward-word
bindkey '^[d' delete-word
bindkey '^[^H' backward-delete-word
bindkey '^[^?' backward-delete-word
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward
#bindkey '^[/' history-incremental-pattern-search-backward

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Replace some annoying vi widgets
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

fpath=($HOME/share/zsh/site-functions $fpath)
fpath=($HOME/dotfiles_local/share/zsh/site-functions $fpath)

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

mailpath=(~/.maildir/new /var/mail/$USER /var/spool/mail/$USER)

REPORTTIME=10
#TIMEFMT=" Elapsed: %*E User: %U Kernel: %*S"

source $HOME/dotfiles/setup/submodules/powerline/powerline/bindings/zsh/powerline.zsh

unicode_lookup () { grep "^0*$(printf '%X' "$((0x$1))");" <(curl -s http://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt) | awk 'BEGIN {FS=";"} {print $2}'; }

function g () { git "$@" }
for-each-git () { while IFS= read -r -d '' d; do; echo && pushd "$d"/.. && "$@" < /dev/tty; popd -q || continue; done < <(find . -maxdepth 2 -follow -name .git -type d -print0) }
for-each-git-deep () { while IFS= read -r -d '' d; do; echo && pushd "$d"/.. && "$@" < /dev/tty; popd -q || continue; done < <(find . -follow -name .git -type d -print0) }

fancy-for() { local i s="$1"; shift; for i; do eval "$s"; done; }
for-wine-flavors() { fancy-for 'local flavor=$i; eval '"$1"';' vanilla staging }
for-wine-dirs() { for-wine-flavors 'local dir="wine-$flavor"; (cd "$dir" || exit; '"$1"')' }
for-wine-dirs-bump() { for-wine-dirs 'cp wine-$flavor-9999.ebuild wine-$flavor-'"$1"'.ebuild && g a . && repoman manifest && repoman commit -m "app-emulation/wine-$flavor: bump to '"$1"'"' }

startx() { command startx "$@" &> /tmp/startx.log }
xinit() { command xinit "$@" &> /tmp/xinit.log }

md() { mkdir -p "$@" && cd "$@" }
f() { find . -iname "$@" }

# Hook Functions
precmd () {
  echo -n -e "\a"
}
