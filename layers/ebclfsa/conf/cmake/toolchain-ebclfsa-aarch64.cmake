set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(MUSL_SYSROOT_PATH /usr/aarch64-linux-musl)
set(CLANG_ROOT_PATH /usr/aarch64_clang_musl/usr/local)

set(LOC_TARGET aarch64-linux-musl)
set(CLANG_LIBS_1 ${CLANG_ROOT_PATH}/lib)
set(CLANG_LIBS_2 ${CLANG_ROOT_PATH}/lib/${LOC_TARGET})
set(MUSL_INCLUDE ${SYSROOT_PATH}/${LOC_TARGET}/include)
set(CLANG_INCLUDE_1 ${CLANG_ROOT_PATH}/include/c++/v1)
set(CLANG_INCLUDE_2 ${CLANG_ROOT_PATH}/include/aarch64-unknown-linux-musl/c++/v1)

set(CMAKE_C_COMPILER ${CLANG_ROOT_PATH}/bin/clang)
set(CMAKE_CXX_COMPILER ${CLANG_ROOT_PATH}/bin/clang++)
set(CMAKE_LINKER /usr/bin/lld)
set(CMAKE_SYSROOT ${MUSL_SYSROOT_PATH})
set(CMAKE_FIND_ROOT_PATH ${MUSL_SYSROOT_PATH})


# Only static binaries are allowed
set(CMAKE_C_FLAGS "-static")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -target ${LOC_TARGET}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isystem ${CLANG_INCLUDE_1}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isystem ${CLANG_INCLUDE_2}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isystem ${MUSL_INCLUDE}")

set(CMAKE_EXE_LINKER_FLAGS "-stdlib=libc++ -lc++ -lc++abi -lunwind -fuse-ld=lld -L${CLANG_LIBS_1} -L${CLANG_LIBS_2}")

