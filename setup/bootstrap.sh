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

DotfilesDir=$HOME/dotfiles
OldDotfilesDir=$HOME/dotfiles_old

if [[ -e $OldDotfilesDir ]]
then
    read -n 1 -ep "$OldDotfilesDir backup already exists. Continue? (y/n) "
    [[ $REPLY =~ ^[Nn]$ ]] && exit 1
fi

mkdir -p $OldDotfilesDir

install_as_symlink() {
    source_file="$1"
    target_file="$2"
    # shenanigans because BSD mv doesn't have --backup
    if [[ -e "$target_file" ]]; then #&& mv -v "$target_file" "$OldDotfilesDir/"
        target_file_basename=$(basename "$target_file")
        target_file_backup="$OldDotfilesDir/$target_file_basename"
        if [[ ! -e "$target_file_backup" ]]; then
            # file does not exist in the backup directory
            mv -v "$target_file" "$target_file_backup"
        else
            num=2
            while [[ -e "$target_file_backup.$num" ]]; do
                (( num++ ))
            done
            mv -v "$target_file" "$target_file_backup.$num"
        fi
    fi

    echo "Creating symlink '$target_file' to source file '$source_file'"
    ln -s "$source_file" "$target_file"
}

cd $DotfilesDir
for i in .* *
do
    should_ignore $i && continue
    install_as_symlink "$DotfilesDir/$i" "$HOME/$i"
done

read -n 1 -ep "Update submodules? (y/n) "
[[ $REPLY =~ ^[Yy]$ ]] && cd $DotfilesDir && git submodule update --recursive --init

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

