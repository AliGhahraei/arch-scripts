#!/usr/bin/env bash
msg 'Installing additional packages...'

# wpa_actiond and dialog are for wireless support and wifi-menu. xorg and xorg-xinit provide a graphical environment
pacman -S --noconfirm wpa_actiond dialog xorg xorg-xinit xf86-input-synaptics sudo feh rxvt-unicode emacs dunst libnotify xmonad xmonad-contrib xmobar dmenu trayer scrot neovim ttf-inconsolata firefox-developer-edition alsa-utils htop gvfs evince rsync openssh
