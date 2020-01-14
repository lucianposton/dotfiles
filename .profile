# After /etc/profile, this file is sourced by sh and bash when the shell is a
# *login* shell. bash sources this file for *login* shells only if
# ~/.bash_profile and ~/.bash_login do not exist.
#
# Since this file is shared by multiple shells, it should not contain settings
# specifically related to any one shell.
#
# See
# https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# for overview of shell startup scripts.

# 027 to prevent others from reading newly created files, but also may affect
# system files created while sudo'd.
#umask 027

#stty erase 
stty erase 

# homebrew. /usr/local/bin before standard paths to prefer homebrew binaries
export PATH="/usr/local/bin${PATH:+":$PATH"}"
#export EPREFIX="$HOME/gentoo-prefix"
#export PATH="$EPREFIX/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/games:$PATH"

# Powerline scripts dir path placed before ~/bin, so that the compiled
# powerline is before the python symlink in ~/bin
export PATH="$HOME/dotfiles/setup/submodules/powerline/scripts:$PATH"
export PYTHONPATH="${PYTHONPATH:+"$PYTHONPATH:"}$HOME/dotfiles/setup/submodules/powerline"
(powerline-daemon -q --replace &)

export EDITOR="vim"

export LESS="-R -M --shift 5"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export PROMPT=$'
%{\e[0;31m%}[ %{\e[0;36m%}%M %{\e[0;31m%}: %{\e[0;32m%}%d%{\e[0;31m%} ]
%{\e[0;33m%}%n%{\e[0m%} > '

# Generate with dircolors .dir_colors
LS_COLORS='no=00:fi=00:rs=0:di=35:mh=03:ln=36:bd=04;33;01:cd=04;33:pi=04;32:so=04;36:do=04;31;01;03:or=01;41:mi=01;41:su=41:sg=41;30:ca=30;47:ow=30;46:tw=01;07;32;41:st=30;42:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.msi=01;32:*.tar=31:*.tgz=31:*.arc=31:*.arj=31:*.taz=31:*.lha=31:*.lz4=31:*.lzh=31:*.lzma=31:*.tlz=31:*.txz=31:*.tzo=31:*.t7z=31:*.zip=31:*.z=31:*.Z=31:*.dz=31:*.gz=31:*.lrz=31:*.lz=31:*.lzo=31:*.xz=31:*.bz2=31:*.bz=31:*.tbz=31:*.tbz2=31:*.tz=31:*.deb=31:*.rpm=31:*.jar=31:*.war=31:*.ear=31:*.sar=31:*.rar=31:*.alz=31:*.ace=31:*.zoo=31:*.cpio=31:*.7z=31:*.rz=31:*.cab=31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=32:*.ps=32:*.txt=32:*.patch=32:*.diff=32:*.log=32:*.tex=32:*.doc=32:*.xml=32:*.ini=32:*.aac=34:*.au=34:*.flac=34:*.m4a=34:*.mid=34:*.midi=34:*.mka=34:*.mp3=34:*.mpc=34:*.ogg=34:*.ra=34:*.wav=34:*.axa=34:*.oga=34:*.spx=34:*.xspf=34:*.opus=34:';
export LS_COLORS

# TODO: test on bsd, set LSCOLORS
export CLICOLOR="true"

export REPORTTIME=10
#export TIMEFMT=" Elapsed: %*E User: %U Kernel: %*S"

# Create predictable $SSH_AUTH_SOCK to enable reattached tmux/screen sessions
# to continue to use ssh-agent.
#
# Could alternatively use keychain (https://wiki.gentoo.org/wiki/Keychain) or
# something like scripts from
# http://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions
if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/.ssh_auth_sock" ] ; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/.ssh_auth_sock"
    chmod go-rwx "$HOME/.ssh/.ssh_auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/.ssh_auth_sock"
fi

if [ -e "$HOME/dotfiles_local/.profile" ]
then
    . "$HOME/dotfiles_local/.profile"
fi

