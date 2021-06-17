#!/bin/bash

# helepr script to be sourced
# expecting variable THIS_PACKAGE and the rest from main bootstrap script

tarball_link=$(awk '{ if($1 == "'${THIS_PACKAGE}'") print $2; }' ${PACKAGE_LIST_FILE})

if [[ -z $tarball_link ]]; then
        echo CRITICAL ERROR, ${THIS_PACKAGE} awk failed
        exit 1
fi

cd ${SOURCE_DIR}
tarball_name="${tarball_link##*/}"
directory_name="${tarball_name%.tar.*}"
if [[ -z $tarball_name || -z $directory_name ]]; then
        echo "Something is wrong with cutting the names, tarname: \"$tarball_name\", dirname: \"$directory_name\"" >&2
        exit 1
fi

if [[ ! -f "$tarball_name" ]]; then
        echo "$tarball_name" is not present in the directory
        exit 1
fi

rm -rf "${directory_name}/"
tar xf "${tarball_name}"

cd "${directory_name}/"
