#!/bin/bash

if [[ ${BOOTSTRAP_STAGE} != 2 ]]; then
	echo "Sanity check failed, expected to be called at stage 2"
	exit 1
fi

THIS_PACKAGE=util-linux
. "$(dirname "$0")/validate_and_cd_into.sh"

mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --docdir=/usr/share/doc/util-linux-2.36.2 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run
make -j"$PARALLEL_JOBS"
make install
