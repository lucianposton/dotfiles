#!/bin/sh

set -e

urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -o -f
    urxvtc "$@"
fi
