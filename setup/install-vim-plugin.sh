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

die() {
    echo "${red}${bold} ✘${reset}  $@${reset}"
    exit 1
}


initialize_colors2
[[ -n "$1" ]] || die "Usage: $0 DIR [PACK_NAME]"

plugin_path="$1"
[[ -d "$plugin_path"  ]] || die "$plugin_name is not a directory."

plugin_path="$( cd "$plugin_path" && pwd )"
plugin_name="$( basename "$plugin_path" )"
[[ -n "$plugin_name" ]] || die "Failed to determine plugin_name"

dotfiles_dir="$( cd "$( dirname "$plugin_path" )" && git rev-parse --show-toplevel )"
[[ -d "$dotfiles_dir" ]] || die "Expected plugin to be in dotfiles dir, but in $dotfiles_dir"

pack_name="${2:-dotfiles}"
vim_pack_dir="$dotfiles_dir/.vim/pack/${pack_name}/start"
mkdir -p "$vim_pack_dir"
cd "$vim_pack_dir" || die "Couldn't create $vim_pack_dir"
[[ -e "$plugin_name" ]] && die "$plugin_name already exists at $vim_pack_dir/$plugin_name"

plugin_path_in_dotfiles_dir="${plugin_path##$dotfiles_dir/}"
[[ -d ../../../../"$plugin_path_in_dotfiles_dir" ]] || die ""

ln -s ../../../../"$plugin_path_in_dotfiles_dir" "$plugin_name"
if [[ "$(realpath "$plugin_name")" != "$plugin_path" ]]; then
    ls -l -F --color=auto
    die "Invalid symlink in $(pwd). $(realpath "$plugin_name") != $plugin_path"
fi

echo "${green}${bold} ✓${reset}  Installed $plugin_name to $vim_pack_dir/$plugin_name${reset}"
ls -l -F --color=auto "$vim_pack_dir/$plugin_name"
git add "$plugin_name"
