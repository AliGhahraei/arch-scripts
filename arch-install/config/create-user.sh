#!/usr/bin/env bash
source utils/msg.sh

USER="ali"
TTY_FILE='/etc/systemd/system/getty@tty1.service.d/override.conf'


msg 'Creating user'
useradd -m -G wheel -s /usr/bin/fish $USER

msg "Setting user password"
passwd $USER

msg "Adding to sudoers"
echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

msg 'Making this user login automatically'
mkdir -p '/etc/systemd/system/getty@tty1.service.d'
touch $TTY_FILE
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" >> $TTY_FILE

