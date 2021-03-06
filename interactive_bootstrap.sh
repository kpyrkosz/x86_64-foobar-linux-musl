#!/bin/bash

#TODO break on error and split into stages that can be interrupted and continued from

THIS_DIR=$PWD
LFS_ARCH=x86_64
LFS_VENDOR=foobar
export LFS_TGT="${LFS_ARCH}-${LFS_VENDOR}-linux-musl"
#TODO autodetect host cc/ld
export CC_FOR_BUILD=/usr/local/bin/cc
export CXX_FOR_BUILD=/usr/local/bin/c++
export HOST_LD=/usr/local/bin/ld.lld
export CMAKE=/usr/local/bin/cmake
# Determining sysroot
while [[ -z $LFS_SYSROOT ]]; do
echo "Enter the root directory where YOYO Linux is about to be installed"
	read -r LFS_SYSROOT
	mkdir -pv "${LFS_SYSROOT}"
	if (( $? != 0 )); then
		echo "Unable to create directory \"${LFS_SYSROOT}\""
		unset LFS_SYSROOT
		continue
	fi
	touch "${LFS_SYSROOT}/writetest.$$"
	if (( $? != 0 )); then
		echo "Directory \"${LFS_SYSROOT}\" is not writable for the current user"
		unset LFS_SYSROOT
		continue
	fi
	rm "${LFS_SYSROOT}/writetest.$$"
done
echo "Installing in ${LFS_SYSROOT}"
export LFS_SYSROOT

# Creating basic dirs
mkdir -pv "${LFS_SYSROOT}/"{usr/{bin/,lib/,include/,src/,local/},boot/,dev/,etc/,home/,mnt/,opt/,proc/,root/,run/,sbin/,srv/,sys/,tmp/,var/}
ln -sv usr/bin ${LFS_SYSROOT}/bin
ln -sv usr/lib ${LFS_SYSROOT}/lib
echo "Created basic dirs"

# Fetch sources from the internet or find them if they are present offline
export SOURCE_DIR="${LFS_SYSROOT}/usr/src/"
export PACKAGE_LIST_FILE="${THIS_DIR}/required_packages"
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
	# First stage is only downloading, not extracting
        # rm -rf "${directory_name}/"
        # tar xf "${tarball_name}"
done < "${PACKAGE_LIST_FILE}"
cd "${OLDPWD}"

#TODO - change this to MAKEOPTS or MAKEFLAGE how as it called
export PARALLEL_JOBS=5
# First build clang for the target using your host's default compiler.
bash initial_bootstrap_scripts/build_clang.sh

# export CC, CXX etc for the frenshly built compiler
export PATH="${LFS_SYSROOT}/tools/bin:$PATH"
export CC="${LFS_SYSROOT}/tools/bin/clang"
export CXX="${LFS_SYSROOT}/tools/bin/clang++"
export LD="${LFS_SYSROOT}/tools/bin/ld.lld"
export CFLAGS="-O2"
export CXXLAGS="-O2"
export LDFLAGS="-s"
#check for cc symlink
# musl libc
bash initial_bootstrap_scripts/build_musl.sh

# kernel headers
bash initial_bootstrap_scripts/build_linux_headers.sh

# m4
bash initial_bootstrap_scripts/build_m4.sh

# skip ncurses

# bash
bash initial_bootstrap_scripts/build_bash.sh

# coreutils
bash initial_bootstrap_scripts/build_coreutils.sh

# diffutils
bash initial_bootstrap_scripts/build_diffutils.sh

# file
bash initial_bootstrap_scripts/build_file.sh

# findutils
bash initial_bootstrap_scripts/build_findutils.sh

# gawk
bash initial_bootstrap_scripts/build_gawk.sh

# grep
bash initial_bootstrap_scripts/build_grep.sh

# gzip
bash initial_bootstrap_scripts/build_gzip.sh

# make
bash initial_bootstrap_scripts/build_make.sh

# patch
bash initial_bootstrap_scripts/build_patch.sh

# sed
bash initial_bootstrap_scripts/build_sed.sh

# tar
bash initial_bootstrap_scripts/build_tar.sh

# xz
bash initial_bootstrap_scripts/build_xz.sh

# clang working in chroot
bash initial_bootstrap_scripts/build_clang2.sh
