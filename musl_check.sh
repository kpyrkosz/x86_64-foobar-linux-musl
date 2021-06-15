#!/bin/bash

. vars.sh

# TODO hardcoded paths
# Temporarly copy shared libraries: libunwind.so, libc++.so libc++abi.so
# into sysroot/usr/lib. Right now they carry dependency to hosts's glibc
# but will be built against the freshly bootstrapped musl
# My clang lives inside /opt/clang_second, so:
# cp /opt/clang_second/lib/lib*so* "$LFS_SYSROOT"/usr/lib/
set -e

cd "${LFS_SOURCES}"
echo -e '#include<stdio.h>\nint main(){puts("foobar");return 0;}' > foo.c
$CC foo.c --sysroot="$LFS_SYSROOT"
"${LFS_SYSROOT}/lib/ld-musl-x86_64.so.1" ./a.out
