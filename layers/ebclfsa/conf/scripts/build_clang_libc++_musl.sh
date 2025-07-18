#!/bin/bash

#Overview
#The default Clang installation on Ubuntu uses GNU libraries, which are not compatible with building LLVM runtimes for musl.
#To solve this, we first need to build a Clang toolchain for the host machine (x86_64) using musl, and then use that to build a Clang toolchain with runtimes for the aarch64-musl target.

#1. Build musl sysroot for x86_64-linux-musl using musl-cross-make

#Step 1a: Create a config.mak file with the following content:
#    TARGET = x86_64-linux-musl
#    GCC_VER = 12.4.0
#    MUSL_VER = 1.2.5
#    BINUTILS_VER = 2.33.1
#    OUTPUT = /workspace/musl-cross-make/output-x86_64

#Step 1b: Build the musl sysroot
#    make && make install

#2. Build musl sysroot for aarch64-linux-musl using musl-cross-make

#Step 2a: Create a second config.mak file:
#    TARGET = aarch64-linux-musl
#    GCC_VER = 12.4.0
#    MUSL_VER = 1.2.5
#    BINUTILS_VER = 2.33.1
#    OUTPUT = /workspace/musl-cross-make/output-aarch64

#Step 2b: Build the musl sysroot
#    make && make install

#Step 2c: Adjust the sysroot if needed
#You may need to move or symlink specific libraries.
#    Example: link libc
#    ln -s /workspace/musl-cross-make/output-aarch64/aarch64-linux-musl/lib/libc.a /some/target/path/

#3. Build Clang for x86_64-musl using the musl sysroot

#Step 3a: Create a CMake toolchain file toolchain-x86_64-musl.cmake
#(See this file for full details)

#Step 3b: Run your first CMake configuration to build Clang using musl
#cmake -G "Unix Makefiles" -S llvm -B build_x86_64_clang_musl \
#    -DLLVM_ENABLE_PROJECTS="clang" \
#    -DCMAKE_TOOLCHAIN_FILE="/workspace/llvm-project/toolchain-x86_64-musl.cmake" \
#    -DCMAKE_BUILD_TYPE=Release \
#    -DCMAKE_C_COMPILER_TARGET=x86_64-linux-musl \
#    -DCMAKE_CXX_COMPILER_TARGET=x86_64-linux-musl \
#    -DLIBCXX_HAS_MUSL_LIBC=ON 

#make -C build_x86_64_clang_musl
#DESTDIR=/workspace/llvm-project/output_x86_64_clang_musl make -C build_x86_64_clang_musl install

#Step 3c: Fix Clang runtime linking with patchelf
#Use patchelf to set the correct runtime library paths:
#
#   patchelf --set-interpreter \
#       /workspace/musl-cross-make/output-x86_64/x86_64-linux-musl/lib/libc.so \
#       /workspace/llvm-project/output_x86_64_clang_musl/usr/local/bin/clang
#
#   patchelf --set-rpath \
#       /workspace/musl-cross-make/output-x86_64/x86_64-linux-musl/lib \
#       /workspace/llvm-project/output_x86_64_clang_musl/usr/local/bin/clang

#Step 3d (optional). Test your Clang compiler
#Compile a small C/C++ test file in verbose mode to verify that:
#- The correct libraries are being used (musl is included instead of glibc)
#./test_x86_64_clang.sh

#4. Build Clang with runtimes for aarch64-musl
#Step 4a: Create a CMake toolchain file toolchain-aarch64-musl.cmake
#(See this file for full details)

#Step 4b: Run your second CMake configuration to build Clang using musl
#cmake -G "Unix Makefiles" -S llvm -B build_aarch64_clang_musl \
#    -DLLVM_ENABLE_PROJECTS="clang" \
#    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
#    -DLLVM_ENABLE_LIBCXX=ON \
#    -DLLVM_RUNTIME_TARGETS="aarch64-linux-musl" \
#    -DCMAKE_TOOLCHAIN_FILE="/workspace/llvm-project/toolchain-aarch64-musl.cmake" \
#    -DCMAKE_BUILD_TYPE=Release \
#    -DCMAKE_C_COMPILER_TARGET=aarch64-linux-musl \
#    -DCMAKE_CXX_COMPILER_TARGET=aarch64-linux-musl \
#    -DCXX_SUPPORTS_CXXABI=ON \
#    -DLIBCXX_HAS_MUSL_LIBC=ON

#make -C build_aarch64_clang_musl
#DESTDIR=/workspace/llvm-project/output_aarch64_clang_musl make -C build_aarch64_clang_musl install

#Step 4c: Fix Clang runtime linking with patchelf
#Use patchelf to set the correct runtime library paths:
#
#   patchelf --set-interpreter \
#       /workspace/musl-cross-make/output-aarch64/aarch64-linux-musl/lib/libc.so \
#       /workspace/llvm-project/output_aarch64_clang_musl/usr/local/bin/clang
#
#   patchelf --set-rpath \
#       /workspace/musl-cross-make/output-aarch64/aarch64-linux-musl/lib/ \
#       /workspace/llvm-project/output_aarch64_clang_musl/usr/local/bin/clang

#Step 4d (optional). Test libc++ with musl
#Compile a small C++ program to verify that libc++ is using musl.
#./test_aarch64_clang.sh

#!/bin/bash
set -ex

export LLVM_SYMBOLIZER_PATH=/usr/lib/llvm-18/bin/llvm-symbolizer

# Variables
PROC_NR=2
WORK_DIR="/build"
BUILD_TOOL="ninja"

LD_MUSL_X86_64=ld-musl-x86_64.so.1
LD_MUSL_AARCH64=ld-musl-aarch64.so.1
X86_64_TARGET="x86_64-linux-musl"
AARCH64_TARGET="aarch64-linux-musl"

MUSL_CROSS_PROJECT_DIR="${WORK_DIR}/musl-cross-make"
MUSL_CROSS_GIT_REPO="https://github.com/richfelker/musl-cross-make.git"
GCC_VER="12.4.0"
LINUX_VER="5.15.183"
MUSL_X86_64_INSTALL_DIR="/usr/x86_64-linux-musl"
MUSL_AARCH64_INSTALL_DIR="/usr/aarch64-linux-musl"

LLVM_PROJECT_DIR="${WORK_DIR}/llvm-project"
LLVM_GIT_REPO="https://github.com/llvm/llvm-project.git"
LLVM_GIT_BRNCH="release/18.x"
CLANG_X86_64_INSTALL_DIR="/usr/x86_64_clang_musl"
CLANG_AARCH64_INSTALL_DIR="/usr/aarch64_clang_musl"


check_tools() {
    patchelf --version
    cmake --version
    make --version
    /usr/bin/ld.lld --version
    if [ "$BUILD_TOOL" = "ninja" ]; then
        ninja --version
    else 
        exit 1
    fi
}

clone_musl() {
    cd $WORK_DIR
    if [ ! -d "$MUSL_CROSS_PROJECT_DIR" ]; then
        git clone $MUSL_CROSS_GIT_REPO
        cd $MUSL_CROSS_PROJECT_DIR
        git config --global --add safe.directory $MUSL_CROSS_PROJECT_DIR
        git config --global user.email "inquiries@elektrobit.com"
        git config --global user.name "Elektrobit"
        git am $WORK_DIR/0001-musl-cross-add-linux-5.15.183-hash.patch
    fi
}

build_musl_target() {
    local target=$1
    local install_dir=$2

    cd $MUSL_CROSS_PROJECT_DIR

    cat > config.mak <<EOF
TARGET=${target}
GCC_VER=${GCC_VER}
MUSL_VER=1.2.5
BINUTILS_VER=2.33.1
LINUX_VER=${LINUX_VER}
OUTPUT=${install_dir}
EOF

    make -j$PROC_NR
}

install_musl_target() {
    local target=$1
    local install_dir=$2
    local ld_musl=$3

    cd $MUSL_CROSS_PROJECT_DIR

    rm -frd "$install_dir"
    make install

    cd "$install_dir"
    if [ -d "$target" ]; then
        cd "$target/lib"
        rm -f "$ld_musl"
        ln -s libc.so "$ld_musl"
        cd -
    fi

    local gcc_dir="$install_dir/lib/gcc/$target/$GCC_VER"
    if [ -d "$gcc_dir" ]; then
        for f in "$install_dir/lib/libcc1"*; do
            [ -e "$f" ] && mv "$f" "$gcc_dir"
        done
        ln -sf $gcc_dir/* $install_dir/$target/lib
    fi
}


clone_llvm() {
    cd $WORK_DIR
    if [ ! -d "$LLVM_PROJECT_DIR" ]; then
        git clone --depth 1 --branch $LLVM_GIT_BRNCH $LLVM_GIT_REPO
        cd $LLVM_PROJECT_DIR
        git config --global --add safe.directory $LLVM_PROJECT_DIR
        git config --global user.email "inquiries@elektrobit.com"
        git config --global user.name "Elektrobit"
        git am $WORK_DIR/0001-llvm-enable-by-default-musl-libc.patch
    fi
}

build_clang_target() {
    local target=$1
    local musl_dir=$2
    local compiler_dir=$3
    local build_dir=$4
    local toolchain_file="$LLVM_PROJECT_DIR/${target}-toolchain.cmake"

    local cm_build_tool=""
    if [ "$BUILD_TOOL" = "ninja" ]; then
        cm_build_tool="Ninja"
    elif [ "$BUILD_TOOL" = "make" ]; then
        cm_build_tool="Unix Makefiles"
    else
        exit 1
    fi

    cd $LLVM_PROJECT_DIR
   

    if [ "$target" = "x86_64-linux-musl" ]; then
        cat > "$toolchain_file" <<EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${target%%-*})
set(CMAKE_C_COMPILER ${compiler_dir}/bin/${target}-gcc)
set(CMAKE_CXX_COMPILER ${compiler_dir}/bin/${target}-g++)
set(CMAKE_C_COMPILER_TARGET ${target})
set(CMAKE_CXX_COMPILER_TARGET ${target})
set(CMAKE_SYSROOT ${musl_dir})
set(CMAKE_FIND_ROOT_PATH ${musl_dir})
EOF

    cmake -G $cm_build_tool -S llvm -B "$build_dir" \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DCMAKE_TOOLCHAIN_FILE="$toolchain_file" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLIBCXX_HAS_MUSL_LIBC=ON

    elif [ "$target" = "aarch64-linux-musl" ]; then
        cat > "$toolchain_file" <<EOF1
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${target%%-*})
set(CMAKE_C_COMPILER ${compiler_dir}/usr/local/bin/clang)
set(CMAKE_CXX_COMPILER ${compiler_dir}/usr/local/bin/clang++)
set(CMAKE_LINKER /usr/bin/lld)
set(CMAKE_C_COMPILER_TARGET ${target})
set(CMAKE_CXX_COMPILER_TARGET ${target})
set(CMAKE_SYSROOT ${musl_dir})
set(CMAKE_FIND_ROOT_PATH ${musl_dir})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=lld")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
EOF1

    cmake -G $cm_build_tool -S llvm -B "$build_dir" \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
        -DLLVM_ENABLE_LIBCXX=ON \
        -DLLVM_RUNTIME_TARGETS="${target}" \
        -DCMAKE_TOOLCHAIN_FILE="$toolchain_file" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCXX_SUPPORTS_CXXABI=ON \
        -DLIBCXX_HAS_MUSL_LIBC=ON 
    fi

    $BUILD_TOOL -j$PROC_NR -C "$build_dir"
}

install_clang_target() {
    local clang_install_dir=$1
    local build_dir=$2

    cd $LLVM_PROJECT_DIR

    rm -frd "$clang_install_dir"
    DESTDIR="$clang_install_dir" $BUILD_TOOL -C "$build_dir" install
}

patch_clang_bins() {
    local install_dir=$1
    local ld_path=$2

    if [ -d "$install_dir/usr/local/bin" ]; then
        for f in "$install_dir/usr/local/bin/"*; do
            if [ -x "$f" ] && file "$f" | grep -q "ELF"; then
                patchelf --set-interpreter "$ld_path" "$f"
                patchelf --set-rpath "$(dirname "$ld_path")" "$f"
            fi
        done
    fi
}

clean_all() {
    rm -frd $MUSL_CROSS_PROJECT_DIR
    rm -frd $LLVM_PROJECT_DIR
}

main() {
    case "$1" in
        --check_tools)
            check_tools
            ;;
        --clone_musl)
            clone_musl
            ;;
        --build_musl_x86)
            build_musl_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR"
            ;;
        --install_musl_x86)
            install_musl_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR" "$LD_MUSL_X86_64"
            ;;
        --clone_llvm)
            clone_llvm
            ;;
        --build_clang_x86)
            build_clang_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR" "$MUSL_X86_64_INSTALL_DIR" "build_x86_64_clang_musl"
            ;;
        --install_clang_x86)
            install_clang_target "$CLANG_X86_64_INSTALL_DIR" "build_x86_64_clang_musl"
            patch_clang_bins "$CLANG_X86_64_INSTALL_DIR" "$MUSL_X86_64_INSTALL_DIR/$X86_64_TARGET/lib/$LD_MUSL_X86_64"
            ;;
        --build_musl_aarch64)
            build_musl_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR"
            ;;
        --install_musl_aarch64)
            install_musl_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR" "$LD_MUSL_AARCH64"
            ;;
        --build_clang_aarch64)
            build_clang_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR" "$CLANG_X86_64_INSTALL_DIR" "build_aarch64_clang_musl"
            ;;
        --install_clang_aarch64)
            install_clang_target "$CLANG_AARCH64_INSTALL_DIR" "build_aarch64_clang_musl"
            patch_clang_bins "$CLANG_AARCH64_INSTALL_DIR" "$MUSL_AARCH64_INSTALL_DIR/$AARCH64_TARGET/lib/$LD_MUSL_AARCH64"
            ;;
        --all)
            check_tools
            clone_musl
            clone_llvm
            
            build_musl_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR"
            install_musl_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR" "$LD_MUSL_X86_64"
            build_musl_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR"
            install_musl_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR" "$LD_MUSL_AARCH64"
            build_clang_target "$X86_64_TARGET" "$MUSL_X86_64_INSTALL_DIR" "$MUSL_X86_64_INSTALL_DIR" "build_x86_64_clang_musl"
            install_clang_target "$CLANG_X86_64_INSTALL_DIR" "build_x86_64_clang_musl"
            patch_clang_bins "$CLANG_X86_64_INSTALL_DIR" "$MUSL_X86_64_INSTALL_DIR/$X86_64_TARGET/lib/$LD_MUSL_X86_64"
            build_clang_target "$AARCH64_TARGET" "$MUSL_AARCH64_INSTALL_DIR" "$CLANG_X86_64_INSTALL_DIR" "build_aarch64_clang_musl"
            install_clang_target "$CLANG_AARCH64_INSTALL_DIR" "build_aarch64_clang_musl"
            patch_clang_bins "$CLANG_AARCH64_INSTALL_DIR" "$MUSL_AARCH64_INSTALL_DIR/$AARCH64_TARGET/lib/$LD_MUSL_AARCH64"
            ;;
        --clean)
            clean_all
            ;;
        *)
            echo "Usage: $0 [--x86|--aarch64|--clean]"
            exit 1
            ;;
    esac
}

main "$@"
