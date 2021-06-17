#!/bin/bash

THIS_PACKAGE=llvm
. "$(dirname "$0")/validate_and_cd_into.sh"

#this package has different directory name that tar name
cd "llvm-project-llvmorg-12.0.0"
mkdir build
cd build
# TODO it's better to build with /usr prefix and then install everything to /tools and only unwind/cxx/cxxabi/crt/builtins to /usr/
# Fasten your seatbelts!!
cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$LFS_SYSROOT/tools" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLIBCXX_HAS_MUSL_LIBC=ON -DLLVM_TARGETS_TO_BUILD=X86
make llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld} -j"$PARALLEL_JOBS"
make install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
