FROM ubuntu:latest

ARG CONTAINER_USER="ebcl"

# "Activate" Python env
ENV VIRTUAL_ENV=/build/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

USER root

# Copy berrymill config
RUN mkdir -p /etc/berrymill
COPY conf/berrymill/berrymill_local.conf /etc/berrymill
COPY conf/berrymill/berrymill.conf /etc/berrymill
COPY conf/kiwi/kiwi-boxed-plugin.yml /etc/berrymill
COPY conf/kiwi/kiwi.yml /etc

# Copy linux.elektrobit.com repo key
RUN mkdir -p /etc/berrymill/keyrings.d
RUN cp /etc/apt/trusted.gpg.d/elektrobit.gpg /etc/berrymill/keyrings.d/

USER $CONTAINER_USER
WORKDIR /build

# Install berrymill
RUN pip install kiwi==10.1.2 kiwi-boxed-plugin==0.2.36
RUN pip install 'berrymill @ git+https://github.com/tomirgang/berrymill.git@f4ff87f08edf5f178284a5a689e2b6e301faad35'

# copy apt helper scripts
COPY scripts/apt/* /build/bin/

# copy berrymill helper scripts
COPY scripts/berrymill/* /build/bin/

# copy gpg helper scripts
COPY scripts/gpg/* /build/bin/

# copy kiwi helper scripts
COPY scripts/kiwi/* /build/bin/
