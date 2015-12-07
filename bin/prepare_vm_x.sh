#!/usr/bin/env bash

# Automates preparation of some software for gentoo dev vm

run_interactive_mode() {

# Find others with "eix -c x11-wm\/"
OPTIONS=(
none
dwm
xmonad
blackbox
fluxbox
i3
awesome
)

select opt in "${OPTIONS[@]}" "Quit";
do
    case "$opt" in
        "" )
            continue;;
        Quit )
            echo "Dying"
            exit 1
            break;;
        none )
            break;;
        * )
            OPT_X_WM=$opt
            break;;
    esac
done

OPTIONS=(
xauth
xorg-server
)

select opt in "${OPTIONS[@]}" "Quit";
do
    case "$opt" in
        "" )
            continue;;
        Quit )
            echo "Dying"
            exit 1
            break;;
        xauth )
            OPT_X_PKGS="xauth"
            break;;
        xorg-server )
            OPT_X_PKGS="xorg-server rxvt-unicode virtualbox-guest-additions"
            break;;
    esac
done

echo 'Run "depmod -a" ?'
select yn in "Yes" "No";
do
    case $yn in
        Yes )
            OPT_DEPMOD=1
            break;;
        No )
            break;;
    esac
done

}

run_emerge_X_pkgs() {
    PKGS="$OPT_X_PKGS $OPT_X_WM $OPT_XTRA_PKGS"
    sudo USE="$OPT_USE" emerge -nv $PKGS
}

run_depmod() {
    # For vboxvideo
    sudo depmod -a
}

parse_options() {
    # Reset in case getopts has been used previously in the shell.
    OPTIND=1

    # Initialize our own variables:
    OPT_X_PKGS=xauth

    while getopts "h?iu:mfw:x:d" opt; do
        case "$opt" in
            h|\?)
                echo "Usage: $(basename $0) [OPTIONS]"
                echo
                echo "   -i        Run interactive mode"
                echo "   -u [ARG]  Specify USE flags"
                echo "   -m        Minimal X (only xauth for x11 forwarding)"
                echo "   -f        Full xorg-server install"
                echo "   -w [ARG]  Install specified window manager"
                echo "   -x [ARG]  Xtra packages to install"
                echo "   -d        Run depmod -a after emerge"
                echo
                echo "   -h        Display this help"
                exit 0
                ;;

            i)
                OPT_MODE=interactive
                ;;

            u)
                OPT_USE=$OPTARG
                ;;

            m)
                OPT_X_PKGS=xauth
                ;;

            f)
                OPT_X_PKGS="xorg-server rxvt-unicode virtualbox-guest-additions "
                OPT_USE=X
                ;;

            w)
                OPT_X_WM=$OPTARG
                ;;

            x)
                OPT_XTRA_PKGS=$OPTARG
                ;;

            d)
                OPT_DEPMOD=1
                ;;

        esac
    done

    shift $((OPTIND-1))

    if [ "$1" = "--" ]; then
        shift
    fi

    if [ -n "$1" ] && [ -z "${OPT_XTRA_PKGS+x}" ]; then
        OPT_XTRA_PKGS="$@"
    fi
}

main() {
    parse_options "$@"

    #[ "$(whoami)" == "root" ] || exec sudo -- "$0" "$@"

    # Script expects pwd to be its directory
    #SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
    #cd "$SCRIPTDIR"

    if [ "$OPT_MODE" == "interactive" ]
    then
        run_interactive_mode
    fi

    run_emerge_X_pkgs

    if [ "$OPT_DEPMOD" ]
    then
        run_depmod
    fi
}

main "$@"
