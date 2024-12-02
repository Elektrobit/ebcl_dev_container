FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

# "Activate" Python env
ENV VIRTUAL_ENV=/build/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

USER root

# install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt -y install \
    python3 python3-pip python3-venv libparted-dev python3-dev pkg-config \
    mtools e2fsprogs cryptsetup-bin dosfstools fakeroot fdisk udev cpio

USER $CONTAINER_USER

RUN pip install pyyaml types-PyYAML \
    requests types-requests \
    Jinja2 types-Jinja2 \
    unix-ar zstandard

# Install embedgen
WORKDIR /build
RUN git clone --branch v0.1.2 https://github.com/Elektrobit/embdgen.git embdgen
WORKDIR /build/embdgen
RUN pip install -e embdgen-core
RUN pip install -e embdgen-cominit
RUN pip install -e embdgen-config-yaml

# Add apt keys
RUN mkdir -p /build/keys
COPY conf/elektrobit.pub /build/keys/

# Install EBcL build helpers
RUN pip install jsonpickle robotframework requests pyyaml psutil

# Install EBcl build tools
WORKDIR /build
RUN git clone --branch v1.3.2 https://github.com/Elektrobit/ebcl_build_tools ebcl_build_tools
RUN pip install -e ebcl_build_tools

# Prepare cache folders
RUN mkdir -p /workspace/state/cache
RUN mkdir -p /workspace/state/apt
