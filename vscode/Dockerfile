ARG BASE_CONTAINER_NAME="ubuntu:22.04"
FROM $BASE_CONTAINER_NAME

ARG CONTAINER_USER="ebcl"

# "Activate" Python env
ENV VIRTUAL_ENV=/build/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install EBcl build tools
WORKDIR /build
RUN git clone --branch devel https://github.com/Elektrobit/ebcl_vscode_tools.git ebcl_vscode_tools
RUN pip install -e ebcl_vscode_tools

WORKDIR /workspace

# Set the entry point
ENTRYPOINT ["/build/bin/init"]
