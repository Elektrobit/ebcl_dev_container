FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

USER root

# Add rust binaries to PATH
ENV PATH="/home/$CONTAINER_USER/.cargo/bin:${PATH}"
RUN echo "export PATH=\$PATH:~/.cargo/bin" >> /home/$CONTAINER_USER/.bashrc
RUN echo "export PATH=\$PATH:/home/$CONTAINER_USER/.cargo/bin" >> /root/.bashrc

USER $CONTAINER_USER

# Install rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
