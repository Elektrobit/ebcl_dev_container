from utils import run_command

class Kiwi:

    def kiwi_is_available(self):
        (lines, _stdout, _stderr) = run_command('source /build/venv/bin/activate; kiwi-ng -v')
        assert lines[-2].startswith('KIWI ')

    def berrymill_is_available(self):
        (_lines, stdout, _stderr) = run_command('source /build/venv/bin/activate; berrymill -h')
        assert 'usage: berrymill' in stdout
