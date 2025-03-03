set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

set(CMAKE_SYSROOT /build/sysroot_hi_aarch64)

set(GCC_LIBS /usr/lib/gcc-cross/aarch64-linux-gnu/11)
set(MUSL_LIBS /usr/lib/aarch64-linux-musl)
set(MUSL_INCLUDE /usr/include/aarch64-linux-musl)

# Only static binaries are allowed
set(CMAKE_C_FLAGS "-static")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isystem ${MUSL_INCLUDE}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -target aarch64-linux-musl")

set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld -nostdlib -L${MUSL_LIBS} -L ${GCC_LIBS} -lc -lgcc -lgcc_eh")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MUSL_LIBS}/Scrt1.o ${MUSL_LIBS}/crti.o ${GCC_LIBS}/crtbeginS.o ${GCC_LIBS}/crtendS.o ${MUSL_LIBS}/crtn.o")

set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

