#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.astron.com/pub/file/file-5.39.tar.gz"
mkdir build
pushd build
  CC=$CC_FOR_BUILD ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix=/usr --host="$LFS_TGT"
make FILE_COMPILE=$(pwd)/build/src/file -j"$PARALLEL_JOBS"
make DESTDIR="$LFS_SYSROOT" install
