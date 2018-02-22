#!/bin/sh

#Defaults
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#-------------------------------Personal---------------------------------

# Cambia el teclado
setxkbmap es

# Inicia al daemon de nuestro queridísimo URxvt
urxvtd &

# Pon al wallpaper 
/home/ali/.fehbg

# Pon al cursor normal como flecha
xsetroot -cursor_name left_ptr &

# Lanza trayer 
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --height 12 --margin 320 --transparent true --tint 0x1C1E1F  --width 8 &

# Make DISPLAY and XAUTHORITY available to systemd
sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# Y lanza al WM en turno
# exec startxfce4
exec xmonad
