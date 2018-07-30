#!/usr/bin/env bash
USER="${USER:-ali}"
TTY_FILE='/etc/systemd/system/getty@tty1.service.d/override.conf'


msg 'Creating user, setting its password and adding it to sudoers'

useradd -m -G wheel -s /bin/bash $USER
passwd $USER
echo "$USER ALL=(ALL) ALL" >> /etc/sudoers


msg 'Making this user login automatically'

mkdir '/etc/systemd/system/getty@tty1.service.d'
touch $TTY_FILE
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" >> $TTY_FILE

