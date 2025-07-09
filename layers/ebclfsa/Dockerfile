FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

USER root

COPY conf/apt/ebclfsa.list /etc/apt/sources.list.d/
# Install ebclfsa tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    lisa-elf-enabler \
    lld \
    patchelf \
    ninja-build

# add cmake toolchains
RUN mkdir -p /build/cmake
COPY conf/cmake/* /build/cmake/

COPY conf/scripts/build_clang_libc++_musl.sh /build/build_clang_libc++_musl.sh
COPY conf/patches/0001-llvm-enable-by-default-musl-libc.patch /build
COPY conf/patches/0001-musl-cross-add-linux-5.15.183-hash.patch /build

RUN chmod +x /build/build_clang_libc++_musl.sh
RUN bash /build/build_clang_libc++_musl.sh --check_tools
RUN bash /build/build_clang_libc++_musl.sh --clone_musl
RUN bash /build/build_clang_libc++_musl.sh --clone_llvm
RUN bash /build/build_clang_libc++_musl.sh --build_musl_x86
RUN bash /build/build_clang_libc++_musl.sh --install_musl_x86
RUN bash /build/build_clang_libc++_musl.sh --build_musl_aarch64
RUN bash /build/build_clang_libc++_musl.sh --install_musl_aarch64
RUN bash /build/build_clang_libc++_musl.sh --build_clang_x86
RUN bash /build/build_clang_libc++_musl.sh --install_clang_x86
RUN bash /build/build_clang_libc++_musl.sh --build_clang_aarch64
RUN bash /build/build_clang_libc++_musl.sh --install_clang_aarch64

#clean the docker images, from unnecesary binaries, files and projects.
RUN bash /build/build_clang_libc++_musl.sh --clean

RUN rm /build/build_clang_libc++_musl.sh \
       /build/0001-llvm-enable-by-default-musl-libc.patch \
       /build/0001-musl-cross-add-linux-5.15.183-hash.patch

RUN apt remove -y \
    ninja-build \
    patchelf

