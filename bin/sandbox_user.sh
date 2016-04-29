#!/usr/bin/env bash

# https://wiki.gentoo.org/wiki/Simple_sandbox

set -e

[ $# -ne 4 ] && echo "Usage: $0 category/package sandbox_user_name sandbox_user_home user_name" && exit 1

pkg=$1
sbuser=$2
home=$3
user=$4

useradd --home=$home --create-home --shell /bin/false --user-group $sbuser
chgrp $user $home
chmod 770 $home

echo "$user ALL=($sbuser) NOPASSWD: ALL" > /etc/sudoers.d/$sbuser

qlist "$pkg" | xargs chmod u-x,g-w,o-o
qlist "$pkg" | xargs chown root:$sbuser

bashrc="/etc/portage/env/$pkg"

mkdir -p $(dirname $bashrc)

echo "post_src_install() {
  chmod -R u-x,g-w,o-o \${D}
  chown -R root:$sbuser \${D}
}" > $bashrc
