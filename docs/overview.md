# Overview

The EB corbos Linux dev container provides a stable and versioned built environment 
for building images and applications. This container is used as base for the 
EB corbos Linux SDK workspace. It can be used for local development and for automated
application and image building in a CI environment.

To improve maintainability and variant support, the EB corbos Linux dev container
is implemented as a set of layers. Each layer is a default Docker container, and
the layer are stacked on top of each other. The overall container is defined using
the configuration file _configuration/build_config.yaml_. It defines the base container,
some metadata like the container version, and the used layers, as list of relative paths
to the folders containing the containers.

For building the container a Python script, _builder/build_container.py_, is used with takes 
care of running the Docker builds for the layers, and stacking the resulting containers.
The dependencies of this script are also contained in _requirements.txt_.
The shell script _builder/build_container_ takes care that a virtual environment with the 
dependencies is available and runs the Python script to build the dev container.

At the moment, the container is distributed as exported image, and this image is generated
using _builder/export_container_.

There are also some helper scripts which supports and demos how to use the container stand-alone.
These scripts are contained in _usage_.
The script _usage/run_container_ runs the dev container for interactive usage.
The script _usage/run_background_ runs the container in the background.
This script is also used for the robot tests.
The script _usage/stop_container_ stops a dev container running in the background.
