#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "https://tukaani.org/xz/xz-5.2.5.tar.xz"
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make install
