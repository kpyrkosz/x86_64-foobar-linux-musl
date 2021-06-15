#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
sed -i s/mawk// configure

CPPFLAGS="--sysroot=$LFS_SYSROOT" CXXFLAGS="--sysroot=$LFS_SYSROOT" CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT" --with-shared --without-debug --without-ada --without-normal --enable-widec --without-pkg-config
make -j"$PARALLEL_JOBS"
make install
echo "INPUT(-lncursesw)" > $LFS_SYSROOT/usr/lib/libncurses.so
