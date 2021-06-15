#!/bin/bash

. vars.sh

[[ $EUID != 0 ]] && echo "Please run this script as root" >&2 && exit 1

mkdir -pv $LFS_SYSROOT/{bin,etc,lib,sbin,usr,var,dev,proc,sys,run}
chown -R root:root $LFS_SYSROOT/{usr,lib,var,etc,bin,sbin}
mknod -m 600 $LFS_SYSROOT/dev/console c 5 1
mknod -m 666 $LFS_SYSROOT/dev/null c 1 3
mount -v --bind /dev $LFS_SYSROOT/dev
mount -v --bind /dev/pts $LFS_SYSROOT/dev/pts
mount -vt proc proc $LFS_SYSROOT/proc
mount -vt sysfs sysfs $LFS_SYSROOT/sys
mount -vt tmpfs tmpfs $LFS_SYSROOT/run
if [ -h $LFS_SYSROOT/dev/shm ]; then
  mkdir -pv $LFS_SYSROOT/$(readlink $LFS_SYSROOT/dev/shm)
fi

# Links in /bin. Maybe make /bin be symlink to /usr/bin like Debian does?
# TODO
# ln -sv /usr/bin/bash "${LFS_SYSROOT}/bin/bash"

# Links for llvm-objdump to objdump etc
for i in "${LFS_SYSROOT}"/usr/bin/llvm-*; do [[ -f $i && ! -L $i ]] && ln -sv "$(basename $i)" "${LFS_SYSROOT}/usr/bin/${i##*llvm-}"; done

# Links for clang and clang++ respecting musl
ln -sv clang "${LFS_SYSROOT}/usr/bin/${LFS_TGT}-clang"
ln -sv clang++ "${LFS_SYSROOT}/usr/bin/${LFS_TGT}-clang"++
ln -sv "${LFS_TGT}-clang" "${LFS_SYSROOT}/usr/bin/cc"
ln -sv "${LFS_TGT}-clang++" "${LFS_SYSROOT}/usr/bin/c++"

# Stripping
for i in "${LFS_SYSROOT}"/usr/bin/*; do [[ -f $i && ! -L $i ]] && llvm-strip "$i"; done
