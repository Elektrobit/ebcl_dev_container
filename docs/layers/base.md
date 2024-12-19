# Base Layer

The base layer does the basic configuration needed for all additional layers, and installs the common tools. These configurations are:

- [Setup the **ebcl** user](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L3).
- [Setup the apt sources](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L8).
- [Install the common packages](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L26).
- [Make the _addon_ packages available](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L38).
- [Configure the expected folder structure](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L56).
- [Configure the shell environment and common scripts](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L70).
- [Prepare a common Python virtual environment](https://github.com/Elektrobit/ebcl_dev_container/blob/9727219bfd009b717d7b29d1eb54d42586e9eebd/layers/base/Dockerfile#L100).

## Remarks

- The _bashrc_ is used to source a EB corbos Linux environment setup file _/build/bin/ebcl_env_. This file is _layers/base/scripts/bash/ebcl_env_.
- The base layer provides some helper scripts to generate a user-specific GPG key. See _layers/base/scripts/gpg_.
