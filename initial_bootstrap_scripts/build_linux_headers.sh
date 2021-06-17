#!/bin/bash

THIS_PACKAGE=linux
. "$(dirname "$0")/validate_and_cd_into.sh"

echo "The script you are running has basename `basename "$0"`, dirname `dirname "$0"`"
echo "The present working directory is `pwd`"
# Based on linux from scratch
make LLVM=1 headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include "${LFS_SYSROOT}/usr"
