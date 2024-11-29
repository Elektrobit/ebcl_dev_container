FROM ubuntu:latest as base_container_name 

# intentionally lower case 'from' to avoid rewrite by the build script
FROM scratch
COPY --from=base_container_name / /
