#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "https://musl.libc.org/releases/musl-1.2.2.tar.gz"
CROSS_COMPILE="llvm-" ./configure --prefix="$LFS_PREFIX" --syslibdir="$LFS_SYSROOT/lib" --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make install
ln -sfv libc.so "${LFS_SYSROOT}/lib/ld-musl-x86_64.so.1"
ln -sfv /lib/libc.so "${LFS_SYSROOT}/bin/ldd"
