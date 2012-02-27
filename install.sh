#!/bin/bash

parse_git_branch() {
	git-branch --no-color 2> /dev/null \
		| sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) -- /'
}

DIR=/home/hans/.dotfiles/

mkdir -p ~/dotfiles_old

cd $DIR
for i in *
do
	mv ~/.$i ~/dotfiles_old/
	ln -s $DIR/$i ~/.$i
done

rm ~/.make.sh
