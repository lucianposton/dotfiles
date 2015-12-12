#!/usr/bin/env bash

set -e

# $1 is overlay name in overlays directory
list_overlay_atoms() {
    find overlays/"$1" -name "*.ebuild" | sed -e 's:\.ebuild$::' | cut -d '/' -f 3,5
}

# $1 is "$OPT_OVERLAY"
# $2 is "$OPT_MATCH"
start_overlay_mode() {
    ATOMS=$(list_overlay_atoms "$1" | grep "$2")
    TMPFILE=$(mktemp /tmp/tatt-tmp.XXXXXX)
    echo "$ATOMS" > "$TMPFILE"
    start_file_mode "$TMPFILE"
    rm "$TMPFILE"
}

# $1 is path to file
start_file_mode() {
    tatt -j "$OPT_JOB_NAME" -f "$1"
    sudo "./${OPT_JOB_NAME}-useflags.sh" || echo "Failed to run/find ./${OPT_JOB_NAME}-useflags.sh"
    sudo "./${OPT_JOB_NAME}-rdeps.sh" || echo "Failed to run/find ./${OPT_JOB_NAME}-rdeps.sh"
    sudo "./${OPT_JOB_NAME}-cleanup.sh" || echo "Failed to run/find ./${OPT_JOB_NAME}-cleanup"
}

parse_options() {
    # Reset in case getopts has been used previously in the shell.
    OPTIND=1

    # Initialize our own variables:
    OPT_MODE=overlay
    OPT_OVERLAY=didactic-duck

    while getopts "h?o:m:f:j:" opt; do
        case "$opt" in
            h|\?)
                echo "Usage: $(basename $0) [OPTIONS]"
                echo
                echo "   -o, --overlay [ARG] Search atoms in overlay"
                echo "   -m, --match [ARG]   String to match against atoms"
                echo
                echo "   -f, --file [ARG]    Use atoms listed in file"
                echo
                echo "   -j, --job [ARG]     Set job name"
                echo
                echo "   -h, --help          Display this help"
                exit 0
                ;;

            m)
                OPT_MATCH=$OPTARG
                ;;

            o)
                OPT_MODE=overlay
                OPT_OVERLAY=$OPTARG
                ;;

            f)
                OPT_MODE=file
                OPT_FILE=$OPTARG
                ;;

            j)
                OPT_JOB_NAME=$OPTARG
                ;;

        esac
    done

    shift $((OPTIND-1))

    if [ "$1" = "--" ]; then
        shift
    fi

    if [ -n "$1" ] && [ -z "${OPT_MATCH+x}" ]; then
        OPT_MATCH=$1
    fi

    OPT_JOB_NAME=${OPT_JOB_NAME:-tatters}
}

main() {
    parse_options "$@"

    #[ "$(whoami)" == "root" ] || exec sudo -- "$0" "$@"

    # Script expects pwd to be its directory
    #SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
    #cd "$SCRIPTDIR"

    if [ "$OPT_MODE" == "overlay" ]
    then
        start_overlay_mode "$OPT_OVERLAY" "$OPT_MATCH"
        exit
    fi

    if [ "$OPT_MODE" == "file" ]
    then
        start_file_mode "$OPT_FILE"
        exit
    fi
}

main "$@"
