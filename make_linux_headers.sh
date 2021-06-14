#!/bin/bash

. vars.sh

mkdir -pv "${LFS_SOURCES}"
cd "${LFS_SOURCES}"
if [[ ! -f linux-5.10.43.tar.xz ]]; then
	echo "Downloading linux source" >&2
	wget "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.43.tar.xz"
	tar xf "linux-5.10.43.tar.xz"
fi
cd "linux-5.10.43"

# Based on linux from scratch
make LLVM=1 headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include "${LFS_SYSROOT}/usr"
