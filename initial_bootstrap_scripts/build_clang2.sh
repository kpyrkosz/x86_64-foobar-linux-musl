#!/bin/bash

THIS_PACKAGE=llvm
. "$(dirname "$0")/validate_and_cd_into.sh"

#this package has different directory name that tar name
cd "llvm-project-llvmorg-12.0.0"
rm -rf build
mkdir build
cd build
CXXFLAGS='-D_LIBCPP_HAS_MUSL_LIBC' CFLAGS='-D_LIBCPP_HAS_MUSL_LIBC' CC="${LFS_SYSROOT}/tools/bin/clang" CXX="${LFS_SYSROOT}/tools/bin/clang++" LDFLAGS='-s' /usr/local/bin/cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld;clang-tools-extra" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLIBCXXABI_USE_LLVM_UNWINDER=YES -DCOMPILER_RT_BUILD_LIBFUZZER=OFF -DLLVM_USE_LINKER=lld -DLLVM_ENABLE_LIBCXX=ON -DLIBCXX_USE_COMPILER_RT=YES -DLIBCXXABI_USE_COMPILER_RT=YES -DCLANG_DEFAULT_LINKER=lld -DCLANG_DEFAULT_CXX_STDLIB=libc++ -DCLANG_DEFAULT_RTLIB=compiler-rt -DCLANG_DEFAULT_UNWINDLIB=libunwind -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON -DLLVM_TARGETS_TO_BUILD=X86 -DCOMPILER_RT_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLLVM_DEFAULT_TARGET_TRIPLE="$LFS_TGT" -DLIBCXX_HAS_MUSL_LIBC=ON -DLLVM_HOST_TRIPLE="$LFS_TGT" -DCLANG_TABLEGEN="${LFS_SYSROOT}/tools/bin/clang-tblgen" -DLLVM_TABLEGEN="${LFS_SYSROOT}/tools/bin/llvm-tblgen"

make llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} {cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
make DESTDIR="${LFS_SYSROOT}" install-llvm-{objdump,objcopy,as,ar,ranlib,addr2line,nm,readelf,strip,symbolizer,strings,size} install-{cxx,cxxabi,unwind,clang,clang-resource-headers,crt,builtins,lld}
pushd "${LFS_SYSROOT}/usr/bin/"
for i in llvm-*; do ln -sv "$i" "${i#llvm-}"; done
for i in llvm-*; do ln -sv "$i" "${LFS_TGT}-${i#llvm-}"; done
ln -sv clang "${LFS_TGT}-clang"
ln -sv clang++ "${LFS_TGT}-clang++"
ln -sv clang "${LFS_TGT}-cpp"
ln -sv ld.lld "${LFS_TGT}-ld"
popd
