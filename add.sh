#!/bin/bash

if [[ $# -ne 1 || -z $1 ]]
then
	echo "Usage: $0 [FILE]"
	return -1
fi

PATHTOFILE=$1
FILE="$( basename "$PATHTOFILE" )"

if [[ ! -f $PATHTOFILE && ! -d $PATHTOFILE ]] || [[ -h $PATHTOFILE ]]
then
	echo "$FILE is not a regular file or directory."
	return -1
fi

DOTFILESDIR="$( cd "$( dirname "$0" )" && pwd )"
FILEDIR="$( cd "$( dirname "$PATHTOFILE" )" && pwd )"

if [[ $FILEDIR != $HOME ]]
then
	echo "$FILE must be in $HOME"
	return -1
fi

if [[ $DOTFILESDIR == $HOME ]]
then
	echo "cannot add files because dotfile directory is the home directory."
	return -1
fi

if [[ $DOTFILESDIR == $FILEDIR ]]
then
	echo "$FILE is already in the dotfile directory."
	return -1
fi

# check git to make sure $DOTFILESDIR is in dotfiles repo, else not so safe to
# rm -rf

TARGETPATH=$DOTFILESDIR/$FILE
echo "target $TARGETPATH"

#rm -rI $TARGETPATH
echo "rm -rI $TARGETPATH"
#mv -T $PATHTOFILE $TARGETPATH
echo "mv -T $PATHTOFILE $TARGETPATH"
#ln -s $TARGETPATH $PATHTOFILE
echo "ln -s $TARGETPATH $PATHTOFILE"
