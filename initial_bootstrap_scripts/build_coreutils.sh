#!/bin/bash

THIS_PACKAGE=coreutils
. "$(dirname "$0")/validate_and_cd_into.sh"

CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="/usr" --host="$LFS_TGT" --enable-install-program=hostname
make -j"$PARALLEL_JOBS"
make DESTDIR="${LFS_SYSROOT}" install
