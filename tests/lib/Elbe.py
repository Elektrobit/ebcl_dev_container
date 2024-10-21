""" Tests for the elbe layer of the SDK container. """
from utils import run_command

class Elbe:
    """ Robot class implementing the tests for the elbe layer of the SDK container. """

    def elbe_is_available(self):
        """ Test that ensures that the elbe command is available. """
        (lines, _stdout, _stderr) = run_command('elbe --version')
        assert lines[-2].startswith('elbe v')

    def check_binfmt_works(self):
        """ Test that aarch64 binaries are executable. """
        (lines, _stdout, _stderr) = run_command('file /usr/bin/busybox')
        assert 'aarch64' in lines[-2]
        (_lines, stdout, _stderr) = run_command('busybox --help')
        assert 'Usage: busybox' in stdout
