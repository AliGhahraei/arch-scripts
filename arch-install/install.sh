#/usr/bin/env bash
source utils/msg.sh

MOUNTDIR="/mnt"
MOUNTDIR_INSTALL="opt/install"
ABSOLUTE_MOUNTDIR_INSTALL=$MOUNTDIR/$MOUNTDIR_INSTALL

msg "Installing essential packages. This will take a while"
pacstrap $MOUNTDIR base base-devel linux linux-firmware refind

msg "Generating fstab"
genfstab -U $MOUNTDIR >> $MOUNTDIR/etc/fstab

msg "Copying installation scripts to the mount directory"
mkdir -p $ABSOLUTE_MOUNTDIR_INSTALL
cp -R * $ABSOLUTE_MOUNTDIR_INSTALL

msg "Entering chroot"
arch-chroot $MOUNTDIR sh -c "cd /$MOUNTDIR_INSTALL && ./chroot-install.sh"

msg "Removing installation scripts from mount"
rm -r $ABSOLUTE_MOUNTDIR_INSTALL

msg "Don't forget to check /etc/fstab, uncomment /etc/locale.gen and run 
locale-gen. DONE!"

