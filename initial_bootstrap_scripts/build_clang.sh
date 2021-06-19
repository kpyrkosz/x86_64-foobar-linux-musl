#!/bin/bash

THIS_PACKAGE=llvm
. "$(dirname "$0")/validate_and_cd_into.sh"

#this package has different directory name that tar name
cd "llvm-project-llvmorg-12.0.0"
rm -rf build
mkdir build
cd build
# Fasten your seatbelts!!
# TODO maybe build the initial stage as shared libs to save space?

CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD "$CMAKE" ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${LFS_SYSROOT}/tools" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=YES -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DLIBCXX_USE_COMPILER_RT=YES -DLIBCXXABI_USE_COMPILER_RT=YES -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_HOST_TRIPLE="$LFS_TGT" -DLLVM_TARGETS_TO_BUILD=X86 -DDEFAULT_SYSROOT="$LFS_SYSROOT"
make cxx cxxabi unwind crt builtins
make install-{cxx,cxxabi,unwind,crt,builtins}
make llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
make install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
cp -v bin/{llvm,clang}-tblgen "${LFS_SYSROOT}/tools/bin/"
pushd "${LFS_SYSROOT}/tools/bin/"
for i in llvm-*; do ln -sv "$i" "${i#llvm-}"; done
for i in llvm-*; do ln -sv "$i" "${LFS_TGT}-${i#llvm-}"; done
ln -sv clang "${LFS_TGT}-clang"
ln -sv clang++ "${LFS_TGT}-clang++"
ln -sv clang "${LFS_TGT}-cpp"
ln -sv ld.lld "${LFS_TGT}-ld"
popd
