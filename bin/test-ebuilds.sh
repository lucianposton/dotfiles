#!/usr/bin/env bash

set -e

JOB_BATCH_FILE_EXT="batch"

# $1 is the script's name
create_job_dir() {
    local SCRIPT_NAME=$1
    mkdir -p /tmp/"$SCRIPT_NAME"
    mktemp -d "/tmp/${SCRIPT_NAME}/${OPT_TATT_JOB_NAME}.XXXXXXXXX"
}

# $1 is overlay name in overlays directory
list_overlay_atoms() {
    pushd ~ > /dev/null
    find overlays/"$1" -name "*.ebuild" | sed -e 's:\.ebuild$::' | cut -d '/' -f 3,5
    popd > /dev/null
}

# $1 is dir in which to create job batches
create_job_batch_files() {
    local JOB_DIR=$1
    mkdir -p "$JOB_DIR"
    if [ "$OPT_MODE" == "overlay" ]; then
        local ATOMS=$(list_overlay_atoms "$OPT_OVERLAY" | grep "$OPT_MATCH")
    elif [ "$OPT_MODE" == "file" ]; then
        local ATOMS=$(<"$OPT_FILE")
    else
        echo "Invalid mode: $OPT_MODE"
        exit 99
    fi

    while read -r ATOM; do
        if [ "$OPT_BATCH_MODE" ]; then
            echo "$ATOM" >> "${JOB_DIR}/${OPT_TATT_JOB_NAME}.${JOB_BATCH_FILE_EXT}"
        else
            local ATOM_FILENAME=$(echo "$ATOM" | sed -e 's/=//' -e 's:/:_:')
            echo "$ATOM" > "${JOB_DIR}/${ATOM_FILENAME}.${JOB_BATCH_FILE_EXT}"
        fi
    done <<< "$ATOMS"
}

# $1 is job file
# $2 is job name
start_job() {
    local JOB_FILE=$1
    local JOB_NAME=$2
    scp "$JOB_FILE" "$OPT_VM_HOSTNAME":

    ssh -t "$OPT_VM_HOSTNAME" "$(cat << EOF
        sudo eix-sync -q \
            && ./bin/update --no-sync \
            && ./bin/tatters.sh -j "$JOB_NAME" -f "$(basename $JOB_FILE)"
EOF
)"
}

# $1 is job name
save_job_report() {
    local JOB_NAME=$1
    mkdir -p "${OPT_REPORTS_DIR}/${JOB_NAME}/"
    scp "$OPT_VM_HOSTNAME":"$JOB_NAME".report "${OPT_REPORTS_DIR}/${JOB_NAME}/"
}

install_xauth() {
    ssh -T "$OPT_VM_HOSTNAME" "$(cat <<'EOF'
        ./bin/prepare_vm_x.sh
EOF
)"
}

initialize_vm() {
    VBoxManage snapshot "$OPT_VM_NAME" restorecurrent
    VBoxManage startvm "$OPT_VM_NAME" --type headless
}

poweroff_vm() {
    VBoxManage controlvm "$OPT_VM_NAME" poweroff
}

parse_options() {
    set +e
    getopt --test > /dev/null
    if [ "$?" -ne 4 ]; then
        echo "Unsupported version of getopt" 1>&2
        exit 9
    fi
    set -e

    local SHORT="o:m:f:r:n:v:bxj:h?"
    local LONG="overlay:,match:,file:,reports-dir:,vm-name:,vm-hostname:,batch,xauth,job-name:,help"
    local NORMALIZED
    NORMALIZED=$(getopt --options $SHORT --longoptions $LONG --name "$( basename $0)" -- "$@")
    if [ $? != 0 ]; then
        exit 1
    fi
    eval set -- "$NORMALIZED"

    OPT_VM_NAME=gentoo-x86
    OPT_MODE=overlay
    OPT_OVERLAY=didactic-duck
    OPT_TATT_JOB_NAME=tatters
    OPT_REPORTS_DIR=/tmp/tatt-reports

    while true; do
        case "$1" in
            -h|-\?|--help)
                echo "Usage: $(basename $0) [OPTIONS]"
                echo
                echo "   -o, --overlay [ARG]     Search atoms in overlay"
                echo "   -m, --match [ARG]       String to match against atoms"
                echo
                echo "   -f, --file [ARG]        Use atoms listed in file"
                echo
                echo "   -r, --reports-dir [ARG]  Reports output directory"
                echo
                echo "   -n, --vm-name [ARG]     Name of VM"
                echo "       --vm-hostname [ARG] Hostname of VM, if different than name"
                echo "   -b, --batch             Emerge everything in single vm session"
                echo "   -x, --xauth             Setup X11 forwarding on VM"
                echo "   -j, --job-name [ARG]    Set tatt job name"
                echo
                echo "   -h, --help              Display this help"
                exit 0
                ;;
            -o|--overlay)
                OPT_MODE=overlay
                OPT_OVERLAY=$2
                shift 2
                ;;
            -m|--match)
                OPT_MATCH=$2
                shift 2
                ;;
            -f|--file)
                OPT_MODE=file
                OPT_FILE=$2
                shift 2
                ;;
            -r|--reports-dir)
                OPT_REPORTS_DIR=$2
                shift 2
                ;;
            -n|--vm-name)
                OPT_VM_NAME=$2
                shift 2
                ;;
            --vm-hostname)
                OPT_VM_HOSTNAME=$2
                shift 2
                ;;
            -b|--batch)
                OPT_BATCH_MODE=1
                shift
                ;;
            -x|--xauth)
                OPT_INSTALL_XAUTH=1
                shift
                ;;
            -j|--job-name)
                OPT_TATT_JOB_NAME=$2
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Error parsing parameters" 1>&2
                exit 3
                ;;
        esac
    done

    if [ -n "$1" ] && [ -z "${OPT_MATCH+x}" ]; then
        OPT_MATCH=$1
    fi

    OPT_VM_HOSTNAME=${OPT_VM_HOSTNAME:-$OPT_VM_NAME}
}

main() {
    local SCRIPT_NAME=$(basename "$0")
    parse_options "$@"

    local JOB_DIR=$(create_job_dir "$SCRIPT_NAME")
    create_job_batch_files "$JOB_DIR"
    shopt -s nullglob
    local JOB_FILES=( "${JOB_DIR}"/*."${JOB_BATCH_FILE_EXT}" )
    shopt -u nullglob

    if [ "$OPT_INSTALL_XAUTH" ] && [ "${#JOB_FILES[@]}" -gt 1 ]; then
        OPT_INSTALL_XAUTH=
        echo "Disabled X11Foward setup since there are multiple jobs" 1>&2
    fi

    for JOB_FILE in "${JOB_FILES[@]}"; do
        local JOB_NAME=$(basename "$JOB_FILE" | sed -e 's/.batch//')
        echo
        echo -e "\033[0;33;40mStarting job \033[01m${JOB_NAME}\033[0m"
        echo
        initialize_vm
        start_job "$JOB_FILE" "$JOB_NAME"
        save_job_report "$JOB_NAME"

        if [ "$OPT_INSTALL_XAUTH" ]
        then
            install_xauth
        else
            poweroff_vm
        fi
    done
}

main "$@"
