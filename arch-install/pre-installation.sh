#/usr/bin/env bash
source utils/msg.sh

KEYBOARD="${KEYBOARD:-us}"

if [ ! -d "/sys/firmware/efi/efivars" ]; then
  error_msg "Booted in non-UEFI mode, which is unsupported by this script"
  exit 1
fi

msg "Setting keymap to $KEYBOARD"
loadkeys $KEYBOARD

msg "Opening iwctl so you can connect to the internet..."
iwctl

msg "Turning on system clock sync"
timedatectl set-ntp true

msg "Listing available devices:"
lsblk

msg "Opening cgdisk so you can format your partitions..."
cgdisk

msg "You should now format and mount your partitions and check the mirrorlist.\
 Then run install.sh"

