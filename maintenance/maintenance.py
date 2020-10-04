#!/usr/bin/env python3
from os import listdir
from os.path import expanduser, join
from platform import system

from colored import fg, attr, stylize
from sh import git, doom, pipx, ErrorReturnCode_128, asdf


_SUBSTRING_ALWAYS_PRESENT_IN_NON_EMPTY_OUTPUT = '->'
GIT_DIR = expanduser(join('~', 'g'))


def main():
    upgrade_os = get_platform_commands(system())
    upgrade_os()
    upgrade_python_tools()
    upgrade_doom()
    check_repos_clean()
    info('Done!')


def colorize(message, foreground, *styles):
    return stylize(message, styles=[fg(foreground), *("".join(attr(style) for style in styles))])


def task(message):
    def decorator(f):
        def wrapper(*args, **kwargs):
            dotted_message = f'{message}...'
            print(colorize(dotted_message, 'magenta', 'bold'))
            f(*args, **kwargs)

        return wrapper
    return decorator


def info(message):
    print(colorize(message, 'cyan'))


def warning(message):
    print(colorize(message, 'yellow'))


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

    return upgrade_macos


def get_arch_linux_commands():
    from sh import yay

    @task('Upgrading with yay')
    def upgrade_arch():
        yay('-Syu', _fg=True)

    return upgrade_arch


@task('Upgrading python tools and packages')
def upgrade_python_tools():
    pipx('upgrade-all', _fg=True)
    asdf('update', _fg=True)


@task('Upgrading doom')
def upgrade_doom():
    doom('upgrade', _fg=True)


@task('Checking git repos')
def check_repos_clean():
    def is_tree_dirty(dir_):
        try:
            unsaved_changes = git('-C', dir_, 'status', '--ignore-submodules', '--porcelain')
            unpushed_commits = git('-C', dir_, 'log', '--branches', '--not', '--remotes',
                                   '--oneline')
        except ErrorReturnCode_128 as e:
            raise ValueError(f'Invalid repository: {dir_}') from e

        is_dirty = any([_decode_output(unsaved_changes), _is_not_empty_ignoring_escape_sequences(unpushed_commits)])
        return is_dirty

    all_repos = [join(GIT_DIR, repo) for repo in listdir(GIT_DIR)]
    dirty_repos = [repo for repo in all_repos if is_tree_dirty(repo)]
    if dirty_repos:
        for repo in dirty_repos:
            warning(f"{repo}'s tree was not clean")
    else:
        info("Everything's clean!")


def _decode_output(output):
    return output.stdout.decode('utf-8')


def _is_not_empty_ignoring_escape_sequences(unpushed_commits_output):
    return _SUBSTRING_ALWAYS_PRESENT_IN_NON_EMPTY_OUTPUT in _decode_output(unpushed_commits_output)


if __name__ == '__main__':
    main()
