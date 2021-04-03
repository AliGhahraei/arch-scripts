#!/usr/bin/env python3
from os import listdir
from os.path import expanduser, join
from platform import system

from sh import git, doom, fish, pipx, ErrorReturnCode_128
from maintenance.core import info, task_title, title, warning


_SUBSTRING_ALWAYS_PRESENT_IN_NON_EMPTY_OUTPUT = '->'
GIT_DIR = expanduser(join('~', 'g'))


def run():
    upgrade_fish()
    upgrade_os()
    upgrade_python_tools()
    upgrade_doom()
    check_repos_clean()
    info('Done!')


def upgrade_fish():
    if system() == 'Linux':
        title('Upgrading fisher')
        fish('-c', 'fisher update', _fg=True)


def upgrade_os():
    def get_macos_commands():
        from sh import open, brew

        @task_title('Upgrading with brew')
        def upgrade_macos():
            brew('update', _fg=True)
            brew('upgrade', _fg=True)

        return upgrade_macos


    def get_arch_linux_commands():
        from sh import paru

        @task_title('Upgrading with paru')
        def upgrade_arch():
            paru(_fg=True)

        return upgrade_arch

    os_upgrade_commands = {
        'Darwin': get_macos_commands,
        'Linux': get_arch_linux_commands,
    }
    current_platform = system()
    try:
        upgrade_os = os_upgrade_commands[current_platform]()
    except KeyError:
        def upgrade_os():
            warning(f"Package managers for {current_platform} aren't supported")
    upgrade_os()


@task_title('Upgrading python tools and packages')
def upgrade_python_tools():
    pipx('upgrade-all', _fg=True)


@task_title('Upgrading doom')
def upgrade_doom():
    doom('upgrade', _fg=True)


@task_title('Checking git repos')
def check_repos_clean():
    def is_tree_dirty(dir_):
        try:
            unsaved_changes = git('-C', dir_, 'status', '--ignore-submodules', '--porcelain')
            unpushed_commits = git('-C', dir_, 'log', '--branches', '--not', '--remotes',
                                   '--oneline')
        except ErrorReturnCode_128 as e:
            raise ValueError(f'Invalid repository: {dir_}') from e

        is_dirty = any([decode_output(unsaved_changes),
                        is_not_empty_ignoring_escape_sequences(unpushed_commits)])
        return is_dirty

    def decode_output(output):
        return output.stdout.decode('utf-8')

    def is_not_empty_ignoring_escape_sequences(unpushed_commits_output):
        return _SUBSTRING_ALWAYS_PRESENT_IN_NON_EMPTY_OUTPUT in decode_output(unpushed_commits_output)

    all_repos = [join(GIT_DIR, repo) for repo in listdir(GIT_DIR)]
    dirty_repos = [repo for repo in all_repos if is_tree_dirty(repo)]
    if dirty_repos:
        for repo in dirty_repos:
            warning(f"{repo}'s tree was not clean")
    else:
        info("Everything's clean!")
