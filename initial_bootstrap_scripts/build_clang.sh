#!/bin/bash

THIS_PACKAGE=llvm
. "$(dirname "$0")/validate_and_cd_into.sh"

#this package has different directory name that tar name
cd "llvm-project-llvmorg-12.0.0"
mkdir build
cd build
# TODO it's better to build with /usr prefix and then install everything to /tools and only unwind/cxx/cxxabi/crt/builtins to /usr/
# Fasten your seatbelts!!
#okay, this one does not link libunwind in cxxabi but it builds proper crosscompiler (runniung on host and targeting musl)
#cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$LFS_SYSROOT/tools" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLIBCXX_HAS_MUSL_LIBC=ON -DLLVM_TARGETS_TO_BUILD=X86
#I changed prefix to / so that i can install entire thing inside /tools and then basic first stage libs in /usr/lib
#HEY, but there has to be a stage before that, without sysroot just to build the arch compatible basic libs so that the bootstrap below does not complain about not working compiler in the sysroot dir
#CXX
# holy fuck, my head can't visualise the chain of dependencies
# total edits of the file = 58

cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${LFS_SYSROOT}/tools" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=YES -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DLIBCXX_USE_COMPILER_RT=YES -DLIBCXXABI_USE_COMPILER_RT=YES -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_HOST_TRIPLE="$LFS_TGT" -DLLVM_TARGETS_TO_BUILD=X86 -DDEFAULT_SYSROOT="$LFS_SYSROOT"
make cxx cxxabi unwind crt builtins
make llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
make install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
# TEMP
exit 0
# TODO patch the line to define in the include __config. I tried setting it on botostrap and also as cflag but it didnt work
# but is required in the next stages
# /* #undef _LIBCPP_HAS_MUSL_LIBC */
# also, create symlinks to clang, ld, cc, binutils with target prefix (x86_64-foobar-linux-musl-ar) and also prefixless (ar)

CXXFLAGS="--sysroot=${LFS_SYSROOT}" CFLAGS="--sysroot=${LFS_SYSROOT}" cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="/" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=YES -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DLIBCXX_USE_COMPILER_RT=YES -DLIBCXXABI_USE_COMPILER_RT=YES -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLIBCXX_HAS_MUSL_LIBC=ON -DLLVM_HOST_TRIPLE="$LFS_TGT" -DLLVM_TARGETS_TO_BUILD=X86 -DDEFAULT_SYSROOT="$LFS_SYSROOT"
make cxx cxxabi unwind crt builtins
make DESTDIR="$LFS_SYSROOT/usr" install-{cxx,cxxabi,unwind,crt,builtins}
#now build host clang targeting musl
make llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld} -j"$PARALLEL_JOBS"
make DESTDIR="$LFS_SYSROOT/tools" install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
