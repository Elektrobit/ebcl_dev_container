FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

USER root

# Install Debian tools
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y \
build-essential chrpath cpio debianutils diffstat file gawk gcc git iputils-ping \
libacl1 liblz4-tool locales python3 python3-git python3-jinja2 python3-pexpect \
python3-pip python3-subunit socat texinfo unzip wget xz-utils zstd \
kas

USER $CONTAINER_USER
