#!/bin/bash

set -e

function parse_git_branch {
   git branch --no-color 2> /dev/null \
      | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) -- /'
}

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

mkdir -p ~/dotfiles_old

DotfilesDir=$HOME/dotfiles
OldDotfilesDir=$HOME/dotfiles_old

cd $DotfilesDir
for i in .* *
do
	should_ignore $i && continue

	echo -$i
	echo "mv ~/$i $OldDotfilesDir/"
	echo "ln -s $DotfilesDir/$i ~/$i"
#   mv ~/.$i $OldDotfilesDir/
#   ln -s $DotfilesDir/$i ~/.$i
done

