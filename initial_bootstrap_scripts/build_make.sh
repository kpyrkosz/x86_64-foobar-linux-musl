#!/bin/bash

THIS_PACKAGE=make
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix="/usr" --without-guile --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make DESTDIR="${LFS_SYSROOT}" install
