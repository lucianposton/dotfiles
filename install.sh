#!/bin/bash

set -ex

parse_git_branch() {
	git branch --no-color 2> /dev/null \
		| sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) -- /'
}

mkdir -p ~/dotfiles_old

DotfilesDir=$HOME/dotfiles/
OldDotfilesDir=$HOME/dotfiles_old/

cd $DotfilesDir
for i in *
do
	mv ~/.$i $OldDotfilesDir/
	ln -s $DotfilesDir/$i ~/.$i
done

rm ~/.make.sh
