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
