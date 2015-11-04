#!/bin/zsh

typeset -A names
names[no]="global default"
names[fi]="normal file"
names[rs]="reset"
names[di]="directory"
names[ln]="symbolic link"
names[mh]="multihardlink"
names[pi]="named pipe"
names[so]="socket"
names[do]="door"
names[bd]="block device"
names[cd]="character device"
names[or]="orphan symlink"
names[mi]="missing file"
names[su]="set uid"
names[sg]="set gid"
names[ca]="capability"
names[tw]="sticky other writable"
names[ow]="other writable"
names[st]="sticky"
names[ex]="executable"

for i in ${(s.:.)LS_COLORS}
do
    key=${i%\=*}
    color=${i#*\=}
    name=${names[(e)$key]-$key}
    printf '\e[%sm%s\e[m\n' $color $name
done
