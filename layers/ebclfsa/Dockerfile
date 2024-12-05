FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

USER root

COPY conf/apt/ebclfsa.list /etc/apt/sources.list.d/
# Install ebclfsa tools
RUN apt-get update && apt-get install -y musl-dev:arm64 lisa-elf-enabler

# add cmake toolchains
RUN mkdir -p /build/cmake
COPY conf/cmake/* /build/cmake/
