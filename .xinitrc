#!/bin/sh
# .xinitrc

kill_and_daemonize () {
    pidof "$1" && killall "$1" && sleep 4
    (exec "$@") &
}


case "${1}" in
failsafe)
    xterm -geometry 80x50+494+51 &
    xterm -geometry 80x20+494-0 &
    exec xterm -geometry 80x66+0+0 -name login
;;
xfce)
    command=startxfce4
;;
"")
    # https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
    export _JAVA_AWT_WM_NONREPARENTING=1

    #trayer-srg &
    #trayer --edge top --align right --expand true --SetDockType true --SetPartialStrut true --tint 0x000000 --alpha 0 --transparent true --height 17 --width 10 --margin 175 &
    #stalonetray --geometry 1x1+1660+0 -i 16 -bg '#212121' --window-type dock --grow-gravity NE --icon-gravity E &
    xsetroot -cursor_name left_ptr

    #parcellite &

    #compton -b
    compton -b --paint-on-overlay
    #xloadimage -onroot -fullscreen image.png
    #nitrogen --restore
    #feh --bg-scale xplanet.png
    nice -n 19 xwinwrap -ni -o 1 -ov -fs -s -st -sp -b -nf -- /usr/lib/misc/xscreensaver/cubicgrid -root -window-id WID -delay 60000 -speed 0.25 -tick 25 -bigdots &
    #nice -n 19 xwinwrap -ni -o 0.5 -ov -fs -s -st -sp -b -nf -- /usr/lib/misc/xscreensaver/cubicgrid -root -window-id WID -delay 60000 -speed 0.25 -tick 25 -bigdots &
    #BinaryRing, BlockTube, CloudLife, Drift, Euler2D, Flurry, GLSlideshow,
    # Intermomentary, Photopile, Piecewise, Rocks, StarWars, TimeTunnel,
    # WhirlWindWarp, Wormhole

    start-pulseaudio-x11

    #TODO Setup XDG crap, autostart apps, etc. See /etc/xdg/xfce4/xinitrc

    command=xmonad
;;
*)
    command="$1"
;;
esac

sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

##setxkbmap se
##setxkbmap -option terminate:ctrl_alt_bksp &  # C-M-<Backspace> kills X.
#xkbcomp -I$HOME/conf/xkb $HOME/conf/xkb/hhkb2.xkb $DISPLAY
##setxkbmap -option ctrl:swapcaps

# These should take care of ck-launch-session, dbus-launch, etc by launching
# them or adding them to $command
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Local-machine-specific stuff goes here
if [ -d "$HOME"/dotfiles_local/xinitrc.d ]; then
    for f in "$HOME"/dotfiles_local/xinitrc.d/?*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# TODO move to local xinitrc.d
#xboxdrv -s --dpad-as-button
xinput --set-prop 'pointer:Razer Razer Naga' 'Device Accel Constant Deceleration' 2 || echo "Razer Naga device not found"
xinput --set-prop 'pointer:Logitech K400 Plus' 'Evdev Scrolling Distance' -2, -2, 1 || echo "Logitech K400 Plus device not found"

# TODO
#PYTHONPATH=/usr/lib/python3.4/site-packages powerline-daemon -q

if command -v ssh-agent >/dev/null ; then
    command="ssh-agent -- $command"
fi
echo command=$command
$command &
WM_PID=$!

xset s 3600 # BlankTime aka screensaver
xset dpms 3900 3960 4020 # StandbyTime SuspendTime OffTime

urxvtd -f -o
nice -n 19 redshift &

wait "$WM_PID"

