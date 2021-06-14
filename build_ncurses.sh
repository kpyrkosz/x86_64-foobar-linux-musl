#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
sed -i s/mawk// configure
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT" --with-shared --without-debug --without-ada --without-normal --enable-widec
make -j"$PARALLEL_JOBS"
make install
