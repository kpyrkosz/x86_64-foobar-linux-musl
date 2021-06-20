#!/bin/bash

if [[ ${BOOTSTRAP_STAGE} != 2 ]]; then
	echo "Sanity check failed, expected to be called at stage 2"
	exit 1
fi

THIS_PACKAGE=ncurses
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix=/usr                \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --enable-widec
make -j"$PARALLEL_JOBS"
make install
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
