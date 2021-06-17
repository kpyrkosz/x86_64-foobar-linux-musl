#!/bin/bash

THIS_PACKAGE=bash
. "$(dirname "$0")/validate_and_cd_into.sh"
# TODO CC_FOR_BUILD should be detected at bootstrap time (the one used to build clang itself)
CC_FOR_BUILD=clang CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="/usr" --host="$LFS_TGT" --without-bash-malloc
make -j"$PARALLEL_JOBS"
make DESTDIR="${LFS_SYSROOT}" install
