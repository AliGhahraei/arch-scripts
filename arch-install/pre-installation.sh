#/usr/bin/env bash
LOCALE="${LOCALE:-en_US.UTF-8}"


loadkeys $LOCALE
wifi-menu
timedatectl set-ntp true
cgdisk
msg "You should now format and mount your partitions. Then run install.sh"

