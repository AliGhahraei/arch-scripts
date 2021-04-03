#!/usr/bin/env python3
from colored import fg, attr, stylize
from functools import wraps


def task_title(message):
    def decorator(f):
        wraps(f)
        def wrapper(*args, **kwargs):
            title(message)
            f(*args, **kwargs)

        return wrapper
    return decorator


def title(message):
    dotted_message = f'\n{message}...'
    print(_colorize(dotted_message, 'magenta', 'bold'))


def info(message):
    print(_colorize(message, 'cyan'))


def warning(message):
    print(_colorize(message, 'yellow'))


def _colorize(message, foreground, *styles):
    return stylize(message, styles=[fg(foreground), *("".join(attr(style) for style in styles))])
