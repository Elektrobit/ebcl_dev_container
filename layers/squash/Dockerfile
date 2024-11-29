ARG BASE_CONTAINER_NAME="ubuntu:22.04"
FROM $BASE_CONTAINER_NAME as source 

FROM scratch
COPY --from=source / /
