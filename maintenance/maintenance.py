#!/usr/bin/env python3
from json import loads
from os import listdir
from os.path import expanduser, join
from platform import system

from crayons import green, yellow, blue
#pylint: disable=no-name-in-module
from sh import brew, git, pip3


SYSTEM = system()
GIT_DIR = expanduser(join('~', 'g'))
REPOS = listdir(GIT_DIR)


def task(message):
    print(f'\n{green(message, bold=True)}')


def info(message):
    print(blue(message))


def warning(message):
    print(yellow(message))


if SYSTEM == 'Darwin':
    from sh import open as os_open
else:
    def os_open(*_, **__):
        warning(f'MEGAsync not supported for {SYSTEM}')


def pip_upgrade():
    outdated_packages = [package['name'] for package in loads(pip3('list',
                                                                   '--format=json',
                                                                   '--outdated').stdout)]
    if outdated_packages:
        pip3('install', '-U', *outdated_packages, _fg=True)

    pip3('install', '--upgrade', 'pip', _fg=True)


def tree_clean(dir_):
    #pylint: disable=too-many-function-args
    is_dirty = bool(git('-C', dir_, 'status', '--porcelain').stdout)

    if is_dirty:
        warning(f"{dir_}'s tree was not clean")
    return not is_dirty


if __name__ == '__main__':
    task('Upgrading pip...')
    pip_upgrade()

    if SYSTEM == 'Darwin':
        task('Upgrading brew...')
        brew('update', _fg=True)
        brew('upgrade', _fg=True)
        brew('cask', 'upgrade', _fg=True)
    else:
        warning(f"Package managers for {SYSTEM} aren't supported")

    task('Checking git repos...')
    if all([tree_clean(join(GIT_DIR, repo)) for repo in REPOS]):
        info("Everything's clean!")

    task('Launching backup tool...')
    os_open('-a', 'MEGAsync', _bg=True)
    warning('Remember to update Emacs manually')
    info('Done!')
