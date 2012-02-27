#!/bin/bash

if [[ $# -ne 1 || -z $1 ]]
then
	echo "Usage: $0 [FILE]"
	exit 1
fi

PATHTOFILE=$1
FILE="$( basename "$PATHTOFILE" )"

if [[ $FILE == ".git" ]]
then
	echo "You probably don't want to add $FILE"
	exit 1
fi

if [[ ! -f $PATHTOFILE && ! -d $PATHTOFILE ]] || [[ -h $PATHTOFILE ]]
then
	echo "$FILE is not a regular file or directory."
	exit 1
fi

DOTFILESDIR="$( cd "$( dirname "$0" )" && pwd )"
FILEDIR="$( cd "$( dirname "$PATHTOFILE" )" && pwd )"

if [[ $FILEDIR != $HOME ]]
then
	echo "$FILE must be in $HOME"
	exit 1
fi

if [[ $DOTFILESDIR == $HOME ]]
then
	echo "cannot add files because dotfile directory is the home directory."
	exit 1
fi

if [[ $DOTFILESDIR == $FILEDIR ]]
then
	echo "$FILE is already in the dotfile directory."
	exit 1
fi


TARGETPATH=$DOTFILESDIR/$FILE

# check git to make sure $DOTFILESDIR is in dotfiles repo, and check that
# adding file will not result in losing unsaved changes in repo
if [[ -e $TARGETPATH ]] && cd $DOTFILESDIR && ( ! git ls-files --error-unmatch $FILE > /dev/null 2> /dev/null || ! git diff --quiet $FILE )
then
	echo "$FILE has changes that haven't been commited"
	exit 1
fi

if [[ -e $TARGETPATH ]]
then
	echo "removing $TARGETPATH"
	rm -rI $TARGETPATH
fi

mv -T $PATHTOFILE $TARGETPATH
ln -s $TARGETPATH $PATHTOFILE

cd $DOTFILESDIR && git commit -a

