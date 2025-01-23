set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

set(CMAKE_SYSROOT /build/sysroot_hi_aarch64)

# Only static binaries are allowed
set(CMAKE_C_FLAGS "-static")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isystem /usr/include/aarch64-linux-musl/ -isystem /usr/lib/gcc-cross/aarch64-linux-gnu/11/include/")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -target aarch64-linux-musl")

set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld -nostdlib -L/usr/lib/aarch64-linux-musl -L/usr/lib/gcc-cross/aarch64-linux-gnu/11 -lc -lgcc")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /usr/lib/aarch64-linux-musl/crt1.o /usr/lib/aarch64-linux-musl/crti.o /usr/lib/aarch64-linux-musl/crtn.o /usr/lib/gcc-cross/aarch64-linux-gnu/11/crtend.o /usr/lib/gcc-cross/aarch64-linux-gnu/11/crtbeginT.o")

set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_INSTALL_PREFIX "/" CACHE STRING "Install prefix" FORCE)
