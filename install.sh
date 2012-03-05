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

mkdir -p $HOME/dotfiles_old

DotfilesDir=$HOME/dotfiles
OldDotfilesDir=$HOME/dotfiles_old

if [[ -e $OldDotfilesDir ]]
then
	read -n 1 -p "$OldDotfilesDir exists and files will be overwritten. Continue? (y/n)"
	[[ $REPLY =~ ^[Nn]$ ]] && && exit 1
fi

cd $DotfilesDir
for i in .* *
do
	should_ignore $i && continue
	mv $HOME/$i $OldDotfilesDir/
	ln -s $DotfilesDir/$i $HOME/$i
done

