# Layers

The different EB corbos Linux dev container features are grouped into separate Docker container layers.
Each layer should be independent of the other layers.
The default layers are contained in _docs/layers_.

## Customer specific layers

You can add your own layers by using an own container configuration file.
The default configuration is contained in _configuration/build_config.yaml_.

To create an own layer follow these steps:

- Prepare your layer, i.e. a Docker image in a separate folder.
- Copy the configuration from _configuration/build_config.yaml_ and add the path to your layer.
- Make sure the Python dependencies are available, e.g. by creating a venv and installing the dependencies form _requirements.txt_.
- Run the build using your configuration: `python builder/build_container.py path/to/your/configuration.yaml`