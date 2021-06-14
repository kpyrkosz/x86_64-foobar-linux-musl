#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make install
