#!/usr/bin/env bash
msg 'Installing additional packages...'

pacman -S --noconfirm --needed netctl dialog wpa_supplicant dhcpcd xorg-server xf86-input-libinput picom xorg-xinput xorg-xinit xorg-xkill sudo feh rxvt-unicode emacs dunst libnotify xmonad xmonad-contrib xmobar trayer dmenu scrot neovim ttf-inconsolata firefox-developer-edition alsa-utils htop qpdfview rsync openssh man fish thefuck s-nail fzf polkit
