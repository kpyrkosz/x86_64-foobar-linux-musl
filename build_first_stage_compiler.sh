#!/bin/bash

. vars.sh

# This stage is building cxx, cxxabi, unwind, clang, lld and binutils
# that are going to be linked against musl libc

mkdir -pv "${LFS_SOURCES}"
cd "${LLVM_SOURCE_TREE}"
mkdir build_first_stage
cd build_first_stage

# Fasten your seatbelts!!
# TODO hardcoded host llvm-tblgen and clang-tblgen
CFLAGS="--sysroot=$LFS_SYSROOT -D_LIBCPP_HAS_MUSL_LIBC" CXXFLAGS="--sysroot=$LFS_SYSROOT -D_LIBCPP_HAS_MUSL_LIBC" cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$LFS_PREFIX" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DLIBCXXABI_USE_LLVM_UNWINDER=YES -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DLLVM_USE_LINKER=lld -DLLVM_ENABLE_LIBCXX=ON -DLIBCXX_USE_COMPILER_RT=YES -DLIBCXXABI_USE_COMPILER_RT=YES -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -GNinja -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON -DLLVM_TABLEGEN=/usr/local/src/llvm-project/b/bin/llvm-tblgen -DCLANG_TABLEGEN=/usr/local/src/llvm-project/b/bin/clang-tblgen -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT"  -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLIBCXX_HAS_MUSL_LIBC=ON -DLLVM_HOST_TRIPLE="$LFS_TGT" -DLLVM_TARGETS_TO_BUILD=X86
# TODO Not building entire compiler-rt because execinfo.h is missing
ninja cxx cxxabi unwind crt builtins
ninja install-{cxx,cxxabi,unwind,crt,builtins}
ninja llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins}
ninja install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
# TODO, look at "DEFAULT_SYSROOT" CMakeCache variable
# maybe it's possible to avoid passing --sysroot in the bootstrap of initial utilities?
