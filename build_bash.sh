#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
CC_FOR_BUILD="$CC" CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT" --without-bash-malloc
make -j"$PARALLEL_JOBS"
make install