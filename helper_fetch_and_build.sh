#!/bin/bash

# Building most packages is very similar, it's a good idea to outsource
# the steps fetching and unpacking tarballs to a helper function

. vars.sh

# $1 tarball link
fetch_and_unpack()
{
	tarball_name="${1##*/}"
	directory_name="${tarball_name%.tar.*}"
	if [[ -z $tarball_name || -z $directory_name ]]; then
		echo "Something is wrong tarname: \"$tarball_name\", dirname: \"$directory_name\"" >&2
		exit 1
	fi
	mkdir -pv "${LFS_SOURCES}"
	cd "${LFS_SOURCES}"
	if [[ ! -f "$tarball_name" ]]; then
        	echo "Downloading $tarball_name" >&2
		wget "$1"
	fi
	rm -rf "${directory_name}/"
	tar xf "${tarball_name}" 
	cd "${directory_name}/"
}
