#!/bin/bash

#add support for CFLAGS CXXFLAGS LDFLAGS and so on
if (( $EUID != 0 )); then
	echo "Please run the second stage as root"
	exit 1
fi

if [[ -z ${LFS_SYSROOT} ]]; then
	echo Please set "LFS_SYSROOT" env var
	exit 1
fi

# Fetch sources from the internet or find them if they are present offline
# pretty much a copy from first stage with changed package file name
export SOURCE_DIR="${LFS_SYSROOT}/usr/src/"
export PACKAGE_LIST_FILE="${PWD}/userland_packages"
cd "${SOURCE_DIR}"
while read -r package_name tarball_link; do
	if [[ ${package_name:0:1} == "#" ]]; then continue; fi
	tarball_name="${tarball_link##*/}"
        directory_name="${tarball_name%.tar.*}"
        if [[ -z $tarball_name || -z $directory_name ]]; then
                echo "Something is wrong tarname: \"$tarball_name\", dirname: \"$directory_name\"" >&2
                exit 1
        fi
        if [[ ! -f "$tarball_name" ]]; then
                echo "Downloading $tarball_name" >&2
                wget "$tarball_link"
        fi
done < "${PACKAGE_LIST_FILE}"
cd "${OLDPWD}"

mkdir -v "${LFS_SYSROOT}/tools"
cp -va userland_scripts/* "${LFS_SYSROOT}/tools"
chmod 500 "${LFS_SYSROOT}/tools/build_all.sh"

# TODO, mvoe this outside first stage since it's used in both. Plus these global vars...
cp -va "initial_bootstrap_scripts/validate_and_cd_into.sh" "${LFS_SYSROOT}/tools"
cp -va "${PACKAGE_LIST_FILE}" "${LFS_SYSROOT}/tools"

./lfs_enter.sh "${LFS_SYSROOT}" "/tools/build_all.sh"

rm -rv "${LFS_SYSROOT}/tools"
