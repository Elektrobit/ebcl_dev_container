#!/usr/bin/env python
""" Script to build the EBcL SDK container. """
import argparse
import logging
import os
import subprocess
import time

from typing import Any, Optional

import yaml


class ContainerBuilder:
    """ ContainerBuilder builds and EBcL SDK dev container.  """

    # User ID of the container user.
    uid: Optional[int]
    gid: Optional[int]

    def __init__(self):
        self.config: Optional[dict[str, Any]] = None
        self.build_tool: Optional[str] = None
        self.base_container_name: Optional[str] = None
        self.uid = None
        self.gid = None
        self.version = 'unknown'
        self.version_packages = '1.5'

    def load_config(self, file: Optional[str]) -> None:
        """ Load container configuration from config file.

        Args:
            file (str, optional): Path to the container configuration.
                Defaults to "build_config.yaml".
        """
        if not file:
            file = "build_config.yaml"

        with open(file, 'r', encoding='utf-8') as f:
            self.config = yaml.safe_load(f)
        logging.info('Conifg: %s', self.config)
        
        if self.config:
            self.version = self.config.get('Version', 'unknown')

    def _set_builder(self) -> None:
        """ Get the build tool form the environment. """
        if 'BUILDER' in os.environ:
            self.build_tool = os.environ['BUILDER']
        else:
            self.build_tool = 'docker'
        logging.info('Builder: %s', self.build_tool)

    def _build_container(self, name: str, path: str) -> None:
        """ Build a container layer. """
        logging.info('Building layer %s.', name)

        uid = os.getuid()
        if self.uid:
            uid = self.uid

        gid = 1000
        if self.gid:
            gid = self.gid


        # Replace first FROM with previous layer.
        command = f'echo "FROM {self.base_container_name} AS base_container_name" > Dockerfile.tmp; ' \
            'sed \'0,/FROM /{/FROM /d;}\' Dockerfile >> Dockerfile.tmp'
        subprocess.run(command, shell=True, check=True, cwd=path)

        # Build the container.
        command = f'{self.build_tool} build -t {name} -f Dockerfile.tmp '\
            f'--build-arg HOST_USER="{uid}" '\
            f'--build-arg HOST_GROUP="{gid}" '\
            f'--build-arg TIMESTAMP="{time.time()}" '\
            f'--build-arg VERSION="{self.version}" '\
            f'--build-arg VERSION_PACKAGES="{self.version_packages}" '\
            f'.'
        logging.debug('Command: %s', command)
        subprocess.run(command, shell=True, check=True, cwd=path)

        # Delete the temporary Dockerfile.
        subprocess.run('rm Dockerfile.tmp', shell=True, check=True, cwd=path)

    def _tag_container(self) -> None:
        """ Tag a container. """
        assert self.config
        repo = self.config['Repository']
        basename = self.config['Base-Name']
        version = self.config['Version']
        tag = f'{repo}/{basename}:{version}'

        logging.info('Tagging container %s as %s.',
                     self.base_container_name, tag)

        command = f'{self.build_tool} tag {self.base_container_name} {tag}'
        subprocess.run(command, shell=True, check=True)

    def _get_container_name(self, path: str) -> str:
        """ Build the container name. """
        assert self.config
        repo = self.config['Repository']
        basename = self.config['Base-Name']
        name = os.path.basename(path)
        version = self.version

        env_version = os.getenv('CONTAINER_TAG', None)
        if env_version:
            logging.info('Using container tag %s form env version.',
                         env_version)
            version = env_version

        return f'{repo}/{basename}_{name}:{version}'

    def build_container(self, uid: Optional[int], gid: Optional[int]):
        """ Build the dev container. """
        assert self.config

        self.uid = uid
        self.gid = gid

        self._set_builder()
        self.base_container_name = self.config['Base-Container']

        for path in self.config['Layers']:
            container_name = self._get_container_name(path)
            self._build_container(container_name, path)
            self.base_container_name = container_name

        self._tag_container()


def main() -> None:
    """ Main entrypoint of container generator. """
    logging.basicConfig(level=logging.INFO)

    parser = argparse.ArgumentParser(
        description='Tool to build the EBcl SDK dev container.')
    parser.add_argument('-c', '--config', type=str,
                        help='Path to the YAML configuration file.',
                        required=False)
    parser.add_argument('-u', '--uid', type=int,
                        help='User ID of the container user.',
                        required=False)
    parser.add_argument('-g', '--gid', type=int,
                        help='Group ID of the container user.',
                        required=False)

    args = parser.parse_args()

    builder = ContainerBuilder()

    builder.load_config(args.config)

    builder.build_container(args.uid, args.gid)


if __name__ == '__main__':
    main()
