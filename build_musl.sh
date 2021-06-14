#!/bin/bash

. vars.sh

mkdir -pv "${LFS_SOURCES}"
cd "${LFS_SOURCES}"
if [[ ! -f musl-1.2.2.tar.gz ]]; then
	echo "Downloading musl" >&2
	wget "https://musl.libc.org/releases/musl-1.2.2.tar.gz"
	tar xf "musl-1.2.2.tar.gz"
fi
cd "musl-1.2.2"
CROSS_COMPILE="llvm-" ./configure --prefix="$LFS_PREFIX" --libdir="$LFS_SYSROOT/lib" --host="$LFS_TGT"
make -j"$PARALLEL_JOBS"
make install
