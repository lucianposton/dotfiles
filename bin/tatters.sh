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
    JOB_NAME=tatters
    tatt -j "$JOB_NAME" -f "$1"
    echo sudo "./${JOB_NAME}-useflags.sh" || echo "Failed to run/find ./${JOB_NAME}-useflags.sh"
    echo sudo "./${JOB_NAME}-rdeps.sh" || echo "Failed to run/find ./${JOB_NAME}-rdeps.sh"
    echo sudo "./${JOB_NAME}-cleanup.sh" || echo "Failed to run/find ./${JOB_NAME}-cleanup"
}

parse_options() {
    # Reset in case getopts has been used previously in the shell.
    OPTIND=1

    # Initialize our own variables:
    OPT_MODE=overlay
    OPT_OVERLAY=didactic-duck

    while getopts "h?m:df:" opt; do
        case "$opt" in
            h|\?)
                echo "Usage: $(basename $0) [OPTIONS]"
                echo
                echo "   -o, --overlay [ARG] search atoms in overlay"
                echo "   -m, --match [ARG]   string to match against atoms"
                echo
                echo "   -f, --file [ARG]    Use atoms listed in file"
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

        esac
    done

    shift $((OPTIND-1))

    if [ "$1" = "--" ]; then
        shift
    fi

    if [ -n "$1" ] && [ -z "${OPT_MATCH+x}" ]; then
        OPT_MATCH=$1
    fi
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
