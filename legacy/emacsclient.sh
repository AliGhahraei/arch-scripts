#!/usr/bin/env sh
for f in "$@"
do
    emacsclient --alternate-editor="open /Applications/Emacs.app" -t -n "$f"
done
