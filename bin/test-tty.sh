#!/bin/bash
#USE-Flag build tests for job tatt


echo $-

[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'

shopt -q login_shell && echo 'Bash login shell' || echo 'Not bash login shell'

[[ -o login ]] && echo 'zsh login shell' || echo 'Not zsh login shell'

[ -t 0 ] && echo '0 connected to tty' || echo '0 not connected to tty'
[ -t 1 ] && echo '1 connected to tty' || echo '1 not connected to tty'
[ -t 2 ] && echo '2 connected to tty' || echo '2 not connected to tty'

tty
