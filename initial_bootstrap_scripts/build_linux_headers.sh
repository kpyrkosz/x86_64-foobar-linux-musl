#!/bin/bash

THIS_PACKAGE=linux
. "$(dirname "$0")/validate_and_cd_into.sh"

# Based on linux from scratch
make LLVM=1 headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include "${LFS_SYSROOT}/usr"
