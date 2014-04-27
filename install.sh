#!/bin/bash

set -e

function should_ignore {
   ignored_files=(
       "."
       ".."
       ".git"
       ".gitignore"
       "add.sh"
       "install.sh"
       "submodules"
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
    read -n 1 -ep "$OldDotfilesDir exists and files will be overwritten. Continue? (y/n) "
    [[ $REPLY =~ ^[Nn]$ ]] && exit 1
fi

mkdir -p $OldDotfilesDir

cd $DotfilesDir
for i in .* *
do
    should_ignore $i && continue
    [[ ! -e $HOME/$i ]] || mv $HOME/$i $OldDotfilesDir/
    ln -s $DotfilesDir/$i $HOME/$i
done

read -n 1 -ep "Update submodules? (y/n) "
[[ $REPLY =~ ^[Nn]$ ]] && exit 0
cd $DotfilesDir && git submodule update --recursive --init

# TODO install fonts for powerline

# TODO install homebrew
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
