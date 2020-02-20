#!/usr/bin/env bash
msg 'Installing additional packages...'

pacman -S --noconfirm --needed netctl dialog wpa_supplicant dhcpcd xorg-server xf86-input-libinput xorg-xinput xorg-xinit sudo feh rxvt-unicode emacs dunst libnotify xmonad xmonad-contrib xmobar dmenu scrot neovim ttf-inconsolata firefox-developer-edition alsa-utils htop evince gvfs rsync openssh man
