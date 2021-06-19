#!/bin/bash

# more or less whats to be done:
#+run as root
#+validate that previous stage is ok
#create the directories, sticky tmp, proper /root TODO, revisit creation of filesystem hierarchy in first stage
#+create the dev null, dev console
#+chown to everything to root to avoid UID problems with lfs user id on the build machine
#mount and chroot inside
#then go with python, perl and these things
#delete /tools
#and that's the ready stage 2 that can be untared and chrooted into on the destination machine
if (( $EUID != 0 )); then
	echo "Please run the second stage as root"
	exit 1
fi

if [[ -z ${LFS_SYSROOT} ]]; then
	echo Please set "LFS_SYSROOT" env var
	exit 1
fi

# deduce the triple
LFS_TGT=$("${LFS_SYSROOT}/tools/bin/clang" --version | grep 'Target: ' | cut -d' ' -f2)
if [[ -z ${LFS_TGT} ]]; then
	echo Error deducing triplet, the triplet is empty
	exit 1
fi

if [[ ${LFS_TGT} =~ ^[[:alnum:]]-[[:alnum:]]-[[:alnum:]]-[[:alnum:]]$ ]]; then
	echo Error deducing triplet, the triplet is not in a form of A-B-C-D
	exit 1
fi

# sanity checks
pushd "${LFS_SYSROOT}/tools/bin/" > /dev/null
declare -a required_stuff=(clang clang++ objdump ar)
for i in "${required_stuff[@]}"; do
	if [[ ! -f "${LFS_TGT}-${i}" ]]; then
		echo Error, expected "${LFS_TGT}-${i}" to exist inside $PWD
		exit 1
	fi
done
popd > /dev/null

chown -R root:root "${LFS_SYSROOT}/"

mknod -m 600 "${LFS_SYSROOT}/dev/console" c 5 1
mknod -m 666 "${LFS_SYSROOT}/dev/null" c 1 3
