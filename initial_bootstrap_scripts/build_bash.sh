#!/bin/bash

THIS_PACKAGE=bash
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix="/usr" --host="$LFS_TGT" --without-bash-malloc
make -j"$PARALLEL_JOBS"
make DESTDIR="${LFS_SYSROOT}" install
