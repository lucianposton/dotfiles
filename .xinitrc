xmodmap $HOME/.xmodmaprc

#xsetroot -cursor_name left_ptr

# pulseaudio doesn't work without consolekit
# https://bugs.gentoo.org/show_bug.cgi?id=321181
exec ssh-agent -- ck-launch-session xmonad
#exec startxfce4
#scrotwm
