#!/bin/bash

. vars.sh
. helper_fetch_and_build.sh
# TODO This is a nightmare
# For some reason it picks pkgconfig from aarch64 even tho I'm on x86 host.
# The hosts's tic builds and executes just fine but inside chroot backspace works as space.
# There is also problem with builds where bin and lib are not symlinks to usr/bin usr/lib
# because bash can't find curses library.
# I suppose cross building ncurses (this script) should be removed because bash can work just well
# without it, and you can built it without pain inside chroot with the local compiler

fetch_and_unpack "http://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
sed -i s/mawk// configure

mkdir build
pushd build
  CC=$CC_FOR_BUILD ../configure
  make -C include -j"$PARALLEL_JOBS"
  make -C progs tic -j"$PARALLEL_JOBS"
popd

CPPFLAGS="--sysroot=$LFS_SYSROOT" CXXFLAGS="--sysroot=$LFS_SYSROOT" CFLAGS="--sysroot=$LFS_SYSROOT" ./configure --prefix="$LFS_PREFIX" --host="$LFS_TGT" --with-shared --without-debug --without-ada --without-normal --enable-widec --without-pkg-config
make -j"$PARALLEL_JOBS"
make TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS_SYSROOT/usr/lib/libncurses.so
