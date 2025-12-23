FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

# "Activate" Python env
ENV VIRTUAL_ENV=/build/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

USER $CONTAINER_USER
WORKDIR /build

# copy apt helper scripts
COPY scripts/apt/* /build/bin/

# copy gpg helper scripts
COPY scripts/gpg/* /build/bin/

