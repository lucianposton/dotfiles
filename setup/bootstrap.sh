#!/bin/bash

set -e

should_ignore() {
   ignored_files=(
       "."
       ".."
       ".git"
       ".gitignore"
       ".gitmodules"
       ".gitattributes"
       "setup"
   )

   for f in ${ignored_files[@]}
   do
       if [[ $f == $1 ]]
       then
           return 0
       fi
   done

   return 1
}

DOTFILESDIR="$( cd "$( dirname "$0" )" && git rev-parse --show-toplevel )"
OLDDOTFILESDIR="$HOME/dotfiles_old"

if [[ -e "$OLDDOTFILESDIR" ]]
then
    read -n 1 -ep "$OLDDOTFILESDIR backup already exists. Continue? (y/n) "
    [[ "$REPLY" =~ ^[Nn]$ ]] && exit 1
fi

mkdir -p "$OLDDOTFILESDIR"

install_as_symlink() {
    SOURCE_FILE="$1"
    TARGET_FILE="$2"
    # shenanigans because BSD mv doesn't have --backup
    if [[ -e "$TARGET_FILE" ]]; then #&& mv -v "$TARGET_FILE" "$OLDDOTFILESDIR/"
        TARGET_FILE_BASENAME="$(basename "$TARGET_FILE")"
        TARGET_FILE_BACKUP="$OLDDOTFILESDIR/$TARGET_FILE_BASENAME"
        if [[ ! -e "$TARGET_FILE_BACKUP" ]]; then
            # file does not exist in the backup directory
            mv -v "$TARGET_FILE" "$TARGET_FILE_BACKUP"
        else
            NUM_SUFFIX=2
            while [[ -e "${TARGET_FILE_BACKUP}.${NUM_SUFFIX}" ]]; do
                NUM_SUFFIX=$(( NUM_SUFFIX + 1 ))
            done
            mv -v "$TARGET_FILE" "${TARGET_FILE_BACKUP}.${NUM_SUFFIX}"
        fi
    fi

    echo "Creating symlink '$TARGET_FILE' to source file '$SOURCE_FILE'"
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
}

cd "$DOTFILESDIR"

# Changes globbing so that * matches include .* files but exclude . and ..
GLOBIGNORE=".:.."

# Remove others' permissions (mainly just for .ssh directory).
chmod o-rwx *

for i in *
do
    should_ignore "$i" && continue
    install_as_symlink "$DOTFILESDIR/$i" "$HOME/$i"
done

read -n 1 -ep "Update submodules? (y/n) "
[[ "$REPLY" =~ ^[Yy]$ ]] && cd "$DOTFILESDIR" && git submodule update --recursive --init

git config --local --replace-all include.path '../setup/gitconfig_secret_filters' gitconfig_secret_filters

if [[ `uname` == 'Darwin' ]]; then
    # OSX uses a different font directory
    chmod -a "group:everyone deny delete" "$HOME/Library/Fonts" || echo "Skipping ACL removal on '$HOME/Library/Fonts'"
    install_as_symlink "$HOME/.fonts" "$HOME/Library/Fonts"
    echo "Probably need to reboot for fonts to take effect..."

    xcode-select --install
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update

    # TODO install gnu utils
    # http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
    #brew install --default-names coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
    # ...
    #ant cairo coreutils curl findutils fontforge gfortran git gnu-sed gnuplot john
    #lua neovim p7zip tcptraceroute tmux tree watch wget wine winetricks
    #brew tap homebrew/dupes
    #brew install grep --default-names
    #brew install findutils --default-names
    #brew install gnu-indent --default-names
    #brew install gnu-sed --default-names
    #brew install gnutls --default-names
    #brew install grep --default-names
    #brew install gnu-tar --default-names
    #brew install gawk
fi

