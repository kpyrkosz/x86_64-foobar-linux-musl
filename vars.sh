#!/bin/bash

LFS_ARCH=x86_64
LFS_VENDOR=foobar

export LD=ld.lld
export LFS_TGT="${LFS_ARCH}-${LFS_VENDOR}-linux-musl"
export LFS_SYSROOT=/srv/chroot/x86-linux-musl
export LFS_PREFIX="${LFS_SYSROOT}/usr"
export LFS_SOURCES="${LFS_SYSROOT}/sources"
export CC="${PWD}/${LFS_TGT}-clang"
export CC_FOR_BUILD=clang
export CXX="${PWD}/${LFS_TGT}-clang++"
export PARALLEL_JOBS=5
#I keep my llvm source tree there, I'm going to omit cloning the git repository in the script
export LLVM_SOURCE_TREE=/usr/local/src/llvm-project/
