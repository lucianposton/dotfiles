xmodmap $HOME/.xmodmaprc

#xsetroot -cursor_name left_ptr

# pulseaudio doesn't work without consolekit
# https://bugs.gentoo.org/show_bug.cgi?id=321181
exec ssh-agent -- ck-launch-session xmonad
#exec startxfce4
#scrotwm

#xinput --set-prop 'pointer:Razer Razer Naga' 'Device Accel Constant Deceleration' 2 || echo "Razer Naga device not found"
