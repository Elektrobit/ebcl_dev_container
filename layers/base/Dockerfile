FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"
ARG HOST_USER=1000
ARG HOST_GROUP=1000
ARG VERSION="unknown"
ARG VERSION_PACKAGES

# Config apt sources
RUN rm -rf /etc/apt/sources.list
COPY conf/apt/sources.list /etc/apt/sources.list

# Copy linux.elektrobit.com repo key
RUN mkdir -p /etc/apt/trusted.gpg.d
COPY conf/apt-keys/elektrobit.gpg /etc/apt/trusted.gpg.d/

# Copy linux.elektrobit.com repo config
RUN mkdir -p /etc/apt/sources.list.d
COPY conf/apt/elektrobit.list /etc/apt/sources.list.d/
RUN sed -i "s/VERSION/${VERSION_PACKAGES}/g" /etc/apt/sources.list.d/elektrobit.list
RUN cat /etc/apt/sources.list.d/elektrobit.list

# add arm64 arch for cross-building
RUN dpkg --add-architecture arm64

# Update container
RUN apt update
# Install compiler and base tools
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y \
    bash-completion \
    bmap-tools \ 
    build-essential \
    ca-certificates \
    cmake \
    crossbuild-essential-arm64 \
    curl \
    fakechroot \
    fakeroot \
    fdisk \
    file \
    g++ \
    g++-aarch64-linux-gnu \
    gcc \
    gcc-aarch64-linux-gnu \
    gdb-multiarch \
    gdisk \
    git \
    iproute2 \
    iptables \
    iputils-ping \
    kmod \
    libc6:arm64 \
    locales \
    lshw \
    parted \
    pkg-config \
    psmisc procps \
    python3 \
    python3-pip \
    python3-venv \
    qemu-system-arm \
    qemu-system-x86 \
    rsync \
    software-properties-common \
    squashfs-tools \
    sudo \
    tcpdump \
    tzdata \
    vim \
    wget \
    xz-utils \
    zip

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/bin
# add addon ppa
RUN add-apt-repository ppa:elos-team/ppa
RUN apt update

# Setup locale
RUN export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    locale-gen en_US.UTF-8

# Create build user mathching outside UID and GID to avoid ownership issues
# and allow user to use sudo
RUN userdel ubuntu || true
RUN addgroup --gid $HOST_GROUP $CONTAINER_USER && \
  useradd -rm -d /home/$CONTAINER_USER -s /bin/bash -g $CONTAINER_USER -G sudo -u $HOST_USER $CONTAINER_USER && \
  echo "$CONTAINER_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  mkdir -p /home/$CONTAINER_USER/.ssh && \
  chown -R $CONTAINER_USER:$CONTAINER_USER /home/$CONTAINER_USER

# Prepare base structure
RUN mkdir -p /build/results/images && \
    mkdir -p results/packages && \
    mkdir -p images && \
    mkdir -p identity && \
    mkdir -p bin && \
    chown -R $CONTAINER_USER:$CONTAINER_USER /build
RUN mkdir -p /workspace && \
    chown -R $CONTAINER_USER:$CONTAINER_USER /workspace

# Create mount point for SSH keys
RUN mkdir -p /home/$CONTAINER_USER/.ssh && \
    chown -R $CONTAINER_USER:$CONTAINER_USER /home/$CONTAINER_USER

# Copy bashrc
COPY conf/bash/bashrc /home/$CONTAINER_USER/.bashrc
RUN chown -R $CONTAINER_USER:$CONTAINER_USER /home/$CONTAINER_USER && \
    chmod +x /home/$CONTAINER_USER/.bashrc

RUN mkdir -p /root
COPY conf/bash/bashrc /root/.bashrc
RUN chown -R root:root /root && \
    chmod +x /root/.bashrc

# Copy profile (task bash completion)
COPY conf/profile.d/task-completion.sh /etc/profile.d

# Copy environment helper scripts
COPY scripts/bash/* /build/bin/

# Copy GnuPG helper scripts
COPY scripts/gpg/* /build/bin/

# Copy QEMU helper scripts
COPY scripts/qemu/* /build/bin/

# Copy mount helper scripts
COPY scripts/mount/* /build/bin/

# Ensure correct attributes for scripts
RUN chown -R $CONTAINER_USER:$CONTAINER_USER /build/bin && \
    chmod +x /build/bin/*

# Write version
RUN echo $VERSION > /etc/sdk_version

USER $CONTAINER_USER

# Prepare Python env
ENV VIRTUAL_ENV=/build/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install mypy pep8 pylint pytest pytest-cov robotframework

# Ensure venv owner
USER root
RUN chown -R $CONTAINER_USER:$CONTAINER_USER /build/venv
