#!/bin/bash

THIS_PACKAGE=xz
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix="/usr" --disable-static --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make DESTDIR="${LFS_SYSROOT}" install
