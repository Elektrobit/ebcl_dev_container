from utils import run_command
import os

class Base:

    def sdk_version(self, version: str):
        (lines, stdout, stderr) = run_command('cat /etc/sdk_version')
        assert version in lines[-2], (stdout, stderr)

    def ensure_ebcl_user_is_used(self):
        (_lines, stdout, _stderr) = run_command('id')
        assert 'uid={}(ebcl)'.format(os.getuid()) in stdout
        assert 'gid=1000(ebcl)' in stdout

    def ensure_environment_is_ok(self):
        (lines, _stdout, _stderr) = run_command('env')
        for line in lines:
            if line.startswith('PATH'):
                assert '/build/bin' in line, "/build/bin is in path"
            if line.startswith('DEBFULLNAME'):
                assert line == "DEBFULLNAME=Elektrobit Automotive GmbH", "DEBFULLNAME is set"
            if line.startswith('DEBEMAIL'):
                assert line == "DEBEMAIL=info@elektrobit.com", "DEBMAIL is set"
