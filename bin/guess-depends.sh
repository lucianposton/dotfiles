#!/usr/bin/env bash

set -e

initialize_colors2() {
    set +e
    red=`tput setaf 1`
    green=`tput setaf 2`
    yellow=`tput setaf 3`
    blue=`tput setaf 4`
    magenta=`tput setaf 5`
    cyan=`tput setaf 6`
    white=`tput setaf 7`
    b=`tput bold`
    u=`tput sgr 0 1`
    ul=`tput smul`
    xl=`tput rmul`
    stou=`tput smso`
    xtou=`tput rmso`
    dim=`tput dim`
    reverse=`tput rev`
    reset=`tput sgr0`
    set -e
}

msg_info_heading() {
    echo "${blue}${b}==>${white} $1${reset}"
}

msg_info() {
    echo "${blue}${b}==>${reset} $1"
}

msg_success_heading() {
    echo "${green}${b}==> $1${reset}"
}

msg_success() {
    echo "${green}${b}==>${reset}${green} $1${reset}"
}

msg_error() {
    echo "${red}==> ${u}${b}${red}$1${reset}"
}

msg_error_minor() {
    echo "${red}==>${reset} $1"
}

msg_green() {
    echo "${green}$1${reset}"
}

msg_red() {
    echo "${red}$1${reset}"
}

msg_check() {
    echo "${green}${bold} ✓${reset}  $1${reset}"
}

msg_uncheck() {
    echo "${red}${bold} ✘${reset}  $1${reset}"
}

msg_notification() {
    echo "${red}${dim} ➜${reset}  $1${reset}"
}


expand_origin() {
    local escaped_origin=$(sed 's_/_\\/_g' <<< "$1")
    sed -e 's/$\({ORIGIN}\|ORIGIN\)/'"$escaped_origin"'/g'
}

parse_lib_paths() {
    sed -e 's|^.*\[\([^]]*\)\].*$|\1|'
}

begins_with() {
    case $2 in "$1"*) true;; *) false;; esac;
}

is_in_path() {
    local path="$1"
    local dirs="$2"
    [ -n "$dirs" ] || return
    IFS=: read -r -d '' -a dirs_array < <(printf '%s:\0' "$dirs")
    for dir in "${dirs_array[@]}"; do
        # how does ld.so handle symlinks?
        if begins_with "$dir" "$path"; then
            find "$dir" -maxdepth 1 -name "${path#$dir/}" > /dev/null && return
        fi
    done
    false
}

is_found() {
    local libpath="$1"
    [ "$libpath" != "not found" ]
}

is_in_special_paths() {
    local soname="$1"
    local path="$2"
    local rpath="$3"
    local runpath="$4"

    # man ld.so logic
    if grep '/' <<< "$soname"; then
        # TODO Rare case ...
        exit 17
    fi
    if [ -n "$rpath" ] && [ -z "$runpath" ]; then
        is_in_path "$path" "$rpath" && return
    fi
    if [ -n "$LD_LIBRARY_PATH" ]; then
        if is_in_path "$path" "$LD_LIBRARY_PATH"; then
            msg_notification "Warning: $soname loaded from \$LD_LIBRARY_PATH"
            true
            return
        fi
    fi
    if [ -n "$runpath" ]; then
        is_in_path "$path" "$runpath" && return
    fi
    false
}

find_lib_dependencies() {
    local from_index="$1"
    local current_dependency_depth="$2"
    local path="$3"
    local rpath="$4"
    local origin="$( cd "$( dirname "$path" )" && pwd )"
    local runpath="$(readelf -d "$path" | grep RUNPATH | \
        parse_lib_paths | expand_origin "$origin")"

    local i
    for ((i=$from_index; i<${#LINES_ARRAY[@]}; ++i)); do
        local line="${LINES_ARRAY[i]}"
        local leading_spaces="$(echo "$line" | sed -e 's|\( *\).*|\1|')"
        local lib_dependency_depth="$(( ${#leading_spaces}/4 ))"
        local soname="$(echo "${line%% =>*}" | sed -e 's/^[[:space:]]*//')"
        local libpath="${line#*=> }"
        [ "$lib_dependency_depth" -gt "$current_dependency_depth" ] && continue
        if [ "$lib_dependency_depth" -lt "$current_dependency_depth" ]; then
            return
        fi
        if ! is_found "$libpath"; then
            msg_error_minor "Warning: $soname not found" 1>&2
            continue
        fi
        if is_in_special_paths "$soname" "$libpath" "$rpath" "$runpath"; then
            find_lib_dependencies "$(($i+1))" "$(($current_dependency_depth+1))" "$libpath" "$rpath"
        else
            RESULTS_ARRAY+=( "$current_dependency_depth:$libpath" )
            LIBPATHS_RESULTS_ARRAY+=( "$libpath" )
        fi
    done
}

usage() {
    msg_info_heading "Usage: ${script_name} INPUT_ELF_FILE"
    echo
    msg_info "If the binary normally requires LD_LIBRARY_PATH to run, export"
    msg_info "that env variable before running this script."
}

main() {
    local script_name=$(basename "$0")
    initialize_colors2
    if [ $# -eq 0 ];
    then
        usage
        exit 2
    fi
    if [ -n "$LD_LIBRARY_PATH" ]; then
        msg_notification "Warning: \$LD_LIBRARY_PATH is set. Libs in \$LD_LIBRARY_PATH" 1>&2
        msg_notification "         will be assumed to be provided by the binary's package." 1>&2
        msg_notification "         Libs loaded from \$LD_LIBRARY_PATH will be excluded" 1>&2
        msg_notification "         from the set of dependencies in the output." 1>&2
    fi

    # Need absolute path for lddtree to output absolute paths
    local path="$(readlink -f $1)"
    if [ ! -f "$path" ]; then
        msg_error "$path is not a regular file"
        usage
        exit 3
    fi

    # In linux, RPATH is used for all children in dependency tree. RUNPATH is
    # only for the specific ELF binary containing the RUNPATH. Different
    # behavior on non-linux.
    local origin="$( cd "$( dirname "$path" )" && pwd )"
    local rpath="$(readelf -d "$path" | grep RPATH | \
        parse_lib_paths | expand_origin "$origin")"

    declare -a RESULTS_ARRAY
    declare -a LIBPATHS_RESULTS_ARRAY
    declare -a LINES_ARRAY
    mapfile -t LINES_ARRAY < <(lddtree "$path")
    #for ((i=0; i<${#LINES_ARRAY[@]}; ++i)); do
    #    echo "$i" "${LINES_ARRAY[i]}"
    #done
    find_lib_dependencies "1" "1" "$path" "$rpath"
    #echo
    #echo '------'
    #for ((i=0; i<${#RESULTS_ARRAY[@]}; ++i)); do
    #    echo "$i" "${RESULTS_ARRAY[i]}"
    #done

    msg_info "Note: @system packages, such as sys-devel/gcc and sys-libs/glibc"
    msg_info "will be included in the results. These do not need to be included"
    msg_info "in DEPEND."
    echo
    msg_info "Note: If a program calls external programs, e.g. via execve() or"
    msg_info "system(), those external programs will not be captured by this script."
    echo
    msg_info "Note: Indirect dependencies may be satisfied due to packages pulling"
    msg_info "in additional dependencies due to its USE flags. Looking at the"
    msg_info "output of lddtree may help identify these indirect dependencies and"
    msg_info "USE flags."
    echo
    msg_info "Note: Some programs load additional libraries at runtime via the"
    msg_info "dlopen() API. These can be identified by using lsof on the running"
    msg_info 'program, e.g. `lsof -p PID_OF_PROCCESS | awk "{print $9}" | grep '"'\\.so'\`,"
    msg_info "and comparing the loaded libraries of the process to the output of"
    msg_info "lddtree. Libraries listed in lsof but not listed in lddtree may have"
    msg_info "been loaded in this manner."
    echo
    msg_success_heading "Looking up packages..."
    printf "%s\0" "${LIBPATHS_RESULTS_ARRAY[@]}" | xargs -0 equery b
}

main "$@"
