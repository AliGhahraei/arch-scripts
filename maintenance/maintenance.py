#!/usr/bin/env python3
from os import listdir
from os.path import expanduser, join
from platform import system

from crayons import magenta, yellow, blue
from sh import git, doom, pipx, ErrorReturnCode_128


GIT_DIR = expanduser(join('~', 'g'))


def main():
    upgrade_os = get_platform_commands(system())
    upgrade_os()
    upgrade_pipx()
    upgrade_doom()
    check_repos_clean()
    info('Done!')


def task(message):
    def decorator(f):
        def wrapper(*args, **kwargs):
            dotted_message = f'{message}...'
            print(f'\n{magenta(dotted_message, bold=True)}')
            f(*args, **kwargs)

        return wrapper
    return decorator


def info(message):
    print(blue(message))


def warning(message):
    print(yellow(message))


def get_platform_commands(current_platform):
    os_upgrade_commands = {
        'Darwin': get_macos_commands,
        'Linux': get_arch_linux_commands,
    }
    try:
        upgrade_os = os_upgrade_commands[current_platform]()
    except KeyError:
        def upgrade_os():
            warning(f"Package managers for {current_platform} aren't supported")
    return upgrade_os


def get_macos_commands():
    from sh import open, brew

    @task('Upgrading with brew')
    def upgrade_macos():
        brew('update', _fg=True)
        brew('upgrade', _fg=True)
        brew('cask', 'upgrade', _fg=True)

    return upgrade_macos


def get_arch_linux_commands():
    from sh import yay

    @task('Upgrading with yay')
    def upgrade_arch():
        yay('-Syu', _fg=True)

    return upgrade_arch


@task('Upgrading pipx packages')
def upgrade_pipx():
    pipx('upgrade-all', _fg=True)


@task('Updating/upgrading doom')
def upgrade_doom():
    doom('upgrade', _fg=True)


@task('Checking git repos')
def check_repos_clean():
    def is_tree_dirty(dir_):
        try:
            git_status = git('-C', dir_, 'status', '--ignore-submodules', '--porcelain')
        except ErrorReturnCode_128 as e:
            raise ValueError(f'Invalid repository: {dir_}') from e
        is_dirty = bool(git_status.stdout)
        return is_dirty

    all_repos = [join(GIT_DIR, repo) for repo in listdir(GIT_DIR)]
    dirty_repos = [repo for repo in all_repos if is_tree_dirty(repo)]
    if dirty_repos:
        for repo in dirty_repos:
            warning(f"{repo}'s tree was not clean")
    else:
        info("Everything's clean!")


if __name__ == '__main__':
    main()
