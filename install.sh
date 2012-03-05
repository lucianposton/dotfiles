#!/bin/bash

parse_git_branch() {
	git branch --no-color 2> /dev/null \
		| sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) -- /'
}

DotfilesDir=$HOME/dotfiles/

mkdir -p ~/dotfiles_old

cd $DotfilesDir
for i in *
do
	mv ~/.$i ~/dotfiles_old/
	ln -s $DotfilesDir/$i ~/.$i
done

rm ~/.make.sh
