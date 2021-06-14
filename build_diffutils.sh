#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz"
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make install
