#!/bin/bash

set -ev

echo "outdated. See https://wiki.gentoo.org/wiki/Project:Prefix/Bootstrap"
exit 99

if [ -z "$EPREFIX" ]; then
    echo "You must first export EPREFIX to indicate where to install the prefix"
    exit 1
fi

export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"

./bootstrap-prefix.sh $EPREFIX tree
./bootstrap-prefix.sh $EPREFIX/tmp make
./bootstrap-prefix.sh $EPREFIX/tmp wget
./bootstrap-prefix.sh $EPREFIX/tmp sed
./bootstrap-prefix.sh $EPREFIX/tmp coreutils || ./bootstrap-prefix.sh $EPREFIX/tmp coreutils6
./bootstrap-prefix.sh $EPREFIX/tmp findutils5
./bootstrap-prefix.sh $EPREFIX/tmp tar || ./bootstrap-prefix.sh $EPREFIX/tmp tar22
./bootstrap-prefix.sh $EPREFIX/tmp patch
./bootstrap-prefix.sh $EPREFIX/tmp grep
./bootstrap-prefix.sh $EPREFIX/tmp gawk
./bootstrap-prefix.sh $EPREFIX/tmp bash
./bootstrap-prefix.sh $EPREFIX/tmp zlib
./bootstrap-prefix.sh $EPREFIX/tmp python
./bootstrap-prefix.sh $EPREFIX portage

echo "initial bootstrap complete"
sleep 10

emerge -1 sed
emerge -1 --nodeps bash
emerge --oneshot --nodeps sys-apps/baselayout-prefix
emerge --oneshot --nodeps app-arch/xz-utils
emerge --oneshot --nodeps sys-devel/m4
emerge --oneshot --nodeps sys-devel/flex
emerge --oneshot --nodeps sys-devel/bison
emerge --oneshot --nodeps sys-devel/binutils-config
emerge patch
hash -r
emerge --oneshot --nodeps sys-devel/binutils
emerge --oneshot --nodeps sys-devel/gcc-config
emerge --oneshot --nodeps "=sys-devel/gcc-4.2*" || emerge --oneshot --nodeps "=sys-devel/gcc-4.1*"
hash -r
emerge --oneshot sys-apps/coreutils
emerge --oneshot sys-apps/findutils
emerge --oneshot app-arch/tar
emerge --oneshot sys-apps/grep
emerge --oneshot sys-devel/patch
emerge --oneshot sys-apps/gawk
emerge --oneshot sys-devel/make
emerge --oneshot sys-libs/zlib
emerge --oneshot --nodeps sys-apps/file
emerge --oneshot --nodeps app-admin/eselect
emerge --oneshot app-misc/pax-utils
emerge --oneshot "<net-misc/wget-1.13.4-r1"
hash -r
env FEATURES="-collision-protect" emerge --oneshot sys-apps/portage
rm -Rf $EPREFIX/tmp/*
hash -r
emerge --sync || $EPREFIX/usr/sbin/emerge-webrsync
emerge "<dev-libs/mpc-0.9"
env USE=-git emerge -u system
echo 'USE="unicode nls"' >> $EPREFIX/etc/make.conf
echo 'CFLAGS="-O2 -pipe"' >> $EPREFIX/etc/make.conf
echo 'CXXFLAGS="${CFLAGS}"' >> $EPREFIX/etc/make.conf
gcc-config 1
hash -r
emerge portage
emerge -e system
hash -r

$EPREFIX/usr/sbin/makewhatis -u
cd $EPREFIX/usr/portage/scripts
./bootstrap-prefix.sh $EPREFIX startscript
$EPREFIX/usr/sbin/dispatch-conf
