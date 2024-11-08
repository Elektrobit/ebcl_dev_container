FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

USER root

# install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt -y install libjsoncpp-dev

# Update cmake version and install required tools
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update && apt -y install cmake sshpass rsync

USER $CONTAINER_USER
WORKDIR /build

# add cmake toolchains
RUN mkdir -p /build/cmake
COPY conf/cmake/* /build/cmake/

# add cmake helper scripts
COPY scripts/cmake/* /build/bin/

# Result folder for cmake builds
RUN mkdir -p /build/results/apps
