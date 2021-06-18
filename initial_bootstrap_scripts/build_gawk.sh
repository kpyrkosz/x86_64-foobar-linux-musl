#!/bin/bash

THIS_PACKAGE=gawk
. "$(dirname "$0")/validate_and_cd_into.sh"

CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="/usr" --host="$LFS_TGT"
#make -j"$PARALLEL_JOBS"
make
make DESTDIR="${LFS_SYSROOT}" install
