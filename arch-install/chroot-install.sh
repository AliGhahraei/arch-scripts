#/usr/bin/env bash
source utils/msg.sh

TIMEZONE="America/Mexico_City"
LOCALE="${LOCALE:-en_US.UTF-8}"
HOSTNAME="ali"

msg "Setting timezone"
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

msg "Syncing hardware clock"
hwclock --systohc

msg "Creating locale.conf"
echo "LANG=$LOCALE" > /etc/locale.conf

msg "Setting hostname"
echo $HOSTNAME > /etc/hostname

msg "Adding hosts to /etc/hosts"
echo "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\tmyhostname.localdomain  
\t$HOSTNAME" > /etc/hosts

msg "Setting root password"
passwd

msg "Installing refind"
refind-install

config/create-user.sh
