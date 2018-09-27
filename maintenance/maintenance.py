#!/usr/bin/env python3
from contextlib import contextmanager
from json import loads
from os import listdir
from os.path import expanduser, join
from platform import system

from crayons import green, yellow, blue
from sh import git, doom  #pylint: disable=no-name-in-module
from sh.contrib import sudo as sh_sudo


SYSTEM = system()
GIT_DIR = expanduser(join('~', 'g'))
REPOS = listdir(GIT_DIR)




def main():
    if SYSTEM == 'Darwin':
        from sh import open as os_open, brew  #pylint: disable=no-name-in-module

        megasync = os_open.bake('-a', 'MEGAsync', _bg=True)

        task('Upgrading with brew...')
        brew('update', _fg=True)
        brew('upgrade', _fg=True)
        brew('cask', 'upgrade', _fg=True)
    elif SYSTEM == 'Linux':
        from sh import megasync as mega, pacaur

        megasync = mega.bake(_bg=True)

        task('Upgrading with pacaur...')
        pacaur('-Syu', _fg=True)
    else:
        def megasync():
            warning(f'MEGAsync not supported for {SYSTEM}')

        warning(f"Package managers for {SYSTEM} aren't supported")


    task('Checking git repos...')
    if all([tree_clean(join(GIT_DIR, repo)) for repo in REPOS]):
        info("Everything's clean!")

    task('Launching backup tool...')
    megasync()

    task('Updating doom...')
    doom('upgrade', _fg=True)
    doom('update', _fg=True)
    doom('refresh', _fg=True)
    info('Done!')


def task(message):
    print(f'\n{green(message, bold=True)}')


def info(message):
    print(blue(message))


def warning(message):
    print(yellow(message))


@contextmanager
def sudo():
    print('\a')
    with sh_sudo:
        yield


def tree_clean(dir_):
    git_status = git('-C', dir_, 'status', '--ignore-submodules', '--porcelain') #pylint: disable=too-many-function-args
    is_dirty = bool(git_status.stdout)
    if is_dirty:
        warning(f"{dir_}'s tree was not clean")
    return not is_dirty


if __name__ == '__main__':
    main()
