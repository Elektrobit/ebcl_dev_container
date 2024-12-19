# Testing the dev container

## Tooling tests

The image build tests are contained in _tests_.
You can run these tests by running the _tests/run_tests_ script.
This script will ensure that a proper Python virtual environment is available
and then run all robot tests contained in _tests_.

## Image build tests

To ensure a good test coverage, also the build tests for the EB corbos Linux template workspace should be used.
Running these tests is supported by the shell script _tests/image_build_tests/run_tests_.
This script clones the current EB corbos Linux template workspace,
mounts is into the latest local built dev container,
and runs the image build robot tests from the EB corbos Linux template workspace in this container.
