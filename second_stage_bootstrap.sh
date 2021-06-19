#!/bin/bash

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
pushd "${LFS_SYSROOT}/tools/bin/"
declare -a required_stuff=(clang clang++ objdump ar)
for i in "${required_stuff[@]}"; do
	if [[ ! -f "${LFS_TGT}-${i}" ]]; then
		echo Error, expected "${LFS_TGT}-${i}" to exist inside $PWD
	fi
done
popd

# doing the root things
