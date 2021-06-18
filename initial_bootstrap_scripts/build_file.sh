#!/bin/bash

THIS_PACKAGE=file
. "$(dirname "$0")/validate_and_cd_into.sh"

mkdir build
pushd build
  LD=$HOST_LD CFLAGS= CC=$CC_FOR_BUILD ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make -j"$PARALLEL_JOBS"
popd
./configure --prefix="/usr" --host="$LFS_TGT"
make FILE_COMPILE=$(pwd)/build/src/file -j"$PARALLEL_JOBS"
make DESTDIR="$LFS_SYSROOT" install
