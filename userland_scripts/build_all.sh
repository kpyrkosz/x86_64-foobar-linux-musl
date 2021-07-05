#!/bin/bash

export CC=clang
export CXX=clang++
export CFLAGS="-O3 -funsafe-math-optimizations -march=native -DNDEBUG -flto -fno-plt -fpic" #-fvisibility=hidden"
export LDFLAGS='-s -flto -Wl,--as-needed -Wl,--gc-sections'
export CXXFLAGS="$CFLAGS -std=c++20"

export PARALLEL_JOBS=5
#todo, package list file is ugly, i suppose i should pass it as an argument
export PACKAGE_LIST_FILE=/tools/userland_packages
#aand another global var :(
export SOURCE_DIR=/usr/src/

bash /tools/iana.sh
bash /tools/zlib.sh
bash /tools/xz.sh
bash /tools/bzip.sh
