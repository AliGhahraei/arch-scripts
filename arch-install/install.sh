#/usr/bin/env bash
LOCALE="${LOCALE:-en_US.UTF-8}"
HOSTNAME="ali"


pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc

echo "LANG=$LOCALE" > /etc/locale.conf

echo $HOSTNAME > /etc/hostname
echo "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\tmyhostname.localdomain  
\t$HOSTNAME" > /etc/hosts
passwd
refind-install


msg "Don't forget to check /etc/fstab, uncomment /etc/locale.gen and run 
locale-gen. DONE!"

config/create-user.sh && config/enable-systemd-timers.sh && 
	config/install-additional-programs.sh
