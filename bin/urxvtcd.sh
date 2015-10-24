#!/bin/sh
urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -o -f
    urxvtc "$@"
fi
