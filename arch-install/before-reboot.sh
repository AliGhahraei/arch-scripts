#!/usr/bin/env bash
# DISCLAIMER: please change this script's values to fit your needs before running it.

# wpa_actiond and dialog are for wireless support. sudo, xorg and xorg-xinit are 
# common packages that I always use and rsync and openssh are used to back up and 
# recover my files
show(){
    GREEN='\033[0;32m'
    END='\033[0m'

    printf "\n${GREEN}${1}\n${END}"
}

show 'installing packages'
pacman -S --noconfirm wpa_actiond dialog sudo xorg xorg-xinit rsync openssh

show 'Adding user and setting its password'
useradd -m -G wheel -s /bin/bash ali
passwd ali

show 'Adding user to sudoers'
echo 'ali ALL=(ALL) ALL' >> /etc/sudoers

show 'Making this user login automatically'
mkdir '/etc/systemd/system/getty@tty1.service.d'
TTY_FILE='/etc/systemd/system/getty@tty1.service.d/override.conf'
touch $TTY_FILE
echo -e '[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin ali --noclear %I $TERM' >> $TTY_FILE

show 'DONE!'
