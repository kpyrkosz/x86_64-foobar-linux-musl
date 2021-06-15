#!/bin/bash

# Please beforehand create the directory yourself and make it writable for the nonroot user that builds the packages
# sudo mkdir /srv/chroot/x86-linux-musl
# sudo chown tgq:tgq /srv/chroot/x86-linux-musl

. vars.sh

mkdir -pv ${LFS_SYSROOT} ${LFS_SYSROOT}/usr/{bin,lib}
ln -sv usr/bin ${LFS_SYSROOT}/bin
ln -sv usr/lib ${LFS_SYSROOT}/lib
ln -sfv $(which clang) x86_64-foobar-linux-musl-clang
ln -sfv $(which clang++) x86_64-foobar-linux-musl-clang++
