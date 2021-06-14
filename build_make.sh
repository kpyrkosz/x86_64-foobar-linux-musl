#!/bin/bash

# make 4.3 does not build against musl:
# src/dir.c:1185:8: error: unknown type name '__ptr_t'
# src/dir.c:1336:7: error: no member named 'gl_opendir' in 'glob_t' 


. vars.sh
. helper_fetch_and_build.sh

fetch_and_unpack "http://ftp.gnu.org/gnu/make/make-4.2.tar.gz"
CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT" --without-guile
make -j"$PARALLEL_JOBS"
make install
