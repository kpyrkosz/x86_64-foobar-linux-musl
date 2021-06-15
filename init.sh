#!/bin/bash

# TODO fix manual steps
# Please beforehand create the directory yourself and make it writable for the nonroot user that builds the packages
# sudo mkdir /srv/chroot/x86-linux-musl
# sudo chown tgq:tgq /srv/chroot/x86-linux-musl

. vars.sh

mkdir -pv ${LFS_SYSROOT} ${LFS_SYSROOT}/usr/{bin,lib}
ln -sv usr/bin ${LFS_SYSROOT}/bin
ln -sv usr/lib ${LFS_SYSROOT}/lib
ln -sfv $(which clang) ${LFS_TGT}-clang
ln -sfv $(which clang++) ${LFS_TGT}-clang++
