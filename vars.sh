#!/bin/bash

LFS_ARCH=x86_64
LFS_VENDOR=foobar
#Please beforehand create the directory yourself and make it writable for the nonroot user that builds the packages
# sudo mkdir /srv/chroot/x86-linux-musl
# sudo chown tgq:tgq /srv/chroot/x86-linux-musl
LFS_SYSROOT=/srv/chroot/x86-linux-musl

export CC=clang
export CXX=clang++
export LD=ld.lld
export LFS_TGT="${LFS_ARCH}-${LFS_VENDOR}-linux-musl"
export LFS_PREFIX="${LFS_SYSROOT}/usr"
export LFS_SOURCES="${LFS_SYSROOT}/sources"
export PARALLEL_JOBS=5
#I keep my llvm source tree there, I'm going to omit cloning the git repository in the script
export LLVM_SOURCE_TREE=/usr/local/src/llvm-project/
