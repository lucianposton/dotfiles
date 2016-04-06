#!/bin/bash

set -ev

echo "outdated. See https://wiki.gentoo.org/wiki/Project:Prefix/Bootstrap"
exit 99

if [ -z "$EPREFIX" ]; then
    echo "You must first export EPREFIX to indicate where to install the prefix"
    exit 1
fi

export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"

./bootstrap-prefix.sh $EPREFIX latest_tree
./bootstrap-prefix.sh $EPREFIX/tmp make
./bootstrap-prefix.sh $EPREFIX/tmp wget
./bootstrap-prefix.sh $EPREFIX/tmp sed
./bootstrap-prefix.sh $EPREFIX/tmp python
./bootstrap-prefix.sh $EPREFIX/tmp coreutils6
./bootstrap-prefix.sh $EPREFIX/tmp findutils
./bootstrap-prefix.sh $EPREFIX/tmp tar15
./bootstrap-prefix.sh $EPREFIX/tmp patch9
./bootstrap-prefix.sh $EPREFIX/tmp grep
./bootstrap-prefix.sh $EPREFIX/tmp gawk
./bootstrap-prefix.sh $EPREFIX/tmp bash
./bootstrap-prefix.sh $EPREFIX portage

hash -r
emerge -1 sed
emerge --oneshot --nodeps bash
emerge --oneshot pax-utils
emerge --oneshot --nodeps xz-utils
emerge --oneshot --nodeps "<wget-1.13.4-r1"
emerge --oneshot --nodeps sys-apps/baselayout-prefix
emerge --oneshot --nodeps sys-devel/m4
emerge --oneshot --nodeps sys-devel/flex
emerge --oneshot --nodeps sys-devel/bison
emerge --oneshot --nodeps sys-devel/binutils-config

# only for gcc 4.2.1
emerge --oneshot --nodeps sys-devel/binutils-apple
emerge --oneshot --nodeps sys-devel/gcc-config
emerge --oneshot --nodeps sys-devel/gcc-apple
hash -r
emerge --oneshot sys-apps/coreutils
emerge --oneshot sys-apps/findutils
emerge --oneshot app-arch/tar
emerge --oneshot sys-apps/grep
emerge --oneshot sys-devel/patch
emerge --oneshot sys-apps/gawk
emerge --oneshot sys-devel/make
emerge --oneshot --nodeps sys-apps/file
emerge --oneshot --nodeps app-admin/eselect
env FEATURES="-collision-protect" emerge --oneshot sys-apps/portage
rm -Rf $EPREFIX/tmp/*
hash -r

emerge --sync || $EPREFIX/usr/sbin/emerge-webrsync
env USE=-git emerge -u system
echo 'USE="unicode nls"' >> $EPREFIX/etc/make.conf
echo 'CFLAGS="-O2 -pipe -march=nocona"' >> $EPREFIX/etc/make.conf
echo 'CXXFLAGS="${CFLAGS}"' >> $EPREFIX/etc/make.conf

# bug 407573
gcc-config 1

emerge portage
emerge -e system
hash -r

$EPREFIX/usr/sbin/makewhatis -u
cd $EPREFIX/usr/portage/scripts
./bootstrap-prefix.sh $EPREFIX startscript
$EPREFIX/usr/sbin/dispatch-conf
