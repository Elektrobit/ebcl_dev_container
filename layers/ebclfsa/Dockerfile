FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

USER root

COPY conf/apt/ebclfsa.list /etc/apt/sources.list.d/
# Install ebclfsa tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    lisa-elf-enabler \
    lld \
    llvm \
    musl-dev:arm64
    
# add cmake toolchains
RUN mkdir -p /build/cmake
COPY conf/cmake/* /build/cmake/
