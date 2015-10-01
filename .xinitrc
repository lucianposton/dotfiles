# .xinitrc

xmodmap $HOME/.xmodmaprc

xsetroot -cursor_name left_ptr

xinput --set-prop 'pointer:Razer Razer Naga' 'Device Accel Constant Deceleration' 2 || echo "Razer Naga device not found"

# https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
export _JAVA_AWT_WM_NONREPARENTING=1

# pulseaudio doesn't work without consolekit
# https://bugs.gentoo.org/show_bug.cgi?id=321181
exec ssh-agent -- ck-launch-session xmonad
#exec startxfce4
#scrotwm

