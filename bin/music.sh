#!/usr/bin/env sh
# vim: set ft=c:

# Usage: music.sh [PARAM1] [PARAM2]
#
# Optionally accepts two parameters that will override the two strings
# used to generate notes. Each parameter must be 8 characters long.

PARAM1=${1:-'BY}6YB6%'}
PARAM2=${2:-'Qj}6jQ6%'}

blue=`tput setaf 4`
green=`tput setaf 2`
white=`tput setaf 7`
b=`tput bold`
reset=`tput sgr0`
echo "${blue}${b}==>${white} Using '${green}"$PARAM1"${white}' and '${green}"$PARAM2"${white}' to generate notes.${reset}"
tail -n "+$(( ${LINENO}+1 ))" "${0}" | sed -e "s/@PARAM1@/${PARAM1}/" -e "s/@PARAM2@/${PARAM2}/" | gcc -xc - && ./a.out | aplay ; exit 0

#include <unistd.h>
#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>

int unlink_self() {
    char path_buffer[PATH_MAX];
    int result = readlink("/proc/self/exe", path_buffer, sizeof(path_buffer)/sizeof(path_buffer[0]));
    if (result < 0) {
        perror("readlink");
        exit(EXIT_FAILURE);
    } else if (result >= sizeof(path_buffer)/sizeof(path_buffer[0])) {
        fprintf(stderr, "Crazy long path to exe");
        exit(EXIT_FAILURE);
    } else {
        path_buffer[result] = '\0';
        remove(path_buffer);
    }
}

int amp(int i, int filter, int time, int shift) {
    char* param1 = "@PARAM1@";
    char* param2 = "@PARAM2@";
    char* choice;
    if (3 & i>>16) {
        choice = param1;
    } else {
        choice = param2;
    }

    int result = choice[time%8];
    result += 51;
    result *= i;
    result >>= shift;
    result &= filter;
    result &= 3;
    result <<= 4;

    return result;
}

int main(int argc, char* argv) {
    unlink_self();

    int speed = 1;
    int time;
    for(time = 0; 1; time += speed) {
        int n = time >> 14;
        int s = time >> 17;

        int instruments =
            amp(time, 1,   n,                  12) +
            amp(time, s,   n^time>>13,         10) +
            amp(time, s/3, n+((time>>11)%3),   10) +
            amp(time, s/5, 8+n-((time>>10)%3), 9) +
            0;

        putchar(instruments);
    }
}
