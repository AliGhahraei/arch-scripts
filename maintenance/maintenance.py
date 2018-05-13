#!/usr/bin/env python3
from json import loads
from os.path import expanduser, join
from platform import system

from crayons import red, green, yellow
from sh import brew, git, pip3


SYSTEM = system()
GIT_DIR = expanduser(join('~', 'g'))
REPOS = 'scripts', 'dotfiles'


def info(message):
    print(green(message))


def warning(message):
    print(yellow(message))


def error(message):
    print(red(message))
    exit(1)


if SYSTEM == 'Darwin':
    from sh import open as os_open
else:
    os_open = lambda *_, **__: warning(f'MEGAsync not supported for {SYSTEM}')



def pip_upgrade():
    outdated_packages = [package['name'] for package in loads(pip3('list',
                                                                   '--format=json',
                                                                   '--outdated').stdout)]
    if outdated_packages:
        pip3('install', '-U', *outdated_packages, _fg=True)

    pip3('install', '--upgrade', 'pip', _fg=True)


def tree_clean(dir_):
    is_dirty = bool(git('-C', dir_, 'status', '--porcelain').stdout)

    if is_dirty:
        warning(f"Commit your files! {dir_}'s tree was not clean")
    return not is_dirty


info('Upgrading pip...')
pip_upgrade()

if SYSTEM == 'Darwin':
    info('Upgrading brew...')
    brew('update', _fg=True)
    brew('upgrade', _fg=True)
    brew('cask', 'upgrade', _fg=True)
else:
    warning(f"Package managers for {SYSTEM} aren't supported")

info('Checking git repos...')
if all([tree_clean(join(GIT_DIR, repo)) for repo in REPOS]):
    info("Everything's clean!")

info('Launching backup tool...')
os_open('-a', 'MEGAsync', _bg=True)
warning('Remember to update Emacs manually')
info('Done!')
