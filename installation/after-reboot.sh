sudo wifi-menu
systemctl enable netctl-auto@wlp2s0
systemctl --user enable backup.timer
systemctl --user enable battery.timer
